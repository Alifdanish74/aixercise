import 'package:flutter/material.dart';
import 'package:mynotes/constant/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../background.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: const Text(
                "Confirm your email address",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Column(
                children: [
                  const Text(
                    "We've send the email verification to your email.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.03),
                  const Text(
                    "Check your email and click on the confirmation link to continue",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.03),
                  TextButton(
                    onPressed: () async {
                      await AuthService.firebase().sendEmailVerification();
                    },
                    child: const Text(
                      'Resend Email Verification',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 255, 136, 54)),
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        await AuthService.firebase().logOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute, (route) => false);
                      },
                      child: const Text('Go to Log in Page'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
