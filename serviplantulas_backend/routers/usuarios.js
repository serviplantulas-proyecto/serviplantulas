import express from "express";

import {
    registro,
    login
} from "../controllers/usuario-controller.js";

import {
    forgotPassword,
    verifyCode
} from "../controllers/recuperar-controller.js";

const router = express.Router();


// ============================================================
// AUTENTICACIÓN
// ============================================================


// POST - Registrar usuario
// URL: http://localhost:3000/auth/register
// Body: JSON
//
// {
//     "nombre_usuarios": "Juan",
//     "apellido_usuarios": "Pérez",
//     "telefono_usuarios": "3001234567",
//     "email_usuarios": "juan@gmail.com",
//     "contrasena_usuarios": "123456"
// }

router.post("/register", registro);


// POST - Iniciar sesión
// URL: http://localhost:3000/auth/login
// Body: JSON
//
// {
//     "email_usuarios": "juan@gmail.com",
//     "contrasena_usuarios": "123456"
// }

router.post("/login", login);


// POST - Solicitar recuperación de contraseña
// URL: http://localhost:3000/auth/forgot-password
// Body: JSON
//
// {
//     "email": "juan@gmail.com"
// }

router.post("/forgot-password", forgotPassword);


// POST - Verificar código y cambiar contraseña
// URL: http://localhost:3000/auth/verify-code
// Body: JSON
//
// {
//     "email": "juan@gmail.com",
//     "codigo": "123456",
//     "nuevaContrasena": "NuevaContraseña123"
// }

router.post("/verify-code", verifyCode);


export default router;