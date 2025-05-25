import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _sendRecoveryEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um e-mail válido.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Um e-mail de recuperação foi enviado para $email.')),
    );

    Navigator.pop(context); // Volta para a tela anterior (Login)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd8eefe),
      appBar: AppBar(
        title: const Text('Recuperar Senha'),
        backgroundColor: const Color(0xFF094067),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Digite seu e-mail para receber instruções de recuperação de senha.',
              style: TextStyle(fontSize: 16, color: Color(0xFF094067)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                labelStyle: const TextStyle(color: Color(0xFF094067)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF094067)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendRecoveryEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3da9fc),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
