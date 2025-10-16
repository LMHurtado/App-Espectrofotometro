// lib/pininos/bluetooth_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothService {
  // ignore: deprecated_member_use
  final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;

  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? dataCharacteristic;
  final StreamController<String> _dataController =
      StreamController<String>.broadcast();

  Stream<String> get dataStream => _dataController.stream;

  /// Escanea dispositivos durante [timeout] y devuelve la lista de BluetoothDevice encontrados.
  Future<List<BluetoothDevice>> scanForDevices({
    Duration timeout = const Duration(seconds: 4),
  }) async {
    final List<BluetoothDevice> devices = [];

    // Inicia el escaneo
    await FlutterBluePlus.startScan(timeout: timeout);

    // Escucha resultados de escaneo (stream de lista de ScanResult)
    final StreamSubscription<List<ScanResult>> sub = _flutterBlue.scanResults
        .listen((results) {
          for (var result in results) {
            // Evitar duplicados comparando el id
            if (!devices.any((d) => d.id == result.device.id)) {
              devices.add(result.device);
            }
          }
        });

    // Espera el tiempo de timeout
    await Future.delayed(timeout);

    // Para el escaneo y cancela la suscripción
    await _flutterBlue.stopScan();
    await sub.cancel();

    return devices;
  }

  /// Conecta a [device], descubre servicios y activa notificación en la primera característica "notify" que encuentre.
  Future<void> connectToDevice(BluetoothDevice device) async {
    // Si ya está conectado a otro, desconectar primero
    if (connectedDevice != null) {
      await disconnect();
    }

    // Conectar
    await device.connect(
      timeout: const Duration(seconds: 10),
      autoConnect: false,
    );
    connectedDevice = device;

    // Descubrir servicios y características
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          dataCharacteristic = characteristic;
          await characteristic.setNotifyValue(true);
          characteristic.value.listen((value) {
            try {
              final s = utf8.decode(value);
              _dataController.add(s);
            } catch (e) {
              // Si hay bytes no UTF8, ignora o maneja aquí
            }
          });
          // Si quieres escuchar solo la primera característica notify encontrada, salimos
          return;
        }
      }
    }
  }

  Future<void> disconnect() async {
    try {
      await dataCharacteristic?.setNotifyValue(false);
    } catch (e) {}
    try {
      await connectedDevice?.disconnect();
    } catch (e) {}
    connectedDevice = null;
    dataCharacteristic = null;
  }

  void dispose() {
    _dataController.close();
  }
}
