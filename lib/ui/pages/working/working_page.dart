import 'package:cutting_master/providers/working/working_provider.dart';
import 'package:cutting_master/ui/widgets/custom_divider.dart';
import 'package:cutting_master/ui/widgets/custom_dropdown.dart';
import 'package:cutting_master/ui/widgets/custom_input.dart';
import 'package:cutting_master/utils/theme/app_colors.dart';

import 'package:provider/provider.dart';

class WorkingPage extends StatelessWidget {
  const WorkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider<WorkingProvider>(
      create: (context) => WorkingProvider()..initialize(),
      builder: (context, snapshot) {
        return Consumer<WorkingProvider>(
          builder: (context, provider, _) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Working'),
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
                                      TextSpan(
                                        text: 'Model: ',
                                      ),
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
                              hint: "Specification Categories",
                              value: provider.selectedSpecificationCategory['id'],
                              items: provider.specificationCategories.map((specCategory) {
                                return DropdownMenuItem(
                                  value: specCategory['id'],
                                  child: Text(
                                    specCategory['name'] ?? "Noma'lum",
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
                              controller: provider.specQuantityController,
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
                                await provider.markAsCut(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Submit'),
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
                                    cut['submodel']['name'] ?? "Noma'lum",
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
                                              cut['category']['name'] ?? "Noma'lum",
                                              style: textTheme.titleMedium,
                                            ),
                                            subtitle: Text(
                                              "${cut['quantity']} ta",
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
              resizeToAvoidBottomInset: false,
              // bottomNavigationBar: Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child:
              //   ),
              // ),
            );
          },
        );
      },
    );
  }
}
