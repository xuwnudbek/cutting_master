import 'package:cutting_master/providers/printer/printer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrinterPage extends StatelessWidget {
  const PrinterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrinterProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Printerlar'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: RefreshIndicator(
              onRefresh: () async {
                provider.initialize();
              },
              child: ListView(
                children: [
                  if (provider.printers.isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 120,
                      child: Center(
                        child: provider.isLoading ? CircularProgressIndicator() : Text('Printer topilmadi!'),
                      ),
                    ),
                  ...provider.printers.map((printer) {
                    return ListTile(
                      title: Text(printer.device.platformName),
                      subtitle: Text(
                        printer.device.remoteId.toString(),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.bluetooth_connected_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: printer.device.isConnected ? Colors.blue : null,
                          foregroundColor: printer.device.isConnected ? Colors.white : null,
                        ),
                        onPressed: () {
                          provider.connectPrinter(printer);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
