import 'package:flutter/material.dart';

import 'package:window_manager/window_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _error = '';

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username == 'SECT' && password == 'SWMTdjanet') {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _error = 'Invalid credentials';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 61, 122),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 236, 236, 236),
              Color.fromARGB(255, 221, 221, 221),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: LayoutBuilder(builder: (context, constraints) {
              final double containerWidth = constraints.maxWidth * 0.9 < 400
                  ? constraints.maxWidth * 0.9
                  : constraints.maxWidth * 0.28;

              return Center(
                child: Container(
                  width: containerWidth,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 70, 70, 72)
                            .withOpacity(0.3),
                        spreadRadius: 4,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: size.height * 0.35,
                        child: const ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Image(
                            image: AssetImage('assets/SWMT.png'),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'WORKFORCE-IQ',
                        style: TextStyle(
                          fontSize: size.width < 600 ? 20 : 24,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.normal,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  'Nom d\'utilisateur',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFormField(
                                  controller: _usernameController,
                                  decoration: const InputDecoration(
                                    hintText: 'SECT',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  'Mot de passe',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Saisir votre mot de passe',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 13, 78, 131),
                                        minimumSize: const Size.fromHeight(45),
                                      ),
                                      onPressed: _login,
                                      child: const Text(
                                        'S\'authentifier',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 234, 239, 243),
                                        minimumSize: const Size.fromHeight(45),
                                      ),
                                      onPressed: () {
                                        windowManager.close();
                                      },
                                      child: const Text(
                                        'Quitter',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromARGB(255, 158, 49, 49),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (_error.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Center(
                                  child: Text(
                                    _error,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                )
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SWMT DJANET 2025',
              style: TextStyle(
                fontSize: 8,
                color: Color.fromARGB(255, 214, 233, 245),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Developed by OPP/Cheloufi Youcef Ouassim',
              style: TextStyle(
                fontSize: 8,
                color: Color.fromARGB(255, 214, 233, 245),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
