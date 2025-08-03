import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';

class EmployeeDialog extends StatefulWidget {
  final Employee? employee;
  final Function(Employee) onSave;

  const EmployeeDialog({Key? key, this.employee, required this.onSave})
    : super(key: key);

  @override
  _EmployeeDialogState createState() => _EmployeeDialogState();
}

class _EmployeeDialogState extends State<EmployeeDialog> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController positionController;
  late TextEditingController salaryController;
  late String selectedDept;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.employee?.name ?? '');
    emailController = TextEditingController(text: widget.employee?.email ?? '');
    positionController = TextEditingController(
      text: widget.employee?.position ?? '',
    );
    salaryController = TextEditingController(
      text: widget.employee?.salary.toString() ?? '',
    );
    selectedDept = widget.employee?.department ?? 'Engineering';
    selectedDate = widget.employee?.joinDate ?? DateTime.now();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    positionController.dispose();
    salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 24),
            _buildFormField('Full Name', nameController, Icons.person),
            SizedBox(height: 16),
            _buildFormField('Email Address', emailController, Icons.email),
            SizedBox(height: 16),
            _buildDepartmentDropdown(),
            SizedBox(height: 16),
            _buildFormField('Position', positionController, Icons.work),
            SizedBox(height: 16),
            _buildFormField(
              'Salary',
              salaryController,
              Icons.attach_money,
              TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildDatePicker(),
            SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6366F1).withOpacity(0.1),
                Color(0xFF8B5CF6).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFF6366F1).withOpacity(0.2)),
          ),
          child: Icon(
            widget.employee == null
                ? Icons.person_add_rounded
                : Icons.edit_rounded,
            color: Color(0xFF6366F1),
            size: 24,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.employee == null ? 'Add New Employee' : 'Edit Employee',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                widget.employee == null
                    ? 'Enter employee details to add them to the system'
                    : 'Update employee information',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    IconData icon, [
    TextInputType? keyboardType,
  ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
            letterSpacing: 0.1,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              prefixIcon: Container(
                padding: EdgeInsets.all(12),
                child: Icon(icon, color: Color(0xFF6366F1), size: 20),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedDept,
        decoration: InputDecoration(
          labelText: 'Department',
          prefixIcon: Icon(Icons.business_center, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        items:
            ['Engineering', 'Marketing', 'HR', 'Finance', 'Operations']
                .map((dept) => DropdownMenuItem(value: dept, child: Text(dept)))
                .toList(),
        onChanged: (value) {
          setState(() {
            selectedDept = value!;
          });
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          setState(() {
            selectedDate = date;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey[600]),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Join Date',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Cancel'),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveEmployee,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              widget.employee == null ? 'Add Employee' : 'Update Employee',
            ),
          ),
        ),
      ],
    );
  }

  void _saveEmployee() {
    // Validation
    if (!_validateFields()) return;

    final double salary = double.parse(salaryController.text.trim());

    if (widget.employee == null) {
      // Create new employee
      final newEmployee = Employee(
        id: EmployeeService.generateEmployeeId(),
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        department: selectedDept,
        position: positionController.text.trim(),
        joinDate: selectedDate,
        salary: salary,
      );
      widget.onSave(newEmployee);
    } else {
      // Update existing employee
      widget.employee!.name = nameController.text.trim();
      widget.employee!.email = emailController.text.trim();
      widget.employee!.department = selectedDept;
      widget.employee!.position = positionController.text.trim();
      widget.employee!.salary = salary;
      widget.employee!.joinDate = selectedDate;
      widget.onSave(widget.employee!);
    }

    Navigator.pop(context);
  }

  bool _validateFields() {
    if (nameController.text.trim().isEmpty) {
      _showError('Please enter employee name');
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      _showError('Please enter email address');
      return false;
    }
    if (positionController.text.trim().isEmpty) {
      _showError('Please enter position');
      return false;
    }
    if (salaryController.text.trim().isEmpty) {
      _showError('Please enter salary');
      return false;
    }

    try {
      double.parse(salaryController.text.trim());
    } catch (e) {
      _showError('Please enter a valid salary amount');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
