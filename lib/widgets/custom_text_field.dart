import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.onSurface),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: AppColors.primary, size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      ),
    );
  }
}
