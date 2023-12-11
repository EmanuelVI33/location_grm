import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:location_grm/feactures/mapa/infrastructure/models/usuario.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/login/login_screen.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = 'signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  late User user;

  @override
  void initState() {
    super.initState();
    user = User(
      ci: '',
      password: '',
      fullname: '',
      phone: 0,
      sex: '',
      birthdate: '',
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    final birth = DateFormat('dd-MM-yyyy').format(picked!);

    if (picked != null && birth != user.birthdate) {
      setState(() {
        user.birthdate = birth;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      print(user.toMap());
      // Realizar acciones de registro aquí con los datos ingresados

      // Mostrar un mensaje de éxito
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          // height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Crear Cuenta",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Nombre'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese su nombre';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            user.fullname = value!;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'CI'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese su CI';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            user.ci = value!;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Contraseña'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese su contraseña';
                            }
                            user.password = value;
                            return null;
                          },
                          onSaved: (value) {
                            user.password = value!;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Confirmar Contraseña'),
                          obscureText: true,
                          validator: (value) {
                            if (value != user.password) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        Text('Sexo:'),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text('M'),
                                value: 'M',
                                groupValue: user.sex,
                                onChanged: (value) {
                                  setState(() {
                                    user.sex = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text('F'),
                                value: 'F',
                                groupValue: user.sex,
                                onChanged: (value) {
                                  setState(() {
                                    user.sex = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Teléfono'),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese su número de teléfono';
                            } else if (!RegExp(r'^\d{8}$').hasMatch(value)) {
                              return 'El número de teléfono debe tener 8 dígitos';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            print(value);
                            user.phone = int.parse(value!);
                          },
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text('Fecha de Nacimiento:'),
                            SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              icon: Icon(Icons.calendar_today),
                            ),
                            SizedBox(width: 8),
                            Text(user.birthdate),
                          ],
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Grupo Sanguíneo'),
                          onSaved: (value) {
                            user.bloodGroup = value;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Seguro'),
                          onSaved: (value) {
                            user.assurance = value;
                          },
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.only(top: 3, left: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                            ),
                          ),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () {
                              _submitForm();
                            },
                            color: Color(0xffff0000),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "Registrar",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Ya tienes cuenta?"),
                  TextButton(
                    onPressed: () {
                      context.pushNamed(LoginScreen.routeName);
                    },
                    child: Text(
                      " Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
