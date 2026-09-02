import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import {crearUsuario, obtenerPorEmail} from "../models/usuarios-model.js";

// REGISTRO

export const registro = async (req, res) => {
    try {
        const {
            nombre_usuarios,
            apellido_usuarios,
            telefono_usuarios,
            email_usuarios,
            contrasena_usuarios
        } = req.body;

        // Validar datos
        if (
            !nombre_usuarios ||
            !apellido_usuarios ||
            !telefono_usuarios ||
            !email_usuarios ||
            !contrasena_usuarios
        ) {
            return res.status(400).json({
                error: "Todos los campos son obligatorios"
            });
        }

        // Verificar si el email ya existe
        const { data: usuarioExiste } =
            await obtenerPorEmail(email_usuarios);

        if (usuarioExiste) {
            return res.status(400).json({
                error: "El correo electrónico ya está registrado"
            });
        }

        // Crear hash de la contraseña
        const hashedPassword = await bcrypt.hash(
            contrasena_usuarios,
            10
        );

        // Crear usuario
        const { data, error } = await crearUsuario(
            nombre_usuarios,
            apellido_usuarios,
            telefono_usuarios,
            email_usuarios,
            hashedPassword
        );

        if (error) {
            return res.status(500).json({
                error: "Error al crear el usuario"
            });
        }

        return res.status(201).json({
            mensaje: "Usuario registrado con éxito",
            usuario: {
                id: data[0].id_usuarios,
                nombre: data[0].nombre_usuarios,
                apellido: data[0].apellido_usuarios,
                telefono: data[0].telefono_usuarios,
                email: data[0].email_usuarios,
                rol: data[0].rol_usuarios
            }
        });

    } catch (error) {
        console.error("Error en el registro:", error);
        return res.status(500).json({
            error: error.message || "Error interno"
        });
    }
};

// LOGIN
export const login = async (req, res) => {
    try {
        const {
            email_usuarios,
            contrasena_usuarios
        } = req.body;

        // Validar datos
        if (!email_usuarios || !contrasena_usuarios) {
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
        const passwordValida = await bcrypt.compare(
            contrasena_usuarios,
            usuario.contrasena_usuarios
        );

        if (!passwordValida) {
            return res.status(400).json({
                error: "Contraseña incorrecta"
            });
        }

        // Generar token JWT
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