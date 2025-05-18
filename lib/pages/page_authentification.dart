import 'dart:io';
import 'dart:math';

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
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 12,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      color: Colors.grey,
                      spreadRadius: 2,
                      offset: Offset(8, 8)
                    ),
                  ],
                ),
                child:  CircleAvatar(
                  radius: min(MediaQuery.of(context).size.width * 0.35, 150),
                  child: ClipOval(
                    child: Image(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
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
                elevation: 8,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    spacing: 12,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Mail',
                          hintText: 'Please provide your email',
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
                          spacing: 10,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Surname',
                                hintText: 'Please enter your surname',
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
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                              controller: _nameController,
                            ),
                          ],
                        ),
                      ElevatedButton(
                        onPressed: _handleAuthentification,
                        child: Text("S'authentifier"),
                      ),
                    ],
                  ),
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
