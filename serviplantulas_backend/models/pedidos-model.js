import { supabase } from "../config/supabase.js";

// Obtener todos los pedidos
export const obtenerTodos = async () => {
    const { data, error } = await supabase
        .from("pedidos")
        .select("*");
    return { data, error };
};

// Obtener pedido por ID
export const obtenerPorId = async (id) => {
    const { data, error } = await supabase
        .from("pedidos")
        .select("*")
        .eq("id_pedido", id)
        .single();
    return { data, error };
};

// Crear pedido
export const crearPedido = async (pedidoData) => {
    const { data, error } = await supabase
        .from("pedidos")
        .insert(pedidoData)
        .select();
    return { data, error };
};

// Actualizar pedido
export const actualizarPedido = async (id, pedidoData) => {
    const { data, error } = await supabase
        .from("pedidos")
        .update(pedidoData)
        .eq("id_pedido", id)
        .select();
    return { data, error };
};

// Eliminar pedido
export const eliminarPedido = async (id) => {
    const { data, error } = await supabase
        .from("pedidos")
        .delete()
        .eq("id_pedido", id);
    return { data, error };
};