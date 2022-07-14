import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone_flutter/resources/auth_methods.dart';
import 'package:insta_clone_flutter/screens/login_screen.dart';

import 'package:insta_clone_flutter/utils/colors.dart';
import 'package:insta_clone_flutter/widgets/text_field.dart';

import '../utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final String _errorText = "Password doesn't match";
  String? _passedErrorText;
  bool _passwordMatches = false;
  bool _isLoading = false;

  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailAddressController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = "An error occured";
    if (_image != null) {
      res = await AuthMethods().signUpUser(
        email: _emailAddressController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        file: _image!,
      );
    } else {
      res = "Please select profile picture";
    }
    // print(res);
    if (res != "Success!") {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(res, Colors.red, context);
    }
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 5.0,
                    ),
                    SvgPicture.asset(
                      'assets/Instagram_logo_written.svg',
                      color: primaryColor,
                      height: 48.0,
                    ),
                    // Upload profile picture - Circular widget
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Stack(
                            fit: StackFit.loose,
                            children: [
                              Center(
                                child: CircleAvatar(
                                  radius: 32.0,
                                  backgroundImage: _image != null
                                      ? MemoryImage(_image!)
                                      : Image.asset('assets/usericon.png')
                                          .image,
                                ),
                              ),
                              Positioned(
                                child: IconButton(
                                  onPressed: () => selectImage(),
                                  icon: const Icon(Icons.add_a_photo_outlined),
                                  color: Colors.blue,
                                ),
                                bottom: -10,
                                left: 180,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Email Address
                    CustomTextField(
                      textEditingController: _emailAddressController,
                      hintText: "E-mail",
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      enableSuggestions: true,
                      autocorrect: false,
                    ),
                    // Username
                    CustomTextField(
                      textEditingController: _usernameController,
                      hintText: "Username",
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      enableSuggestions: true,
                      autocorrect: false,
                    ),
                    // Password
                    CustomTextField(
                      textEditingController: _passwordController,
                      hintText: "Password",
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                    // Confirm Password
                    ValueListenableBuilder(
                      valueListenable: _confirmPasswordController,
                      builder: (context, TextEditingValue value, _) {
                        if (value == _passwordController.value) {
                          _passedErrorText = null;
                        } else {
                          _passedErrorText = _errorText;
                        }
                        return CustomTextField(
                          textEditingController: _confirmPasswordController,
                          hintText: "Confirm Password",
                          errorText: _passedErrorText,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                        );
                      },
                    ),
                    // SignUp
                    ValueListenableBuilder(
                      valueListenable: _confirmPasswordController,
                      builder: (context, TextEditingValue value, _) {
                        if (value == _passwordController.value) {
                          _passwordMatches = true;
                        } else {
                          _passwordMatches = false;
                        }
                        return _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : TextButton(
                                onPressed: _passwordMatches ? signUpUser : null,
                                child: Container(
                                  child: const Text(
                                    "SignUp",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                    ),
                                    color: Colors.blue,
                                  ),
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),

              // Login Instead
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text("Have an account already?"),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 1.0),
                    ),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: Container(
                        child: const Text(
                          "Login instead",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 1.0),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
