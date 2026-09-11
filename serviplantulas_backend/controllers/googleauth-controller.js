import jwt from "jsonwebtoken";
import { OAuth2Client } from "google-auth-library";
import { obtenerPorEmail, crearUsuarioGoogle, actualizarUsuario } from "../models/usuarios-model.js";
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

export const autenticarConGoogle = async (req, res) => {
    try {
        const { idToken } = req.body;

        if (!idToken) {
            return res.status(400).json({
                error: 'El idToken de Google es requerido'
            });
        }

        // 1. Validar el token con Google
        const ticket = await client.verifyIdToken({
            idToken,
            audience: process.env.GOOGLE_CLIENT_ID
        });

        const payload = ticket.getPayload();
        const { sub: googleId, email_usuarios, name: nombre_usuarios, picture: avatar } = payload;

        // 2. Comprobar si ya existe en Supabase
        const { data: usuarioExistente } = await obtenerPorEmail(email_usuarios);

        let usuarioFinal = null;

        if (usuarioExistente) {
            // LOGIN: Ya existe, actualizamos si faltaba vincular Google
            usuarioFinal = usuarioExistente;

            const camposActualizar = {};
            if (!usuarioExistente.googleId) camposActualizar.googleId = googleId;
            if (!usuarioExistente.avatar && avatar) camposActualizar.avatar = avatar;
            if (!usuarioExistente.isVerified) camposActualizar.isVerified = true;

            if (Object.keys(camposActualizar).length > 0) {
                await actualizarUsuario(usuarioExistente.id, camposActualizar);
            }
        } else {
            // REGISTRO: Usuario nuevo
            const { data: nuevoUsuario, error: errorCrear } = await crearUsuarioGoogle({
                nombre_usuarios,
                email_usuarios,
                googleId,
                avatar,
                rol_usuarios: 'usuario'
            });

            if (errorCrear) {
                return res.status(500).json({
                    error: 'Error al registrar el usuario en Supabase',
                    detalle: errorCrear.message
                });
            }

            usuarioFinal = Array.isArray(nuevoUsuario) ? nuevoUsuario[0] : nuevoUsuario;
        }

        // 3. Generar token de sesión JWT
        const token = jwt.sign(
            { id_usuarios: usuarioFinal.id, rol_usuarios: usuarioFinal.rol },
            process.env.JWT_SECRET,
            { expiresIn: '1d' }
        );

        return res.status(200).json({
            message: usuarioExistente ? 'Inicio de sesión exitoso con Google' : 'Registro exitoso con Google',
            token,
            usuario: {
                id_usuarios: usuarioFinal.id,
                nombre_usuarios: usuarioFinal.nombre,
                email_usuarios: usuarioFinal.email,
                rol_usuarios: usuarioFinal.rol,
                avatar: usuarioFinal.avatar || avatar
            }
        });

    } catch (error) {
        console.error('Error en autenticarConGoogle:', error);
        return res.status(401).json({
            error: 'Token de Google inválido o expirado'
        });
    }
};