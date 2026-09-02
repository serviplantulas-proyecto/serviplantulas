import { supabase } from '../config/supabase.js';

export const obtenerTodos = async () => {

    const { data, error } = await supabase
        .from('categorias')
        .select('*');

    return { data, error };

};

export const obtenerPorId = async (id) => {

    const { data, error } = await supabase
        .from('categorias')
        .select('*')
        .eq('id_categoria', id)
        .single();

    return { data, error };

};

export const crearCategoria = async (categoriaData) => {

    const { data, error } = await supabase
        .from('categorias')
        .insert(categoriaData)
        .select();

    return { data, error };

};

export const actualizarCategoria = async (id, categoriaData) => {

    const { data, error } = await supabase
        .from('categorias')
        .update(categoriaData)
        .eq('id_categoria', id)
        .select();

    return { data, error };

};

export const eliminarCategoria = async (id) => {

    const { data, error } = await supabase
        .from('categorias')
        .delete()
        .eq('id_categoria', id);

    return { data, error };

};