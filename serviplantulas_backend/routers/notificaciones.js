import express from "express";

import {
    listarNotificaciones,
    listarNoLeidas,
    obtenerNotificacion,
    crear,
    marcarLeida,
    eliminar
} from "../controllers/notificaciones-controller.js";

import { verificarToken } from "../middlewares/middlewares.js";

const router = express.Router();

// ============================================================
// NOTIFICACIONES
// ============================================================

// Todas las rutas requieren autenticación.
// En Postman:
// Authorization → Bearer Token → colocar el token obtenido
// al iniciar sesión.


// GET - Obtener todas las notificaciones
// URL: http://localhost:3000/notificaciones/
// Body: No requiere
// Authorization: Bearer Token

router.get("/", listarNotificaciones);


// GET - Obtener notificaciones no leídas
// URL: http://localhost:3000/notificaciones/no-leidas
// Body: No requiere
// Authorization: Bearer Token

router.get("/no-leidas", listarNoLeidas);


// GET - Obtener notificación por ID
// URL: http://localhost:3000/notificaciones/:id
//
// Ejemplo:
// http://localhost:3000/notificaciones/1
//
// Body: No requiere
// Authorization: Bearer Token

router.get("/:id", obtenerNotificacion);


// POST - Crear notificación
// URL: http://localhost:3000/notificaciones/
//
// Body: JSON
//
// {
//     "tipo": "poco_stock",
//     "titulo": "Stock bajo",
//     "mensaje": "El producto tiene poco stock",
//     "id_producto": 1
// }
//
// titulo y mensaje son obligatorios.
//
// tipo es opcional.
// Si no se envía, se utiliza "general".
//
// id_producto es opcional.
// Si no se envía, se guarda como null.
//
// Authorization: Bearer Token

router.post("/", crear);


// PUT - Marcar notificación como leída
// URL: http://localhost:3000/notificaciones/:id/leida
//
// Ejemplo:
// http://localhost:3000/notificaciones/1/leida
//
// Body: No requiere
// Authorization: Bearer Token

router.put("/:id/leida", marcarLeida);


// DELETE - Eliminar notificación
// URL: http://localhost:3000/notificaciones/:id
//
// Ejemplo:
// http://localhost:3000/notificaciones/1
//
// Body: No requiere
// Authorization: Bearer Token

router.delete("/:id", eliminar);

export default router;