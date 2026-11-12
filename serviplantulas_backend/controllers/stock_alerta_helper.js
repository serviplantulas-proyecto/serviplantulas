import { crearNotificacion, obtenerNoLeidas } from "../models/notificaciones-model.js";
import { actualizarProducto, obtenerPorId } from "../models/productos-model.js";

async function yaHayNoLeida(tipo, idProducto) {
    const { data: noLeidas } = await obtenerNoLeidas();
    return (noLeidas || []).some(
        (n) =>
            n.tipo === tipo &&
            Number(n.id_producto) === Number(idProducto)
    );
}

/**
 * - stock === 0 → alerta "sin_stock" (sin existencias)
 * - 0 < stock <= stock_minimo → alerta "poco_stock"
 * stock_minimo es umbral de alerta, no piso de inventario.
 */
export async function notificarStockBajoSiAplica(producto) {
    if (!producto) return;
    const stock = Number(producto.stock) || 0;
    const min = Number(producto.stock_minimo) || 0;
    const nombre = producto.nombre_producto || "Producto";
    const id = producto.id_producto;

    if (stock === 0) {
        if (await yaHayNoLeida("sin_stock", id)) return;
        await crearNotificacion({
            tipo: "sin_stock",
            titulo: "Sin existencias",
            mensaje: `El producto ${nombre} se quedó sin existencias (0 unidades).`,
            id_producto: id,
            leida: false
        });
        return;
    }

    if (min <= 0) return;
    if (stock > min) return;
    if (await yaHayNoLeida("poco_stock", id)) return;

    await crearNotificacion({
        tipo: "poco_stock",
        titulo: "Alerta de Stock Crítico",
        mensaje: `El stock de ${nombre} ha bajado a ${stock} unidades (Mínimo requerido: ${min}).`,
        id_producto: id,
        leida: false
    });
}

export async function descontarStockYAlertar(producto, cantidad) {
    const actual = Number(producto.stock) || 0;
    const cant = Number(cantidad) || 0;
    if (cant <= 0) {
        return { error: new Error("Cantidad inválida") };
    }
    if (actual < cant) {
        return {
            error: new Error(`Stock insuficiente. Disponible: ${actual}`)
        };
    }

    const nuevo = actual - cant;
    const { data, error } = await actualizarProducto(producto.id_producto, {
        stock: nuevo
    });
    if (error) {
        console.error("Error actualizar stock:", error);
        return { error };
    }

    let actualizado = data?.[0];
    if (!actualizado) {
        const { data: full } = await obtenerPorId(producto.id_producto);
        actualizado = full || { ...producto, stock: nuevo };
    }

    if (Number(actualizado.stock) !== nuevo) {
        return {
            error: new Error(
                "No se pudo actualizar el stock en la base de datos."
            )
        };
    }

    await notificarStockBajoSiAplica(actualizado);
    return { data: actualizado, error: null };
}
