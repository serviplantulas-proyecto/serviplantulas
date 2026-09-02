import { supabase } from "../config/supabase.js";


// Crear codigo de recuperacion

export const crearCodigoRecuperacion = async (usuarioId, codigo) => {

    // El codigo tendra una duracion de 15 minutos

    const expiresAt = new Date(
        Date.now() + 15 * 60 * 1000
    );


    const { data, error } = await supabase
        .from("recovery_codes")
        .insert({
            usuario_id: usuarioId,
            codigo: String(codigo),
            expires_at: expiresAt.toISOString()
        })
        .select();

    return { data, error };

};


// Obtener codigo valido

export const obtenerCodigoValido = async (usuarioId, codigo) => {

    const codigoBuscado = String(codigo);


    const { data, error } = await supabase
        .from("recovery_codes")
        .select("*")
        .eq("usuario_id", usuarioId);

    if (error) {
        return {
            data: null,
            error
        };
    }


    const codigoRecord = (data || []).find((registro) => {

        const codigoDb = String(
            registro.codigo ?? ""
        );

        const expirado =
            new Date(registro.expires_at) <= new Date();


        return (
            !registro.usado &&
            codigoDb === codigoBuscado &&
            !expirado
        );

    });


    return {
        data: codigoRecord ?? null,
        error: null
    };

};


// Marcar codigo como utilizado

export const marcarComoUsado = async (codigoId) => {

    const { data, error } = await supabase
        .from("recovery_codes")
        .update({
            usado: true
        })
        .eq("id", codigoId)
        .select();

    return { data, error };

};