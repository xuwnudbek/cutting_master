import 'package:cutting_master/utils/extension/datetime_extension.dart';
import 'package:flutter/material.dart';

class OrderPrintingCard extends StatelessWidget {
  final Map<String, dynamic> orderPrintingTimeData;
  final Function onPressed;

  const OrderPrintingCard({
    super.key,
    required this.orderPrintingTimeData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    DateTime plannedTime = DateTime.parse(orderPrintingTimeData['planned_time']);
    DateTime? actualTime = DateTime.tryParse(orderPrintingTimeData['actual_time'] ?? "");

    Map model = orderPrintingTimeData['model'] ?? {};

    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadowColor: Colors.grey.withValues(alpha: 0.2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                model['name'] ?? 'No Name',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Reja: ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: plannedTime.toLocal().toHM,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Bajarildi: ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: actualTime != null ? actualTime.toLocal().toHM : 'N/A',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: actualTime == null ? Colors.red.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    actualTime == null ? 'Bajarilmagan' : 'Bajarildi',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: actualTime == null ? Colors.red : Colors.green,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
