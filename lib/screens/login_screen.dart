import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/firebase/notification/push_notifications_service.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/utils/global_utils.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SharedPreferences? _prefs;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberUser = false;
  Map<String, List<dynamic>> _formErrors = {};

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
      _formErrors = {};
    });

    final auth = Provider.of<AuthenticationProvider>(context, listen: false);

    final email = _emailController.text;
    final password = _passwordController.text;
    // final email = "patrick@gmail.com";
    // final password = "admin123";
    // final email = "patrick@gmail.com";
    // final password = "admin123";

    try {
      await auth.signIn(email, password);

      if (PushNotificationService.tokenValue != '') {
        await auth.updateUser(email, PushNotificationService.tokenValue);
      }

      if (_rememberUser) {
        await savePreferences(email, password);
      } else {
        await clearPreferences();
      }

      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacementNamed('/trip');
      });
    } on ApiException catch (e) {
      if (e.message != '') {
        // Si el login falla, muestra un mensaje de error
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.message),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(ctx).pop(),
              )
            ],
          ),
        );
      }

      setState(() {
        _isLoading = false;
        _formErrors = e.errors;
      });
    } catch (e) {
      // Manejar otros errores que no son de ApiException aquí
      setState(() {
        _isLoading = false;
        _formErrors = {
          'general': ['An unexpected error occurred']
        };
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> savePreferences(String email, String password) async {
    if (_prefs != null) {
      await _prefs!.setString('email', email);
      await _prefs!.setString('password', password);
    }
  }

  @override
  void initState() {
    loadPreferences();
    super.initState();
  }

  void loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs != null) {
      setState(() {
        _rememberUser = _prefs!.getString('email') != null &&
            _prefs!.getString('password') != null;
        if (_rememberUser) {
          _emailController.text = _prefs!.getString('email') ?? '';
          _passwordController.text = _prefs!.getString('password') ?? '';
        }
      });
    }
  }

  Future<void> clearPreferences() async {
    if (_prefs != null) {
      await _prefs!.remove('email');
      await _prefs!.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Globals.primaryColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(
              Utils.responsiveValue(context, 32.0, 64.0, 400),
              0.0,
              Utils.responsiveValue(context, 32.0, 64.0, 400),
              32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    bottom: Utils.responsiveValue(context, 16.0, 32.0, 400)),
                child: Column(
                  children: const [
                    SizedBox(
                      height: 90.0,
                      width: 90.0,
                      child: Image(image: AssetImage('images/logo.png')),
                    ),
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 14.0),
                    Text(
                      'Please login to continue',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Email address',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: Utils.responsiveValue(context, 10.0, 20.0, 400),
                    horizontal: Utils.responsiveValue(context, 10.0, 20.0, 400),
                  ),
                  hintStyle: TextStyle(
                    fontSize: Utils.responsiveValue(context, 12.0, 14.0, 400),
                  ),
                ),
              ),
              if (_formErrors.containsKey('email'))
                ..._formErrors['email']!
                    .map((error) => Text(
                          error,
                          style: const TextStyle(color: Colors.red),
                        ))
                    .toList(),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Password',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: Utils.responsiveValue(context, 10.0, 20.0, 400),
                    horizontal: Utils.responsiveValue(context, 10.0, 20.0, 400),
                  ),
                  hintStyle: TextStyle(
                    fontSize: Utils.responsiveValue(context, 12.0, 14.0, 400),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
              ),
              if (_formErrors.containsKey('password'))
                ..._formErrors['password']!
                    .map((error) => Text(
                          error,
                          style: const TextStyle(color: Colors.red),
                        ))
                    .toList(),
              //Recordar Usuario
              const SizedBox(height: 5.0),
              Row(
                children: [
                  Checkbox(
                    value: _rememberUser,
                    onChanged: (value) {
                      setState(() {
                        _rememberUser = value!;
                      });
                    },
                    visualDensity: VisualDensity.compact,
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    checkColor: Colors.red,
                  ),
                  const Text(
                    'Guardar mis credenciales',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login to your account'),
              ),
              const SizedBox(height: 16.0),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Dont' have an account? ",
                  style: const TextStyle(color: Colors.white),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign up',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Lógica del enlace aquí
                          Navigator.of(context).pushNamed('/signup');
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
