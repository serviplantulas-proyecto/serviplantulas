import express from "express";

import {
    listarDetalles,
    obtenerDetalle,
    obtenerDetallesPorPedido,
    crear,
    editar,
    eliminar
} from "../controllers/detalle-pedidos-controller.js";

import { verificarToken } from "../middlewares/middlewares.js";

const router = express.Router();

// ============================================================
// DETALLE DE PEDIDOS
// ============================================================

// Todas las rutas requieren autenticación.
// En Postman:
// Authorization → Bearer Token → colocar el token obtenido
// al iniciar sesión.


// GET - Obtener todos los detalles
// URL: http://localhost:3000/detalle-pedidos/
// Body: No requiere
// Authorization: Bearer Token

router.get("/", listarDetalles);


// GET - Obtener detalles de un pedido
// URL: http://localhost:3000/detalle-pedidos/pedido/:id_pedido
//
// Ejemplo:
// http://localhost:3000/detalle-pedidos/pedido/1
//
// Body: No requiere
// Authorization: Bearer Token

router.get("/pedido/:id_pedido", obtenerDetallesPorPedido);


// GET - Obtener detalle por ID
// URL: http://localhost:3000/detalle-pedidos/:id
//
// Ejemplo:
// http://localhost:3000/detalle-pedidos/1
//
// Body: No requiere
// Authorization: Bearer Token

router.get("/:id", obtenerDetalle);


// POST - Crear detalle
// URL: http://localhost:3000/detalle-pedidos/
//
// Body: JSON
//
// {
//     "id_pedido": 1,
//     "id_producto": 1,
//     "cantidad": 2,
//     "precio_unitario": 15000
// }
//
// Todos los campos son obligatorios.
//
// cantidad debe ser mayor que 0.
//
// precio_unitario no puede ser negativo.
//
// El sistema verifica automáticamente que el producto
// tenga suficiente stock.
//
// Authorization: Bearer Token

router.post("/", crear);


// PUT - Actualizar detalle
// URL: http://localhost:3000/detalle-pedidos/:id
//
// Ejemplo:
// http://localhost:3000/detalle-pedidos/1
//
// Body: JSON
//
// {
//     "cantidad": 3,
//     "precio_unitario": 15000
// }
//
// Authorization: Bearer Token

router.put("/:id", editar);


// DELETE - Eliminar detalle
// URL: http://localhost:3000/detalle-pedidos/:id
//
// Ejemplo:
// http://localhost:3000/detalle-pedidos/1
//
// Body: No requiere
// Authorization: Bearer Token

router.delete("/:id", eliminar);

export default router;