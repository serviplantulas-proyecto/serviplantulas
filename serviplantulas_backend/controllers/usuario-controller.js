import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

import {
    obtenerPorEmail,
    obtenerUsuarioParaVerificacion,
    verificarUsuario
} from "../models/usuarios-model.js";



// ==========================================
// LOGIN
// ==========================================

export const login = async (req, res) => {

    try {

        const {
            email_usuarios,
            contrasena_usuarios
        } = req.body;


        // Validar datos
        if (
            !email_usuarios ||
            !contrasena_usuarios
        ) {

            return res.status(400).json({
                error: "Todos los campos deben estar llenos"
            });

        }


        // Buscar usuario
        const { data: usuario } =
            await obtenerPorEmail(email_usuarios);


        if (!usuario) {

            return res.status(400).json({
                error: "El correo no está registrado"
            });

        }


        // Comparar contraseña
        const passwordValida =
            await bcrypt.compare(
                contrasena_usuarios,
                usuario.contrasena_usuarios
            );


        if (!passwordValida) {

            return res.status(400).json({
                error: "Contraseña incorrecta"
            });

        }


        // ==========================================
        // VERIFICAR CUENTA
        // ==========================================

        if (!usuario.isVerified) {

            return res.status(403).json({

                error:
                    "Tu cuenta no ha sido verificada. Debes ingresar el código enviado a tu correo antes de iniciar sesión."

            });

        }


        // ==========================================
        // GENERAR TOKEN
        // ==========================================

        const token = jwt.sign(

            {
                id: usuario.id_usuarios,
                nombre: usuario.nombre_usuarios,
                apellido: usuario.apellido_usuarios,
                rol: usuario.rol_usuarios,
                email: usuario.email_usuarios
            },

            process.env.JWT_SECRET,

            {
                expiresIn: "1h"
            }

        );


        return res.status(200).json({

            mensaje: "Login exitoso",

            token,

            usuario: {

                id: usuario.id_usuarios,
                nombre: usuario.nombre_usuarios,
                apellido: usuario.apellido_usuarios,
                email: usuario.email_usuarios,
                rol: usuario.rol_usuarios

            }

        });


    } catch (error) {

        console.error("Error en el login:", error);

        return res.status(500).json({
            error: error.message || "Error interno"
        });

    }

};



// ==========================================
// VERIFICAR CUENTA
// ==========================================

export const verificarCuenta = async (req, res) => {

    try {

        const {
            email_usuarios,
            codigo
        } = req.body;


        // Validar datos
        if (!email_usuarios || !codigo) {

            return res.status(400).json({

                error:
                    "El correo electrónico y el código de verificación son obligatorios"

            });

        }


        // Buscar usuario
        const {
            data: usuario,
            error: errorUsuario
        } = await obtenerUsuarioParaVerificacion(
            email_usuarios
        );


        if (errorUsuario || !usuario) {

            return res.status(404).json({
                error: "Usuario no encontrado"
            });

        }


        // Verificar si ya está verificado
        if (usuario.isVerified) {

            return res.status(400).json({

                error:
                    "La cuenta ya se encuentra verificada"

            });

        }


        // Comparar código
        if (
            String(usuario.codigoVerificacion).trim() !==
            String(codigo).trim()
        ) {

            return res.status(400).json({

                error:
                    "El código de verificación es incorrecto"

            });

        }


        // Verificar expiración
        const ahora = new Date();

        const expiracion =
            new Date(
                usuario.codigoVerificacionExpiracion
            );


        if (ahora > expiracion) {

            return res.status(400).json({

                error:
                    "El código ha expirado. Solicita uno nuevo."

            });

        }


        // Activar cuenta
        const {
            data: usuarioVerificado,
            error: errorUpdate
        } = await verificarUsuario(
            usuario.id_usuarios
        );


        if (errorUpdate) {

            console.error(
                "Error al verificar usuario:",
                errorUpdate
            );

            return res.status(500).json({

                error:
                    "Error al actualizar el estado de verificación"

            });

        }


        return res.status(200).json({

            mensaje:
                "Cuenta verificada exitosamente. Ya puedes iniciar sesión."

        });


    } catch (error) {

        console.error(
            "Error en verificarCuenta:",
            error
        );

        return res.status(500).json({

            error:
                error.message || "Error interno"

        });

    }

};