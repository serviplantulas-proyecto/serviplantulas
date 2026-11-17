import jwt from "jsonwebtoken";
import { OAuth2Client } from "google-auth-library";
import {
    obtenerPorEmail,
    obtenerPorGoogleId,
    crearUsuarioGoogle,
    actualizarUsuario
} from "../models/usuarios-model.js";

const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

function firmarToken(usuario) {
    return jwt.sign(
        {
            id: usuario.id_usuarios,
            nombre: usuario.nombre_usuarios,
            apellido: usuario.apellido_usuarios || "",
            rol: usuario.rol_usuarios,
            email: usuario.email_usuarios
        },
        process.env.JWT_SECRET,
        { expiresIn: "1d" }
    );
}

function respuestaOk(res, usuario, avatar, esNuevo) {
    return res.status(200).json({
        mensaje: esNuevo
            ? "Registro exitoso con Google"
            : "Inicio de sesión exitoso con Google",
        token: firmarToken(usuario),
        usuario: {
            id: usuario.id_usuarios,
            nombre: usuario.nombre_usuarios,
            apellido: usuario.apellido_usuarios || "",
            email: usuario.email_usuarios,
            telefono: usuario.telefono_usuarios || null,
            rol: usuario.rol_usuarios,
            avatar: usuario.avatar || avatar
        }
    });
}

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

        const googleId = payload.sub;
        const email = String(payload.email).trim().toLowerCase();
        const nombre = (payload.given_name || payload.name || "Usuario")
            .toString()
            .trim();
        const apellido = (payload.family_name || "").toString().trim();
        const avatar = payload.picture || null;

        // 1) Por correo
        let { data: usuario } = await obtenerPorEmail(email);

        // 2) Si no, por googleId (evita error 23505)
        if (!usuario) {
            const byG = await obtenerPorGoogleId(googleId);
            usuario = byG.data || null;
        }

        if (usuario) {
            const campos = {};
            if (!usuario.googleId) campos.googleId = googleId;
            if (!usuario.avatar && avatar) campos.avatar = avatar;
            if (!usuario.isVerified) campos.isVerified = true;
            // Si entró por googleId y el email cambió, actualizar
            if (
                usuario.email_usuarios &&
                String(usuario.email_usuarios).toLowerCase() !== email
            ) {
                campos.email_usuarios = email;
            }
            if (Object.keys(campos).length > 0) {
                const { data: actualizados } = await actualizarUsuario(
                    usuario.id_usuarios,
                    campos
                );
                if (actualizados?.[0]) usuario = actualizados[0];
            }
            return respuestaOk(res, usuario, avatar, false);
        }

        // 3) Crear nuevo
        const { data: nuevo, error: errorCrear } = await crearUsuarioGoogle({
            nombre_usuarios: nombre,
            apellido_usuarios: apellido,
            email_usuarios: email,
            googleId,
            avatar,
            rol_usuarios: "usuario"
        });

        if (errorCrear || !nuevo) {
            // Carrera / duplicado: reintentar por googleId o email
            if (errorCrear?.code === "23505") {
                const again =
                    (await obtenerPorGoogleId(googleId)).data ||
                    (await obtenerPorEmail(email)).data;
                if (again) {
                    return respuestaOk(res, again, avatar, false);
                }
            }
            console.error("Error crearUsuarioGoogle:", errorCrear);
            return res.status(500).json({
                error: "Error al registrar el usuario con Google",
                detalle: errorCrear?.message || String(errorCrear)
            });
        }

        return respuestaOk(res, nuevo, avatar, true);
    } catch (error) {
        console.error("Error en autenticarConGoogle:", error);
        return res.status(401).json({
            error: "Token de Google inválido o expirado"
        });
    }
};
