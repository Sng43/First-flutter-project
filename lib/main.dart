import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converter',
      home: TemperatureConverterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  _TemperatureConverterScreenState createState() =>
      _TemperatureConverterScreenState();
}

enum ConversionType { fToC, cToF }

class _TemperatureConverterScreenState
    extends State<TemperatureConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  double? _convertedValue;
  ConversionType _selectedConversion = ConversionType.fToC;
  final List<String> _conversionHistory = [];

  void _convertTemperature() {
    final input = double.tryParse(_inputController.text);
    if (input == null) return;

    double result;
    String historyEntry;

    if (_selectedConversion == ConversionType.fToC) {
      result = (input - 32) * 5 / 9;
      historyEntry =
          "F to C: ${input.toStringAsFixed(1)} => ${result.toStringAsFixed(2)}";
    } else {
      result = input * 9 / 5 + 32;
      historyEntry =
          "C to F: ${input.toStringAsFixed(1)} => ${result.toStringAsFixed(2)}";
    }

    setState(() {
      _convertedValue = result;
      _conversionHistory.insert(0, historyEntry); // Most recent on top
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text('Converter', style: TextStyle(color: Colors.white),),
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

  Widget _buildPortraitLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildCommonWidgets(),
    );
  }

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

  List<Widget> _buildCommonWidgets() {
    return [
      Text(
        "Conversion:",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Row(
        children: [
          Expanded(
            child: RadioListTile<ConversionType>(
              title: Text("Fahrenheit to Celsius", style: TextStyle(fontSize: 12),),
              value: ConversionType.fToC,
              groupValue: _selectedConversion,
              onChanged: (value) {
                setState(() {
                  _selectedConversion = value!;
                });
              },
            ),
          ),
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
      Row(
        children: [
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
          Text(
            "=",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(width: 5),
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
      ElevatedButton(
        onPressed: _convertTemperature,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.blueAccent)),
        child: Text("CONVERT", style: TextStyle(color: Colors.white,)),
      ),
      SizedBox(height: 5),
      Text(
        "History (most recent at the top):",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
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