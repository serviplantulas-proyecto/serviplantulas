import jwt from "jsonwebtoken";
export const verificarToken = (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;
        // Verificar si existe el header Authorization
        if (!authHeader) {
            return res.status(401).json({
                error: "Token no proporcionado"
            });
        }
        // El formato esperado es:
        // Bearer TOKEN
        const token = authHeader.split(" ")[1];
        if (!token) {
            return res.status(401).json({
                error: "Formato de token inválido"
            });
        }
        // Verificar el token
        const decoded = jwt.verify(
            token,
            process.env.JWT_SECRET
        );
        // Guardar los datos del usuario en la petición
        req.usuario = decoded;
        // Continuar hacia la ruta
        next();

    } catch (error) {
        return res.status(401).json({
            error: "Token inválido o expirado"
        });
    }
}; 
export const verificarAdmin = (req, res, next) => {
    try {
        if (req.usuario.rol !== "admin") {
            return res.status(403).json({
                error: "No tienes permisos para realizar esta acción"
            });
        }
        next();

    } catch (error) {
        return res.status(403).json({
            error: "Error al verificar permisos"
        });
    }
};