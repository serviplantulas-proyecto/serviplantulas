import {
    obtenerTodos,
    obtenerPorId,
    obtenerPorCategoria,
    crearProducto,
    actualizarProducto,
    eliminarProducto
} from "../models/productos-model.js";


// Obtener todos los productos
export const listarProductos = async (req, res) => {
    try {

        const { data, error } = await obtenerTodos();

        if (error) {
            return res.status(500).json({
                error: "Error al obtener los productos"
            });
        }

        return res.status(200).json(data);

    } catch (error) {

        return res.status(500).json({
            error: error.message
        });

    }
};


// Obtener producto por ID
export const obtenerProducto = async (req, res) => {
    try {

        const { id } = req.params;

        const { data, error } = await obtenerPorId(id);

        if (error || !data) {
            return res.status(404).json({
                error: "Producto no encontrado"
            });
        }

        return res.status(200).json(data);

    } catch (error) {

        return res.status(500).json({
            error: error.message
        });

    }
};


// Obtener productos por categoría
export const obtenerPorCat = async (req, res) => {
    try {

        const { id_categoria } = req.params;

        const { data, error } =
            await obtenerPorCategoria(id_categoria);

        if (error) {
            return res.status(500).json({
                error: "Error al obtener los productos"
            });
        }

        return res.status(200).json(data);

    } catch (error) {

        return res.status(500).json({
            error: error.message
        });

    }
};


// Crear producto
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


        // Obtener la URL de la imagen subida a Cloudinary
        const imagen_url = req.file
            ? req.file.path
            : null;


        const { data, error } = await crearProducto({
            nombre_producto,
            descripcion_producto,
            precio_producto,
            costo_compra,
            stock,
            stock_minimo,
            id_proveedor,
            id_categoria,
            imagen_url
        });


        if (error) {
            return res.status(500).json({
                error: "Error al crear el producto"
            });
        }


        return res.status(201).json({
            message: "Producto creado",
            producto: data[0]
        });

    } catch (error) {

        return res.status(500).json({
            error: error.message
        });

    }
};


// Actualizar producto
export const editar = async (req, res) => {
    try {

        const { id } = req.params;


        const datosActualizados = {
            ...req.body
        };


        // Si se envía una nueva imagen,
        // actualizamos la URL de la imagen
        if (req.file) {
            datosActualizados.imagen_url = req.file.path;
        }


        const { data, error } =
            await actualizarProducto(id, datosActualizados);


        if (error) {
            return res.status(500).json({
                error: "Error al actualizar el producto"
            });
        }


        return res.status(200).json({
            message: "Producto actualizado",
            producto: data[0]
        });

    } catch (error) {

        return res.status(500).json({
            error: error.message
        });

    }
};


// Eliminar producto
export const eliminar = async (req, res) => {
    try {

        const { id } = req.params;

        const { error } = await eliminarProducto(id);

        if (error) {
            return res.status(500).json({
                error: "Error al eliminar el producto"
            });
        }

        return res.status(200).json({
            message: "Producto eliminado"
        });

    } catch (error) {

        return res.status(500).json({
            error: error.message
        });

    }
};