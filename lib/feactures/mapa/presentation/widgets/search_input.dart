import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const SearchInput({
    Key? key,
    required this.controller,
    this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          suffixIcon: const Icon(Icons.search, color: Colors.grey),
        ),
        textInputAction: TextInputAction.search,
        // onSubmitted: onSubmitted,
        onChanged: onChanged,
      ),
    );
  }
}
