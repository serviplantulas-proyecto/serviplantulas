import express from "express";

import {
    listarPedidos,
    obtenerPedido,
    crear,
    editar,
    eliminar
} from "../controllers/pedidos-controller.js";

import { verificarToken } from "../middlewares/middlewares.js";

const router = express.Router();

// ============================================================
// PEDIDOS
// ============================================================

// Todas las rutas de pedidos requieren autenticación.
// En Postman:
// Authorization → Bearer Token → colocar el token obtenido
// al iniciar sesión.


// GET - Obtener todos los pedidos
// URL: http://localhost:3000/pedidos/
// Body: No requiere
// Authorization: Bearer Token

router.get("/", verificarToken, listarPedidos);


// GET - Obtener pedido por ID
// URL: http://localhost:3000/pedidos/:id
// Ejemplo:
// http://localhost:3000/pedidos/1
//
// Body: No requiere
// Authorization: Bearer Token

router.get("/:id", verificarToken, obtenerPedido);


// POST - Crear pedido
// URL: http://localhost:3000/pedidos/
//
// Body: JSON
//
// {
//     "id_cliente": 1,
//     "metodo_pago": "Nequi",
//     "observaciones": "Entrega en la tarde"
// }
//
// Campos obligatorios:
// id_cliente
// metodo_pago
//
// El id_usuario NO se envía.
// Se obtiene automáticamente desde el token.
//
// estado → se establece automáticamente como "completado"
// total → se establece inicialmente en 0
//
// Authorization: Bearer Token

router.post("/", verificarToken, crear);


// PUT - Actualizar pedido
// URL: http://localhost:3000/pedidos/:id
// Ejemplo:
// http://localhost:3000/pedidos/1
//
// Body: JSON
//
// Los campos que se pueden actualizar dependen
// de los datos enviados al controlador.
//
// Authorization: Bearer Token

router.put("/:id", verificarToken, editar);


// DELETE - Eliminar pedido
// URL: http://localhost:3000/pedidos/:id
// Ejemplo:
// http://localhost:3000/pedidos/1
//
// Body: No requiere
// Authorization: Bearer Token

router.delete("/:id", verificarToken, eliminar);

export default router;


//backend probado y funcionando correctamente