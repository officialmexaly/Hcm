import 'package:flutter/material.dart';

class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final int delay;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.delay = 0,
  }) : super(key: key);

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _elevationAnimation = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;

    return Expanded(
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _hoverController.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _hoverController.reverse();
        },
        child: TweenAnimationBuilder(
          duration: Duration(milliseconds: 800 + widget.delay),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double animValue, child) {
            return Transform.scale(
              scale: animValue,
              child: AnimatedBuilder(
                animation: _elevationAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          surfaceColor,
                          widget.color.withOpacity(isDark ? 0.03 : 0.02),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color:
                            _isHovered
                                ? widget.color.withOpacity(0.3)
                                : borderColor,
                        width: _isHovered ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withOpacity(isDark ? 0.15 : 0.1),
                          blurRadius: _elevationAnimation.value + 4,
                          offset: Offset(0, _elevationAnimation.value / 2 + 1),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.color.withOpacity(0.1),
                                widget.color.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: widget.color.withOpacity(0.2),
                            ),
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.color,
                            size: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        _buildAnimatedValue(),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedValue() {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 1500 + widget.delay),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, double countValue, child) {
        String displayValue = widget.value;

        if (widget.value.startsWith('\$')) {
          // Handle salary values that start with $
          String numericPart = widget.value.substring(1);
          int numValue = int.tryParse(numericPart) ?? 0;
          displayValue = '\$${(numValue * countValue).toInt()}';
        } else {
          // Handle regular numeric values
          int numValue = int.tryParse(widget.value) ?? 0;
          displayValue = '${(numValue * countValue).toInt()}';
        }

        return Text(
          displayValue,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: widget.color,
            letterSpacing: -0.3,
          ),
        );
      },
    );
  }
}
