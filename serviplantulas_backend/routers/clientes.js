import express from 'express';
import {listarClientes, obtenerCliente, buscarPorCedula, crear, editar, eliminar} from "../controllers/clientes-controller.js";

const router = express.Router();

// ============================================================
// CLIENTES
// ============================================================


// GET - Obtener todos los clientes
// URL: http://localhost:3000/clientes/
// Body: No requiere

router.get('/', listarClientes);


// GET - Buscar cliente por cédula
// URL: http://localhost:3000/clientes/cedula/:cedula
// Ejemplo: http://localhost:3000/clientes/cedula/1234567890
// Body: No requiere

router.get('/cedula/:cedula', buscarPorCedula);


// GET - Obtener cliente por ID
// URL: http://localhost:3000/clientes/:id
// Ejemplo: http://localhost:3000/clientes/1
// Body: No requiere

router.get('/:id', obtenerCliente);


// POST - Crear cliente
// URL: http://localhost:3000/clientes/
// Body: JSON
//
// {
//     "nombre_cliente": "Juan Pérez",
//     "telefono_cliente": "3001234567",
//     "correo_cliente": "juan@gmail.com",
//     "direccion_cliente": "Cali, Colombia",
//     "cedula_cliente": "1234567890"
// }

router.post('/', crear);


// PUT - Actualizar cliente
// URL: http://localhost:3000/clientes/:id
// Ejemplo: http://localhost:3000/clientes/1
// Body: JSON
//
// Enviar los campos que se quieran modificar.

router.put('/:id', editar);


// DELETE - Eliminar cliente
// URL: http://localhost:3000/clientes/:id
// Ejemplo: http://localhost:3000/clientes/1
// Body: No requiere

router.delete('/:id', eliminar);

export default router;