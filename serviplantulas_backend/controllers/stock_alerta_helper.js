import { crearNotificacion, obtenerNoLeidas } from "../models/notificaciones-model.js";
import { actualizarProducto } from "../models/productos-model.js";

/**
 * Si stock <= stock_minimo (>0), crea notificación poco_stock
 * (evita duplicado no leído del mismo producto).
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

/** Resta stock y notifica si aplica. */
export async function descontarStockYAlertar(producto, cantidad) {
    const nuevo = Math.max(0, (Number(producto.stock) || 0) - Number(cantidad));
    const { data, error } = await actualizarProducto(producto.id_producto, {
        stock: nuevo
    });
    if (error) return { error };
    const actualizado = data?.[0] || { ...producto, stock: nuevo };
    await notificarStockBajoSiAplica(actualizado);
    return { data: actualizado, error: null };
}
