import { supabase } from '../config/supabase.js';

export const obtenerTodos = async () => {
    const { data, error } = await supabase.from('proveedores').select('*');
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
    // Snapshot en productos se conserva; solo se limpia el id
    const { data: productos, error: desvError } = await supabase
        .from('productos')
        .update({ id_proveedor: null })
        .eq('id_proveedor', id)
        .select('id_producto');

    if (desvError) return { data: null, error: desvError };

    const { data, error } = await supabase
        .from('proveedores')
        .delete()
        .eq('id_proveedor', id)
        .select('id_proveedor');

    if (error && productos?.length) {
        await supabase
            .from('productos')
            .update({ id_proveedor: id })
            .in('id_producto', productos.map((p) => p.id_producto))
            .is('id_proveedor', null);
    }
    return { data, error };
};
