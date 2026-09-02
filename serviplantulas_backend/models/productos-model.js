import { supabase } from '../config/supabase.js';

export const obtenerTodos = async () => {

    const { data, error } = await supabase
        .from('productos')
        .select('*');

    return { data, error };

};

export const obtenerPorId = async (id) => {

    const { data, error } = await supabase
        .from('productos')
        .select('*')
        .eq('id_producto', id)
        .single();

    return { data, error };

};

export const obtenerPorCategoria = async (id_categoria) => {

    const { data, error } = await supabase
        .from('productos')
        .select('*')
        .eq('id_categoria', id_categoria);

    return { data, error };

};

export const crearProducto = async (productoData) => {

    const { data, error } = await supabase
        .from('productos')
        .insert(productoData)
        .select();

    return { data, error };

};

export const actualizarProducto = async (id, productoData) => {

    const { data, error } = await supabase
        .from('productos')
        .update(productoData)
        .eq('id_producto', id)
        .select();

    return { data, error };

};

export const eliminarProducto = async (id) => {

    const { data, error } = await supabase
        .from('productos')
        .delete()
        .eq('id_producto', id);

    return { data, error };

};