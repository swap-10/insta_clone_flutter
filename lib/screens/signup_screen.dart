import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:insta_clone_flutter/utils/colors.dart';
import 'package:insta_clone_flutter/widgets/text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final String _errorText = "Password doesn't match";
  String? _passedErrorText;

  @override
  void dispose() {
    super.dispose();
    _emailAddressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              TextButton(
                onPressed: (() => {}),
                child: Container(
                  child: const Text(
                    "SignUp",
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
                    child: const Text("Have an account already?"),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 1.0),
                  ),
                  GestureDetector(
                    onTap: () {},
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
