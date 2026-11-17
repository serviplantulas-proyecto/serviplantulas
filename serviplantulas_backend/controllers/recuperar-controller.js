import bcrypt from "bcrypt";

import {
    crearCodigoRecuperacion,
    obtenerCodigoValido,
    marcarComoUsado
} from "../models/recuperar-model.js";

import {
    obtenerPorEmail,
    actualizarUsuario
} from "../models/usuarios-model.js";

import {
    enviarCodigoRecuperacion,
    enviarConfirmacionCambioContrasena,
    enviarConfirmacionCambioPerfil
} from "../services/email-service.js";


// ==========================================
// SOLICITAR RECUPERACIÓN DE CONTRASEÑA
// ==========================================

export const forgotPassword = async (req, res) => {

    try {

        const email = req.body.email?.trim().toLowerCase();


        // Validar correo

        if (!email) {

            return res.status(400).json({
                error: "El correo electrónico es requerido"
            });

        }


        // Buscar usuario

        const {
            data: usuario,
            error: errorUsuario
        } = await obtenerPorEmail(email);


        if (errorUsuario || !usuario) {

            return res.status(404).json({
                error: "Usuario no encontrado"
            });

        }


        // Generar código de 6 dígitos

        const codigo = Math.floor(
            100000 + Math.random() * 900000
        );


        // Guardar código en la base de datos

        const {
            error: errorCodigo
        } = await crearCodigoRecuperacion(
            usuario.id_usuarios,
            codigo
        );


        if (errorCodigo) {

            console.error(
                "Error al crear código:",
                errorCodigo
            );

            return res.status(500).json({
                error: "Error al crear el código de recuperación"
            });

        }


        // Enviar correo con Brevo

        const envio = await enviarCodigoRecuperacion(
            email,
            usuario.nombre_usuarios,
            codigo
        );

        if (!envio.exito) {
            return res.status(502).json({
                error: "No se pudo enviar el correo de recuperación. Inténtalo de nuevo."
            });
        }


        return res.status(200).json({

            message:
                "Código de recuperación enviado al correo"

        });


    } catch (error) {

        console.error(
            "Error al enviar el correo:",
            error
        );

        return res.status(500).json({

            error:
                "Error al enviar el correo de recuperación"

        });

    }

};


// VERIFICAR CÓDIGO Y CAMBIAR CONTRASEÑA

export const verifyCode = async (req, res) => {

    try {

        const email =
            req.body.email?.trim().toLowerCase();

        const codigo =
            req.body.codigo;

        const nuevaContrasena =
            req.body.nuevaContrasena;


        // Validar datos

        if (
            !email ||
            !codigo ||
            !nuevaContrasena
        ) {

            return res.status(400).json({

                error:
                    "Todos los campos son requeridos"

            });

        }


        // Buscar usuario

        const {
            data: usuario,
            error: errorUsuario
        } = await obtenerPorEmail(email);


        if (errorUsuario || !usuario) {

            return res.status(404).json({

                error:
                    "Usuario no encontrado"

            });

        }


        // Buscar código válido

        const {
            data: codigoRecord,
            error: errorCodigo
        } = await obtenerCodigoValido(
            usuario.id_usuarios,
            codigo
        );


        if (
            errorCodigo ||
            !codigoRecord
        ) {

            return res.status(400).json({

                error:
                    "Código de recuperación inválido o expirado"

            });

        }


        // Encriptar nueva contraseña

        const hashedPassword =
            await bcrypt.hash(
                nuevaContrasena,
                10
            );


        // Actualizar contraseña

        const {
            error: updateError
        } = await actualizarUsuario(

            usuario.id_usuarios,

            {
                contrasena_usuarios:
                    hashedPassword
            }

        );


        if (updateError) {

            console.error(
                "Error actualizando contraseña:",
                updateError
            );

            return res.status(500).json({

                error:
                    "Error al actualizar la contraseña"

            });

        }


        // Marcar código como utilizado

        const {
            error: errorMarcar
        } = await marcarComoUsado(
            codigoRecord.id
        );


        if (errorMarcar) {

            console.error(
                "Error marcando código:",
                errorMarcar
            );

            return res.status(500).json({

                error:
                    "La contraseña fue actualizada, pero hubo un error al marcar el código"

            });

        }


        // Enviar confirmación por correo (Brevo)
        // No bloqueamos la respuesta si falla el envío

        await enviarConfirmacionCambioContrasena(
            email,
            usuario.nombre_usuarios
        );


        return res.status(200).json({

            message:
                "Contraseña actualizada correctamente"

        });


    } catch (error) {

        console.error(
            "Error en verifyCode:",
            error
        );

        return res.status(500).json({

            error:
                "Error al verificar el código o cambiar la contraseña"

        });

    }

};


export const verifyProfileChange = async (req, res) => {
    try {
        const email = req.body.email?.trim().toLowerCase();
        const codigo = req.body.codigo;
        const nuevoEmail = req.body.nuevo_email?.trim().toLowerCase();
        const nuevoTelefono = req.body.nuevo_telefono?.trim();

        if (!email || !codigo) {
            return res.status(400).json({ error: "Email y código son requeridos" });
        }
        if (!nuevoEmail && !nuevoTelefono) {
            return res.status(400).json({
                error: "Debes enviar nuevo_email o nuevo_telefono"
            });
        }

        const { data: usuario, error: errorUsuario } = await obtenerPorEmail(email);
        if (errorUsuario || !usuario) {
            return res.status(404).json({ error: "Usuario no encontrado" });
        }

        const { data: codigoRecord, error: errorCodigo } =
            await obtenerCodigoValido(usuario.id_usuarios, codigo);
        if (errorCodigo || !codigoRecord) {
            return res.status(400).json({
                error: "Código inválido o expirado"
            });
        }

        const campos = {};
        if (nuevoEmail) {
            const { data: existente } = await obtenerPorEmail(nuevoEmail);
            if (existente && existente.id_usuarios !== usuario.id_usuarios) {
                return res.status(400).json({
                    error: "Ese correo ya está registrado"
                });
            }
            campos.email_usuarios = nuevoEmail;
        }
        if (nuevoTelefono) {
            campos.telefono_usuarios = nuevoTelefono;
        }

        const { error: updateError } = await actualizarUsuario(
            usuario.id_usuarios,
            campos
        );
        if (updateError) {
            return res.status(500).json({ error: "Error al actualizar el perfil" });
        }

        await marcarComoUsado(codigoRecord.id);

        const destino = nuevoEmail || email;

        // Enviar confirmación por correo (Brevo)
        // No bloqueamos la respuesta si falla el envío
        await enviarConfirmacionCambioPerfil(
            destino,
            usuario.nombre_usuarios,
            { nuevoEmail, nuevoTelefono }
        );

        return res.status(200).json({
            message: "Perfil actualizado correctamente",
            email: nuevoEmail || email,
            telefono: nuevoTelefono || usuario.telefono_usuarios || null
        });
    } catch (error) {
        console.error("Error en verifyProfileChange:", error);
        return res.status(500).json({ error: "Error al actualizar el perfil" });
    }
};