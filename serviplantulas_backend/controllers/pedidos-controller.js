import {obtenerTodos, obtenerPorId, crearPedido, actualizarPedido, eliminarPedido} from "../models/pedidos-model.js";
import { obtenerPorId as obtenerClientePorId } from "../models/clientes-model.js";

export const listarPedidos = async (req, res) => {
    try {
        const { data, error } = await obtenerTodos();
        if (error) {
            return res.status(500).json({ error: "Error al obtener los pedidos" });
        }
        return res.status(200).json(data);
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

export const obtenerPedido = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await obtenerPorId(id);
        if (error || !data) {
            return res.status(404).json({ error: "Pedido no encontrado" });
        }
        return res.status(200).json(data);
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

export const crear = async (req, res) => {
    try {
        const {
            id_cliente,
            metodo_pago,
            observaciones,
            nombre_cliente_snapshot: snapshotBody
        } = req.body;

        const id_usuario = req.usuario?.id ?? null;

        if (!id_cliente || !metodo_pago) {
            return res.status(400).json({
                error: "id_cliente y metodo_pago son obligatorios"
            });
        }

        // Resolver nombre para snapshot (obligatorio para facturas futuras)
        let nombreSnapshot =
            typeof snapshotBody === "string" ? snapshotBody.trim() : "";

        if (!nombreSnapshot) {
            const { data: cliente, error: errCli } =
                await obtenerClientePorId(id_cliente);
            if (errCli || !cliente) {
                return res.status(404).json({ error: "Cliente no encontrado" });
            }
            nombreSnapshot = (cliente.nombre_cliente || "").trim();
        }

        if (!nombreSnapshot) {
            return res.status(400).json({
                error: "No se pudo obtener el nombre del cliente para el historial"
            });
        }

        const { data, error } = await crearPedido({
            id_usuario,
            id_cliente,
            nombre_cliente_snapshot: nombreSnapshot,
            metodo_pago,
            estado: "completado",
            total: 0,
            observaciones
        });

        if (error) {
            console.error("Error crear pedido:", error);
            return res.status(500).json({ error: "Error al crear el pedido" });
        }

        return res.status(201).json({
            message: "Pedido creado",
            pedido: data[0]
        });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

export const editar = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await actualizarPedido(id, req.body);
        if (error) {
            return res.status(500).json({ error: "Error al actualizar el pedido" });
        }
        return res.status(200).json({
            message: "Pedido actualizado",
            pedido: data[0]
        });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

export const eliminar = async (req, res) => {
    try {
        const { id } = req.params;
        const { error } = await eliminarPedido(id);
        if (error) {
            return res.status(500).json({ error: "Error al eliminar el pedido" });
        }
        return res.status(200).json({ message: "Pedido eliminado" });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};
