// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'package:com.invoseg.innovation/main_app/app/Modules/addFamilyMember/addFamilyMember_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore_for_file: file_names

// ignore_for_file: avoid_unnecessary_containers

class AddMember extends StatefulWidget {
  const AddMember({super.key});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  AddFamilyMemberController controller = Get.put(AddFamilyMemberController());
  final GlobalKey<FormState> _FMformKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            }),
        foregroundColor: const Color(0xff212121),
        title: const Text(
          'Add Family Member',
          style: TextStyle(color: Color(0xff212121), fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(),
                    child: Column(
                      children: <Widget>[
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  "ADD FAMILY MEMBERS",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: (MediaQuery.of(context).size.width - MediaQuery.of(context).padding.top) * 0.060,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Maximum 10 Inherited Logins Allowed",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: (MediaQuery.of(context).size.width - MediaQuery.of(context).padding.top) * 0.040,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Obx(
                                    () => Text(
                                      "Your Remaining logins are ${controller.remaining.value}",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: (MediaQuery.of(context).size.width - MediaQuery.of(context).padding.top) * 0.040,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Form(
                            key: _FMformKey,
                            child: SingleChildScrollView(
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              SizedBox(
                                  width: double.infinity,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Container(
                                            height: 30.0,
                                            width: 1.0,
                                            color: Colors.grey.withOpacity(0.5),
                                            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: controller.nameController,
                                              // initialValue: FMinitials['name'] as String,
                                              decoration: const InputDecoration(
                                                labelText: 'Enter Your Full Name',
                                                border: InputBorder.none,
                                                hintText: 'Adam Hunt',
                                                hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'This field is required and cannot be left empty!';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                // addFMmodel.name = value!;
                                              },
                                              keyboardType: TextInputType.text,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                            child: Icon(
                                              Icons.email,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Container(
                                            height: 30.0,
                                            width: 1.0,
                                            color: Colors.grey.withOpacity(0.5),
                                            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: controller.emailController,
                                              // initialValue: FMinitials['email'] as String,
                                              keyboardType: TextInputType.emailAddress,
                                              decoration: const InputDecoration(
                                                labelText: 'Enter Your Email(optional)',
                                                border: InputBorder.none,
                                                hintText: 'john@email.com',
                                                hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                              ),
                                              validator: (value) {
                                                return null;
                                              },
                                              onSaved: (value) {
                                                // addFMmodel.email = value!;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                            child: Icon(
                                              Icons.phone,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Container(
                                            height: 30.0,
                                            width: 1.0,
                                            color: Colors.grey.withOpacity(0.5),
                                            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: controller.phoneController,
                                              // initialValue: FMinitials['phoneNo'] as String,
                                              keyboardType: TextInputType.phone,
                                              decoration: const InputDecoration(
                                                labelText: 'Enter Your Phone Number',
                                                border: InputBorder.none,
                                                hintText: '030xxxxxxxx',
                                                hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Phone Number is not valid!';
                                                }
                                                if (value.contains("#") ||
                                                    value.contains("*") ||
                                                    value.contains("\$") ||
                                                    value.contains("=") ||
                                                    value.contains("&") ||
                                                    value.contains("^") ||
                                                    value.contains("%") ||
                                                    value.contains("@")) {
                                                  return 'Invalid Phone Number';
                                                }
                                                if (value.length != 11) {
                                                  return 'Invalid phone number';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                // addFMmodel.phoneNo = value!;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                      child: Row(
                                        children: <Widget>[
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                            child: Icon(
                                              Icons.lock,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Container(
                                            height: 30.0,
                                            width: 1.0,
                                            color: Colors.grey.withOpacity(0.5),
                                            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              // obscureText: true,
                                              controller: controller.sPassword,
                                              keyboardType: TextInputType.visiblePassword,
                                              decoration: const InputDecoration(
                                                // suffixIcon: Container(
                                                //   margin: const EdgeInsets.all(8),
                                                //   child: TextButton(
                                                //     style: TextButton.styleFrom(
                                                //       minimumSize: const Size(100, 50),
                                                //     ),
                                                //     child: const Text(
                                                //       "generate pass",
                                                //       style: TextStyle(fontSize: 10),
                                                //     ),
                                                //     onPressed: () {
                                                //       // generatePassword();
                                                //     },
                                                //   ),
                                                // ),
                                                labelText: 'Enter Your Password',
                                                border: InputBorder.none,
                                                hintText: '********',
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Password is not valid!';
                                                }
                                                if (value.length <= 6) {
                                                  return 'Password must be greater or equal to 6 words';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                // addFMmodel.password = value!;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(top: 20.0),
                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              )),
                                              padding: MaterialStateProperty.all(
                                                  EdgeInsets.symmetric(vertical: 25, horizontal: MediaQuery.of(context).size.width - MediaQuery.of(context).padding.top) * 0.25),
                                              backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(15, 39, 127, 1)), // <-- Button color
                                              overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                                if (states.contains(MaterialState.pressed)) {
                                                  return const Color.fromRGBO(15, 39, 127, 0.548);
                                                }
                                                return null;
                                              }),
                                            ),
                                            child: const Text(
                                              "Add Family Member",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            onPressed: () async {
                                              if (_FMformKey.currentState!.validate()) {
                                                _FMformKey.currentState!.save();
                                                await controller.registerFM(context);
                                               
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Please correct the errors in the form')),
                                                );
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ]))
                            ])))
                      ],
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
