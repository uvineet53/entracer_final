import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

Widget statsWidget({
  required String email,
  required String location,
  required String temp,
  required String oxygen,
  required String risk,
}) {
  return Column(
    children: [
      VStack([
        HStack([
          CircleAvatar(
            radius: Get.width * .05,
            backgroundColor: Vx.green400,
            child: email.substring(0, 1).text.xl.green700.make(),
          ),
          "  $email".text.xl.white.bold.make(),
        ]).py4(),
        HStack([
          "Location: ".text.xl.semiBold.green300.make(),
          location.text.xl.white.bold.make(),
        ]).py4(),
        HStack([
          "Temp: ".text.xl.semiBold.green300.make(),
          temp.text.xl.white.bold.make(),
        ]).py4(),
        HStack([
          "Oxygen: ".text.xl.semiBold.green300.make(),
          oxygen.text.xl.white.bold.make(),
        ]).py4(),
        HStack(
          [
            "Risk: ".text.xl.semiBold.green300.make(),
            risk.text.xl.white.bold.make(),
          ],
          alignment: MainAxisAlignment.center,
        )
            .box
            .gray800
            .width(double.infinity)
            .p8
            .roundedSM
            .make()
            .marginSymmetric(vertical: 4),
      ]).box.gray600.p8.width(double.infinity).roundedSM.make(),
    ],
  );
}
