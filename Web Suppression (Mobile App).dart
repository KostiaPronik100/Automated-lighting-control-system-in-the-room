import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(SpotlightApp());
}

class SpotlightApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Керування прожектором',
      theme: ThemeData.dark(),
      home: SpotlightControl(),
    );
  }
}

class SpotlightControl extends StatefulWidget {
  @override
  _SpotlightControlState createState() => _SpotlightControlState();
}

class _SpotlightControlState extends State<SpotlightControl> {
  double brightness = 0.5;
  Color selectedColor = Colors.white;

  Future<void> sendCommand(String endpoint) async {
    final uri = Uri.parse('http://192.168.0.100:5000/$endpoint');
    await http.get(uri);
  }

  void onColorChanged(Color color) {
    setState(() {
      selectedColor = color;
    });
    final hex = color.value.toRadixString(16).substring(2);
    sendCommand('color/$hex');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Освітлення сцени')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          ElevatedButton(
            onPressed: () => sendCommand('focus'),
            child: Text('Сфокусуватись на об\'єкті'),
          ),
          SizedBox(height: 20),
          Text('Яскравість'),
          Slider(
            value: brightness,
            onChanged: (val) {
              setState(() => brightness = val);
              sendCommand('brightness/${(val * 100).toInt()}');
            },
          ),
          SizedBox(height: 20),
          Text('Колір'),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              Color? color = await showDialog(
                context: context,
                builder: (_) => ColorPickerDialog(selectedColor: selectedColor),
              );
              if (color != null) onColorChanged(color);
            },
            child: Container(
              height: 50,
              width: 100,
              color: selectedColor,
              alignment: Alignment.center,
              child: Text('Вибрати', style: TextStyle(color: Colors.black)),
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => sendCommand('stop'),
            child: Text('Стоп'),
          ),
        ]),
      ),
    );
  }
}

class ColorPickerDialog extends StatelessWidget {
  final Color selectedColor;
  const ColorPickerDialog({required this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Оберіть колір'),
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: selectedColor,
          onColorChanged: (color) => Navigator.of(context).pop(color),
        ),
      ),
    );
  }
}
