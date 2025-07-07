import 'package:flutter/material.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  const RegisterScreen({super.key});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '', _confirmPassword = '';
  bool _loading = false;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _loading = true);

    // TODO: gọi API đăng ký
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _loading = false);
      // Điều hướng sang Login và thay thế màn này
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white70,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bg.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),
                    const Text(
                      'Chào bạn!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Hãy đăng ký để tiếp tục!',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    const SizedBox(height: 32),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: inputDecoration,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => v != null && v.contains('@')
                                ? null
                                : 'Email không hợp lệ',
                            onSaved: (v) => _email = v!.trim(),
                          ),

                          const SizedBox(height: 24),
                          const Text(
                            'Mật khẩu',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: inputDecoration,
                            obscureText: true,
                            validator: (v) => v != null && v.length >= 6
                                ? null
                                : 'Mật khẩu ít nhất 6 ký tự',
                            onSaved: (v) => _password = v!.trim(),
                          ),

                          const SizedBox(height: 24),
                          const Text(
                            'Xác nhận mật khẩu',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: inputDecoration,
                            obscureText: true,
                            validator: (v) => v != null && v == _password
                                ? null
                                : 'Không khớp mật khẩu',
                            onSaved: (v) => _confirmPassword = v!.trim(),
                          ),

                          const SizedBox(height: 32),
                          _loading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Đăng ký',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                          const SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.of(
                                context,
                              ).pushReplacementNamed(LoginScreen.routeName),
                              child: const Text(
                                'Đã có tài khoản? Đăng nhập',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),

                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
