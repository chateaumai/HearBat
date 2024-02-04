import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final VoidCallback? onLeadingIconPressed;

  const TopBar({
    Key? key,
    required this.title,
    this.leadingIcon,
    this.onLeadingIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 95, 95, 95),
            width: 2.0,
          ),
        ),
      ),
      child: AppBar(
        leading: leadingIcon != null
            ? Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: IconButton(
                  icon: Icon(leadingIcon, size: 36),
                  onPressed: onLeadingIconPressed ?? () => Navigator.of(context).pop(),
                ),
            )
            : null,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        elevation: 0, 
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
