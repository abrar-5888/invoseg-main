// ignore_for_file: deprecated_member_use

import 'package:com.invoseg.innovation/main_app/app/Modules/Login/login_page.dart';
import 'package:com.invoseg.innovation/main_app/app/Modules/Profile/profile_controller.dart';
import 'package:com.invoseg.innovation/main_app/app/Modules/addFamilyMember/addFamilyMember_view.dart';
import 'package:com.invoseg.innovation/main_app/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileController controller = Get.put<ProfileController>(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  SharedPreferences userinfo = await SharedPreferences.getInstance();
                  userinfo.clear();

                  Get.offAll(const LoginPage());
                },
                icon: const Icon(Icons.logout_outlined))
          ],
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
            'Profile',
            style: TextStyle(color: Color(0xff212121), fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ),
        body: FutureBuilder(
            future: controller.initializeSharedPreferencesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.grey, Colors.white],
                              ),
                            ),
                            child: Column(children: [
                              const SizedBox(
                                height: 30.0,
                              ),
                              const CircleAvatar(
                                radius: 65.0,
                                backgroundImage: AssetImage(Assets.imagesProfileIconSVG),
                                backgroundColor: Colors.white,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(controller.userData!.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                  )),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                controller.userData?.designation ?? "",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              ElevatedButton.icon(
                                  label: const Text(
                                    'Add Family Members',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Get.to(() => const AddMember());
                                  },
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100),
                                      )),
                                      backgroundColor: MaterialStateProperty.all(Colors.black),
                                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 20))),
                                  icon: const Icon(Icons.add, color: Colors.white))
                            ]),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            color: Colors.grey[200],
                            child: Center(
                                child: Card(
                                    margin: const EdgeInsets.fromLTRB(0.0, 55.0, 0.0, 20.0),
                                    child: SizedBox(
                                        width: 310.0,
                                        //height: 290.0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SingleChildScrollView(
                                            physics: const BouncingScrollPhysics(),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "More Information",
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                Divider(
                                                  color: Colors.grey[300],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.home,
                                                      color: Colors.blueAccent[400],
                                                      size: 35,
                                                    ),
                                                    const SizedBox(
                                                      width: 20.0,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text(
                                                          "Address",
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                          ),
                                                        ),
                                                        Text(
                                                          controller.userData?.address ?? "",
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Colors.grey[400],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                if (controller.userData!.age.isNotEmpty)
                                                  const SizedBox(
                                                    height: 20.0,
                                                  ),
                                                if (controller.userData!.age.isNotEmpty)
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.date_range_rounded,
                                                        color: Colors.greenAccent[400],
                                                        size: 35,
                                                      ),
                                                      const SizedBox(
                                                        width: 20.0,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Text(
                                                            "Age",
                                                            style: TextStyle(
                                                              fontSize: 15.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            controller.userData?.age ?? "",
                                                            style: TextStyle(
                                                              fontSize: 12.0,
                                                              color: Colors.grey[400],
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),

                                                // Row(
                                                //   mainAxisAlignment: MainAxisAlignment.start,
                                                //   children: [
                                                //     Icon(
                                                //       Icons.phone,
                                                //       color: Colors.pinkAccent[400],
                                                //       size: 35,
                                                //     ),
                                                //     const SizedBox(
                                                //       width: 20.0,
                                                //     ),
                                                //     Column(
                                                //       crossAxisAlignment: CrossAxisAlignment.start,
                                                //       children: [
                                                //         const Text(
                                                //           "Phone",
                                                //           style: TextStyle(
                                                //             fontSize: 15.0,
                                                //           ),
                                                //         ),
                                                //        Text(
                                                //                 controller.userData!.phoneNumber,
                                                //                 // "TEST",
                                                //                 style: TextStyle(
                                                //                   fontSize: 12.0,
                                                //                   color: Colors.grey[400],
                                                //                 ),
                                                //               )

                                                //       ],
                                                //     )
                                                //   ],
                                                // ),

                                                const SizedBox(
                                                  height: 20.0,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.star_purple500_outlined,
                                                      color: Colors.blue[400],
                                                      size: 35,
                                                    ),
                                                    const SizedBox(
                                                      width: 20.0,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text(
                                                          "Father Name",
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                          ),
                                                        ),
                                                        Text(
                                                          controller.userData?.fatherName ?? "",
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Colors.grey[400],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 20.0,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.people,
                                                      color: Colors.lightGreen[400],
                                                      size: 35,
                                                    ),
                                                    const SizedBox(
                                                      width: 20.0,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const FittedBox(
                                                          child: Text(
                                                            "Father PhoneNo",
                                                            style: TextStyle(
                                                              fontSize: 15.0,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          controller.userData?.fatherPhoneNumber ?? "",
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Colors.grey[400],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 20.0,
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.no_accounts_outlined,
                                                      color: Colors.redAccent[400],
                                                      size: 35,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    GestureDetector(
                                                      child: const Text(
                                                        "Deactivate My Account",
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      onTap: () async {},
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )))),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.height * 0.40,
                        left: 20.0,
                        right: 20.0,
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.yellowAccent[400],
                                size: 35,
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Phone",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  Text(
                                    controller.userData!.phoneNumber,
                                    // "TEST",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey[400],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ))),
                  ],
                );
              }
            }));
  }
}
