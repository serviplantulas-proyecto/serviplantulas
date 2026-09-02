import express from 'express';
import {listarCategorias, obtenerCategoria, crear, editar, eliminar} from "../controllers/categorias-controller.js";

const router = express.Router();

// ============================================================
// CATEGORÍAS
// ============================================================


// GET - Obtener todas las categorías
// URL: http://localhost:3000/categorias/
// Body: No requiere

router.get('/', listarCategorias);


// GET - Obtener categoría por ID
// URL: http://localhost:3000/categorias/:id
// Ejemplo: http://localhost:3000/categorias/1
// Body: No requiere

router.get('/:id', obtenerCategoria);


// POST - Crear categoría
// URL: http://localhost:3000/categorias/
// Body: JSON
//
// {
//     "nombre_categoria": "Ornamentales",
//     "descripcion_categoria": "Plantas ornamentales"
// }

router.post('/', crear);


// PUT - Actualizar categoría
// URL: http://localhost:3000/categorias/:id
// Ejemplo: http://localhost:3000/categorias/1
// Body: JSON
//
// {
//     "nombre_categoria": "Plantas ornamentales",
//     "descripcion_categoria": "Descripción actualizada",
//     "estado": true
// }

router.put('/:id', editar);


// DELETE - Eliminar categoría
// URL: http://localhost:3000/categorias/:id
// Ejemplo: http://localhost:3000/categorias/1
// Body: No requiere

router.delete('/:id', eliminar);

export default router;