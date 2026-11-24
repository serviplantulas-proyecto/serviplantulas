import { supabase } from "../config/supabase.js";
import bcrypt from "bcrypt";

// Crear usuario
export const crearUsuario = async (
    nombre_usuarios,
    apellido_usuarios,
    telefono_usuarios,
    email_usuarios,
    contrasena_usuarios,
    codigoVerificacion,
    codigoVerificacionExpiracion
) => {

    const { data, error } = await supabase
        .from("usuarios")
        .insert({
            nombre_usuarios,
            apellido_usuarios,
            telefono_usuarios,
            email_usuarios,
            contrasena_usuarios,
            rol_usuarios: "admin",
            isVerified: false,
            codigoVerificacion,
            codigoVerificacionExpiracion
        })
        .select()
        .single();

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
        .eq("email_usuarios", String(email).trim().toLowerCase())
        .maybeSingle();

    return { data, error };
};

export const obtenerPorGoogleId = async (googleId) => {
    if (!googleId) return { data: null, error: null };

    const { data, error } = await supabase
        .from("usuarios")
        .select("*")
        .eq("googleId", googleId)
        .maybeSingle();

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


// Obtener usuario para verificar cuenta
export const obtenerUsuarioParaVerificacion = async (email) => {

    const { data, error } = await supabase
        .from("usuarios")
        .select(
            "id_usuarios, email_usuarios, isVerified, codigoVerificacion, codigoVerificacionExpiracion"
        )
        .eq("email_usuarios", email)
        .single();

    return { data, error };
};

// Verificar cuenta
export const verificarUsuario = async (id) => {

    const { data, error } = await supabase
        .from("usuarios")
        .update({
            isVerified: true,
            codigoVerificacion: null,
            codigoVerificacionExpiracion: null
        })
        .eq("id_usuarios", id)
        .select()
        .single();

    return { data, error };
};

//crear usuario google
    export const crearUsuarioGoogle = async ({
    nombre_usuarios,
    apellido_usuarios,
    email_usuarios,
    googleId,
    avatar,
    rol_usuarios = "usuario"
}) => {
    const hashPlaceholder = await bcrypt.hash(
        `google_${googleId}_${Date.now()}`,
        10
    );

    const fila = {
        nombre_usuarios: (nombre_usuarios || "Usuario").toString().trim(),
        apellido_usuarios: (apellido_usuarios || "").toString().trim(),
        telefono_usuarios: "",
        email_usuarios: String(email_usuarios).trim().toLowerCase(),
        contrasena_usuarios: hashPlaceholder,
        rol_usuarios,
        isVerified: true,
        codigoVerificacion: null,
        codigoVerificacionExpiracion: null,
        // Nombres según el schema (camelCase en Supabase)
        googleId: googleId,
        avatar: avatar || null
    };

    const { data, error } = await supabase
        .from("usuarios")
        .insert(fila)
        .select("*");

    if (error) {
        console.error("crearUsuarioGoogle error:", error);
        return { data: null, error };
    }

    const user = Array.isArray(data) ? data[0] : data;
    return { data: user || null, error: null };
};
