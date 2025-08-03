import '../models/employee.dart';

class EmployeeService {
  static List<Employee> getSampleEmployees() {
    return [
      Employee(
        id: '001',
        name: 'John Doe',
        email: 'john.doe@company.com',
        department: 'Engineering',
        position: 'Senior Developer',
        joinDate: DateTime(2022, 1, 15),
        salary: 75000,
      ),
      Employee(
        id: '002',
        name: 'Jane Smith',
        email: 'jane.smith@company.com',
        department: 'Marketing',
        position: 'Marketing Manager',
        joinDate: DateTime(2021, 6, 10),
        salary: 65000,
      ),
      Employee(
        id: '003',
        name: 'Mike Johnson',
        email: 'mike.johnson@company.com',
        department: 'HR',
        position: 'HR Specialist',
        joinDate: DateTime(2023, 3, 20),
        salary: 55000,
      ),
      Employee(
        id: '004',
        name: 'Sarah Wilson',
        email: 'sarah.wilson@company.com',
        department: 'Finance',
        position: 'Financial Analyst',
        joinDate: DateTime(2022, 8, 5),
        salary: 60000,
      ),
      Employee(
        id: '005',
        name: 'Alex Thompson',
        email: 'alex.thompson@company.com',
        department: 'Operations',
        position: 'Operations Manager',
        joinDate: DateTime(2021, 11, 12),
        salary: 70000,
      ),
      Employee(
        id: '002',
        name: 'Jane Smith',
        email: 'jane.smith@company.com',
        department: 'Marketing',
        position: 'Marketing Manager',
        joinDate: DateTime(2021, 6, 10),
        salary: 65000,
      ),
      Employee(
        id: '003',
        name: 'Mie Johson',
        email: 'mike.johnn@company.com',
        department: 'HR',
        position: 'HR Specialist',
        joinDate: DateTime(2023, 3, 20),
        salary: 55000,
      ),
      Employee(
        id: '004',
        name: 'Sarah Wilson',
        email: 'sarah.wilson@company.com',
        department: 'Finance',
        position: 'Financial Analyst',
        joinDate: DateTime(2022, 8, 5),
        salary: 60000,
      ),
    ];
  }

  static List<String> getDepartments() {
    return ['All', 'Engineering', 'Marketing', 'HR', 'Finance', 'Operations'];
  }

  static List<Employee> filterEmployees(
    List<Employee> employees,
    String searchQuery,
    String selectedDepartment,
  ) {
    return employees.where((employee) {
      bool matchesSearch =
          employee.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          employee.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
          employee.position.toLowerCase().contains(searchQuery.toLowerCase());

      bool matchesDepartment =
          selectedDepartment == 'All' ||
          employee.department == selectedDepartment;

      return matchesSearch && matchesDepartment;
    }).toList();
  }

  static double getAverageSalary(List<Employee> employees) {
    if (employees.isEmpty) return 0;
    return employees.map((e) => e.salary).reduce((a, b) => a + b) /
        employees.length;
  }

  static int getNewEmployeesThisMonth(List<Employee> employees) {
    final now = DateTime.now();
    return employees
        .where(
          (e) => e.joinDate.month == now.month && e.joinDate.year == now.year,
        )
        .length;
  }

  static List<String> getUniqueDepartments(List<Employee> employees) {
    return employees.map((e) => e.department).toSet().toList();
  }

  static String generateEmployeeId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
