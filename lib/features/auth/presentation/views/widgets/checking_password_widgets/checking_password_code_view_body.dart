import 'package:flutter/material.dart';

class CheckingPasswordCodeViewBody extends StatefulWidget {
  const CheckingPasswordCodeViewBody({super.key});

  @override
  State<CheckingPasswordCodeViewBody> createState() =>
      _CheckingPasswordCodeViewBodyState();
}

class _CheckingPasswordCodeViewBodyState
    extends State<CheckingPasswordCodeViewBody> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _submitCode() {
    if (_formKey.currentState!.validate()) {
      final otp = _controllers.map((e) => e.text).join();
      print("✅ OTP Entered: $otp");
      // send code to server
    } else {
      print("❌ Validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Text(
            'أدخل الرمز الذي أرسلناه إلى عنوان بريد التالي Maxxx@email.com',
            style: TextStyle(
              color: Color(0xFF616A6B),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 29),
          Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return PasswordCodeTextFieldWidget(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 3) {
                      _focusNodes[index + 1].requestFocus();
                    } else if (value.isEmpty && index > 0) {
                      _focusNodes[index - 1].requestFocus();
                    }
                  },
                );
              }),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(onPressed: _submitCode, child: const Text('تحقق')),
        ],
      ),
    );
  }
}

class PasswordCodeTextFieldWidget extends StatefulWidget {
  const PasswordCodeTextFieldWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String)? onChanged;
  @override
  State<PasswordCodeTextFieldWidget> createState() =>
      _PasswordCodeTextFieldWidgetState();
}

class _PasswordCodeTextFieldWidgetState
    extends State<PasswordCodeTextFieldWidget> {
  bool isFilled = false;
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        isFilled = widget.controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 64,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isFilled ? Colors.amber : const Color(0xFF0C0D0D),
          fontSize: 23,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF9FAFA),
          counterText: '',
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: (isFilled ? Colors.amber : const Color(0xFFE6E9E9)),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              !RegExp(r'^[0-9]$').hasMatch(value)) {
            return '';
          }
          return null;
        },
      ),
    );
  }
}
