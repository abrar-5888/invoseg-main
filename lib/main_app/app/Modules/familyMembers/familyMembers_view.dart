import 'package:com.invoseg.innovation/main_app/app/Modules/familyMembers/familyMembers_controller.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/usersModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FamilyMembers extends StatelessWidget {
  const FamilyMembers({super.key});

  @override
  Widget build(BuildContext context) {
    FamilymembersController controller = Get.put(FamilymembersController());
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
          'Family Members',
          style: TextStyle(color: Color(0xff212121), fontWeight: FontWeight.w700, fontSize: 23),
        ),
      ),
      body: Obx(() => controller.familyMembers.isNotEmpty
          ? ListView.builder(
              itemCount: controller.familyMembers.length,
              itemBuilder: (context, index) {
                UsersModel family = controller.familyMembers[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    elevation: 10,
                    child: ListTile(
                        tileColor: Colors.white,
                        title: Text(
                          family.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("0${family.phoneNumber}"),
                        trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.vpn_key))),
                  ),
                );
              },
            )
          : const Center(
              child: Text("No family members registered"),
            )),
    );
  }
}
