import 'package:cutting_master/providers/printing/printing_provider.dart';
import 'package:cutting_master/utils/extension/datetime_extension.dart';
import 'package:cutting_master/utils/theme/app_colors.dart';

import 'package:provider/provider.dart';

class PrintingPage extends StatelessWidget {
  const PrintingPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<PrintingProvider>(builder: (context, provider, _) {
      if (provider.isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (provider.orders.isEmpty) {
        return Center(
          child: Text(
            'Buyurtmalar topilmadi',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
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
          child: ListView.builder(
            itemCount: provider.orders.length,
            itemBuilder: (context, index) {
              final order = provider.orders[index];
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
                          text: "Buyurtma: ",
                        ),
                        TextSpan(
                          text: "${order['name']}",
                          style: textTheme.titleMedium,
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
                                        TextSpan(
                                          text: " ─ ",
                                        ),
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
                    SizedBox(height: 8),
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
                            padding: EdgeInsets.zero,
                            child: Text(
                              order['comment'],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
