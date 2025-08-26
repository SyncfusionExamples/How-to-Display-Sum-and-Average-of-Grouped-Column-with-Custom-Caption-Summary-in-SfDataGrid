import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(MyApp());
}

/// The application that contains datagrid on it.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion DataGrid Demo',
      theme: ThemeData(useMaterial3: false),
      home: MyHomePage(),
    );
  }
}

/// The home page of the application which hosts the datagrid.
class MyHomePage extends StatefulWidget {
  /// Creates the home page.
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Employee> employees = <Employee>[];
  late EmployeeDataSource employeeDataSource;

  @override
  void initState() {
    super.initState();
    employees = getEmployeeData();
    employeeDataSource = EmployeeDataSource(employeeData: employees);
    employeeDataSource.addColumnGroup(
      ColumnGroup(name: 'salary', sortGroupRows: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Syncfusion Flutter DataGrid')),
      body: SfDataGrid(
        source: employeeDataSource,
        columnWidthMode: ColumnWidthMode.fill,
        allowExpandCollapseGroup: true,
        columns: <GridColumn>[
          GridColumn(
            columnName: 'id',
            label: Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: Text('ID'),
            ),
          ),
          GridColumn(
            columnName: 'name',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text('Name'),
            ),
          ),
          GridColumn(
            columnName: 'designation',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text('Designation', overflow: TextOverflow.ellipsis),
            ),
          ),
          GridColumn(
            columnName: 'salary',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text('Salary'),
            ),
          ),
        ],
      ),
    );
  }

  List<Employee> getEmployeeData() {
    return [
      Employee(10001, 'James', 'Project Lead', 20000),
      Employee(10002, 'Kathryn', 'Manager', 30000),
      Employee(10003, 'Lara', 'Developer', 20000),
      Employee(10004, 'Michael', 'Designer', 15000),
      Employee(10005, 'Martin', 'Developer', 25000),
      Employee(10006, 'Newberry', 'Developer', 10000),
      Employee(10007, 'Balnc', 'Developer', 15000),
      Employee(10008, 'Perry', 'Developer', 15000),
      Employee(10009, 'Gable', 'Developer', 15000),
      Employee(10010, 'Grimes', 'Developer', 10000),
      Employee(10011, 'Sophia', 'Manager', 32000),
      Employee(10012, 'Ethan', 'Developer', 18000),
      Employee(10013, 'Olivia', 'Designer', 17000),
      Employee(10014, 'Liam', 'Developer', 22000),
      Employee(10015, 'Emma', 'Project Lead', 28000),
      Employee(10016, 'Noah', 'Developer', 16000),
      Employee(10017, 'Ava', 'Developer', 19000),
      Employee(10018, 'Isabella', 'Developer', 21000),
      Employee(10019, 'Mason', 'Developer', 23000),
      Employee(10020, 'Logan', 'Developer', 24000),
    ];
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.designation, this.salary);

  /// Id of an employee.
  final int id;

  /// Name of an employee.
  final String name;

  /// Designation of an employee.
  final String designation;

  /// Salary of an employee.
  final int salary;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<Employee> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                columnName: 'designation',
                value: e.designation,
              ),
              DataGridCell<int>(columnName: 'salary', value: e.salary),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> _employeeData = [];
  Map<String, int> groupColumn = {};
  Map<String, int> occurance = {};

  @override
  List<DataGridRow> get rows => _employeeData;

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

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          child: Text(e.value.toString()),
        );
      }).toList(),
    );
  }
}
