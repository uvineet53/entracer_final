import 'package:entracer/services/auth.dart';
import 'package:entracer/services/database.dart';
import 'package:entracer/view/widgets/authWidgets.dart';
import 'package:entracer/view/widgets/designSet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLogin = true;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String errorText = '';
  bool isLoading = false;

  Widget loginButtonToggle() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: !isLogin
          ? "Login Instead".text.green400.lg.make()
          : "Register Instead".text.green400.lg.make(),
    );
  }

  Widget loginButton(
    bool isLogin,
    String email,
    String password,
  ) {
    return GestureDetector(
      onTap: () async {
        if (_formkey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });
          try {
            if (isLogin) {
              await Auth().login(
                email: email.trim(),
                password: password.trim(),
              );
            } else {
              await Auth().register(
                email: email.trim(),
                password: password.trim(),
              );
              await Database().saveUser(
                email,
                password,
              );
            }
          } on FirebaseAuthException catch (e) {
            setState(() {
              errorText = e.message!;
              isLoading = false;
            });
          }
        }
      },
      child: Container(
        child: isLogin
            ? "Login".text.bold.xl.makeCentered()
            : "Register".text.bold.xl.makeCentered(),
      ).box.green400.width(double.infinity).p12.roundedSM.make(),
    ).marginSymmetric(vertical: 8);
  }

  Widget errorWidget() => errorText.text
      .align(TextAlign.center)
      .red400
      .makeCentered()
      .marginSymmetric(
        vertical: 8,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DesignSet.appName(),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: VStack(
            [
              Lottie.asset("assets/logo.json", height: Get.height * .4),
              AuthWidgets().entryField(
                controller: _emailController,
                title: "Email",
              ),
              AuthWidgets().entryField(
                controller: _passController,
                title: "Password",
                isPass: true,
              ),
              loginButton(
                isLogin,
                _emailController.text,
                _passController.text,
              ),
              loginButtonToggle(),
              isLoading
                  ? const LinearProgressIndicator(
                      color: Vx.green300,
                    )
                  : Container(),
              errorWidget(),
            ],
            alignment: MainAxisAlignment.center,
            crossAlignment: CrossAxisAlignment.center,
          ),
        ).p24(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }
}
