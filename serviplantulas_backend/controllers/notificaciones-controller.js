import {obtenerTodas, obtenerNoLeidas, obtenerPorId, crearNotificacion, marcarComoLeida, eliminarNotificacion} from "../models/notificaciones-model.js";

// Obtener todas las notificaciones
export const listarNotificaciones = async (req, res) => {
    try {
        const { data, error } = await obtenerTodas();
        if (error) {
            return res.status(500).json({
                error: "Error al obtener las notificaciones"
            });
        }
        return res.status(200).json(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

// Obtener notificaciones no leídas
export const listarNoLeidas = async (req, res) => {
    try {
        const { data, error } = await obtenerNoLeidas();
        if (error) {
            return res.status(500).json({
                error: "Error al obtener las notificaciones"
            });
        }
        return res.status(200).json(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

// Obtener notificación por ID
export const obtenerNotificacion = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await obtenerPorId(id);
        if (error || !data) {
            return res.status(404).json({
                error: "Notificación no encontrada"
            });
        }
        return res.status(200).json(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

// Crear notificación
export const crear = async (req, res) => {
    try {
        const {
            tipo,
            titulo,
            mensaje,
            id_producto
        } = req.body;

        // Validar campos obligatorios
        if (!titulo || !mensaje) {
            return res.status(400).json({
                error: "El título y el mensaje son obligatorios"
            });
        }

        const { data, error } = await crearNotificacion({
            tipo: tipo || "general",
            titulo,
            mensaje,
            id_producto: id_producto || null
        });

        if (error) {
            return res.status(500).json({
                error: "Error al crear la notificación"
            });
        }

        return res.status(201).json({
            message: "Notificación creada correctamente",
            notificacion: data[0]
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

// Marcar notificación como leída
export const marcarLeida = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await marcarComoLeida(id);

        if (error) {
            return res.status(500).json({
                error: "Error al actualizar la notificación"
            });
        }

        if (!data || data.length === 0) {
            return res.status(404).json({
                error: "Notificación no encontrada"
            });
        }

        return res.status(200).json({
            message: "Notificación marcada como leída",
            notificacion: data[0]
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

// Eliminar notificación
export const eliminar = async (req, res) => {
    try {
        const { id } = req.params;
        const { error } = await eliminarNotificacion(id);
        if (error) {
            return res.status(500).json({
                error: "Error al eliminar la notificación"
            });
        }

        return res.status(200).json({
            message: "Notificación eliminada correctamente"
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

export const limpiarAntiguas = async (req, res) => {
    try {
        const dias = parseInt(req.body?.dias ?? req.query?.dias, 10);
        const permitidos = [7, 30, 90, 180, 365];
        if (!permitidos.includes(dias)) {
            return res.status(400).json({
                error: "dias debe ser 7, 30, 90, 180 o 365"
            });
        }
        const { error, eliminadas } = await eliminarAntiguas(dias);
        if (error) {
            console.error("limpiarAntiguas:", error);
            return res.status(500).json({
                error: "Error al limpiar notificaciones antiguas"
            });
        }
        return res.status(200).json({
            message: "Limpieza completada",
            dias,
            eliminadas
        });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};