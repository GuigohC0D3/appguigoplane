import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cepController = TextEditingController();
  final _addressController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  final _phoneMask = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  final _cepMask = MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
  final _dateMask = MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você deve aceitar os termos e condições.'),
          ),
        );
        return;
      }

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        String message = 'Erro ao criar conta.';
        if (e.code == 'email-already-in-use') {
          message = 'Email já está em uso.';
        } else if (e.code == 'invalid-email') {
          message = 'Email inválido.';
        } else if (e.code == 'weak-password') {
          message = 'Senha fraca.';
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF094067),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ExpansionTile(
                title: const Text('Informações Pessoais'),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('Nome Completo'),
                    validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _cpfController,
                    inputFormatters: [_cpfMask],
                    decoration: _inputDecoration('CPF'),
                    validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _birthDateController,
                    inputFormatters: [_dateMask],
                    decoration: _inputDecoration('Data de Nascimento'),
                    validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    inputFormatters: [_phoneMask],
                    decoration: _inputDecoration('Telefone'),
                    validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('Informações de Endereço'),
                children: [
                  TextFormField(
                    controller: _cepController,
                    inputFormatters: [_cepMask],
                    decoration: _inputDecoration('CEP'),
                    validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration: _inputDecoration('Endereço'),
                    validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _numberController,
                    decoration: _inputDecoration('Número'),
                    validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _complementController,
                    decoration: _inputDecoration('Complemento'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _neighborhoodController,
                    decoration: _inputDecoration('Bairro'),
                    validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _cityController,
                    decoration: _inputDecoration('Cidade'),
                    validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _stateController,
                    decoration: _inputDecoration('Estado'),
                    validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('Informações de Cadastro'),
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value != null && value.contains('@') ? null : 'Email inválido',
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: _inputDecoration(
                      'Senha',
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) => value != null && value.length >= 6 ? null : 'Senha muito curta',
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: _inputDecoration(
                      'Confirmar Senha',
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    ),
                    validator: (value) =>
                    value == _passwordController.text ? null : 'As senhas não coincidem',
                  ),
                ],
              ),
              CheckboxListTile(
                title: const Text('Aceito os termos e condições'),
                value: _acceptTerms,
                onChanged: (value) => setState(() => _acceptTerms = value ?? false),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3da9fc),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cadastre-se na BibigoAirplane',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
