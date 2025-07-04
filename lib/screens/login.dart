import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'register.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _loading = false;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _loading = true);

    // TODO: Thay bằng API thật của bạn
    Future.delayed(Duration(seconds: 2), () {
      setState(() => _loading = false);

      // Nếu đăng nhập thành công, điều hướng vào HomeScreen
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) =>
                    val!.contains('@') ? null : 'Email không hợp lệ',
                onSaved: (val) => _email = val!.trim(),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (val) =>
                    val!.length >= 6 ? null : 'Mật khẩu ít nhất 6 ký tự',
                onSaved: (val) => _password = val!.trim(),
              ),
              SizedBox(height: 24),
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text('Đăng nhập'),
                    ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text('Quên mật khẩu?'),
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushNamed(ForgotPasswordScreen.routeName);
                    },
                  ),
                  TextButton(
                    child: Text('Đăng ký'),
                    onPressed: () {
                      Navigator.of(context).pushNamed(RegisterScreen.routeName);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
