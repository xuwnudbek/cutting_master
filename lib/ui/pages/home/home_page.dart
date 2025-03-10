import 'dart:developer';

import 'package:cutting_master/providers/home/home_provider.dart';
import 'package:cutting_master/services/storage_service.dart';
import 'package:cutting_master/ui/pages/order_details/order_details_page.dart';
import 'package:cutting_master/utils/extension/datetime_extension.dart';
import 'package:cutting_master/utils/theme/app_colors.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
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
              provider.isLoading = true;
              await provider.getOrders();
              provider.isLoading = false;
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
                ...provider.orders.map((order) {
                  Map orderDetails = provider.ordersDetails.firstWhere(
                    (element) => element['order']['id'] == order['id'],
                    orElse: () => {},
                  );

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
                            TextSpan(
                              text: "${order['name']}",
                              style: TextTheme.of(context).titleMedium?.copyWith(
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
                                style: TextTheme.of(context).titleMedium?.copyWith(
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
                                  }),
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
                                              style: TextTheme.of(context).titleMedium,
                                            ),
                                            TextSpan(
                                              text: " ─ ",
                                            ),
                                            TextSpan(
                                              text: "${size['quantity']} ta",
                                              style: TextTheme.of(context).titleMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
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
                                  color: AppColors.dark.withValues(alpha: 0.2),
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
                                  }),
                                ],
                              ),
                            ],
                          ),
                        if ((order['comment'] ?? []).isNotEmpty)
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 24),
                            Divider(
                              color: AppColors.dark.withValues(alpha: 0.2),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Reja vaqti: ",
                              style: textTheme.titleMedium,
                            ),
                            GestureDetector(
                              onTap: () async {
                                try {
                                  await DatePicker.showDateTimePicker(
                                    context,
                                    locale: LocaleType.ru,
                                    currentTime: DateTime.now().add(Duration(minutes: 5)),
                                    onConfirm: (time) {
                                      orderDetails['planned_time'] = time;
                                      provider.refreshUI();
                                    },
                                  );
                                } catch (e) {
                                  log(e.toString());
                                }
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.light, width: 1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (orderDetails['planned_time'] != null)
                                      Text(
                                        (orderDetails['planned_time'] as DateTime).toLocal().toYMDHM,
                                        style: textTheme.titleMedium,
                                      )
                                    else
                                      Text(
                                        "Reja vaqtini tanlang",
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Izoh: ",
                              style: textTheme.titleMedium,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.light, width: 1),
                              ),
                              padding: EdgeInsets.zero,
                              child: TextFormField(
                                controller: orderDetails['comment'],
                                maxLines: 3,
                                decoration: InputDecoration(
                                  fillColor: AppColors.background,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: "Konstruktor uchun izoh yozing",
                                  hintStyle: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.dark.withValues(alpha: 0.2),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          spacing: 16,
                          children: [
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: provider.isLoading ? AppColors.dark.withValues(alpha: 0.2) : AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  if (provider.isLoading) return;
                                  await provider.sendToConstructor(context, orderDetails);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 8,
                                  children: [
                                    Text(
                                      "Konstruktorga\njo'natish",
                                      style: textTheme.bodySmall?.copyWith(
                                        color: AppColors.light,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_outward_rounded,
                                      color: AppColors.light,
                                    ),
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
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
