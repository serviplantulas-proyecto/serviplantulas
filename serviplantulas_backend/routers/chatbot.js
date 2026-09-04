import express from "express";
import { chatearConServiplantulas, obtenerHistorialServiplantulas } from "../controllers/chatbot-controller.js";

const router = express.Router();

router.post("/", chatearConServiplantulas);
// iniciar chat:
//metodo: POST
//ruta: http://localhost:3000/chatbot
//body: raw / json
//estructura: { "mensaje": "hola" }




router.get("/historial/:sesionId", obtenerHistorialServiplantulas);
// iniciar chat:
//metodo: GET
//ruta: http://localhost:3000/api/chat/historial/EL_SESIONID
//body: no tiene body
//ejemplo id: serviplantulas_sesion_1788537276062



export default router;