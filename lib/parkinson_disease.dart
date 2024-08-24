import 'package:flutter/material.dart';

import 'api_service.dart'; // Import your ApiService class here
import 'colors.dart'; // Import your custom colors

class ParkinsonPredictionPage extends StatefulWidget {
  @override
  _ParkinsonPredictionPageState createState() =>
      _ParkinsonPredictionPageState();
}

class _ParkinsonPredictionPageState extends State<ParkinsonPredictionPage> {
  final ApiService apiService = ApiService(
      baseUrl:
          'http://192.168.18.45:5000'); // Replace with your Flask server IP and port
  final TextEditingController updrsController = TextEditingController();
  final TextEditingController mocaController = TextEditingController();

  String prediction = '';
  String predictionProbability = '';
  bool isLoading = false;
  int? tremorValue;
  int? bradykinesiaValue;
  int? rigidityValue;
  int? posturalInstabilityValue;
  int? sleepDisorderValue;
  int? depressionValue;

  void _makePrediction() async {
    setState(() {
      isLoading = true;
    });

    final input = {
      'Tremor': tremorValue ?? 0,
      'Bradykinesia': bradykinesiaValue ?? 0,
      'Rigidity': rigidityValue ?? 0,
      'PosturalInstability': posturalInstabilityValue ?? 0,
      'UPDRS': double.parse(updrsController.text),
      'MoCA': double.parse(mocaController.text),
      'SleepDisorders': sleepDisorderValue ?? 0,
      'Depression': depressionValue ?? 0,
    };

    try {
      print(
          'Sending request with input: $input'); // Print input data to console
      final result = await apiService.predictParkinsons(input);
      print('Recieving response from model .......');
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
          title: const Text("Parkinson's Disease Predictor",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: tremorValue,
                decoration: const InputDecoration(
                    labelText: 'Tremor'), // Correct usage of decoration
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
                    tremorValue = value;
                  });
                },
              ),
              DropdownButtonFormField<int>(
                value: bradykinesiaValue,
                decoration: const InputDecoration(
                    labelText: 'Bradykinesia'), // Correct usage of decoration
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
                    bradykinesiaValue = value;
                  });
                },
              ),
              DropdownButtonFormField<int>(
                value: rigidityValue,
                decoration: const InputDecoration(
                    labelText: 'Rigidity'), // Correct usage of decoration
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
                    rigidityValue = value;
                  });
                },
              ),
              DropdownButtonFormField<int>(
                value: posturalInstabilityValue,
                decoration: const InputDecoration(
                    labelText:
                        'Postural Instability'), // Correct usage of decoration
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
                    posturalInstabilityValue = value;
                  });
                },
              ),
              TextField(
                controller: updrsController,
                decoration: InputDecoration(labelText: 'UPDRS'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: mocaController,
                decoration: InputDecoration(labelText: 'MoCA'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              DropdownButtonFormField<int>(
                value: sleepDisorderValue,
                decoration: const InputDecoration(
                    labelText:
                        'Sleep Disorders'), // Correct usage of decoration
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
                    sleepDisorderValue = value;
                  });
                },
              ),
              DropdownButtonFormField<int>(
                value: depressionValue,
                decoration: const InputDecoration(
                    labelText: 'Depression'), // Correct usage of decoration
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
                    depressionValue = value;
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
      return "No Parkinson Disease Detected";
    } else if (prediction == '1') {
      return "Parkinson Disease Detected";
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
      final maxProbability = double.parse(probabilities[0]) * 100;
      return maxProbability.toStringAsFixed(2);
    }
    return "";
  }
}
