import 'package:flutter/material.dart';
import 'package:metroca/modulos/login/view/auth_form.dart';

class PaginaLogin extends StatelessWidget {
  const PaginaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(14, 6, 161, 0.49),
                Color.fromRGBO(117, 214, 255, 0.898),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 30,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 70,
                      ),
                      // transform: Matrix4.rotationZ(-8 * pi / 180)
                      //   ..translate(-30.0), //cascade operator
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(20),
                      //   color: Colors.deepOrange.shade900,
                      //   boxShadow: const [
                      //     BoxShadow(
                      //         blurRadius: 8,
                      //         color: Colors.black26,
                      //         offset: Offset(0, 2)),
                      //   ],
                      // ),
                      child: const Text(
                        'Metroca',
                        style: TextStyle(
                          fontSize: 45,
                          fontFamily: 'Anton',
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    AuthForm(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
