import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converter',
      // The main screen of the app is the temperature converter
      home: TemperatureConverterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Main screen that allows users to input a temperature value, choose a conversion type, and view results.
class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  _TemperatureConverterScreenState createState() =>
      _TemperatureConverterScreenState();
}

/// Enum to define the type of conversion available.
enum ConversionType { fToC, cToF }

/// State class for handling the UI and logic of the temperature converter.
class _TemperatureConverterScreenState
    extends State<TemperatureConverterScreen> {
  // Controller to read user input from the TextField
  final TextEditingController _inputController = TextEditingController();

  // Stores the result of the conversion
  double? _convertedValue;

  // Stores the selected conversion type; default is Fahrenheit to Celsius
  ConversionType _selectedConversion = ConversionType.fToC;

  // Keeps a history of past conversions for display
  final List<String> _conversionHistory = [];

  /// Function to perform temperature conversion based on selected conversion type
  void _convertTemperature() {
    final input = double.tryParse(_inputController.text);
    if (input == null) return; // If the input is invalid (non-numeric), return

    double result;
    String historyEntry;

    // Apply selected conversion formula
    if (_selectedConversion == ConversionType.fToC) {
      result = (input - 32) * 5 / 9;
      historyEntry =
          "F to C: ${input.toStringAsFixed(1)} => ${result.toStringAsFixed(2)}";
    } else {
      result = input * 9 / 5 + 32;
      historyEntry =
          "C to F: ${input.toStringAsFixed(1)} => ${result.toStringAsFixed(2)}";
    }

    // Update the state with result and history
    setState(() {
      _convertedValue = result;
      _conversionHistory.insert(0, historyEntry); // Add to top of history
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check device orientation to decide layout
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text('Converter', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: isPortrait ? _buildPortraitLayout() : _buildLandscapeLayout(),
        ),
      ),
    );
  }

  /// Builds the layout for portrait orientation.
  Widget _buildPortraitLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildCommonWidgets(),
    );
  }

  /// Builds the layout for landscape orientation.
  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildCommonWidgets(),
          ),
        ),
      ],
    );
  }

  /// Builds the common UI elements used in both portrait and landscape layouts.
  List<Widget> _buildCommonWidgets() {
    return [
      Text(
        "Conversion:",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Row(
        children: [
          // Radio button for Fahrenheit to Celsius
          Expanded(
            child: RadioListTile<ConversionType>(
              title: Text("Fahrenheit to Celsius", style: TextStyle(fontSize: 12)),
              value: ConversionType.fToC,
              groupValue: _selectedConversion,
              onChanged: (value) {
                setState(() {
                  _selectedConversion = value!;
                });
              },
            ),
          ),
          // Radio button for Celsius to Fahrenheit
          Expanded(
            child: RadioListTile<ConversionType>(
              title: Text("Celsius to Fahrenheit", style: TextStyle(fontSize: 12)),
              value: ConversionType.cToF,
              groupValue: _selectedConversion,
              onChanged: (value) {
                setState(() {
                  _selectedConversion = value!;
                });
              },
            ),
          ),
        ],
      ),
      // Temperature input and output display row
      Row(
        children: [
          // Input field for user to enter temperature
          Expanded(
            child: TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter temperature',
              ),
            ),
          ),
          SizedBox(width: 10),
          // Equal sign
          Text(
            "=",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(width: 5),
          // Container showing the converted value
          Container(
            width: 80,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _convertedValue != null
                  ? _convertedValue!.toStringAsFixed(2)
                  : '',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      SizedBox(height: 5),
      // Convert button
      ElevatedButton(
        onPressed: _convertTemperature,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.blueAccent)),
        child: Text("CONVERT", style: TextStyle(color: Colors.white)),
      ),
      SizedBox(height: 5),
      // History label
      Text(
        "History (most recent at the top):",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      // ListView to display history of conversions
      Expanded(
        child: ListView.builder(
          itemCount: _conversionHistory.length,
          itemBuilder: (context, index) {
            return Text(_conversionHistory[index]);
          },
        ),
      ),
    ];
  }
}
