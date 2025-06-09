import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/auth_service.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import 'profile_setup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _error = null; });
    try {
      final user = await AuthService().signInWithEmail(_emailController.text.trim(), _passwordController.text.trim());
      if (user != null && user.displayName == null) {
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileSetupPage()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() { _error = e.message; });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _loginGoogle() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final user = await AuthService().signInWithGoogle();
      if (user != null && user.displayName == null) {
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileSetupPage()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() { _error = e.message; });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _loginAnon() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final user = await AuthService().signInAnonymously();
      if (user != null && user.displayName == null) {
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileSetupPage()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() { _error = e.message; });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe8f5e9),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/quran.png', height: 80),
                      const SizedBox(height: 16),
                      Text('Quranic Habit Tracker', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green[800])),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                        validator: (v) => v == null || v.isEmpty ? 'Email wajib diisi' : null,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)),
                        obscureText: true,
                        validator: (v) => v == null || v.length < 6 ? 'Password minimal 6 karakter' : null,
                      ),
                      const SizedBox(height: 16),
                      if (_error != null) ...[
                        Text(_error!, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 8),
                      ],
                      _isLoading
                          ? const CircularProgressIndicator()
                          : Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[700],
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    onPressed: _login,
                                    child: const Text('Login', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                                      child: const Text('Daftar', style: TextStyle(color: Colors.green)),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage())),
                                      child: const Text('Lupa Password?', style: TextStyle(color: Colors.green)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(child: Divider()),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text('atau', style: TextStyle(color: Colors.grey)),
                                    ),
                                    Expanded(child: Divider()),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: Image.asset('assets/google.png', height: 32),
                                      onPressed: _loginGoogle,
                                      tooltip: 'Login dengan Google',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.person_outline, color: Colors.green, size: 32),
                                      onPressed: _loginAnon,
                                      tooltip: 'Login Anonim',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
