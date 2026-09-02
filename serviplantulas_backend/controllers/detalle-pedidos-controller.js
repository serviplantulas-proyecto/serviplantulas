import {obtenerTodos,obtenerPorId,obtenerPorPedido,crearDetalle,actualizarDetalle,eliminarDetalle} from "../models/detalle-pedidos-model.js";
import {obtenerPorId as obtenerProductoPorId} from "../models/productos-model.js";

// Obtener todos los detalles
export const listarDetalles = async (req, res) => { 
    try {
        const { data, error } = await obtenerTodos();
        if (error) {
            return res.status(500).json({
                error: "Error al obtener los detalles"
            });
        }
        return res.status(200).json(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

// Obtener detalle por ID
export const obtenerDetalle = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await obtenerPorId(id);
        if (error || !data) {
            return res.status(404).json({
                error: "Detalle no encontrado"
            });
        }
        return res.status(200).json(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

// Obtener detalles de un pedido
export const obtenerDetallesPorPedido = async (req, res) => {
    try {
        const { id_pedido } = req.params;
        const { data, error } = await obtenerPorPedido(id_pedido);
        if (error) {
            return res.status(500).json({
                error: "Error al obtener los detalles del pedido"
            });
        }
        return res.status(200).json(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

// Crear detalle
export const crear = async (req, res) => {
    try {
        const {
            id_pedido,
            id_producto,
            cantidad,
            precio_unitario
        } = req.body;

        // Validar campos obligatorios
        if (
            !id_pedido ||
            !id_producto ||
            !cantidad ||
            precio_unitario === undefined
        ) {
            return res.status(400).json({
                error: "Todos los campos son obligatorios"
            });
        }

        // Validar cantidad
        if (cantidad <= 0) {
            return res.status(400).json({
                error: "La cantidad debe ser mayor que 0"
            });
        }

        // Validar precio
        if (precio_unitario < 0) {

            return res.status(400).json({
                error: "El precio no puede ser negativo"
            });
        }

        // Buscar producto utilizando su model
        const {
            data: producto,
            error: errorProducto
        } = await obtenerProductoPorId(id_producto);

        if (errorProducto || !producto) {
            return res.status(404).json({
                error: "Producto no encontrado"
            });
        }

        // Verificar stock disponible
        if (producto.stock < cantidad) {
            return res.status(400).json({
                error: `Stock insuficiente. Disponible: ${producto.stock}`
            });
        }

        // Crear detalle
        const { data, error } = await crearDetalle({
            id_pedido,
            id_producto,
            cantidad,
            precio_unitario
        });

        if (error) {
            return res.status(500).json({
                error: "Error al agregar el producto al pedido"
            });
        }

        return res.status(201).json({
            message: "Producto agregado correctamente al pedido",
            detalle: data[0]
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

// Editar detalle
export const editar = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } =
            await actualizarDetalle(id, req.body);

        if (error) {
            return res.status(500).json({
                error: "Error al actualizar el detalle"
            });
        }

        if (!data || data.length === 0) {
            return res.status(404).json({
                error: "Detalle no encontrado"
            });
        }

        return res.status(200).json({
            message: "Detalle actualizado correctamente",
            detalle: data[0]
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

// Eliminar detalle
export const eliminar = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await eliminarDetalle(id);

        if (error) {
            return res.status(500).json({
                error: "Error al eliminar el detalle"
            });
        }

        return res.status(200).json({
            message: "Detalle eliminado correctamente"
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};