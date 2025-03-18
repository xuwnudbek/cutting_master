import 'dart:async';
import 'dart:developer';

import 'package:cutting_master/ui/widgets/custom_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

class PrinterProvider extends ChangeNotifier {
  bool _isLoading = false;

  late StreamSubscription<List<ScanResult>> subscription;

  List<ScanResult> _printers = [];
  List<ScanResult> get printers => _printers;
  set printers(List<ScanResult> value) {
    _printers = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void initialize() async {
    isLoading = true;

    subscription = FlutterBluePlus.scanResults.listen((results) {
      printers = results;
      notifyListeners();
    }, onDone: () {
      isLoading = false;
    });

    // FlutterBluePlus.events.onCharacteristicWritten.listen((event) {
    //   log("Characteristic written: ${event.characteristic.lastValue}");
    // });

    await requestBluetoothPermissions();
    await getPrinters();

    // isLoading = false;
  }

  Future<void> sendMessageToPrinter(
    BuildContext context, {
    required String content,
    required String message,
  }) async {
    final ScanResult? scanResult = printers.firstWhereOrNull((element) => element.device.isConnected);

    if (scanResult == null) {
      CustomSnackbars(context).error("Printer topilmadi!");
      return;
    }

    final BluetoothCharacteristic? characteristic = await findWriteCharacteristic(scanResult.device);

    if (characteristic == null) {
      CustomSnackbars(context).error("Yozish uchun xarakteristika topilmadi!");
      return;
    }

    final profile = await CapabilityProfile.load();
    final generator = Generator(
      PaperSize.mm58,
      profile,
    );
    List<int> bytes = [
      ...generator.feed(1),
      ...generator.qrcode(
        content,
        align: PosAlign.center,
        size: QRSize(10),
      ),
      ...generator.feed(1),
      ...generator.text(
        message,
        containsChinese: true,
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
        ),
      ),
      ...generator.cut(),
    ];

    // return bytes;
    await characteristic.write(
      bytes,
      withoutResponse: true,
    );

    // log("Characteristic UUID: ${characteristic.uuid}");

    // final List<int> bytes = "esc".codeUnits;
    // final Uint8List data = Uint8List.fromList(bytes);

    // await characteristic.write(data, withoutResponse: true);

    // final qrList = generator.qrcode(message);

    // await characteristic.write(qrList);
  }

  Future<BluetoothCharacteristic?> findWriteCharacteristic(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();

    return services[2].characteristics.firstWhereOrNull((element) => element.properties.write);
  }

  Future<void> getPrinters() async {
    await FlutterBluePlus.turnOn();
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 1));

    FlutterBluePlus.cancelWhenScanComplete(subscription);

    subscription.onData((results) {
      printers = results.where((el) => el.device.platformName.isNotEmpty).toList();
      notifyListeners();
    });

    await FlutterBluePlus.isScanning.where((val) => val == false).first;
  }

  Future<void> connectPrinter(ScanResult printer) async {
    try {
      await printer.device.connect();
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> requestBluetoothPermissions() async {
    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }
    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }
    if (await Permission.locationWhenInUse.isDenied) {
      await Permission.locationWhenInUse.request();
    }
  }
}
