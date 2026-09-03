import { obtenerTodos, obtenerPorId, obtenerPorCedula, crearCliente, actualizarCliente, eliminarCliente } from "../models/clientes-model.js";

export const listarClientes = async (req, res) => {
    try {
        const { data, error } = await obtenerTodos();
        if (error) {
            return res.status(500).json({
                error: 'Error al obtener los clientes'
            });
        }
        return res.status(200).json(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

export const obtenerCliente = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await obtenerPorId(id);
        if (error || !data) {
            return res.status(404).json({
                error: 'Cliente no encontrado'
            });
        }
        return res.status(200).json(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

export const buscarPorCedula = async (req, res) => {
    try {
        const { cedula } = req.params;
        const { data, error } = await obtenerPorCedula(cedula);
        if (error || !data) {
            return res.status(404).json({
                error: 'Cliente no encontrado'
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
            nombre_cliente,
            telefono_cliente,
            correo_cliente,
            direccion_cliente,
            cedula_cliente
        } = req.body;

        if (!nombre_cliente || !telefono_cliente) {
            return res.status(400).json({
                error: 'nombre_cliente y telefono_cliente son requeridos'
            });
        }

        const { data, error } = await crearCliente({
            nombre_cliente,
            telefono_cliente,
            correo_cliente,
            direccion_cliente,
            cedula_cliente
        });

        if (error) {
            return res.status(500).json({
                error: 'Error al crear el cliente'
            });
        }

        return res.status(201).json({
            message: 'Cliente creado',
            cliente: data[0]
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
        const { data, error } = await actualizarCliente(id, req.body);
        if (error) {
            return res.status(500).json({
                error: 'Error al actualizar el cliente'
            });
        }
        return res.status(200).json({
            message: 'Cliente actualizado',
            cliente: data[0]
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
        const { error } = await eliminarCliente(id);
        if (error) {
            return res.status(500).json({
                error: 'Error al eliminar el cliente'
            });
        }
        return res.status(200).json({
            message: 'Cliente eliminado'
        });

    } catch (error) {

        return res.status(500).json({
            error: error.message
        });
    }
};