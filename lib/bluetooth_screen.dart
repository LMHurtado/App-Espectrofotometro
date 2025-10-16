// lib/screens/bluetooth_screen.dart
import 'package:flutter/material.dart';
import 'bluetooth_service.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final BluetoothService _btService = BluetoothService();
  List devices = [];
  String receivedData = "";
  bool isConnected = false;

  Future<void> _scanDevices() async {
    final foundDevices = await _btService.scanForDevices();
    setState(() {
      devices = foundDevices;
    });
  }

  Future<void> _connect(device) async {
    await _btService.connectToDevice(device);
    _btService.dataStream.listen((data) {
      setState(() => receivedData = data);
    });
    setState(() => isConnected = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Conexión Bluetooth")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _scanDevices,
              child: const Text("Buscar dispositivos"),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return ListTile(
                    title: Text(device.platformName),
                    subtitle: Text(device.remoteId.toString()),
                    onTap: () => _connect(device),
                  );
                },
              ),
            ),
            const Divider(),
            Text(
              isConnected ? "📡 Conectado al ESP32" : "❌ No conectado",
              style: TextStyle(color: isConnected ? Colors.green : Colors.red),
            ),
            const SizedBox(height: 16),
            Text(
              "Datos recibidos:",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              height: 120,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Text(
                  receivedData,
                  style: const TextStyle(fontFamily: "monospace"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
