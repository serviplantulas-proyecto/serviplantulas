import express from "express";
import dotenv from "dotenv";
import { conectaDB, supabase } from "./config/supabase.js";
import productosRouter from "./routers/productos.js";
import categoriasRouter from "./routers/categorias.js";
import proveedoresRouter from "./routers/proveedores.js";
import clientesRouter from "./routers/clientes.js";
import authRouter from "./routers/usuarios.js";
import pedidosRouter from "./routers/pedidos.js";
import detallePedidosRouter from "./routers/detalle-pedidos.js";
import notificacionesRouter from "./routers/notificaciones.js";
import cors from "cors";

//cargamos las variables
dotenv.config();
conectaDB();

//creamos la aplicacion de express
const app = express();

//leer el json
app.use(cors());
app.use(express.json());    

//creamos la ruta
app.get("/", (req, res) => {
    res.json({
        mensaje:"bienvenido al backend de serviplantulas",
        estado:"en linea.",
        vercion:"1.0.0",
    });
});
//rutas de autentificacion
app.use("/productos", productosRouter);
app.use("/categorias", categoriasRouter);
app.use("/proveedores", proveedoresRouter);
app.use("/clientes", clientesRouter);
app.use("/auth", authRouter);
app.use("/pedidos", pedidosRouter);
app.use("/detalle-pedidos", detallePedidosRouter);
app.use("/notificaciones", notificacionesRouter);
app.use(cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  }));

//configuramos el puerto 
const PORT = 3000;
//poner a escuchar el servidor
app.listen(PORT, () => {
    console.log(`servidor escuchando el puerto ${PORT}`);
    console.log(`http://localhost:${PORT}`);
});
