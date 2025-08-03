import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';
import '../widgets/employee_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/employee_dialog.dart';
import '../widgets/employee_details_dialog.dart';

class HCMHomePage extends StatefulWidget {
  @override
  _HCMHomePageState createState() => _HCMHomePageState();
}

class _HCMHomePageState extends State<HCMHomePage>
    with TickerProviderStateMixin {
  AnimationController? _fadeController;
  AnimationController? _slideController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;

  List<Employee> employees = [];
  String searchQuery = '';
  String selectedDepartment = 'All';

  @override
  void initState() {
    super.initState();
    employees = EmployeeService.getSampleEmployees();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController!, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController!, curve: Curves.easeOutCubic),
    );

    _fadeController!.forward();
    _slideController!.forward();
  }

  @override
  void dispose() {
    _fadeController?.dispose();
    _slideController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Color(0xFF0F172A) : Color(0xFFF8FAFC);

    List<Employee> filteredEmployees = EmployeeService.filterEmployees(
      employees,
      searchQuery,
      selectedDepartment,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () => _toggleTheme(context),
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: isDark ? Colors.white : Colors.grey[700],
              ),
              tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            ),
          ),
        ],
      ),
      body:
          _fadeAnimation == null || _slideAnimation == null
              ? Center(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF6366F1),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Loading HCM Dashboard...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : FadeTransition(
                opacity: _fadeAnimation!,
                child: SlideTransition(
                  position: _slideAnimation!,
                  child: Column(
                    children: [
                      _buildHeader(isDark),
                      _buildSearchAndFilter(isDark),
                      _buildStatisticsCards(),
                      SizedBox(height: 16),
                      _buildEmployeeList(filteredEmployees, isDark),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
    );
  }

  void _toggleTheme(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Theme toggle - implement with state management'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isDark
                  ? [Color(0xFF4C1D95), Color(0xFF6366F1), Color(0xFF8B5CF6)]
                  : [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6366F1).withOpacity(isDark ? 0.4 : 0.3),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(Icons.people_outline, color: Colors.white, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Human Capital Management',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Streamline your workforce operations',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            _buildActionButton(
              'Add Employee',
              Icons.add_rounded,
              Colors.white,
              Color(0xFF6366F1),
              () => _showAddEmployeeDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter(bool isDark) {
    final surfaceColor = isDark ? Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;

    return Container(
      padding: EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search employees, positions...',
                  labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                  prefixIcon: Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.search_rounded,
                      color: Color(0xFF6366F1),
                      size: 18,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                value: selectedDepartment,
                decoration: InputDecoration(
                  labelText: 'Department',
                  labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                  prefixIcon: Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.filter_list_rounded,
                      color: Color(0xFF6366F1),
                      size: 18,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                items:
                    EmployeeService.getDepartments()
                        .map(
                          (dept) => DropdownMenuItem(
                            value: dept,
                            child: Text(
                              dept,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDepartment = value!;
                  });
                },
                dropdownColor: surfaceColor,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.grey[800],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          StatCard(
            title: 'Total Employees',
            value: employees.length.toString(),
            icon: Icons.people_rounded,
            color: Color(0xFF3B82F6),
            delay: 0,
          ),
          SizedBox(width: 8),
          StatCard(
            title: 'Departments',
            value:
                EmployeeService.getUniqueDepartments(
                  employees,
                ).length.toString(),
            icon: Icons.business_center_rounded,
            color: Color(0xFFF59E0B),
            delay: 100,
          ),
          SizedBox(width: 8),
          StatCard(
            title: 'Avg Salary',
            value:
                '\$${EmployeeService.getAverageSalary(employees).toStringAsFixed(0)}',
            icon: Icons.trending_up_rounded,
            color: Color(0xFF10B981),
            delay: 200,
          ),
          SizedBox(width: 8),
          StatCard(
            title: 'New This Month',
            value:
                EmployeeService.getNewEmployeesThisMonth(employees).toString(),
            icon: Icons.person_add_rounded,
            color: Color(0xFF8B5CF6),
            delay: 300,
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeList(List<Employee> filteredEmployees, bool isDark) {
    final surfaceColor = isDark ? Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;

    return Expanded(
      child: Container(
        margin: EdgeInsets.fromLTRB(24, 0, 24, 24),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildEmployeeListHeader(filteredEmployees.length, isDark),
            Expanded(
              child:
                  filteredEmployees.isEmpty
                      ? _buildEmptyState(isDark)
                      : ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: filteredEmployees.length,
                        itemBuilder: (context, index) {
                          final employee = filteredEmployees[index];
                          return _buildAnimatedEmployeeCard(employee, index);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 40,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
            ),
          ),
          SizedBox(height: 12),
          Text(
            'No employees found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Try adjusting your search criteria',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[500] : Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeListHeader(int employeeCount, bool isDark) {
    final surfaceColor = isDark ? Color(0xFF334155) : Colors.grey[50]!;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [surfaceColor, isDark ? Color(0xFF1E293B) : Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6366F1).withOpacity(0.1),
                  Color(0xFF8B5CF6).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFF6366F1).withOpacity(0.2)),
            ),
            child: Icon(
              Icons.people_outline_rounded,
              color: Color(0xFF6366F1),
              size: 18,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Employee Directory',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.grey[800],
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  'Manage employee information',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFF6366F1).withOpacity(0.2)),
            ),
            child: Text(
              '$employeeCount ${employeeCount == 1 ? 'employee' : 'employees'}',
              style: TextStyle(
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedEmployeeCard(Employee employee, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutCubic,
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 600 + (index * 100)),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Opacity(
              opacity: value,
              child: EmployeeCard(
                employee: employee,
                onTap: () => _showEmployeeDetails(employee),
                onMenuAction:
                    (action) => _handleEmployeeAction(action, employee),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color textColor,
    Color backgroundColor,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(text, style: TextStyle(fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void _showEmployeeDetails(Employee employee) {
    showDialog(
      context: context,
      builder:
          (context) => EmployeeDetailsDialog(
            employee: employee,
            onEdit: () => _showEditEmployeeDialog(employee),
          ),
    );
  }

  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      builder: (context) => EmployeeDialog(onSave: _addEmployee),
    );
  }

  void _showEditEmployeeDialog(Employee employee) {
    showDialog(
      context: context,
      builder:
          (context) =>
              EmployeeDialog(employee: employee, onSave: _updateEmployee),
    );
  }

  void _handleEmployeeAction(String action, Employee employee) {
    if (action == 'edit') {
      _showEditEmployeeDialog(employee);
    } else if (action == 'delete') {
      _deleteEmployee(employee);
    }
  }

  void _addEmployee(Employee employee) {
    setState(() {
      employees.add(employee);
    });
    _showSuccessMessage(
      '${employee.name} has been added successfully!',
      Colors.green,
    );
  }

  void _updateEmployee(Employee employee) {
    setState(() {
      // Employee is already updated by reference
    });
    _showSuccessMessage(
      '${employee.name} has been updated successfully!',
      Colors.blue,
    );
  }

  void _deleteEmployee(Employee employee) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.warning, color: Colors.red[600]),
                ),
                SizedBox(width: 12),
                Text('Delete Employee'),
              ],
            ),
            content: Text(
              'Are you sure you want to delete ${employee.name}? This action cannot be undone.',
            ),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    employees.remove(employee);
                  });
                  Navigator.pop(context);
                  _showSuccessMessage(
                    '${employee.name} has been deleted',
                    Colors.red,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _showSuccessMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
