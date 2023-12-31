// ignore_for_file: non_constant_identifier_names, must_be_immutable, camel_case_types

import 'package:flutter/material.dart';
import 'package:location_grm/feactures/core/utils/colors.dart';
import 'package:location_grm/feactures/core/utils/dimensions.dart';

class Text_Field extends StatelessWidget {
  final Widget text_field;
  double text_field_height;
  double text_field_width;
  double radius;
  Color? borderColor;
  Text_Field(
      {Key? key,
      this.borderColor,
      required this.text_field,
      this.text_field_height = 0,
      this.text_field_width = 0,
      this.radius = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: text_field_width == 0
          ? Dimensions.text_field_width
          : text_field_width,
      height: text_field_height == 0
          ? Dimensions.text_field_height50
          : text_field_height,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.all(Radius.circular(radius == 0 ? 10 : radius)),
        border: Border.all(
            color: borderColor == null ? AppColors.pink : borderColor!,
            width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: text_field,
      ),
    );
  }
}
