
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme_notifier.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: true);
    final isDark = themeNotifier.themeMode == ThemeMode.dark;
    final primaryYellow = const Color(0xFFFFB300);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryYellow.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        'Regístrate',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: primaryYellow,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Ingresa tu nombre',
                          hintStyle: TextStyle(
                              color: isDark ? Colors.white54 : Colors.grey),
                          prefixIcon: Icon(Icons.person, color: primaryYellow),
                          filled: true,
                          fillColor: isDark ? Colors.black : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryYellow, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                   
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Ingresa tu correo',
                          hintStyle: TextStyle(
                              color: isDark ? Colors.white54 : Colors.grey),
                          prefixIcon: Icon(Icons.email, color: primaryYellow),
                          filled: true,
                          fillColor: isDark ? Colors.black : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryYellow, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo';
                          }
                          if (!value.contains('@')) {
                            return 'Ingresa un correo válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Ingresa tu contraseña',
                          hintStyle: TextStyle(
                              color: isDark ? Colors.white54 : Colors.grey),
                          prefixIcon: Icon(Icons.lock, color: primaryYellow),
                          filled: true,
                          fillColor: isDark ? Colors.black : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryYellow, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushNamed(context, '/login');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryYellow,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Registrarse',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          '¿Ya tienes cuenta? Inicia sesión',
                          style: TextStyle(color: primaryYellow),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: primaryYellow,
                  ),
                  onPressed: () {
                    themeNotifier.toggleTheme();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
