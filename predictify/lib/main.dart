import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _formKey = GlobalKey<FormState>();
  final tvMarketingExpensesController = TextEditingController();
  String? prediction;

  Future<void> showPrediction() async {
    if (_formKey.currentState?.validate() ?? false) {
      final tvValue = double.tryParse(tvMarketingExpensesController.value.text);
      if (tvValue == null) {
        setState(() {
          prediction = 'Please enter a valid number for TV value';
        });
        return;
      }

      final requestBody = jsonEncode({'tv': tvValue});
      debugPrint('Request body: $requestBody'); // Print the request body

      final response = await http.post(
        Uri.parse('https://add6-196-12-151-106.ngrok-free.app/predict'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print(response.body); // Print the response body (prediction value
        final data = jsonDecode(response.body);
        final predictionValue = data;
        setState(() {
          prediction = 'The predicted sales is $predictionValue';
        });
      } else {
        setState(() {
          prediction = 'An error occurred while making the prediction.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'TvSales_Predictify',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 108, 0, 133),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const Text(
                  'Welcome to TvSales_Predictify',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 108, 0, 133),
                  ),
                ),
                const Text(
                  'Predict your Tv Sales with us!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 55, 54, 55),
                  ),
                ),
                const SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: TextFormField(
                          controller: tvMarketingExpensesController,
                          decoration: const InputDecoration(
                            labelText: 'Enter the Tv Marketing Expenses',
                            hintText: 'Tv Marketing Expenses',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 108, 0, 133),
                                width: 2.0,
                              ),
                              gapPadding: 2.0,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a number';
                            } else if (value.contains(RegExp(r'[a-zA-Z]'))) {
                              return 'Please enter a valid number';
                            } else if (value.contains(RegExp(r'[^0-9]'))) {
                              return 'Please enter a valid number';
                            }
                            final inputnumber = double.tryParse(value);
                            if (inputnumber == null ||
                                inputnumber < 1 ||
                                inputnumber > 10000) {
                              return 'Please enter a number between 1 and 10000';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: showPrediction,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 108, 0, 133),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Predict'),
                      ),
                      const SizedBox(height: 20),
                      if (prediction != null)
                        Text(
                          prediction!,
                          style: TextStyle(
                            fontSize: 18,
                            color: prediction!.startsWith('An error')
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
