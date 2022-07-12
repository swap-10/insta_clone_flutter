import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone_flutter/resources/auth_methods.dart';

import 'package:insta_clone_flutter/utils/colors.dart';
import 'package:insta_clone_flutter/utils/utils.dart';
import 'package:insta_clone_flutter/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailAddressController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    String res = await AuthMethods().loginUser(
      email: _emailAddressController.text,
      password: _passwordController.text,
    );
    showSnackBar(res, context);
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
              Flexible(child: Container(), flex: 1),
              Image.asset(
                'assets/instagram_logo.png',
                height: 48.0,
              ),
              const SizedBox(
                height: 24.0,
              ),
              SvgPicture.asset(
                'assets/Instagram_logo_written.svg',
                color: primaryColor,
                height: 48.0,
              ),
              const SizedBox(
                height: 24.0,
              ),
              CustomTextField(
                textEditingController: _emailAddressController,
                hintText: "E-mail",
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                enableSuggestions: true,
                autocorrect: false,
              ),
              const SizedBox(
                height: 24.0,
              ),
              CustomTextField(
                textEditingController: _passwordController,
                hintText: "Password",
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              const SizedBox(
                height: 24.0,
              ),
              TextButton(
                onPressed: loginUser,
                child: Container(
                  child: const Text(
                    "Log in",
                    style: TextStyle(color: Colors.white),
                  ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    color: Colors.blue,
                  ),
                ),
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("Don't have an account?"),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 1.0),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: const Text(
                        "Sign Up",
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
