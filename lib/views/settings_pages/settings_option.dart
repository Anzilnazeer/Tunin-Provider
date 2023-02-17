import 'package:flutter/material.dart';

class OptionWidget extends StatelessWidget {
  final String infoText;
  final IconData infoIcon;
  final Function() infoAction;
  const OptionWidget({
    super.key,
    required this.infoText,
    required this.infoIcon,
    required this.infoAction,
  });

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      height: 65,
      margin: EdgeInsets.only(right: screenwidth / 5),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          color: Color.fromARGB(163, 43, 43, 43)),
      child: Center(
        child: ListTile(
          tileColor: const Color.fromARGB(0, 0, 0, 0),
          title: Text(
            infoText,
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          leading: Icon(
            infoIcon,
            color: Colors.white,
          ),
          onTap: infoAction,
        ),
      ),
    );
  }
}
