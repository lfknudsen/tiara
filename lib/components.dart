import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  const IconText(this.icon, this.text, {super.key});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Icon(icon), Text(" $text")],
        ),
      ],
    );
  }
}

class IconTextButton extends StatelessWidget {
  const IconTextButton(this.onPressed, this.icon, this.text, {super.key});
  final String text;
  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.fromLTRB(85, 5, 85, 5),
      child: ElevatedButton(
        onPressed: onPressed,
        child: IconText(icon, text, key: key),
      ),
    );
  }
}