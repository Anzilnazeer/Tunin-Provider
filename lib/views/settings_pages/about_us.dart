import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tunin_2/utils/consts/colors.dart';

class AboutUs {
  aboutUs(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(226, 69, 69, 69),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "About Us",
                  style: TextStyle(color: Color.fromARGB(255, 180, 63, 63)),
                ),
                Text(
                  "v1.0.1",
                  style: TextStyle(
                      color: Color.fromARGB(255, 172, 45, 45),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
              '''Welcome To Tunin
            Tunin is a Professional Music Platform. Here we will provide you only exciting content, which you will like very much.
            We're dedicated to providing you the best of music with a focus on dependability and offline music.
            We're working to turn our passion for music into a booming.
            We hope you enjoy our music as much as we enjoy offering them to you.
            I will keep posting more essential posts on my Website for all of you. 
            Please give your support and love.''',
                    style: GoogleFonts.abel(),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'Made with love from '),
                        TextSpan(
                          text: 'Brocamp',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorsinUse().red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
