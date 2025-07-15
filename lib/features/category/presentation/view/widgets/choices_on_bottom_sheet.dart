import 'package:flutter/widgets.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/widgets/custom_button.dart';
import 'package:fruits_hub/features/category/presentation/view/widgets/choice_category.dart';

class ChoicesOnBottomSheet extends StatefulWidget {
  const ChoicesOnBottomSheet({super.key});

  @override
  State<ChoicesOnBottomSheet> createState() => _ChoicesOnBottomSheetState();
}

class _ChoicesOnBottomSheetState extends State<ChoicesOnBottomSheet> {
  int? _selectedChoiceIndex;
  bool alpha = false, ascending = false;
  void _onChoiceSelected(int index) {
    setState(() {
      _selectedChoiceIndex = index;
      if (_selectedChoiceIndex == 0) {
        alpha = false;
        ascending = true;
      } else if (_selectedChoiceIndex == 1) {
        alpha = false;
        ascending = false;
      } else if (_selectedChoiceIndex == 2) {
        alpha = true;
        ascending = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Text('ترتيب حسب: ', style: TextStyles.bold19),
          ChoiceCategory(
            text: "السعر ( الأقل الي الأعلي )",
            isChecked: _selectedChoiceIndex == 0,
            onChanged: (value) {
              if (value == true) _onChoiceSelected(0);
            },
          ),
          ChoiceCategory(
            text: "السعر ( الأعلي الي الأقل )",
            isChecked: _selectedChoiceIndex == 1,
            onChanged: (value) {
              if (value == true) _onChoiceSelected(1);
            },
          ),
          ChoiceCategory(
            text: "الأبجديه",
            isChecked: _selectedChoiceIndex == 2,
            onChanged: (value) {
              if (value == true) _onChoiceSelected(2);
            },
          ),
          const Spacer(),
          CustomButton(
            onPressed: () {
              // TODO: implement filtering logic using cubit
            },
            text: 'تصفيه',
          ),
        ],
      ),
    );
  }
}
