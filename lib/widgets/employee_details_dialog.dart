import 'package:flutter/material.dart';
import '../models/employee.dart';

class EmployeeDetailsDialog extends StatelessWidget {
  final Employee employee;
  final VoidCallback onEdit;

  const EmployeeDetailsDialog({
    Key? key,
    required this.employee,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAvatar(),
            SizedBox(height: 16),
            _buildHeader(),
            SizedBox(height: 24),
            _buildDetailsList(),
            SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final color = _getDepartmentColor(employee.department);
    return Hero(
      tag: 'avatar_${employee.id}',
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            employee.initials,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          employee.name,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          employee.position,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildDetailsList() {
    return Column(
      children: [
        _buildDetailRow(
          'Department',
          employee.department,
          Icons.business_center,
        ),
        _buildDetailRow('Email', employee.email, Icons.email),
        _buildDetailRow(
          'Join Date',
          employee.formattedJoinDate,
          Icons.calendar_today,
        ),
        _buildDetailRow('Salary', employee.formattedSalary, Icons.attach_money),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[800])),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onEdit();
            },
            child: Text('Edit'),
          ),
        ),
      ],
    );
  }

  Color _getDepartmentColor(String department) {
    final colorValue = Employee.departmentColors[department];
    return colorValue != null ? Color(colorValue) : Colors.grey;
  }
}
