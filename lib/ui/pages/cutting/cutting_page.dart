import 'package:cutting_master/providers/cutting/cutting_provider.dart';
import 'package:cutting_master/services/storage_service.dart';
import 'package:cutting_master/ui/pages/order_details/order_details_page.dart';
import 'package:cutting_master/ui/pages/working/working_page.dart';
import 'package:cutting_master/utils/extension/datetime_extension.dart';
import 'package:cutting_master/utils/theme/app_colors.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

class CuttingPage extends StatelessWidget {
  const CuttingPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<CuttingProvider>(builder: (context, provider, _) {
      if (provider.isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return Padding(
        padding: EdgeInsets.all(16),
        child: RefreshIndicator(
          edgeOffset: 16,
          displacement: 16,
          onRefresh: () async {
            await provider.getOrders();
          },
          child: ListView(
            children: [
              if (provider.orders.isEmpty)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: Text(
                      'Buyurtmalar topilmadi',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ...provider.orders.map(
                (order) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: AppColors.light,
                      collapsedBackgroundColor: AppColors.light,
                      title: Text.rich(
                        TextSpan(
                          children: [
                            // TextSpan(
                            //   text: "Buyurtma: ",
                            // ),
                            TextSpan(
                              text: "${order['name']}",
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      childrenPadding: EdgeInsets.all(16),
                      expandedAlignment: Alignment.centerLeft,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Model: ",
                                style: textTheme.titleMedium,
                              ),
                              TextSpan(
                                text: "${order['order_model']['model']['name']}",
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Submodellar: ",
                              style: textTheme.titleMedium,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.light, width: 1),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Wrap(
                                runSpacing: 8,
                                spacing: 8,
                                children: [
                                  ...(order['order_model']?['submodels'] ?? []).map((submodel) {
                                    return Chip(
                                      label: Text(submodel['submodel']['name']),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "O'lchamlar: ",
                              style: textTheme.titleMedium,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.light, width: 1),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Wrap(
                                runSpacing: 2,
                                spacing: 8,
                                children: [
                                  ...(order['order_model']?['sizes'] ?? []).map((size) {
                                    return Chip(
                                      label: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "${size['size']['name']}",
                                              style: textTheme.titleMedium,
                                            ),
                                            TextSpan(text: " ─ "),
                                            TextSpan(
                                              text: "${size['quantity']} ta",
                                              style: textTheme.titleMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if ((order['instructions'] ?? []).isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                "Instruksiyalar: ",
                                style: textTheme.titleMedium,
                              ),
                              SizedBox(height: 4),
                              Table(
                                border: TableBorder.all(
                                  color: AppColors.dark.withAlpha(51),
                                  width: 1,
                                ),
                                children: [
                                  ...(order['instructions'] ?? []).map((instruction) {
                                    return TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${instruction['title']}",
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${instruction['description']}",
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                            ],
                          ),
                        if ((order['comment'] ?? '').isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                "Izoh: ",
                                style: textTheme.titleMedium,
                              ),
                              SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.light, width: 1),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Text(
                                  "${order['comment']}",
                                ),
                              ),
                            ],
                          ),
                        if (order['order_printing_time']?['planned_time'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16),
                              Text(
                                "Reja vaqti: ",
                                style: textTheme.titleMedium,
                              ),
                              SizedBox(height: 4),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.light, width: 1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (DateTime.parse(order['order_printing_time']['planned_time'])).toLocal().toYMDHM,
                                      style: textTheme.titleMedium,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        if (order['order_printing_time']?['comment'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                "Izoh: ",
                                style: textTheme.titleMedium,
                              ),
                              SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.light, width: 1),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Text(
                                  order['order_printing_time']?['comment'] ?? '',
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 16),
                        Row(
                          spacing: 8,
                          children: [
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  StorageService.write("order_id", order['id']);
                                  var res = await Get.to(() => WorkingPage());

                                  if (res == true) {
                                    provider.initialize();
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Boshlash"),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: provider.isLoading ? AppColors.warning.withValues(alpha: 0.2) : AppColors.warning,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  if (provider.isLoading) return;
                                  StorageService.write("order_id", order['id']);
                                  await Get.to(() => OrderDetailsPage());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 8,
                                  children: [
                                    Text("Batafsil"),
                                    Icon(
                                      Icons.arrow_outward_rounded,
                                      color: AppColors.light,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
