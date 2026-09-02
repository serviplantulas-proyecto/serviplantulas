import {obtenerTodos, obtenerPorId, crearProveedor, actualizarProveedor, eliminarProveedor} from "../models/proveedores-model.js";

export const listarProveedores = async (req, res) => {
    try {
        const { data, error } = await obtenerTodos();
        if (error) {
            return res.status(500).json({
                error: 'Error al obtener los proveedores'
            });
        }
        return res.status(200).json(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};


export const obtenerProveedor = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await obtenerPorId(id);
        if (error || !data) {
            return res.status(404).json({
                error: 'Proveedor no encontrado'
            });
        }
        return res.status(200).json(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

export const crear = async (req, res) => {
    try {
        const {
            nombre_proveedor,
            contacto_representante,
            telefono_proveedor,
            email_proveedor,
            direccion_proveedor
        } = req.body;

        if (!nombre_proveedor) {
            return res.status(400).json({
                error: 'nombre_proveedor es requerido'
            });
        }

        const { data, error } = await crearProveedor({
            nombre_proveedor,
            contacto_representante,
            telefono_proveedor,
            email_proveedor,
            direccion_proveedor
        });

        if (error) {
            return res.status(500).json({
                error: 'Error al crear el proveedor'
            });
        }

        return res.status(201).json({
            message: 'Proveedor creado',
            proveedor: data[0]
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

export const editar = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await actualizarProveedor(id, req.body);
        if (error) {
            return res.status(500).json({
                error: 'Error al actualizar el proveedor'
            });
        }
        return res.status(200).json({
            message: 'Proveedor actualizado',
            proveedor: data[0]
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

export const eliminar = async (req, res) => {
    try {
        const { id } = req.params;
        const { error } = await eliminarProveedor(id);
        if (error) {
            return res.status(500).json({
                error: 'Error al eliminar el proveedor'
            });
        }
        return res.status(200).json({
            message: 'Proveedor eliminado'
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};