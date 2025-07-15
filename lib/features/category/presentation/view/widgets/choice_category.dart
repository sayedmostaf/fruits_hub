import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class ChoiceCategory extends StatefulWidget {
  const ChoiceCategory({
    super.key,
    required this.text,
    required this.isChecked,
    this.onChanged,
  });
  final String text;
  final bool isChecked;
  final void Function(bool?)? onChanged;
  @override
  State<ChoiceCategory> createState() => _ChoiceCategoryState();
}

class _ChoiceCategoryState extends State<ChoiceCategory> {
  late bool isChecked;
  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.black,
          activeColor: Colors.black,
          value: widget.isChecked,
          shape: CircleBorder(),
          onChanged: widget.onChanged,
        ),
        SizedBox(width: 16),
        Text(widget.text, style: TextStyles.bold13),
      ],
    );
  }
}
