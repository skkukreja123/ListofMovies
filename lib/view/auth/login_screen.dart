import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_managment/helper/validator.dart';
import 'package:state_managment/viewmodel/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  final bool isLogin;
  const LoginScreen({required this.isLogin});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: Validators.validateEmail,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.isLogin) {
                      await vm.login(
                          _emailController.text, _passwordController.text);
                    } else {
                      await vm.register(
                          _emailController.text, _passwordController.text);
                    }

                    if (vm.user != null) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  }
                },
                child: vm.isLoading
                    ? const CircularProgressIndicator()
                    : Text(widget.isLogin ? 'Login' : 'Register'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => LoginScreen(isLogin: !widget.isLogin)),
                  );
                },
                child: Text(widget.isLogin
                    ? 'No account? Register'
                    : 'Already have account? Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
