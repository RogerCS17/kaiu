import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class KaijuFormHabs extends StatefulWidget {
  @override
  _KaijuFormHabsState createState() => _KaijuFormHabsState();
}

class _KaijuFormHabsState extends State<KaijuFormHabs> {
  
  List<TextEditingController> keyControllers = [TextEditingController()];
  List<TextEditingController> valueControllers = [TextEditingController()];
  String selectedOption = 'Opción 1'; // Valor predeterminado
  List<String> dropdownOptions = ['Opción 1', 'Opción 2', 'Opción 3'];

  @override
  Widget build(BuildContext context) {
    var iterableZipController = IterableZip([keyControllers, valueControllers]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Form'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedOption,
              onChanged: (newValue) {
                setState(() {
                  selectedOption = newValue!;
                });
              },
              items:
                  dropdownOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Mostrar los campos de texto existentes para clave y valor
            Column(
              children: iterableZipController.map((pair) {
                
                var keyController = pair[0];
                var valueController = pair[1];

                return Column(
                  children: [
                    TextField(
                      controller: keyController,
                      decoration: InputDecoration(labelText: 'Clave'),
                    ),
                    TextField(
                      controller: valueController,
                      decoration: InputDecoration(labelText: 'Valor'),
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            // Botón para agregar más campos de texto para clave y valor
            ElevatedButton(
              onPressed: () {
                setState(() {
                  keyControllers.add(TextEditingController());
                  valueControllers.add(TextEditingController());
                });
              },
              child: Icon(Icons.add),
            ),
            SizedBox(height: 10),
            // Botón para imprimir los valores actuales de los campos de texto para clave y valor
            ElevatedButton(
              onPressed: () {
                for (var pair in iterableZipController) {
                  print("Llave: ${pair[0].text}, Valor: ${pair[1].text}");
                }
              },
              child: Text('Imprimir Valores'),
            ),
          ],
        ),
      ),
    );
  }
}
