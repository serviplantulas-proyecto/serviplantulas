import { supabase } from "../config/supabase.js";

// Obtener todas las notificaciones
export const obtenerTodas = async () => {
    const { data, error } = await supabase
        .from("notificaciones")
        .select("*")
        .order("creada_en", { ascending: false });
    return { data, error };
};

// Obtener notificaciones no leídas
export const obtenerNoLeidas = async () => {
    const { data, error } = await supabase
        .from("notificaciones")
        .select("*")
        .eq("leida", false)
        .order("creada_en", { ascending: false });
    return { data, error };
};

// Obtener una notificación por ID
export const obtenerPorId = async (id) => {
    const { data, error } = await supabase
        .from("notificaciones")
        .select("*")
        .eq("id_notificacion", id)
        .single();
    return { data, error };
};

// Crear notificación
export const crearNotificacion = async (notificacionData) => {
    const { data, error } = await supabase
        .from("notificaciones")
        .insert(notificacionData)
        .select();
    return { data, error };
};

// Marcar notificación como leída
export const marcarComoLeida = async (id) => {
    const { data, error } = await supabase
        .from("notificaciones")
        .update({
            leida: true
        })
        .eq("id_notificacion", id)
        .select();
    return { data, error };
};

// Eliminar notificación
export const eliminarNotificacion = async (id) => {
    const { data, error } = await supabase
        .from("notificaciones")
        .delete()
        .eq("id_notificacion", id);
    return { data, error };
};