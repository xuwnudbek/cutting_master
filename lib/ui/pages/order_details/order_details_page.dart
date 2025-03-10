import 'package:cutting_master/providers/order_details/order_details_provider.dart';
import 'package:cutting_master/services/storage_service.dart';
import 'package:cutting_master/ui/widgets/custom_snackbars.dart';
import 'package:cutting_master/utils/extension/datetime_extension.dart';
import 'package:cutting_master/utils/theme/app_colors.dart';
import 'package:provider/provider.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fromCutting = StorageService.read("from");
    final textTheme = TextTheme.of(context);

    return ChangeNotifierProvider<OrderDetailsProvider>(
      create: (context) => OrderDetailsProvider()..initialize(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Buyurtma ma`lumotlari'),
          ),
          body: Consumer<OrderDetailsProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: RefreshIndicator(
                  edgeOffset: 16,
                  displacement: 16,
                  onRefresh: () async {
                    provider.initialize();
                  },
                  child: ListView(
                    children: [
                      if (provider.order.isEmpty)
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 150,
                          child: const Center(
                            child: Text('Malumot topilmadi!'),
                          ),
                        ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.light,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(text: 'Buyurtma: '),
                                TextSpan(
                                  text: '${provider.order['name']}',
                                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ]),
                            ),
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(text: 'Miqdor: '),
                                TextSpan(
                                  text: '${provider.order['quantity']} ta',
                                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ]),
                            ),
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(text: 'Status: '),
                                TextSpan(
                                  text: '${provider.order['status']}',
                                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ]),
                            ),
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(text: 'Model: '),
                                TextSpan(
                                  text: '${provider.order['orderModel']?['model']?['name'] ?? "N/A"}',
                                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ]),
                            ),
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(text: 'Muddat: '),
                                TextSpan(
                                  text: "${DateTime.tryParse(provider.order['start_date'] ?? "")?.toYMD ?? "N/A"} - ${DateTime.tryParse(provider.order['end_date'] ?? "")?.toYMD ?? "N/A"}",
                                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ]),
                            ),
                            if (provider.order['comment'] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 4,
                                children: [
                                  Text('Izoh: '),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Text(
                                      "${provider.order['comment']}",
                                      style: textTheme.titleMedium,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            'Buyurtma ma`lumotlari',
                            style: textTheme.titleMedium,
                          ),
                          SizedBox(height: 4),
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
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Model: ",
                                        style: textTheme.bodyMedium,
                                      ),
                                      TextSpan(
                                        text: "${provider.order['orderModel']['model']['name']}",
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
                                      "Mahsulotlar: ",
                                      style: textTheme.bodyMedium,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColors.light, width: 1),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      child: Wrap(
                                        runSpacing: 8,
                                        spacing: 8,
                                        children: [
                                          ...(provider.order['orderModel']?['submodels'] ?? []).map((submodel) {
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
                                      style: textTheme.bodyMedium,
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
                                          ...(provider.order['orderModel']?['sizes'] ?? []).map((size) {
                                            return Chip(
                                              label: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "${size['size']?['name'] ?? "N/A"}",
                                                    ),
                                                    TextSpan(text: " ─ "),
                                                    TextSpan(
                                                      text: "${size['quantity'] ?? 0} ta",
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      if ((provider.order['instructions'] ?? []).isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              'Instruksiyalar',
                              style: textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.light,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(4),
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  ...(provider.order['instructions'] ?? []).map((instruction) {
                                    int index = (provider.order['instructions'] ?? []).indexOf(instruction);
                                    return ListTile(
                                      leading: Text(
                                        "${index + 1}.",
                                        style: textTheme.titleMedium,
                                      ),
                                      tileColor: AppColors.secondary,
                                      title: Text(
                                        "${instruction['title'] ?? "N/A"}",
                                        style: textTheme.titleMedium,
                                      ),
                                      subtitle: Text(
                                        "${instruction['description'] ?? "N/A"}",
                                        style: textTheme.bodyMedium,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (provider.orderPrintingTime.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              'Konstruktor',
                              style: textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.light,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8,
                                children: [
                                  Text.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                        text: 'Masul: ',
                                      ),
                                      TextSpan(
                                        text: '${provider.orderPrintingTime['user']?['employee']?['name'] ?? "N/A"}',
                                        style: textTheme.titleMedium,
                                      ),
                                    ]),
                                  ),
                                  Text.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                        text: 'Reja: ',
                                      ),
                                      TextSpan(
                                        text: DateTime.tryParse(provider.order['orderPrintingTime']['planned_time'])?.toYMD ?? "N/A",
                                        style: textTheme.titleMedium,
                                      ),
                                    ]),
                                  ),
                                  Text.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                        text: 'Real: ',
                                      ),
                                      TextSpan(
                                        text: '${DateTime.tryParse(provider.orderPrintingTime['actual_time'] ?? "") ?? "Bajarilmagan"}',
                                        style: textTheme.titleMedium,
                                      ),
                                    ]),
                                  ),
                                  Text.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                        text: 'Status: ',
                                      ),
                                      TextSpan(
                                        text: provider.orderPrintingTime['status'] == "printing"
                                            ? "Konstruktorda"
                                            : provider.orderPrintingTime['status'] == "cutting"
                                                ? "Kesuvda"
                                                : "Bajarilgan",
                                        style: textTheme.titleMedium,
                                      ),
                                    ]),
                                  ),
                                  if (provider.orderPrintingTime['comment'] != null)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 4,
                                      children: [
                                        Text('Izoh: '),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          child: Text(
                                            "${provider.orderPrintingTime['comment'] ?? "N/A"}",
                                            style: textTheme.titleMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if ((provider.order['orderRecipes'] ?? []).isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              'Xom ashyolar',
                              style: textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.light,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // padding: EdgeInsets.all(4),
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  Table(
                                    border: TableBorder.all(
                                      color: AppColors.secondary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    columnWidths: {
                                      0: const IntrinsicColumnWidth(),
                                      1: const FlexColumnWidth(),
                                      2: const IntrinsicColumnWidth(),
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                                              child: Center(
                                                child: Text(
                                                  '#',
                                                  style: textTheme.titleMedium,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Nomi',
                                                style: textTheme.titleMedium,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Miqdori',
                                                style: textTheme.titleMedium,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ...(provider.order['orderRecipes'] ?? []).map((orderRecipe) {
                                        int index = (provider.order['orderRecipes'] ?? []).indexOf(orderRecipe);

                                        return TableRow(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  "${index + 1}",
                                                  style: textTheme.bodyMedium,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "${orderRecipe['item']['name']} — ${orderRecipe['item']['code']}",
                                                style: textTheme.bodyMedium,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "${orderRecipe['quantity']}  -  ${orderRecipe['item']?['unit']?['name'] ?? "N/A"}",
                                                style: textTheme.bodyMedium,
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (provider.orderOutcomes.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              'Chiqimlar',
                              style: textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Column(
                              spacing: 8,
                              children: [
                                ...provider.orderOutcomes.map((outcome) {
                                  String status = outcome['status'];

                                  return ExpansionTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor: AppColors.light,
                                    collapsedBackgroundColor: AppColors.light,
                                    title: Row(
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "№",
                                                style: TextTheme.of(context).titleMedium,
                                              ),
                                              TextSpan(
                                                text: " - ",
                                                style: TextTheme.of(context).bodyMedium,
                                              ),
                                              TextSpan(
                                                text: "${outcome['number']}",
                                                style: TextTheme.of(context).bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: status == "sent"
                                                ? AppColors.dark.withValues(alpha: 0.2)
                                                : status == "accepted"
                                                    ? AppColors.success.withValues(alpha: 0.2)
                                                    : status == "cancelled"
                                                        ? AppColors.danger.withValues(alpha: 0.2)
                                                        : AppColors.dark.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: Text(
                                            status == "sent"
                                                ? "Yuborilgan"
                                                : status == "accepted"
                                                    ? "Qabul qilingan"
                                                    : status == "cancelled"
                                                        ? "Rad etilgan"
                                                        : "Tayyorlanmoqda",
                                            style: textTheme.titleSmall?.copyWith(
                                              fontSize: 9,
                                              color: status == "sent"
                                                  ? AppColors.dark
                                                  : status == "accepted"
                                                      ? AppColors.success
                                                      : status == "cancelled"
                                                          ? AppColors.danger
                                                          : AppColors.dark.withValues(alpha: 0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    childrenPadding: EdgeInsets.all(4),
                                    expandedAlignment: Alignment.centerLeft,
                                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Table(
                                          border: TableBorder.all(
                                            color: AppColors.secondary,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          columnWidths: {
                                            0: const IntrinsicColumnWidth(),
                                            1: const FixedColumnWidth(300),
                                            2: const IntrinsicColumnWidth(),
                                          },
                                          children: [
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                                                    child: Center(
                                                      child: Text(
                                                        '#',
                                                        style: textTheme.titleMedium,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'Nomi',
                                                      style: textTheme.titleMedium,
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                      child: Text(
                                                        'Miqdori',
                                                        style: textTheme.titleMedium,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ...(outcome['items'] ?? []).map((item) {
                                              int index = (outcome['items'] ?? []).indexOf(item);
                                              return TableRow(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "${index + 1}",
                                                        style: textTheme.bodyMedium,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: "${item['name'] ?? "N/A"}",
                                                          ),
                                                          TextSpan(
                                                            text: " — ",
                                                          ),
                                                          TextSpan(
                                                            text: "${item['code'] ?? "N/A"}",
                                                            style: textTheme.bodyMedium?.copyWith(color: AppColors.dark.withValues(alpha: 0.5)),
                                                          ),
                                                        ],
                                                      ),
                                                      style: textTheme.bodyMedium,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: "${item['quantity'] ?? "N/A"}",
                                                          ),
                                                          TextSpan(
                                                            text: " — ",
                                                          ),
                                                          TextSpan(
                                                            text: "${item['unit']?['name'] ?? "N/A"}",
                                                          ),
                                                        ],
                                                      ),
                                                      style: textTheme.bodyMedium,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      if (status == "sent")
                                        Row(
                                          spacing: 8,
                                          children: [
                                            Expanded(
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: provider.isLoading ? AppColors.dark.withValues(alpha: 0.2) : AppColors.success,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  if (provider.isLoading) return;
                                                  bool isAccepted = await provider.acceptOrCancelCompletedItem(outcome['id'], "accepted", context);

                                                  if (isAccepted) {
                                                    CustomSnackbars(context).success("Item accepted successfully");
                                                  } else {
                                                    // CustomSnackbars(context).error("Failed to accept item");
                                                  }
                                                },
                                                child: Text("Qabul qilish"),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: provider.isLoading ? AppColors.dark.withValues(alpha: 0.2) : AppColors.danger,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  if (provider.isLoading) return;
                                                  bool isCanceled = await provider.acceptOrCancelCompletedItem(outcome['id'], "cancelled", context);

                                                  if (isCanceled) {
                                                    CustomSnackbars(context).success("Item canceled successfully");
                                                  } else {
                                                    // CustomSnackbars(context).error("Failed to cancel item");
                                                  }
                                                },
                                                child: Text("Rad etish"),
                                              ),
                                            ),
                                          ],
                                        )
                                      else if (status == "accepted")
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: AppColors.success.withValues(alpha: 0.2),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () async {},
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Qabul qilingan",
                                                style: textTheme.titleMedium?.copyWith(color: AppColors.success),
                                              ),
                                            ],
                                          ),
                                        )
                                      else if (status == "cancelled")
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: AppColors.danger.withValues(alpha: 0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () async {},
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Bekor qilingan",
                                                style: textTheme.titleMedium?.copyWith(color: AppColors.danger),
                                              ),
                                            ],
                                          ),
                                        )
                                      else if (status == "draft")
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: AppColors.dark.withValues(alpha: 0.2),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () async {},
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Tayyorlanmoqda",
                                                style: textTheme.titleMedium?.copyWith(color: AppColors.dark.withValues(alpha: 0.5)),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
