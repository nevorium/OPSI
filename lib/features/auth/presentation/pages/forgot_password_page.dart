import 'package:flutter/material.dart';
import '../../data/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;
  String? _error;

  Future<void> _sendReset() async {
    setState(() { _isLoading = true; _error = null; _message = null; });
    try {
      await AuthService().sendPasswordResetEmail(_emailController.text.trim());
      setState(() { _message = 'Link reset password telah dikirim ke email.'; });
    } catch (e) {
      setState(() { _error = 'Gagal mengirim email reset password.'; });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe8f5e9),
      appBar: AppBar(title: const Text('Lupa Password'), backgroundColor: Colors.green[700]),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                  ),
                  const SizedBox(height: 16),
                  if (_error != null) ...[
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                  ],
                  if (_message != null) ...[
                    Text(_message!, style: const TextStyle(color: Colors.green)),
                    const SizedBox(height: 8),
                  ],
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _sendReset,
                            child: const Text('Kirim Link Reset', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
