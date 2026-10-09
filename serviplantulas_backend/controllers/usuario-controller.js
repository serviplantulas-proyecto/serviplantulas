import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { randomInt } from "node:crypto";

import {
    obtenerPorEmail,
    obtenerUsuarioParaVerificacion,
    verificarUsuario,
    crearUsuario,
    actualizarUsuario
} from "../models/usuarios-model.js";
import { enviarCodigoVerificacion } from "../services/email-service.js";

const crearCodigo = () => String(randomInt(100000, 1000000));
const crearExpiracionCodigo = () =>
    new Date(Date.now() + 15 * 60 * 1000).toISOString();

// ==========================================
// REGISTRO
// ==========================================

export const registrarUsuario = async (req, res) => {
    try {
        const body = req.body ?? {};
        const nombre = typeof body.nombre_usuarios === "string"
            ? body.nombre_usuarios.trim()
            : "";
        const apellido = typeof body.apellido_usuarios === "string"
            ? body.apellido_usuarios.trim()
            : "";
        const telefono = typeof body.telefono_usuarios === "string"
            ? body.telefono_usuarios.trim()
            : "";
        const email = typeof body.email_usuarios === "string"
            ? body.email_usuarios.trim().toLowerCase()
            : "";
        const contrasena = body.contrasena_usuarios;

        if (!nombre || !apellido || !telefono || !email || !contrasena) {
            return res.status(400).json({
                error: "Todos los campos son obligatorios"
            });
        }

        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            return res.status(400).json({
                error: "Ingresa un correo electrónico válido"
            });
        }

        const digitosTelefono = telefono.replace(/\D/g, "");
        if (digitosTelefono.length < 7 || digitosTelefono.length > 15) {
            return res.status(400).json({
                error: "Ingresa un número de contacto válido"
            });
        }

        if (typeof contrasena !== "string" || contrasena.length < 8) {
            return res.status(400).json({
                error: "La contraseña debe tener al menos 8 caracteres"
            });
        }

        const { data: usuarioExistente } = await obtenerPorEmail(email);
        if (usuarioExistente?.isVerified) {
            return res.status(409).json({
                error: "Ya existe una cuenta verificada con este correo"
            });
        }

        const codigoVerificacion = crearCodigo();
        const codigoVerificacionExpiracion = crearExpiracionCodigo();
        const contrasenaHasheada = await bcrypt.hash(contrasena, 10);
        let usuario;
        let errorUsuario;

        if (usuarioExistente) {
            const resultado = await actualizarUsuario(
                usuarioExistente.id_usuarios,
                {
                    nombre_usuarios: nombre,
                    apellido_usuarios: apellido,
                    telefono_usuarios: telefono,
                    contrasena_usuarios: contrasenaHasheada,
                    codigoVerificacion,
                    codigoVerificacionExpiracion
                }
            );
            usuario = resultado.data?.[0];
            errorUsuario = resultado.error;
        } else {
            const resultado = await crearUsuario(
                nombre,
                apellido,
                telefono,
                email,
                contrasenaHasheada,
                codigoVerificacion,
                codigoVerificacionExpiracion
            );
            usuario = resultado.data;
            errorUsuario = resultado.error;
        }

        if (errorUsuario || !usuario) {
            console.error("Error al registrar usuario:", errorUsuario);
            return res.status(500).json({
                error: "No fue posible crear la cuenta. Inténtalo de nuevo."
            });
        }

        const envio = await enviarCodigoVerificacion(
            email,
            nombre,
            codigoVerificacion
        );

        if (!envio.exito) {
            return res.status(502).json({
                error: "La cuenta quedó pendiente de verificación, pero no se pudo enviar el código. Intenta crear la cuenta nuevamente para solicitar otro."
            });
        }

        return res.status(201).json({
            mensaje: "Cuenta creada. Revisa tu correo para verificarla."
        });
    } catch (error) {
        console.error("Error en registrarUsuario:", error);
        return res.status(500).json({
            error: "Error interno al crear la cuenta"
        });
    }
};

// ==========================================
// LOGIN
// ==========================================

export const login = async (req, res) => {

    try {

        const body = req.body ?? {};
        const email_usuarios =
            typeof body.email_usuarios === "string"
                ? body.email_usuarios.trim().toLowerCase()
                : "";
        const contrasena_usuarios = body.contrasena_usuarios;


        // Validar datos
        if (
            !email_usuarios ||
            typeof contrasena_usuarios !== "string" ||
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
// REENVIAR CÓDIGO DE VERIFICACIÓN
// ==========================================

export const reenviarCodigoVerificacion = async (req, res) => {
    try {
        const email = typeof req.body?.email_usuarios === "string"
            ? req.body.email_usuarios.trim().toLowerCase()
            : "";

        if (!email) {
            return res.status(400).json({
                error: "El correo electrónico es obligatorio"
            });
        }

        const { data: usuario, error } = await obtenerPorEmail(email);
        if (error || !usuario) {
            return res.status(404).json({
                error: "No existe una cuenta con este correo"
            });
        }

        if (usuario.isVerified) {
            return res.status(400).json({
                error: "La cuenta ya se encuentra verificada"
            });
        }

        const codigo = crearCodigo();
        const { error: errorUpdate } = await actualizarUsuario(
            usuario.id_usuarios,
            {
                codigoVerificacion: codigo,
                codigoVerificacionExpiracion: crearExpiracionCodigo()
            }
        );

        if (errorUpdate) {
            console.error("Error al actualizar código de verificación:", errorUpdate);
            return res.status(500).json({
                error: "No fue posible generar un nuevo código"
            });
        }

        const envio = await enviarCodigoVerificacion(
            email,
            usuario.nombre_usuarios,
            codigo
        );

        if (!envio.exito) {
            return res.status(502).json({
                error: "No se pudo enviar el código. Inténtalo de nuevo."
            });
        }

        return res.status(200).json({
            mensaje: "Se envió un nuevo código de verificación"
        });
    } catch (error) {
        console.error("Error en reenviarCodigoVerificacion:", error);
        return res.status(500).json({
            error: "Error interno al enviar el código"
        });
    }
};



// ==========================================
// VERIFICAR CUENTA
// ==========================================

export const verificarCuenta = async (req, res) => {

    try {

        const body = req.body ?? {};
        const email_usuarios =
            typeof body.email_usuarios === "string"
                ? body.email_usuarios.trim().toLowerCase()
                : "";
        const codigo =
            typeof body.codigo === "string" || typeof body.codigo === "number"
                ? String(body.codigo).trim()
                : "";


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