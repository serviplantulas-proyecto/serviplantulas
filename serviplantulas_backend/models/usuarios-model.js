import { supabase } from "../config/supabase.js";

// Crear usuario
export const crearUsuario = async (
    nombre_usuarios,
    apellido_usuarios,
    telefono_usuarios,
    email_usuarios,
    contrasena_usuarios
) => {
    const { data, error } = await supabase
        .from("usuarios")
        .insert({
            nombre_usuarios,
            apellido_usuarios,
            telefono_usuarios,
            email_usuarios,
            rol_usuarios: "usuario",
            contrasena_usuarios
        })
        .select();
    return { data, error };
};

// Obtener todos los usuarios
export const obtenerUsuarios = async () => {
    const { data, error } = await supabase
        .from("usuarios")
        .select("*");
    return { data, error };
};

// Obtener usuario por ID
export const obtenerPorId = async (id) => {
    const { data, error } = await supabase
        .from("usuarios")
        .select("*")
        .eq("id_usuarios", id)
        .single();
    return { data, error };
};


// Obtener usuario por email
export const obtenerPorEmail = async (email) => {
    const { data, error } = await supabase
        .from("usuarios")
        .select("*")
        .eq("email_usuarios", email)
        .single();
    return { data, error };
};

// Actualizar usuario
export const actualizarUsuario = async (id, updatedFields) => {
    const { data, error } = await supabase
        .from("usuarios")
        .update(updatedFields)
        .eq("id_usuarios", id)
        .select();
    return { data, error };
};


// Eliminar usuario
export const eliminarUsuario = async (id) => {
    const { data, error } = await supabase
        .from("usuarios")
        .delete()
        .eq("id_usuarios", id);
    return { data, error };
};