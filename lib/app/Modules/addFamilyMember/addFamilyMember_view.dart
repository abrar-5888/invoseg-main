import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:com.invoseg.innovation/app/Modules/addFamilyMember/addFamilyMember_controller.dart';
// ignore_for_file: file_names

// ignore_for_file: avoid_unnecessary_containers

class AddMember extends StatefulWidget {
  const AddMember({super.key});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  AddFamilyMemberController controller = Get.put(AddFamilyMemberController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  decoration: const InputDecoration(
                                    labelText: 'Enter Your Full Name',
                                    border: InputBorder.none,
                                    hintText: 'Sharjeel',
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                  ),
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
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      labelText: 'Enter Your Email',
                                      border: InputBorder.none,
                                      hintText: 'sharjeel@email.com',
                                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                    )),
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
                                  keyboardType: TextInputType.phone,
                                  controller: controller.phoneController,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter Your Phone Number',
                                    border: InputBorder.none,
                                    hintText: '03014530509',
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                  ),
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
                                  keyboardType: TextInputType.phone,
                                  controller: controller.sPassword,
                                  decoration: const InputDecoration(
                                    labelText: 'Set Password',
                                    border: InputBorder.none,
                                    // hintText: '03014530509',
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                  ),
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
                                  keyboardType: TextInputType.phone,
                                  controller: controller.cPassword,
                                  decoration: const InputDecoration(
                                    labelText: 'Confirm Password',
                                    border: InputBorder.none,
                                    // hintText: '03014530509',
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 1.1,
                              height: 50,
                              child: Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (controller.checkForm()) {
                                      controller.addFM();
                                    }
                                  },
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100),
                                      )),
                                      backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(15, 39, 127, 1)),
                                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 20))),
                                  child: const Text('Add Member Request', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                                ),
                              ),
                            ))
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
