import 'package:flutter/material.dart';
import 'login.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot-password';
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  bool _loading = false;
  bool _sent = false;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _loading = true;
      _sent = false;
    });

    // TODO: Gọi API gửi email lấy lại mật khẩu
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _loading = false;
        _sent = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quên mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _sent
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, size: 80, color: Colors.green),
                  SizedBox(height: 16),
                  Text(
                    'Chúng tôi đã gửi email hướng dẫn đặt lại mật khẩu đến $_email.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    child: Text('Quay về Đăng nhập'),
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(LoginScreen.routeName);
                    },
                  ),
                ],
              )
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Nhập địa chỉ email để nhận link đặt lại mật khẩu',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                          val!.contains('@') ? null : 'Email không hợp lệ',
                      onSaved: (val) => _email = val!.trim(),
                    ),
                    SizedBox(height: 24),
                    _loading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _submit,
                            child: Text('Gửi'),
                          ),
                    SizedBox(height: 16),
                    TextButton(
                      child: Text('Quay về Đăng nhập'),
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(LoginScreen.routeName);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
