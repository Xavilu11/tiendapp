// Importar Express
import express from "express";

// Crear la app
const app = express();
const PORT = 3000; // 👈 mismo puerto que pusiste en tu .env

// Endpoint de prueba
app.get("/status", (req, res) => {
  res.json({ message: "API funcionando en 192.168.10.94" });
});

// Arrancar servidor
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Servidor corriendo en http://192.168.10.94:${PORT}`);
});
