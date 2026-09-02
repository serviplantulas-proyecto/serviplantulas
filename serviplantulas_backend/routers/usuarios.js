import express from "express";

import {
    registro,
    login,
    verificarCuenta
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
//
// El rol se asigna automáticamente como "usuario".
// La cuenta queda inicialmente sin verificar.
// Se genera automáticamente un código de verificación
// de 6 dígitos y se envía al correo mediante Brevo.
// El código tiene una duración de 15 minutos.

router.post("/register", registro);


// POST - Iniciar sesión
// URL: http://localhost:3000/auth/login
// Body: JSON
//
// {
//     "email_usuarios": "juan@gmail.com",
//     "contrasena_usuarios": "123456"
// }
//
// La cuenta debe estar verificada antes de iniciar sesión.
// Si la cuenta está verificada, se genera un token JWT.

router.post("/login", login);


// POST - Verificar cuenta
// URL: http://localhost:3000/auth/verify-account
// Body: JSON
//
// {
//     "email_usuarios": "juan@gmail.com",
//     "codigo": "123456"
// }
//
// El código es enviado al correo durante el registro.
// El código tiene una duración de 15 minutos.
// Si el código es correcto y no ha expirado,
// la cuenta queda verificada.

router.post("/verify-account", verificarCuenta);


// POST - Solicitar recuperación de contraseña
// URL: http://localhost:3000/auth/forgot-password
// Body: JSON
//
// {
//     "email": "juan@gmail.com"
// }
//
// Se genera y envía un código de recuperación
// al correo electrónico.

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
//
// Verifica el código enviado para recuperar la contraseña.
// Si el código es correcto y no ha expirado,
// se actualiza la contraseña del usuario.

router.post("/verify-code", verifyCode);


export default router;