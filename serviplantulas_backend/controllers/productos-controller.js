import {
    obtenerTodos,
    obtenerPorId,
    obtenerPorCategoria,
    crearProducto,
    actualizarProducto,
    eliminarProducto
} from "../models/productos-model.js";
import { obtenerPorId as obtenerProveedorPorId } from "../models/proveedores-model.js";

async function resolverSnapshotProveedor(idProveedor, snapshotBody) {
    if (typeof snapshotBody === "string" && snapshotBody.trim()) {
        return snapshotBody.trim();
    }
    if (idProveedor === undefined || idProveedor === null || idProveedor === "") {
        return null;
    }
    const { data: prov } = await obtenerProveedorPorId(idProveedor);
    return (prov?.nombre_proveedor || "").trim() || null;
}

export const listarProductos = async (req, res) => {
    try {
        const { data, error } = await obtenerTodos();
        if (error) {
            return res.status(500).json({ error: "Error al obtener los productos" });
        }
        return res.status(200).json(data);
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

export const obtenerProducto = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await obtenerPorId(id);
        if (error || !data) {
            return res.status(404).json({ error: "Producto no encontrado" });
        }
        return res.status(200).json(data);
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

export const obtenerPorCat = async (req, res) => {
    try {
        const { id_categoria } = req.params;
        const { data, error } = await obtenerPorCategoria(id_categoria);
        if (error) {
            return res.status(500).json({ error: "Error al obtener los productos" });
        }
        return res.status(200).json(data);
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

export const crear = async (req, res) => {
    try {
        const {
            nombre_producto,
            descripcion_producto,
            precio_producto,
            costo_compra,
            stock,
            stock_minimo,
            id_proveedor,
            id_categoria
        } = req.body;

        if (!nombre_producto || precio_producto === undefined) {
            return res.status(400).json({
                error: "nombre_producto y precio_producto son requeridos"
            });
        }

        const imagen_url = req.file ? req.file.path : null;
        const nombre_proveedor_snapshot = await resolverSnapshotProveedor(
            id_proveedor,
            req.body.nombre_proveedor_snapshot
        );

        const { data, error } = await crearProducto({
            nombre_producto,
            descripcion_producto,
            precio_producto,
            costo_compra,
            stock,
            stock_minimo,
            id_proveedor: id_proveedor || null,
            id_categoria: id_categoria || null,
            nombre_proveedor_snapshot,
            imagen_url
        });

        if (error) {
            console.error("Error crear producto:", error);
            return res.status(500).json({ error: "Error al crear el producto" });
        }

        return res.status(201).json({
            message: "Producto creado",
            producto: data[0]
        });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

export const editar = async (req, res) => {
    try {
        const { id } = req.params;
        const datosActualizados = { ...req.body };

        if (req.file) {
            datosActualizados.imagen_url = req.file.path;
        }

        if (Object.prototype.hasOwnProperty.call(datosActualizados, "id_proveedor")) {
            datosActualizados.nombre_proveedor_snapshot =
                await resolverSnapshotProveedor(
                    datosActualizados.id_proveedor,
                    datosActualizados.nombre_proveedor_snapshot
                );
        }

        const { data, error } = await actualizarProducto(id, datosActualizados);

        if (error) {
            console.error("Error actualizar producto:", error);
            return res.status(500).json({ error: "Error al actualizar el producto" });
        }

        return res.status(200).json({
            message: "Producto actualizado",
            producto: data[0]
        });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};

export const eliminar = async (req, res) => {
    try {
        const { id } = req.params;
        const { error } = await eliminarProducto(id);
        if (error) {
            console.error("Error al eliminar el producto:", error);
            return res
                .status(error.code === "23502" || error.code === "23503" ? 409 : 500)
                .json({
                    error:
                        error.message ||
                        "Error al desvincular el historial del producto"
                });
        }
        return res.status(200).json({ message: "Producto eliminado" });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
};
