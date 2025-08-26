# How-to-Display-Sum-and-Average-of-Grouped-Column-with-Custom-Caption-Summary-in-SfDataGrid

In this article, we will show you how to display the sum and average of a grouped column with a custom caption summary in [Flutter DataTable](https://www.syncfusion.com/flutter-widgets/flutter-datagrid).

Initialize the [SfDataGrid](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid-class.html) widget with the necessary properties. The [DataGridSource.performGrouping](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridSource/performGrouping.html) method is triggered when grouping is applied to the SfDataGrid. Within this method, [custom logic](https://help.syncfusion.com/flutter/datagrid/grouping#custom-grouping) can be implemented to return a String based on specific grouping criteria.

To support group caption summaries, two helper properties—groupColumn and occurrence—are used. These track the total salary and the number of employees in each group. As rows are grouped, the salary is added to the group's total in groupColumn, and the count is incremented in occurrence.

These aggregated values are then used to calculate and display the sum and average salary for each group. This is done by customizing the text in the [buildGroupCaptionCellWidget](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridSource/buildGroupCaptionCellWidget.html) method.

```dart
  Map<String, int> groupColumn = {};
  Map<String, int> occurance = {};

  @override
  Widget? buildGroupCaptionCellWidget(
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    final matchingKey = groupColumn.keys.firstWhere(
      (key) => summaryValue.contains(key),
      orElse: () => '',
    );

    final total = groupColumn[matchingKey] ?? 0;
    final count = occurance[matchingKey] ?? 1;
    final average = (total / count).ceilToDouble();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: Text('$summaryValue | Total: $total | Average: $average'),
    );
  }

  @override
  String performGrouping(String columnName, DataGridRow row) {
    if (columnName != 'salary') {
      return super.performGrouping(columnName, row);
    }

    final int salary = row
        .getCells()
        .firstWhere((cell) => cell.columnName == columnName)
        .value;

    String label;
    if (salary > 25000 && salary <= 30000) {
      label = '<= 30 K & > 25 K';
    } else if (salary > 20000 && salary <= 25000) {
      label = '<= 25 K & > 20 K';
    } else if (salary > 15000 && salary <= 20000) {
      label = '<= 20 K & > 15 K';
    } else if (salary >= 10000 && salary <= 15000) {
      label = '<= 15 K & > 10 K';
    } else {
      label = '> 30 K';
    }

    groupColumn[label] = (groupColumn[label] ?? 0) + salary;
    occurance[label] = (occurance[label] ?? 0) + 1;

    return label;
  }
```

You can download this example on [GitHub](https://github.com/SyncfusionExamples/How-to-Display-Sum-and-Average-of-Grouped-Column-with-Custom-Caption-Summary-in-SfDataGrid.git).



