# Serviplantulas

## 1. Descripción breve del proyecto

**Serviplantulas** es una aplicación desarrollada para apoyar la gestión administrativa de un vivero de plantas. El sistema permite administrar productos, categorías, proveedores, clientes, pedidos, notificaciones y usuarios.

El proyecto cuenta con un backend desarrollado para gestionar la información y las operaciones principales de la aplicación.


## 2. Stack tecnológico

- **Node.js** - Entorno de ejecución utilizado para el backend.
- **Express.js** - Framework utilizado para desarrollar la API.
- **JavaScript** - Lenguaje principal utilizado en el backend.
- **Supabase** - Servicio utilizado para la gestión y conexión con la base de datos.
- **Cloudinary** - Servicio utilizado para el almacenamiento de imágenes.
- **Multer** - Middleware utilizado para la carga y procesamiento de archivos.
- **Nodemailer** - Librería utilizada para el envío de correos electrónicos.
- **Brevo** - Servicio utilizado para funcionalidades relacionadas con el envío de correos.
- **JWT (JSON Web Token)** - Utilizado para la autenticación mediante tokens.
- **Bcrypt** - Utilizado para el cifrado de contraseñas.
- **CORS** - Utilizado para permitir la comunicación entre diferentes orígenes.
- **Git y GitHub** - Utilizados para el control de versiones y almacenamiento del código.
- **Postman** - Utilizado para realizar pruebas de los endpoints del backend.

## 3. Características del proyecto

El proyecto cuenta con los siguientes módulos y funcionalidades:

- **Autenticación y seguridad:** registro e inicio de sesión de usuarios, manejo de contraseñas y autenticación mediante tokens.
- **Gestión de productos:** creación, consulta, actualización y eliminación de productos.
- **Gestión de categorías:** administración de las categorías de los productos.
- **Gestión de proveedores:** registro y administración de proveedores.
- **Gestión de clientes:** registro y administración de clientes.
- **Gestión de pedidos:** creación y administración de pedidos.
- **Detalle de pedidos:** administración de los productos incluidos en cada pedido.
- **Notificaciones:** gestión de notificaciones generadas por diferentes acciones del sistema.
- **Recuperación de contraseña:** generación y envío de códigos para recuperar el acceso a la cuenta.
- **Gestión de imágenes:** carga y almacenamiento de imágenes de productos mediante Cloudinary.
- **Base de datos:** almacenamiento y gestión de la información mediante Supabase.


## 4. Instalación y configuración

### Clonar el proyecto

Desde Visual Studio Code se puede clonar el repositorio utilizando Git:

```bash
git clone https://github.com/serviplantulas-proyecto/serviplantulas.git
```

Luego ingresar a la carpeta del proyecto:

```bash
cd NOMBRE_DEL_REPOSITORIO
```

### Instalar las dependencias

Instalar las dependencias del proyecto mediante:

```bash
npm install
```

Entre las principales dependencias utilizadas se encuentran:

```bash
npm install express
npm install cors
npm install dotenv
npm install mysql2
npm install @supabase/supabase-js
npm install multer
npm install cloudinary
npm install nodemailer
```

Para ejecutar correctamente el proyecto se deben configurar las variables de entorno necesarias en el archivo `.env`, incluyendo las credenciales de conexión a la base de datos, Cloudinary y el servicio de correo electrónico.

**Importante:** el archivo `.env` no debe subirse al repositorio de GitHub, ya que contiene información privada de configuración.

## 5. Comando para ejecutar el proyecto

Para iniciar el backend en modo desarrollo:

```bash
npm run dev
```

El servidor se ejecuta en:

```text
http://localhost:3000
```

## 6. Estructura del proyecto

La estructura principal del backend está organizada de la siguiente manera:

```text
serviplantulas/
│
├── serviplantulas_backend/
│   │
│   ├── config/
│   │   ├── cloudinary.js
│   │   └── supabase.js
│   │
│   ├── controllers/
│   │   ├── categorias-controller.js
│   │   ├── clientes-controller.js
│   │   ├── detalle-pedidos-controller.js
│   │   ├── notificaciones-controller.js
│   │   ├── pedidos-controller.js
│   │   ├── productos-controller.js
│   │   ├── proveedores-controller.js
│   │   ├── recuperar-controller.js
│   │   └── usuario-controller.js
│   │
│   ├── middlewares/
│   │   └── middlewares.js
│   │
│   ├── models/
│   │   ├── categorias-model.js
│   │   ├── clientes-model.js
│   │   ├── detalle-pedidos-model.js
│   │   ├── notificaciones-model.js
│   │   ├── pedidos-model.js
│   │   ├── productos-model.js
│   │   ├── proveedores-model.js
│   │   ├── recuperar-model.js
│   │   └── usuarios-model.js
│   │
│   ├── routers/
│   │   ├── categorias.js
│   │   ├── clientes.js
│   │   ├── detalle-pedidos.js
│   │   ├── notificaciones.js
│   │   ├── pedidos.js
│   │   ├── productos.js
│   │   ├── proveedores.js
│   │   └── usuarios.js
│   │
│   ├── services/
│   │   └── email-service.js
│   │
│   ├── .env
│   ├── .gitignore
│   ├── index.js
│   ├── package.json
│   └── package-lock.json
│
└── serviplantulas_frontend/
```

## 7. Autores

**Proyecto desarrollado por:**

* David Felipe