// ignore_for_file: deprecated_member_use


import 'package:com.invoseg.innovation/main_app/app/Modules/Login/login_controller.dart';
import 'package:com.invoseg.innovation/main_app/generated/assets.dart';
import 'package:com.invoseg.innovation/signup_app/Screen/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPAgeState();
}

class _LoginPAgeState extends State<LoginPage> {
  LoginController controller = Get.put<LoginController>(LoginController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(image: const AssetImage(Assets.imagesLoginbackground), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.color))),
        child: Center(
          child: Card(
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.grey.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Image.asset(
                        Assets.logoBGR,
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 15.0,
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              height: 10.0,
                              width: 1.0,
                              color: Colors.grey.withOpacity(0.5),
                              margin: const EdgeInsets.only(right: 10.0),
                            ),
                            Expanded(
                                child: TextFormField(
                              controller: controller.emailOrPhone.value,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  labelText: 'PhoneNo.', border: InputBorder.none, hintText: 'Enter your Email Address or PhoneNo.', hintStyle: TextStyle(color: Colors.grey, fontSize: 10)),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 15.0,
                              ),
                              child: Icon(
                                Icons.lock_open,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              height: 10.0,
                              width: 1.0,
                              color: Colors.grey.withOpacity(0.5),
                              margin: const EdgeInsets.only(right: 10.0),
                            ),
                            Expanded(
                                child: Obx(
                              () => TextFormField(
                                controller: controller.pass.value,
                                obscureText: controller.showPass.value,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          controller.showPass.value = !controller.showPass.value;
                                        },
                                        icon: controller.showPass.value ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)),
                                    labelText: 'Password',
                                    border: InputBorder.none,
                                    hintText: 'Enter your Password here',
                                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 10)),
                              ),
                            ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: Get.mediaQuery.size.width / 1.1,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (controller.checkForm()) {
                                controller.loginWithNode();
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  const Color.fromRGBO(15, 39, 127, 1),
                                ),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                ),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                )),
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0, top: 5.0, bottom: 5.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              onPressed: () {
                               Get.to(()=>const SignUp());
                              },
                              child: const Text(
                                'Don\'t have an account?',
                                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 10),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
