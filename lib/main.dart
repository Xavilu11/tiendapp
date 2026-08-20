import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; //  Para leer variables .env
import 'package:http/http.dart' as http; //  Para hacer peticiones HTTP

// Función principal: carga el archivo .env antes de arrancar la app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {
    // La app puede arrancar aunque el archivo de configuración no esté disponible.
  }
  runApp(const MyApp());
}

// Aquí inicia la magia
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emprende',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      //  Cambiamos la pantalla inicial para que arranque en el splash
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/status': (context) => const StatusScreen(), // Nueva ruta de prueba
      },
    );
  }
}

//  Función que hace la petición GET al backend
Future<String> probarConexion() async {
  final String apiUrl = dotenv.env['API_BASE_URL'] ?? '';
  if (apiUrl.isEmpty) {
    return "Error: API_BASE_URL no está configurada";
  }
  try {
    final response = await http
        .get(Uri.parse('$apiUrl/status'))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      return response.body; // Devuelve el JSON recibido
    } else {
      return "Error: ${response.statusCode}";
    }
  } catch (e) {
    return "Error de conexión: $e";
  }
}

// Pantalla que muestra el resultado de la petición
class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  late Future<String> _conexion;

  @override
  void initState() {
    super.initState();
    _conexion = probarConexion();
  }

  void _reintentar() {
    setState(() {
      _conexion = probarConexion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prueba de conexión")),
      body: FutureBuilder<String>(
        future: _conexion,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Cargando
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasError ||
              snapshot.data?.startsWith('Error:') == true) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(snapshot.data ?? "Error de conexión"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _reintentar,
                    child: const Text("Reintentar"),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text("Respuesta: ${snapshot.data}"));
          }
        },
      ),
    );
  }
}

// Pantalla de splash: logo + slogan con animación
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    // Animación curva para suavizar la entrada
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _rotation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: -0.08,
          end: 0.06,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.06,
          end: -0.025,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -0.025,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
    ]).animate(_controller);

    // Cuando la animación termine, navega a Home
    _controller.forward().whenComplete(() {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo con fade + zoom + ligera rotación
            FadeTransition(
              opacity: _animation,
              child: ScaleTransition(
                scale: _animation,
                child: RotationTransition(
                  turns: _rotation,
                  child: Image.asset(
                    "assets/logo_emprende.jpeg",
                    width: 200,
                    cacheWidth: 400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Pides aquí, impulsas allá",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de inicio
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emprende")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bienvenido a Emprende",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text("Login (usuarios registrados)"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text("Nuevo usuario"),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de registro
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final cedulaController = TextEditingController();
  final telefonoController = TextEditingController();
  final direccionController = TextEditingController();
  final emprendimientoController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    cedulaController.dispose();
    telefonoController.dispose();
    direccionController.dispose();
    emprendimientoController.dispose();
    super.dispose();
  }

  void _abrirWhatsApp(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Redirigiendo a WhatsApp...")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de nuevo usuario")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: "Nombres"),
            ),
            TextField(
              controller: apellidoController,
              decoration: const InputDecoration(labelText: "Apellidos"),
            ),
            TextField(
              controller: cedulaController,
              decoration: const InputDecoration(labelText: "Número de cédula"),
            ),
            TextField(
              controller: telefonoController,
              decoration: const InputDecoration(labelText: "Teléfono"),
            ),
            TextField(
              controller: direccionController,
              decoration: const InputDecoration(labelText: "Dirección"),
            ),
            TextField(
              controller: emprendimientoController,
              decoration: const InputDecoration(
                labelText: "Nombre del emprendimiento",
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _abrirWhatsApp(context),
              child: const Text(
                "Haz clic aquí para continuar en WhatsApp",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final telefonoController = TextEditingController();
  final nicknameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    telefonoController.dispose();
    nicknameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa tus datos para entrar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: telefonoController,
              decoration: const InputDecoration(labelText: "Teléfono"),
            ),
            TextField(
              controller: nicknameController,
              decoration: const InputDecoration(
                labelText: "Nickname / Emprendimiento",
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Entrar")),
          ],
        ),
      ),
    );
  }
}
