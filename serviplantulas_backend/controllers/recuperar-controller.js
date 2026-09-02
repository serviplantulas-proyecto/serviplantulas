import bcrypt from "bcrypt";
import nodemailer from "nodemailer";

import {
    crearCodigoRecuperacion,
    obtenerCodigoValido,
    marcarComoUsado
} from "../models/recuperar-model.js";

import {
    obtenerPorEmail,
    actualizarUsuario
} from "../models/usuarios-model.js";


// Configuración de Nodemailer

const transporter = nodemailer.createTransport({

    service: "gmail",

    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASSWORD
    }

});


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


        // Enviar correo

        await transporter.sendMail({

            from: process.env.EMAIL_USER,

            to: email,

            subject: "Código de recuperación - Serviplántulas",

            html: `

                <div style="
                    font-family: Arial, sans-serif;
                    max-width: 600px;
                    margin: auto;
                    padding: 20px;
                    border: 1px solid #ddd;
                    border-radius: 10px;
                ">

                    <h2>
                        Recuperación de contraseña
                    </h2>

                    <p>
                        Hola ${usuario.nombre_usuarios || "usuario"}.
                    </p>

                    <p>
                        Hemos recibido una solicitud para
                        recuperar tu contraseña.
                    </p>

                    <p>
                        Tu código de recuperación es:
                    </p>

                    <h1 style="
                        letter-spacing: 8px;
                        text-align: center;
                    ">
                        ${codigo}
                    </h1>

                    <p>
                        Este código expirará en
                        <strong>15 minutos</strong>.
                    </p>

                    <p>
                        Si no solicitaste este cambio,
                        puedes ignorar este mensaje.
                    </p>

                    <p>
                        <strong>
                            No compartas este código con nadie.
                        </strong>
                    </p>

                    <p>
                        Serviplántulas 🌱
                    </p>

                </div>

            `

        });


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


// ==========================================
// VERIFICAR CÓDIGO Y CAMBIAR CONTRASEÑA
// ==========================================

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


        // Enviar confirmación por correo

        await transporter.sendMail({

            from: process.env.EMAIL_USER,

            to: email,

            subject:
                "Contraseña actualizada - Serviplántulas",

            html: `

                <div style="
                    font-family: Arial, sans-serif;
                    max-width: 600px;
                    margin: auto;
                    padding: 20px;
                    border: 1px solid #ddd;
                    border-radius: 10px;
                ">

                    <h2>
                        Contraseña actualizada
                    </h2>

                    <p>
                        Hola ${usuario.nombre_usuarios || "usuario"}.
                    </p>

                    <p>
                        Tu contraseña de
                        <strong>Serviplántulas</strong>
                        ha sido actualizada correctamente.
                    </p>

                    <p>
                        Si tú no realizaste este cambio,
                        contacta al administrador.
                    </p>

                    <p>
                        Serviplántulas 🌱
                    </p>

                </div>

            `

        });


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