import 'package:flutter/material.dart';

import 'api_service.dart'; // Import your ApiService class here
import 'colors.dart'; // Import your custom colors

class ChronicKidneyDisease extends StatefulWidget {
  @override
  _ChronicKidneyDiseaseState createState() => _ChronicKidneyDiseaseState();
}

class _ChronicKidneyDiseaseState extends State<ChronicKidneyDisease> {
  final ApiService apiService = ApiService(
      baseUrl:
          'http://192.168.18.45:5000'); // Replace with your Flask server IP and port
  final TextEditingController bpController = TextEditingController();
  final TextEditingController sgController = TextEditingController();
  final TextEditingController alController = TextEditingController();
  final TextEditingController suController = TextEditingController();
  final TextEditingController rbcController = TextEditingController();
  final TextEditingController buController = TextEditingController();
  final TextEditingController scController = TextEditingController();
  final TextEditingController sodController = TextEditingController();
  final TextEditingController potController = TextEditingController();
  final TextEditingController hemoController = TextEditingController();
  final TextEditingController wbccController = TextEditingController();
  final TextEditingController rbccController = TextEditingController();
  final TextEditingController htnController = TextEditingController();

  String prediction = '';
  String predictionProbability = '';
  bool isLoading = false;
  String rbcValue = '';
  String htnValue = '';

  void _makePrediction() async {
    setState(() {
      isLoading = true;
    });

    final input = {
      'Bp': int.parse(bpController.text),
      'Sg': double.parse(sgController.text),
      'Al': int.parse(alController.text),
      'Su': int.parse(suController.text),
      'Rbc': rbcValue == 'Normal' ? 0 : 1,
      'Bu': double.parse(buController.text),
      'Sc': double.parse(scController.text),
      'Sod': double.parse(sodController.text),
      'Pot': double.parse(potController.text),
      'Hemo': double.parse(hemoController.text),
      'Wbcc': int.parse(wbccController.text),
      'Rbcc': double.parse(rbccController.text),
      'Htn': htnValue == 'Yes' ? 1 : 0,
    };

    try {
      print(
          'Sending request with input: $input'); // Print input data to console
      final result = await apiService.predict(input);
      print('Received response: $result'); // Print API response to console
      setState(() {
        prediction = result['prediction'].toString();
        predictionProbability = result['prediction_probability'].toString();
        isLoading = false;
      });
    } catch (e) {
      print('Error occurred: $e'); // Print error to console
      setState(() {
        prediction = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          backgroundColor: pColor,
          title: const Text("Chronic Kidney Disease Predictor",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: bpController,
                decoration: InputDecoration(labelText: 'Blood Pressure'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: sgController,
                decoration: InputDecoration(labelText: 'Specific Gravity'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: alController,
                decoration: InputDecoration(labelText: 'Albumin'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: suController,
                decoration: InputDecoration(labelText: 'Sugar'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<int>(
                value: rbcController.text.isEmpty
                    ? null
                    : int.parse(rbcController.text),
                decoration: const InputDecoration(
                    labelText:
                        'Red Blood Cells'), // Correct usage of decoration
                items: const [
                  DropdownMenuItem(
                    child: Text('Normal'),
                    value: 0,
                  ),
                  DropdownMenuItem(
                    child: Text('Abnormal'),
                    value: 1,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    rbcController.text = value
                        .toString(); // Set the selected value to the controller
                  });
                },
              ),
              TextField(
                controller: buController,
                decoration: InputDecoration(labelText: 'Blood Urea'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: scController,
                decoration: InputDecoration(labelText: 'Serum Creatinine'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: sodController,
                decoration: InputDecoration(labelText: 'Sodium'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: potController,
                decoration: InputDecoration(labelText: 'Potassium'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: hemoController,
                decoration: InputDecoration(labelText: 'Haemoglobin'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: wbccController,
                decoration:
                    InputDecoration(labelText: 'White Blood Cell Count'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: rbccController,
                decoration: InputDecoration(labelText: 'Red Blood Cell Count'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              DropdownButtonFormField<int>(
                value: rbcController.text.isEmpty
                    ? null
                    : int.parse(rbcController.text),
                decoration: const InputDecoration(
                    labelText: 'Hypertension'), // Correct usage of decoration
                items: const [
                  DropdownMenuItem(
                    child: Text('No'),
                    value: 0,
                  ),
                  DropdownMenuItem(
                    child: Text('Yes'),
                    value: 1,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    htnController.text = value
                        .toString(); // Set the selected value to the controller
                  });
                },
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _makePrediction();
                },
                child: Container(
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Predict",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : Column(
                      children: [
                        Text(
                          _getFriendlyPredictionText(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                prediction == '0' ? Colors.red : Colors.green,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Confidence: ${_getFormattedProbability()}%',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFriendlyPredictionText() {
    if (prediction == '0') {
      return "Chronic Kidney Disease Detected";
    } else if (prediction == '1') {
      return "No Chronic Kidney Disease Detected";
    } else if (prediction.contains('Error')) {
      return "Something went wrong. Please try again.";
    } else {
      return prediction;
    }
  }

  String _getFormattedProbability() {
    if (predictionProbability.isNotEmpty) {
      final probabilities = predictionProbability
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',');
      final maxProbability = double.parse(probabilities[1]) * 100;
      return maxProbability.toStringAsFixed(2);
    }
    return "";
  }
}
