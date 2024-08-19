import 'package:flutter/material.dart';

import 'api_service.dart';
import 'colors.dart';

class ChronicKidneyDisease extends StatefulWidget {
  @override
  _ChronicKidneyDiseaseState createState() => _ChronicKidneyDiseaseState();
}

class _ChronicKidneyDiseaseState extends State<ChronicKidneyDisease> {
  final ApiService apiService = ApiService(
      baseUrl:
          'http://192.168.100.54:5000'); // Replace with your Flask server IP and port
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bpController = TextEditingController();
  final TextEditingController sgController = TextEditingController();
  final TextEditingController scController = TextEditingController();
  final TextEditingController buController = TextEditingController();
  final TextEditingController potassiumController = TextEditingController();
  final TextEditingController haemoglobinController = TextEditingController();

  String prediction = '';
  String predictionProbability = '';
  bool isLoading = false;

  void _makePrediction() async {
    setState(() {
      isLoading = true;
    });

    final input = {
      'age': int.parse(ageController.text),
      'blood_pressure': int.parse(bpController.text),
      'specific_gravity': double.parse(sgController.text),
      'albumin': 0,
      'sugar': 0,
      'red_blood_cells': 'normal',
      'pus_cell': 'normal',
      'pus_cell_clumps': 'notpresent',
      'bacteria': 'notpresent',
      'blood_glucose_random': 131,
      'blood_urea': double.parse(buController.text),
      'serum_creatinine': double.parse(scController.text),
      'sodium': 141,
      'potassium': double.parse(potassiumController.text),
      'haemoglobin': double.parse(haemoglobinController.text),
      'packed_cell_volume': 53,
      'white_blood_cell_count': 6800,
      'red_blood_cell_count': 6.1,
      'hypertension': 'no',
      'diabetes_mellitus': 'no',
      'coronary_artery_disease': 'no',
      'appetite': 'good',
      'peda_edema': 'no',
      'aanemia': 'no'
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
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
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
                controller: scController,
                decoration: InputDecoration(labelText: 'Serum Creatinine'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: buController,
                decoration: InputDecoration(labelText: 'Blood Urea'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: potassiumController,
                decoration: InputDecoration(labelText: 'Potassium'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: haemoglobinController,
                decoration: InputDecoration(labelText: 'Haemoglobin'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
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
      return "Awaiting Prediction...";
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
