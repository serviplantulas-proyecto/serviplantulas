import { supabase } from "../config/supabase.js";

// Obtener todos los detalles
export const obtenerTodos = async () => {
    const { data, error } = await supabase
        .from("detalle_pedidos")
        .select("*");
    return { data, error };
};

// Obtener un detalle por ID
export const obtenerPorId = async (id) => {
    const { data, error } = await supabase
        .from("detalle_pedidos")
        .select("*")
        .eq("id_detalle", id)
        .single();
    return { data, error };
};

// Obtener todos los detalles de un pedido
export const obtenerPorPedido = async (id_pedido) => {
    const { data, error } = await supabase
        .from("detalle_pedidos")
        .select("*")
        .eq("id_pedido", id_pedido);
    return { data, error };
};

// Crear un detalle
export const crearDetalle = async (detalleData) => {
    const { data, error } = await supabase
        .from("detalle_pedidos")
        .insert(detalleData)
        .select();
    return { data, error };
};

// Actualizar un detalle
export const actualizarDetalle = async (id, detalleData) => {
    const { data, error } = await supabase
        .from("detalle_pedidos")
        .update(detalleData)
        .eq("id_detalle", id)
        .select();
    return { data, error };
};

// Eliminar un detalle
export const eliminarDetalle = async (id) => {
    const { data, error } = await supabase
        .from("detalle_pedidos")
        .delete()
        .eq("id_detalle", id);
    return { data, error };
};