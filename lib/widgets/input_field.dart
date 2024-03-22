import 'package:chat_app/theme/fonts.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String? title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final TextInputType? textType;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const InputField(
      { this.title,
      required this.hint,
      this.controller,
      this.widget,
      this.textType,
      this.validator,
      this.onSaved,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(title != null)
            Text(
              title!,
              style: titleStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              autocorrect: title == null? true:false,
              enableSuggestions: title == null? true:false,
              onSaved: onSaved,
              validator: validator,
              controller: controller,
              keyboardType: textType,
              autofocus: false,
              style: titleStyle,
              cursorColor: const Color.fromRGBO(0, 117, 255, 1),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12),
                prefixIcon: widget,
                hintText: hint,
                hintStyle: subTitle,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                      width: 1,
                    )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:  BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    )),
              ),
            ),
          ],
        ));
  }
}
