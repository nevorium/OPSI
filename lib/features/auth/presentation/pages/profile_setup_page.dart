import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/profile_service.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  String? _timezone;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _timezone = DateTime.now().timeZoneName;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _error = null; });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await ProfileService().setupProfile(
          uid: user.uid,
          name: _nameController.text.trim(),
          dailyTarget: int.tryParse(_targetController.text.trim()) ?? 1,
          timezone: _timezone ?? '',
        );
        await user.updateDisplayName(_nameController.text.trim());
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      setState(() { _error = 'Gagal menyimpan profil.'; });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe8f5e9),
      appBar: AppBar(title: const Text('Setup Profil'), backgroundColor: Colors.green[700]),
      body: Center(
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
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nama', prefixIcon: Icon(Icons.person)),
                      validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _targetController,
                      decoration: const InputDecoration(labelText: 'Target Harian (ayat)', prefixIcon: Icon(Icons.flag)),
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || int.tryParse(v) == null || int.parse(v) < 1 ? 'Target minimal 1' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _timezone,
                      items: [
                        DropdownMenuItem(value: _timezone, child: Text(_timezone ?? '')),
                      ],
                      onChanged: (val) {},
                      decoration: const InputDecoration(labelText: 'Zona Waktu', prefixIcon: Icon(Icons.access_time)),
                    ),
                    const SizedBox(height: 16),
                    if (_error != null) ...[
                      Text(_error!, style: const TextStyle(color: Colors.red)),
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
                              onPressed: _saveProfile,
                              child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
