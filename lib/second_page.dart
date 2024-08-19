import 'package:flutter/material.dart';

import 'api_service.dart';
import 'colors.dart';

class ParkinsonPrediction extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<ParkinsonPrediction> {
  final ApiService apiService = ApiService(
      baseUrl:
          'http://192.168.100.54:5000'); // Replace with your Flask server IP and port
  final TextEditingController ageController = TextEditingController();
  final TextEditingController updrsController = TextEditingController();
  final TextEditingController tremorController = TextEditingController();
  final TextEditingController bradykinesiaController = TextEditingController();
  final TextEditingController rigidityController = TextEditingController();
  final TextEditingController posturalInstabilityController =
      TextEditingController();
  final TextEditingController mocaController = TextEditingController();
  // Add other controllers for all required input fields

  String prediction = '';
  bool isLoading = false;

  void _makePrediction() async {
    setState(() {
      isLoading = true;
    });

    final input = {
      'Age': int.parse(ageController.text),
      'Gender': 1,
      'Ethnicity': 0,
      'EducationLevel': 1,
      'BMI': 21.8561,
      'Smoking': 0.0000,
      'AlcoholConsumption': 0.2552,
      'PhysicalActivity': 4.0410,
      'DietQuality': 1.1428,
      'SleepQuality': 5.8705,
      'FamilyHistoryParkinsons': 1.0000,
      'TraumaticBrainInjury': 0.0000,
      'Hypertension': 0.0000,
      'Diabetes': 0.0000,
      'Depression': 0.0000,
      'Stroke': 1.0000,
      'SystolicBP': 133.0000,
      'DiastolicBP': 117.0000,
      'CholesterolTotal': 179.8165,
      'CholesterolLDL': 180.1037,
      'CholesterolHDL': 98.1335,
      'CholesterolTriglycerides': 352.3589,
      'UPDRS': double.parse(updrsController.text),
      'MoCA': double.parse(mocaController.text),
      'FunctionalAssessment': 9.4841,
      'Tremor': int.parse(tremorController.text),
      'Rigidity': int.parse(rigidityController.text),
      'Bradykinesia': int.parse(bradykinesiaController.text),
      'PosturalInstability': int.parse(posturalInstabilityController.text),
      'SpeechProblems': 0.0000,
      'SleepDisorders': 1.0000,
      'Constipation': 0.0000
    };

    try {
      print(
          'Sending request with input: $input'); // Print input data to console
      final result = await apiService.predictParkinsons(input);
      print('Received response: $result'); // Print API response to console
      setState(() {
        prediction = result['prediction'].toString();
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
          title: Text("Parkinson's Disease Predictor",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: updrsController,
                decoration: InputDecoration(labelText: 'UPDRS'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: tremorController,
                decoration: InputDecoration(labelText: 'Tremor'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: bradykinesiaController,
                decoration: InputDecoration(labelText: 'Bradykinesia'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: rigidityController,
                decoration: InputDecoration(labelText: 'Rigidity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: posturalInstabilityController,
                decoration: InputDecoration(labelText: 'Postural Instability'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: mocaController,
                decoration: const InputDecoration(labelText: 'MoCA'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
                                prediction == '1' ? Colors.red : Colors.green,
                          ),
                          textAlign: TextAlign.center,
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
    if (prediction == '1') {
      return "Parkinson's Disease Detected";
    } else if (prediction == '0') {
      return "No Parkinson's Disease Detected";
    } else if (prediction.contains('Error')) {
      return "Something went wrong. Please try again.";
    } else {
      return "Awaiting Prediction...";
    }
  }
}
