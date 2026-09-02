import { supabase } from '../config/supabase.js';
export const obtenerTodos = async () => {
    const { data, error } = await supabase
        .from('clientes')
        .select('*');
    return { data, error };
};

export const obtenerPorId = async (id) => {
    const { data, error } = await supabase
        .from('clientes')
        .select('*')
        .eq('id_cliente', id)
        .single();
    return { data, error };
};

export const obtenerPorCedula = async (cedula) => {
    const { data, error } = await supabase
        .from('clientes')
        .select('*')
        .eq('cedula_cliente', cedula)
        .single();
    return { data, error };
};

export const crearCliente = async (clienteData) => {
    const { data, error } = await supabase
        .from('clientes')
        .insert(clienteData)
        .select();
    return { data, error };
};

export const actualizarCliente = async (id, clienteData) => {
    const { data, error } = await supabase
        .from('clientes')
        .update(clienteData)
        .eq('id_cliente', id)
        .select();
    return { data, error };
};

export const eliminarCliente = async (id) => {
    const { data, error } = await supabase
        .from('clientes')
        .delete()
        .eq('id_cliente', id);
    return { data, error };
};