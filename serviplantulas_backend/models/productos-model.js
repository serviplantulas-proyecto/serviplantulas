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
    const { data: detalles, error: detallesError } = await supabase
        .from('detalle_pedidos')
        .update({ id_producto: null })
        .eq('id_producto', id)
        .select('id_detalle');

    if (detallesError) {
        return { data: null, error: detallesError };
    }

    const { data: notificaciones, error: notificacionesError } = await supabase
        .from('notificaciones')
        .update({ id_producto: null })
        .eq('id_producto', id)
        .select('id_notificacion');

    if (notificacionesError) {
        if (detalles.length > 0) {
            const { error: restaurarError } = await supabase
                .from('detalle_pedidos')
                .update({ id_producto: id })
                .in('id_detalle', detalles.map((detalle) => detalle.id_detalle))
                .is('id_producto', null);

            if (restaurarError) {
                return {
                    data: null,
                    error: new Error(
                        `${notificacionesError.message}; también falló la restauración del historial: ${restaurarError.message}`
                    )
                };
            }
        }
        return { data: null, error: notificacionesError };
    }

    const { data, error } = await supabase
        .from('productos')
        .delete()
        .eq('id_producto', id)
        .select('id_producto');

    if (error) {
        const erroresRestauracion = [];

        if (notificaciones.length > 0) {
            const { error: restaurarError } = await supabase
                .from('notificaciones')
                .update({ id_producto: id })
                .in(
                    'id_notificacion',
                    notificaciones.map((notificacion) => notificacion.id_notificacion)
                )
                .is('id_producto', null);
            if (restaurarError) erroresRestauracion.push(restaurarError.message);
        }

        if (detalles.length > 0) {
            const { error: restaurarError } = await supabase
                .from('detalle_pedidos')
                .update({ id_producto: id })
                .in('id_detalle', detalles.map((detalle) => detalle.id_detalle))
                .is('id_producto', null);
            if (restaurarError) erroresRestauracion.push(restaurarError.message);
        }

        if (erroresRestauracion.length > 0) {
            return {
                data: null,
                error: new Error(
                    `${error.message}; también falló la restauración del historial: ${erroresRestauracion.join('; ')}`
                )
            };
        }
    }

    return { data, error };

};