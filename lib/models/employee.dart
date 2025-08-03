class Employee {
  final String id;
  String name;
  String email;
  String department;
  String position;
  DateTime joinDate;
  double salary;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.position,
    required this.joinDate,
    required this.salary,
  });

  // Helper method to get department color
  static const Map<String, int> departmentColors = {
    'Engineering': 0xFF2196F3, // Colors.blue
    'Marketing': 0xFFFF9800, // Colors.orange
    'HR': 0xFF9C27B0, // Colors.purple
    'Finance': 0xFF4CAF50, // Colors.green
    'Operations': 0xFF009688, // Colors.teal
  };

  // Get initials for avatar
  String get initials {
    return name
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();
  }

  // Get formatted salary
  String get formattedSalary {
    return '\$${salary.toStringAsFixed(0)}';
  }

  // Get formatted join date
  String get formattedJoinDate {
    return '${joinDate.day}/${joinDate.month}/${joinDate.year}';
  }
}
