import express from "express";

import {
    listarProductos,
    obtenerProducto,
    obtenerPorCat,
    crear,
    editar,
    eliminar
} from "../controllers/productos-controller.js";

import {
    verificarToken,
    verificarAdmin
} from "../middlewares/middlewares.js";

import { upload } from "../config/cloudinary.js";

const router = express.Router();


// ============================================================
// PRODUCTOS
// ============================================================

// GET - Obtener todos los productos
// URL: http://localhost:3000/productos/productos
// Body: No requiere

router.get("/productos", listarProductos);


// GET - Obtener producto por ID
// URL: http://localhost:3000/productos/productos/:id
// Ejemplo: http://localhost:3000/productos/productos/1
// Body: No requiere

router.get("/productos/:id", obtenerProducto);


// GET - Obtener productos por categoría
// URL: http://localhost:3000/productos/productos/categoria/:id_categoria
// Ejemplo: http://localhost:3000/productos/productos/categoria/1
// Body: No requiere

router.get("/productos/categoria/:id_categoria", obtenerPorCat);


// POST - Crear producto
// URL: http://localhost:3000/productos/productos
// Autenticación: Token + administrador
// Body: form-data
//
// nombre_producto       → Text
// descripcion_producto  → Text
// precio_producto       → Text
// costo_compra          → Text
// stock                 → Text
// stock_minimo          → Text
// id_proveedor          → Text
// id_categoria          → Text
// imagen                → File

router.post(
    "/productos",
    verificarToken,
    verificarAdmin,
    upload.single("imagen"),
    crear
);


// PUT - Actualizar producto
// URL: http://localhost:3000/productos/productos/:id
// Ejemplo: http://localhost:3000/productos/productos/1
// Autenticación: Token + administrador
// Body: form-data
//
// Se pueden enviar los campos que se quieran modificar.
// imagen → File (opcional)

router.put(
    "/productos/:id",
    verificarToken,
    verificarAdmin,
    upload.single("imagen"),
    editar
);


// DELETE - Eliminar producto
// URL: http://localhost:3000/productos/productos/:id
// Ejemplo: http://localhost:3000/productos/productos/1
// Autenticación: Token + administrador
// Body: No requiere

router.delete(
    "/productos/:id",
    verificarToken,
    verificarAdmin,
    eliminar
);


export default router;