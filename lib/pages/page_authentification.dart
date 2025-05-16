import 'package:chti_face_book/services_firebase/service_authentification.dart';
import 'package:flutter/material.dart';

class PageAuthentification extends StatefulWidget {
  const PageAuthentification({super.key});

  @override
  State<StatefulWidget> createState() => _PageAuthentification();
}

enum View { createAccount, logIn }

class _PageAuthentification extends State<PageAuthentification> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final ServiceAuthentification _serviceAuthentification =
      ServiceAuthentification();

  bool _accountExists = true;

  // Methods

  _handleAuthentification() async {
    if (_accountExists) {
      await _serviceAuthentification.signIn(
        email: _mailController.text,
        password: _passwordController.text,
      );
      return;
    }
    await _serviceAuthentification.createAccount(
      email: _mailController.text,
      password: _passwordController.text,
      surname: _surnameController.text,
      name: _nameController.text,
    );
  }

  _onSelectionChange(Set<bool> selection) {
    setState(() {
      _accountExists = selection.first;
    });
  }

  // Lifecycle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chti Face Bouc"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                "https://static.wikia.nocookie.net/brainrotnew/images/1/10/Bombardiro_Crocodilo.jpg",
              ),
              SegmentedButton<bool>(
                segments: const <ButtonSegment<bool>>[
                  ButtonSegment<bool>(
                    value: false,
                    label: Text("Créer un compte"),
                    icon: Icon(Icons.login),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text("Connexion"),
                    icon: Icon(Icons.login),
                  ),
                ],
                selected: {_accountExists},
                onSelectionChanged: _onSelectionChange,
              ),
              Card(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Mail',
                        hintText: 'Please provide your email',
                        prefixIcon: Icon(Icons.person),
                        suffixIcon: Icon(Icons.check_circle),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      controller: _mailController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Please enter your password',
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: Icon(Icons.check_circle),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      obscureText: true,
                      controller: _passwordController,
                    ),
                    if (!_accountExists)
                      Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Surname',
                              hintText: 'Please enter your surname',
                              prefixIcon: Icon(Icons.password),
                              suffixIcon: Icon(Icons.check_circle),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            controller: _surnameController,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Name',
                              hintText: 'Please enter your name',
                              prefixIcon: Icon(Icons.password),
                              suffixIcon: Icon(Icons.check_circle),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            controller: _nameController,
                          ),
                        ],
                      ),
                    TextButton(
                      onPressed: _handleAuthentification,
                      child: Text("Ch'ti parti !"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }
}
