1 Framework elegido: Flutter.
Justificación: multiplataforma (Android/iOS/Web), hot reload, comunidad amplia, integración sencilla con APIs REST.

2 Entorno de ejecución:
SDK Flutter instalado.
Editor: Visual Studio Code con extensiones Flutter/Dart.
Cadena de herramientas nativa: Android Studio + SDK Android.
Backend: Node.js con Express.

3 Diagnóstico del framework:
Comando flutter doctor ejecutado.
Todos los hallazgos resueltos, sin pendientes.

4 Destino de ejecución:
Dispositivo físico Android conectado por USB.
Justificación: mejor rendimiento que el emulador en el equipo disponible.

5 Proyecto base:
Creado con flutter create emprende.
Verificado hot reload modificando texto y viendo cambios inmediatos.

6 Configuración de API:
Archivo .env con la URL base del backend.
Permiso de Internet en AndroidManifest.xml.
Autorización de tráfico en network_security_config.xml.

7 Solicitud hacia la API:
Backend (server.js) con endpoint /status.
Flutter (main.dart) hace petición GET y muestra respuesta en pantalla.
Resultado: respuesta JSON confirmando conexión exitosa.

8 Ejecución:
Backend: npm install → npm start.
Frontend: flutter pub get → flutter run.

9 Conclusión:
Entorno configurado correctamente.
App Flutter conectada al backend Node.js.
Comunicación verificada con respuesta exitosa.