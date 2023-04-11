import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  String logo;
  void Function()? ontap;
  SquareTile({super.key, required this.logo, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white),
        child: Image.asset(
          logo,
          height: 40,
        ),
      ),
    );
  }
}
