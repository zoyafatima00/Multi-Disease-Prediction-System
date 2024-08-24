import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:kidney_chronic_disease/chronic_kidney_disease.dart';
import 'package:kidney_chronic_disease/parkinson_disease.dart';

import 'colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late double _deviceHeight, _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            pColor.withOpacity(0.8),
            pColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 35, 14, 8),
              child: Image.asset("assets/img.png"),
            ),
            const SizedBox(
              height: 20,
            ),
            Scrollbar(
              child: Container(
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText(
                      "Accurate Health \nPredictions At \n Your Fingertips",
                      textStyle: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                          letterSpacing: 2,
                          wordSpacing: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  repeatForever: true,
                )),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Material(
              color: wColor,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  openAddDialog(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  child: const Text(
                    "Let's Go",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 23,
                      color: pColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  openAddDialog(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(20)),
              height: 270,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Choose",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChronicKidneyDisease()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.symmetric(
                              vertical: 0.015 * _deviceHeight,
                              horizontal: 0.09 * _deviceWidth),
                          child: Text(
                            "Chronic Disease \nPredictor",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ParkinsonPredictionPage()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.symmetric(
                              vertical: 0.015 * _deviceHeight,
                              horizontal: 0.05 * _deviceWidth),
                          child: Text(
                            "Parkinson's Disease\n Predictor",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
