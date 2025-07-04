import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _loading = false;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _loading = true);

    // TODO: Gọi API đăng ký
    Future.delayed(Duration(seconds: 2), () {
      setState(() => _loading = false);
      // Ví dụ điều hướng về login:
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng ký')),
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
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Xác nhận mật khẩu'),
                obscureText: true,
                validator: (val) =>
                    val == _password ? null : 'Mật khẩu xác nhận không khớp',
                onSaved: (val) => _confirmPassword = val!.trim(),
              ),
              SizedBox(height: 24),
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(onPressed: _submit, child: Text('Đăng ký')),
              SizedBox(height: 16),
              TextButton(
                child: Text('Đã có tài khoản? Đăng nhập'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
