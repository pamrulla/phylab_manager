import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextFromFieldRounded extends StatefulWidget {
  TextFromFieldRounded(
      {Key key,
      this.labelText,
      this.controller,
      this.prefixIcon,
      this.focusNode,
      this.validator,
      this.focusNodeNext,
      this.keyboardType = TextInputType.text})
      : super(key: key);
  final String labelText;
  final TextEditingController controller;
  final Icon prefixIcon;
  final FocusNode focusNode;
  final FocusNode focusNodeNext;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;

  @override
  _TextFromFieldRoundedState createState() => _TextFromFieldRoundedState();
}

class _TextFromFieldRoundedState extends State<TextFromFieldRounded> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        validator: widget.validator,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(widget.focusNodeNext);
        },
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).backgroundColor.withAlpha(100),
          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          labelText: widget.labelText,
          labelStyle: Theme.of(context).textTheme.caption,
          prefixIcon: widget.prefixIcon,
          errorStyle: TextStyle(
            color: Colors.red,
            wordSpacing: 1.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(45.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(45.0),
            borderSide: BorderSide(
              color: Theme.of(context).errorColor,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
