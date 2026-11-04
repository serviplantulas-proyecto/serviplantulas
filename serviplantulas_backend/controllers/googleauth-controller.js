import jwt from "jsonwebtoken";
import { OAuth2Client } from "google-auth-library";
import {
    obtenerPorEmail,
    crearUsuarioGoogle,
    actualizarUsuario
} from "../models/usuarios-model.js";

const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

export const autenticarConGoogle = async (req, res) => {
    try {
        const { idToken } = req.body;

        if (!idToken) {
            return res.status(400).json({
                error: "El idToken de Google es requerido"
            });
        }

        const ticket = await client.verifyIdToken({
            idToken,
            audience: process.env.GOOGLE_CLIENT_ID
        });

        const payload = ticket.getPayload();
        if (!payload?.email) {
            return res.status(401).json({
                error: "No se pudo obtener el correo de Google"
            });
        }

        // Payload real de Google: email, name, given_name, family_name, picture, sub
        const googleId = payload.sub;
        const email = String(payload.email).trim().toLowerCase();
        const nombre =
            (payload.given_name || payload.name || "Usuario").toString().trim();
        const apellido = (payload.family_name || "").toString().trim();
        const avatar = payload.picture || null;

        const { data: usuarioExistente } = await obtenerPorEmail(email);

        let usuarioFinal = null;

        if (usuarioExistente) {
            usuarioFinal = usuarioExistente;
            const camposActualizar = {};
            if (!usuarioExistente.googleId) camposActualizar.googleId = googleId;
            if (!usuarioExistente.avatar && avatar) {
                camposActualizar.avatar = avatar;
            }
            if (!usuarioExistente.isVerified) {
                camposActualizar.isVerified = true;
            }
            if (Object.keys(camposActualizar).length > 0) {
                await actualizarUsuario(
                    usuarioExistente.id_usuarios,
                    camposActualizar
                );
            }
        } else {
            const { data: nuevoUsuario, error: errorCrear } =
                await crearUsuarioGoogle({
                    nombre_usuarios: nombre,
                    apellido_usuarios: apellido,
                    email_usuarios: email,
                    googleId,
                    avatar,
                    rol_usuarios: "usuario"
                });

            if (errorCrear || !nuevoUsuario) {
                console.error("Error crearUsuarioGoogle:", errorCrear);
                return res.status(500).json({
                    error: "Error al registrar el usuario con Google",
                    detalle: errorCrear?.message
                });
            }
            usuarioFinal = Array.isArray(nuevoUsuario)
                ? nuevoUsuario[0]
                : nuevoUsuario;
        }

        // Mismo formato de JWT que login normal (middlewares usan req.usuario.id)
        const token = jwt.sign(
            {
                id: usuarioFinal.id_usuarios,
                nombre: usuarioFinal.nombre_usuarios,
                apellido: usuarioFinal.apellido_usuarios || "",
                rol: usuarioFinal.rol_usuarios,
                email: usuarioFinal.email_usuarios
            },
            process.env.JWT_SECRET,
            { expiresIn: "1d" }
        );

        return res.status(200).json({
            mensaje: usuarioExistente
                ? "Inicio de sesión exitoso con Google"
                : "Registro exitoso con Google",
            token,
            usuario: {
                id: usuarioFinal.id_usuarios,
                nombre: usuarioFinal.nombre_usuarios,
                apellido: usuarioFinal.apellido_usuarios || "",
                email: usuarioFinal.email_usuarios,
                telefono: usuarioFinal.telefono_usuarios || null,
                rol: usuarioFinal.rol_usuarios,
                avatar: usuarioFinal.avatar || avatar
            }
        });
    } catch (error) {
        console.error("Error en autenticarConGoogle:", error);
        return res.status(401).json({
            error: "Token de Google inválido o expirado"
        });
    }
};
