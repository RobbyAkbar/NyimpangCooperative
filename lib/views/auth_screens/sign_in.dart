import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyimpang_cooperative/models/auth.dart';
import 'package:nyimpang_cooperative/theme.dart';
import 'package:nyimpang_cooperative/widgets/bottom_nav.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  bool _obscureTextPassword = true;
  late bool _isLoginInProgress;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _isLoginInProgress = false;
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SizedBox(
                  width: 300.0,
                  height: 190.0,
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: focusNodeEmail,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Enter email.';
                              }
                              return null;
                            },
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              hintText: 'Email Address',
                              hintStyle: TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 17.0),
                            ),
                            onFieldSubmitted: (_) {
                              focusNodePassword.requestFocus();
                            },
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, bottom: 40.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: focusNodePassword,
                            controller: _passwordController,
                            obscureText: _obscureTextPassword,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Enter password.';
                              } else if (value!.length < 8) {
                                return 'Password must be at least 8 characters.';
                              }
                              return null;
                            },
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: const Icon(
                                FontAwesomeIcons.lock,
                                size: 22.0,
                                color: Colors.black,
                              ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 17.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleLogin,
                                child: Icon(
                                  _obscureTextPassword
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onFieldSubmitted: (_) {
                              _toggleSignInButton();
                            },
                            textInputAction: TextInputAction.go,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 170.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: CustomTheme.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: CustomTheme.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: LinearGradient(
                      colors: <Color>[
                        CustomTheme.loginGradientEnd,
                        CustomTheme.loginGradientStart
                      ],
                      begin: FractionalOffset(0.2, 0.2),
                      end: FractionalOffset(1.0, 1.0),
                      stops: <double>[0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  onPressed: _isLoginInProgress == true
                      ? null
                      : () {
                          _toggleSignInButton();
                        },
                  highlightColor: Colors.transparent,
                  splashColor: CustomTheme.loginGradientEnd,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Visibility(
                        visible: _isLoginInProgress,
                        replacement: const Text(
                          'LOGIN',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontFamily: 'WorkSansBold'),
                        ),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansMedium'),
                )),
          ),
        ],
      ),
    );
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    _isLoginInProgress = true;
    if (mounted) {
      setState(() {});
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isLoginInProgress = false;
      if (mounted) {
        setState(() {});
      }
      if (userCredential.user?.emailVerified == false) {
        showToastMessage('Please verify your account.',
            color: Colors.red, actionLabel: 'SEND', action: () async {
          await userCredential.user?.sendEmailVerification();
          showToastMessage(
            'Verification URL is sent to your email.',
            color: Colors.green,
          );
        });
      } else if (userCredential.user?.emailVerified == true) {
        final UserModel user = UserModel(
          userEmail: email,
          userId: userCredential.user!.uid,
        );
        await UserAuth().saveUserAuth(user);
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNav()),
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code.contains('INVALID_LOGIN_CREDENTIALS') == true) {
        showToastMessage('E-mail or Password is incorrect!', color: Colors.red);
      }
    } catch (e) {
      showToastMessage(e.toString(), color: Colors.red);
    }

    _isLoginInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleSignInButton() {
    if (_formKey.currentState?.validate() == true) {
      loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  void showToastMessage(String content,
      {Color color = Colors.green, VoidCallback? action, String? actionLabel}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: color,
          content: Text(content),
          action: actionLabel == null
              ? null
              : SnackBarAction(
                  onPressed: () {
                    if (action != null) {
                      action();
                    }
                  },
                  label: actionLabel,
                  textColor: Colors.white,
                  backgroundColor: Colors.black38,
                ),
          behavior: SnackBarBehavior.floating),
    );
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }
}
