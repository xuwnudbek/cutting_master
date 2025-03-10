import 'package:cutting_master/providers/printer/printer_provider.dart';
import 'package:cutting_master/utils/theme/app_colors.dart';
import 'package:provider/provider.dart';

class PrinterPage extends StatelessWidget {
  const PrinterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

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
                  if (provider.isLoading)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        backgroundColor: AppColors.light,
                      ),
                    ),
                  if (provider.printers.isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 120,
                      child: Center(
                        child: provider.isLoading ? CircularProgressIndicator() : Text('Printer topilmadi!'),
                      ),
                    ),
                  ...provider.printers.map((printer) {
                    bool isConnected = printer.device.isConnected;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        selected: isConnected,
                        selectedTileColor: AppColors.primary.withValues(alpha: 0.15),
                        tileColor: AppColors.light,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        dense: true,
                        title: Text(
                          printer.device.platformName,
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        subtitle: Text(
                          printer.device.remoteId.toString(),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.bluetooth_connected_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: printer.device.isConnected ? AppColors.primary : null,
                            foregroundColor: printer.device.isConnected ? Colors.white : null,
                          ),
                          onPressed: () {
                            provider.connectPrinter(printer);
                          },
                        ),
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
