import express from 'express';
import {listarProveedores, obtenerProveedor, crear, editar, eliminar} from "../controllers/proveedores-controller.js";

const router = express.Router();

// ============================================================
// PROVEEDORES
// ============================================================


// GET - Obtener todos los proveedores
// URL: http://localhost:3000/proveedores/
// Body: No requiere

router.get('/', listarProveedores);


// GET - Obtener proveedor por ID
// URL: http://localhost:3000/proveedores/:id
// Ejemplo: http://localhost:3000/proveedores/1
// Body: No requiere

router.get('/:id', obtenerProveedor);


// POST - Crear proveedor
// URL: http://localhost:3000/proveedores/
// Body: JSON
//
// {
//     "nombre_proveedor": "Viveros El Jardín",
//     "contacto_representante": "Carlos Pérez",
//     "telefono_proveedor": "3001234567",
//     "email_proveedor": "proveedor@gmail.com",
//     "direccion_proveedor": "Cali, Colombia"
// }

router.post('/', crear);


// PUT - Actualizar proveedor
// URL: http://localhost:3000/proveedores/:id
// Ejemplo: http://localhost:3000/proveedores/1
// Body: JSON
//
// Enviar los campos que se quieran actualizar.

router.put('/:id', editar);


// DELETE - Eliminar proveedor
// URL: http://localhost:3000/proveedores/:id
// Ejemplo: http://localhost:3000/proveedores/1
// Body: No requiere

router.delete('/:id', eliminar);

export default router;