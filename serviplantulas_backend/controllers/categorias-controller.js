import { obtenerTodos, obtenerPorId, crearCategoria, actualizarCategoria, eliminarCategoria } from "../models/categorias-model.js";

export const listarCategorias = async (req, res) => {
    try {
        const { data, error } = await obtenerTodos();
        if (error) {
            return res.status(500).json({
                error: 'Error al obtener las categorías'
            });
        }
        return res.status(200).json(data);

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};

export const obtenerCategoria = async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await obtenerPorId(id);
        if (error || !data) {
            return res.status(404).json({
                error: 'Categoría no encontrada'
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
            nombre_categoria,
            descripcion_categoria,
            estado
        } = req.body;

        if (!nombre_categoria) {
            return res.status(400).json({
                error: 'nombre_categoria es requerido'
            });
        }

        const { data, error } = await crearCategoria({
            nombre_categoria,
            descripcion_categoria,
            estado
        });

        if (error) {
            return res.status(500).json({
                error: 'Error al crear la categoría'
            });
        }

        return res.status(201).json({
            message: 'Categoría creada',
            categoria: data[0]
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
        const { data, error } = await actualizarCategoria(id, req.body);

        if (error) {
            return res.status(500).json({
                error: 'Error al actualizar la categoría'
            });
        }
        return res.status(200).json({
            message: 'Categoría actualizada',
            categoria: data[0]
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
        const { error } = await eliminarCategoria(id);
        if (error) {
            return res.status(500).json({
                error: 'Error al eliminar la categoría'
            });
        }
        return res.status(200).json({
            message: 'Categoría eliminada'
        });

    } catch (error) {
        return res.status(500).json({
            error: error.message
        });
    }
};