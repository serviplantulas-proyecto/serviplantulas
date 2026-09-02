import { supabase } from '../config/supabase.js';
export const obtenerTodos = async () => {
    const { data, error } = await supabase
        .from('proveedores')
        .select('*');
    return { data, error };
};


export const obtenerPorId = async (id) => {
    const { data, error } = await supabase
        .from('proveedores')
        .select('*')
        .eq('id_proveedor', id)
        .single();
    return { data, error };
};

export const crearProveedor = async (proveedorData) => {
    const { data, error } = await supabase
        .from('proveedores')
        .insert(proveedorData)
        .select();
    return { data, error };
};

export const actualizarProveedor = async (id, proveedorData) => {
    const { data, error } = await supabase
        .from('proveedores')
        .update(proveedorData)
        .eq('id_proveedor', id)
        .select();
    return { data, error };
};

export const eliminarProveedor = async (id) => {
    const { data, error } = await supabase
        .from('proveedores')
        .delete()
        .eq('id_proveedor', id);
    return { data, error };
};