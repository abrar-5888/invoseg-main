// ignore_for_file: deprecated_member_use

import 'package:com.invoseg.innovation/signup_app/Component/component.dart';
import 'package:com.invoseg.innovation/signup_app/generate_password.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final SignupController signupController = SignupController();
  bool _isLoading = false;
  void setGeneratedPassword() {
    setState(() {
      signupController.password.text = PasswordGenerate.generatePassword();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text(
          "Sign Up",
          style: TextStyle(color: Color(0xff212121), fontWeight: FontWeight.w700, fontSize: 24),
        ),
        backgroundColor: Colors.white38,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: SafeArea(
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
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
                                            controller: signupController.name,
                                            //    initialValue: initials['name'] as String,
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
                                            onSaved: (value) {},
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
                                            controller: signupController.email,
                                            // initialValue: initials['email'] as String,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: const InputDecoration(
                                              labelText: 'Enter Your Email (optional)',
                                              border: InputBorder.none,
                                              hintText: 'john@email.com',
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                            ),

                                            onSaved: (value) {},
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
                                            controller: signupController.password,
                                            obscureText: false,
                                            keyboardType: TextInputType.visiblePassword,
                                            decoration: InputDecoration(
                                              suffixIcon: Container(
                                                margin: const EdgeInsets.all(8),
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    minimumSize: const Size(100, 50),
                                                  ),
                                                  child: const Text(
                                                    "generate pass",
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
                                                  ),
                                                  onPressed: () {
                                                    setGeneratedPassword();
                                                  },
                                                ),
                                              ),
                                              labelText: 'Enter Your Password',
                                              border: InputBorder.none,
                                              hintText: '********',
                                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 10),
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
                                              // RegisterationModel.password = value!;
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
                                            controller: signupController.confirmPassword,
                                            keyboardType: TextInputType.visiblePassword,
                                            decoration: const InputDecoration(
                                              labelText: 'Confirm Your Password',
                                              border: InputBorder.none,
                                              hintText: '********',
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please verify your password';
                                              }
                                              if (signupController.password.text != value) {
                                                return 'Password doesn\'t match';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {},
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
                                            controller: signupController.phone,
                                            // initialValue: initials['phoneNo'] as String,
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
                                              // RegisterationModel.phoneNo = value!;
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
                                            controller: signupController.fName,
                                            //    initialValue: initials['name'] as String,
                                            decoration: const InputDecoration(
                                              labelText: 'Enter Father Name/ Guardian Name',
                                              border: InputBorder.none,
                                              hintText: 'The John',
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'This field is required and cannot be left empty!';
                                              }

                                              return null;
                                            },
                                            onSaved: (value) {},
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
                                            controller: signupController.fPhone,
                                            // initialValue: initials['phoneNo'] as String,
                                            keyboardType: TextInputType.phone,
                                            decoration: const InputDecoration(
                                              labelText: 'Enter Father Phone Number',
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
                                              // RegisterationModel.phoneNo = value!;
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
                                            Icons.calendar_today_rounded,
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
                                            controller: signupController.age,
                                            // initialValue: initials['age'] as String,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: 'Enter Your Age(optional)',
                                              border: InputBorder.none,
                                              hintText: '22',
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                            ),

                                            onSaved: (value) {},
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
                                            Icons.house_rounded,
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
                                            controller: signupController.familyName,
                                            // initialValue: initials['owner'] as String,
                                            keyboardType: TextInputType.name,
                                            decoration: const InputDecoration(
                                              labelText: 'Owner Name',
                                              border: InputBorder.none,
                                              hintText: 'John Smith',
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'This field can\'t be empty';
                                              }
                                              return null;
                                            },

                                            onSaved: (value) {},
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
                                            Icons.design_services_outlined,
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
                                            controller: signupController.designation,
                                            // initialValue: initials['age'] as String,
                                            decoration: const InputDecoration(
                                              labelText: 'Enter Your Designation(optional)',
                                              border: InputBorder.none,
                                              hintText: 'Manager',
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                            ),

                                            onSaved: (value) {},
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
                                    margin: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
                                    child: Row(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                          child: Icon(
                                            Icons.pin_drop_rounded,
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
                                            controller: signupController.address,
                                            // initialValue: initials['address'] as String,
                                            keyboardType: TextInputType.streetAddress,
                                            decoration: const InputDecoration(
                                              labelText: 'Enter Your Address',
                                              border: InputBorder.none,
                                              hintText: '455 Maple St, Brooklyn, NY 11225',
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'This field cannot be left empty!';
                                              }
                                              if (value.contains("#") ||
                                                  value.contains("*") ||
                                                  value.contains("\$") ||
                                                  value.contains("=") ||
                                                  value.contains("&") ||
                                                  value.contains("^") ||
                                                  value.contains("%") ||
                                                  value.contains("@")) {
                                                return 'address is not valid';
                                              }
                                              if (value.length <= 3) {
                                                return 'address is too short';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {},
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
                                            Icons.house_outlined,
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
                                            // controller: signupController.societyBlock,
                                            initialValue: 'Marghzar',
                                            keyboardType: TextInputType.text,
                                            enabled: false,
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                              labelText: 'Society Name',
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                            ),
                                            onSaved: (value) {},
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
                                            Icons.house_outlined,
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
                                            controller: signupController.societyBlock,
                                            // initialValue: initials['email'] as String,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                              labelText: 'Society Block (optional)',
                                              border: InputBorder.none,
                                              hintText: 'Block A',
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                            ),
                                            onSaved: (value) {},
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
                                            Icons.house_outlined,
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
                                            controller: signupController.plotSize,
                                            // initialValue: initials['email'] as String,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                              labelText: 'Plot Size (optional)',
                                              border: InputBorder.none,
                                              hintText: '1 acre',
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                            ),
                                            onSaved: (value) {},
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
                                            Icons.add_location_alt_sharp,
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
                                            controller: signupController.mapUrl,
                                            // initialValue: initials['email'] as String,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                              labelText: 'Enter Your Location (optional)',
                                              border: InputBorder.none,
                                              hintText: 'Location Link',
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                            ),
                                            onSaved: (value) {},
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(top: 18.0, bottom: 3),
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
                                              "Continue",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            onPressed: () async {
                                              if (_formKey.currentState!.validate()) {
                                                _formKey.currentState!.save();
                                                setState(() {
                                                  _isLoading = true;
                                                });

                                                try {
                                                  await signupController.signup(context);
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                } catch (e) {
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('An error occurred: ${e.toString()}')),
                                                  );
                                                }
                                              } else {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Please fill up the required fields in the form')),
                                                );
                                              }
                                            }

                                            // onPressed: () async {
                                            //   if (_formKey.currentState!.validate()) {
                                            //     _formKey.currentState!.save();
                                            //     signupController.signup(context);
                                            //     setState(() {
                                            //       _isLoading = true;
                                            //     });
                                            //   } else {
                                            //     ScaffoldMessenger.of(context)
                                            //         .showSnackBar(
                                            //       const SnackBar(
                                            //           content: Text(
                                            //               'Please fill up the required fields in the form')),
                                            //     );
                                            //   }
                                            //   // await saveform();
                                            //   //   print("Working");//
                                            // })
                                            )
                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //   //padding: EdgeInsets.all(20),
                                  //   margin: EdgeInsets.all(20),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                  //     children: [
                                  //       Container(
                                  //           child: TextButton(
                                  //       child:Text( "Register a Family Member ?",
                                  //         style: TextStyle(color: Colors.teal[800]),
                                  //       ),onPressed: (){
                                  //         Navigator.push(
                                  //               context,
                                  //               PageTransition(
                                  //                   duration: Duration(milliseconds: 700),
                                  //                   type: PageTransitionType
                                  //                       .leftToRightWithFade,
                                  //                   child: Register_FM()));

                                  //                   },)),
                                  //       TextButton(
                                  //         style: TextButton.styleFrom(
                                  //           textStyle: const TextStyle(
                                  //               fontSize: 12,
                                  //               fontWeight: FontWeight.w800,
                                  //               color: Color(0xff8d43d6)),
                                  //         ),
                                  //         onPressed: () {
                                  //           Navigator.push(
                                  //               context,
                                  //               PageTransition(
                                  //                   duration: Duration(milliseconds: 700),
                                  //                   type: PageTransitionType
                                  //                       .leftToRightWithFade,
                                  //                   child: Register_FM()));
                                  //         },
                                  //         child: const Text(
                                  //           'Sign Up',
                                  //           style: TextStyle(
                                  //               color: Colors.teal,
                                  //               fontWeight: FontWeight.bold),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
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
