import { crearNotificacion, obtenerNoLeidas } from "../models/notificaciones-model.js";
import { actualizarProducto, obtenerPorId } from "../models/productos-model.js";

/**
 * stock_minimo es solo umbral de ALERTA, no un piso de inventario.
 * El stock puede bajar a 0.
 */
export async function notificarStockBajoSiAplica(producto) {
    if (!producto) return;
    const stock = Number(producto.stock) || 0;
    const min = Number(producto.stock_minimo) || 0;
    if (min <= 0) return;
    if (stock > min) return;

    const { data: noLeidas } = await obtenerNoLeidas();
    const yaHay = (noLeidas || []).some(
        (n) =>
            n.tipo === "poco_stock" &&
            Number(n.id_producto) === Number(producto.id_producto)
    );
    if (yaHay) return;

    const nombre = producto.nombre_producto || "Producto";
    await crearNotificacion({
        tipo: "poco_stock",
        titulo: "Alerta de Stock Crítico",
        mensaje: `El stock de ${nombre} ha bajado a ${stock} unidades (Mínimo requerido: ${min}).`,
        id_producto: producto.id_producto,
        leida: false
    });
}

/**
 * Resta stock real (hasta 0). No usa stock_minimo como piso.
 * Propaga error de Supabase para no dejar la venta sin descontar.
 */
export async function descontarStockYAlertar(producto, cantidad) {
    const actual = Number(producto.stock) || 0;
    const cant = Number(cantidad) || 0;
    if (cant <= 0) {
        return { error: new Error("Cantidad inválida") };
    }
    if (actual < cant) {
        return {
            error: new Error(
                `Stock insuficiente. Disponible: ${actual}`
            )
        };
    }

    // Solo piso en 0: el mínimo NO bloquea la venta
    const nuevo = actual - cant;

    const { data, error } = await actualizarProducto(producto.id_producto, {
        stock: nuevo
    });

    if (error) {
        console.error("Error actualizar stock:", error);
        return { error };
    }

    // Preferir fila devuelta; si no, reconsultar
    let actualizado = data?.[0];
    if (!actualizado) {
        const { data: full } = await obtenerPorId(producto.id_producto);
        actualizado = full || { ...producto, stock: nuevo };
    }

    // Si por algún motivo el stock no bajó, fallar explícito
    if (Number(actualizado.stock) !== nuevo) {
        console.error(
            "Stock no actualizado en BD. esperado=",
            nuevo,
            "obtuvo=",
            actualizado.stock
        );
        return {
            error: new Error(
                "No se pudo actualizar el stock en la base de datos (posible restricción stock >= stock_minimo)."
            )
        };
    }

    await notificarStockBajoSiAplica(actualizado);
    return { data: actualizado, error: null };
}
