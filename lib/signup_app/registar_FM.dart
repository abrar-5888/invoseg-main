import 'package:com.invoseg.innovation/signup_app/Component/component.dart';
import 'package:com.invoseg.innovation/signup_app/generate_password.dart';
import 'package:flutter/material.dart';

class RegisterFM extends StatefulWidget {
  const RegisterFM({super.key});

  @override
  State<RegisterFM> createState() => _RegisterFMState();
}

class _RegisterFMState extends State<RegisterFM> {
  final SignupController signupController = SignupController();
  final GlobalKey<FormState> _FMformKey = GlobalKey();
  bool _isLoading = false;

  void setGeneratedPassword() {
    setState(() {
      signupController.password.text = PasswordGenerate.generatePassword();
    });
  }

  void _registerFamilyMember(BuildContext context) async {
    if (_FMformKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _FMformKey.currentState!.save();
      await signupController.registerFM(context); // Assume this is a Future
      setState(() {
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the errors in the form')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign Up a Family Member",
          style: TextStyle(color: Color(0xff212121), fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.white38,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: _FMformKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "You can add ",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "${signupController.remaining > 0 ? signupController.remaining : 10}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      const Text(
                                        " Family Members",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 35),
                                _buildTextField(
                                  icon: Icons.person,
                                  label: 'Enter Your Full Name',
                                  hint: 'Adam Hunt',
                                  controller: signupController.name,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field is required and cannot be left empty!';
                                    }
                                    return null;
                                  },
                                ),
                                _buildTextField(
                                  keyboardType: TextInputType.number,
                                  icon: Icons.calendar_today_rounded,
                                  label: 'Enter Your Age',
                                  hint: '22',
                                  controller: signupController.age,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field is required and cannot be left empty!';
                                    }
                                    return null;
                                  },
                                ),
                                _buildTextField(
                                  icon: Icons.phone,
                                  label: 'Enter Your Phone Number',
                                  hint: '030xxxxxxxx',
                                  controller: signupController.phone,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Phone Number is not valid!';
                                    }
                                    if (value.contains(RegExp(r'\D'))) {
                                      return 'Invalid Phone Number';
                                    }
                                    if (value.length != 11) {
                                      return 'Invalid phone number';
                                    }
                                    return null;
                                  },
                                ),
                                _buildPasswordTextField(),
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
                                            EdgeInsets.symmetric(vertical: 25, horizontal: MediaQuery.of(context).size.width - MediaQuery.of(context).padding.top) * 0.25,
                                          ),
                                          backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(15, 39, 127, 1)),
                                          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                            (states) {
                                              if (states.contains(MaterialState.pressed)) {
                                                return const Color.fromRGBO(15, 39, 127, 0.548);
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        child: const Text(
                                          "Add Family Member",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () => _registerFamilyMember(context),
                                      )
                                    ],
                                  ),
                                ),
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
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return Container(
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(icon, color: Colors.black),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Container(
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
            child: Icon(Icons.lock, color: Colors.black),
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
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(100, 50),
                    ),
                    onPressed: setGeneratedPassword,
                    child: const Text("generate pass", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black)),
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
            ),
          ),
        ],
      ),
    );
  }
}
