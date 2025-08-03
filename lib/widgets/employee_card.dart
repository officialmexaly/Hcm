import 'package:flutter/material.dart';
import '../models/employee.dart';

class EmployeeCard extends StatefulWidget {
  final Employee employee;
  final VoidCallback onTap;
  final Function(String) onMenuAction;

  const EmployeeCard({
    Key? key,
    required this.employee,
    required this.onTap,
    required this.onMenuAction,
  }) : super(key: key);

  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient:
                    _isHovered
                        ? LinearGradient(
                          colors: [
                            surfaceColor,
                            _getDepartmentColor(
                              widget.employee.department,
                            ).withOpacity(isDark ? 0.03 : 0.02),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                        : null,
                color: _isHovered ? null : surfaceColor,
                border: Border.all(
                  color:
                      _isHovered
                          ? _getDepartmentColor(
                            widget.employee.department,
                          ).withOpacity(0.3)
                          : borderColor,
                  width: _isHovered ? 2 : 1,
                ),
                boxShadow:
                    _isHovered
                        ? [
                          BoxShadow(
                            color: _getDepartmentColor(
                              widget.employee.department,
                            ).withOpacity(isDark ? 0.15 : 0.1),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ]
                        : [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              isDark ? 0.2 : 0.04,
                            ),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: widget.onTap,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        _buildAvatar(),
                        SizedBox(width: 10),
                        Expanded(child: _buildEmployeeInfo()),
                        _buildActionsColumn(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar() {
    final color = _getDepartmentColor(widget.employee.department);
    return Hero(
      tag: 'avatar_${widget.employee.id}',
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.employee.initials,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeInfo() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.employee.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isDark ? Colors.white : Colors.grey[900],
            letterSpacing: -0.1,
          ),
        ),
        SizedBox(height: 3),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _getDepartmentColor(
              widget.employee.department,
            ).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getDepartmentColor(
                widget.employee.department,
              ).withOpacity(0.2),
            ),
          ),
          child: Text(
            '${widget.employee.position} • ${widget.employee.department}',
            style: TextStyle(
              color: _getDepartmentColor(widget.employee.department),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 3),
        Row(
          children: [
            Icon(
              Icons.email_outlined,
              size: 11,
              color: isDark ? Colors.grey[500] : Colors.grey[500],
            ),
            SizedBox(width: 2),
            Expanded(
              child: Text(
                widget.employee.email,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionsColumn() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[50]!, Colors.green[100]!.withOpacity(0.3)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green[200]!, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.payments_outlined, size: 10, color: Colors.green[700]),
              SizedBox(width: 2),
              Text(
                widget.employee.formattedSalary,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6),
        _buildPopupMenu(isDark),
      ],
    );
  }

  Widget _buildPopupMenu(bool isDark) {
    final surfaceColor = isDark ? Color(0xFF334155) : Colors.grey[50]!;
    final borderColor = isDark ? Colors.grey[600]! : Colors.grey[300]!;

    return PopupMenuButton<String>(
      onSelected: widget.onMenuAction,
      offset: Offset(0, 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: isDark ? Color(0xFF1E293B) : Colors.white,
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 12,
                        color: Colors.blue[600],
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: isDark ? Colors.white : Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        size: 12,
                        color: Colors.red[600],
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Delete',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: isDark ? Colors.white : Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color:
              _isHovered
                  ? surfaceColor
                  : (isDark ? Color(0xFF334155) : Colors.grey[50]),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Icon(
          Icons.more_vert,
          size: 14,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
    );
  }

  Color _getDepartmentColor(String department) {
    final colorValue = Employee.departmentColors[department];
    return colorValue != null ? Color(colorValue) : Colors.grey;
  }
}
