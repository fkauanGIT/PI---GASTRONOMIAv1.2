import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FichaInput extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool isNumber;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool isRequired;
  final IconData? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;

  const FichaInput({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.isNumber = false,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
    this.isRequired = false,
    this.prefixIcon,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        onChanged: onChanged,
        focusNode: focusNode,
        textInputAction: textInputAction ?? TextInputAction.next,
        controller: controller,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType ??
            (isNumber
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text),
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF1F2937),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          label: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 15,
              ),
              children: [
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: const Color(0xFF007BFF), // Azul
                  size: 20,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF007BFF), width: 2), // Azul
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}