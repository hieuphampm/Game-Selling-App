import 'package:flutter/material.dart';
import 'login.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot-password';

  const ForgotPasswordScreen({super.key});
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
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _loading = false;
        _sent = true;
      });
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
          // 1. Background image
          Image.asset('assets/images/white_bg.jpg', fit: BoxFit.cover),
          // 2. Overlay mờ
          Container(color: Colors.black.withOpacity(0.3)),

          // 3. Nội dung
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _sent
                  // Trạng thái "Đã gửi"
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.email,
                            size: 80,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Chúng tôi đã gửi email hướng dẫn đặt lại mật khẩu đến\n$_email.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(
                                context,
                              ).pushReplacementNamed(LoginScreen.routeName),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Quay về Đăng nhập',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  // Trạng thái "Chưa gửi"
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 48),
                          const Text(
                            'Quên mật khẩu',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Nhập email để nhận link đặt lại mật khẩu',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
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
                                  validator: (val) =>
                                      val != null && val.contains('@')
                                      ? null
                                      : 'Email không hợp lệ',
                                  onSaved: (val) => _email = val!.trim(),
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
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text(
                                            'Gửi',
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
                                    onPressed: () => Navigator.of(context)
                                        .pushReplacementNamed(
                                          LoginScreen.routeName,
                                        ),
                                    child: const Text(
                                      'Quay về Đăng nhập',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                ),
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
