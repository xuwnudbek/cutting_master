import 'package:cutting_master/providers/printer/printer_provider.dart';
import 'package:cutting_master/providers/working/working_provider.dart';
import 'package:cutting_master/ui/pages/printer/printer_page.dart';
import 'package:cutting_master/ui/widgets/custom_divider.dart';
import 'package:cutting_master/ui/widgets/custom_dropdown.dart';
import 'package:cutting_master/ui/widgets/custom_input.dart';
import 'package:cutting_master/utils/theme/app_colors.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

class WorkingPage extends StatelessWidget {
  const WorkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PrinterProvider>(
          create: (context) => PrinterProvider()..initialize(),
        ),
        ChangeNotifierProvider<WorkingProvider>(
          create: (context) => WorkingProvider()..initialize(),
        ),
      ],
      builder: (context, child) {
        return Consumer2<WorkingProvider, PrinterProvider>(
          builder: (context, provider, printerProvider, _) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Working'),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.print_rounded,
                      color: AppColors.light,
                    ),
                    onPressed: () {
                      Get.to(
                        () => ChangeNotifierProvider.value(
                          value: context.read<PrinterProvider>(),
                          child: PrinterPage(),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 16),
                ],
              ),
              body: provider.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: EdgeInsets.all(16),
                      child: RefreshIndicator(
                        edgeOffset: 16,
                        displacement: 16,
                        onRefresh: () async {
                          provider.initialize();
                        },
                        child: ListView(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.light,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                        text: 'Buyurtma: ',
                                      ),
                                      TextSpan(
                                        text: '${provider.orderData['name']}',
                                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                    ]),
                                  ),
                                  Text.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                        text: 'Miqdor: ',
                                      ),
                                      TextSpan(
                                        text: '${provider.orderData['quantity']} ta',
                                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                    ]),
                                  ),
                                  Text.rich(
                                    TextSpan(children: [
                                      TextSpan(text: 'Model: '),
                                      TextSpan(
                                        text: '${provider.orderData['orderModel']['model']['name']}',
                                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            CustomDropdown(
                              color: AppColors.light,
                              hint: "Submodels",
                              value: provider.selectedSubmodel,
                              items: provider.submodels.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(e['name']),
                                );
                              }).toList(),
                              onChanged: (value) {
                                provider.selectedSubmodel = value;
                              },
                            ),
                            SizedBox(height: 8),
                            CustomDropdown(
                              color: AppColors.light,
                              hint: "Spetsifikatsiya kategoriyasi",
                              value: provider.selectedSpecificationCategory['id'],
                              items: provider.specificationCategories.map((specCategory) {
                                return DropdownMenuItem(
                                  value: specCategory['id'],
                                  child: Text(
                                    specCategory['name'] ?? "Unknown",
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                provider.selectedSpecificationCategory = provider.specificationCategories.firstWhere(
                                  (element) => element['id'] == value,
                                  orElse: () => {},
                                );
                              },
                            ),
                            SizedBox(height: 8),
                            CustomInput(
                              color: AppColors.light,
                              hint: "Miqdor",
                              keyboardType: TextInputType.number,
                              controller: provider.specQuantityController,
                              formatters: [
                                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                              ],
                            ),
                            SizedBox(height: 8),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: provider.isLoading ? AppColors.dark.withValues(alpha: 0.2) : AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                if (provider.isLoading) return;
                                var res = await provider.markAsCut(context);

                                if (res != null) {
                                  printerProvider.sendMessageToPrinter(
                                    context,
                                    content: "${res['order']['id']}/${res['category']['id']}/${res['quantity'] ?? 0}",
                                    message: "${res['order']['name']}, ${res['category']['name']}, ${res['quantity']} ta",
                                  );
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  provider.isSaving
                                      ? SizedBox.square(
                                          dimension: 24,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(AppColors.light),
                                            strokeWidth: 1,
                                          ),
                                        )
                                      : Text(
                                          'Saqlash',
                                          style: textTheme.titleMedium?.copyWith(color: AppColors.light),
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            CustomDivider(),
                            SizedBox(height: 8),
                            ...provider.cuts.map((cut) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cut['submodel']?['name'] ?? "Unknown",
                                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 4),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.light,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ...(cut['cuts'] ?? []).map((cut) {
                                          return ListTile(
                                            leading: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.success.withValues(alpha: 0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(6),
                                              child: Icon(
                                                Icons.check,
                                                size: 16,
                                                color: AppColors.success,
                                              ),
                                            ),
                                            title: Text(
                                              cut['category']['name'] ?? "Unknown",
                                              style: textTheme.titleMedium,
                                            ),
                                            subtitle: Text(
                                              "${cut['quantity'] ?? 0} ta",
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
              bottomNavigationBar: BottomAppBar(
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          await provider.finishCuttingOrder(context);
                        },
                        child: Text(
                          "Buyurtmani tugatish",
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.light,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
