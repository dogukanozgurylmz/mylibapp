import 'package:flutter/material.dart';

class BasicAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const BasicAppBarWidget({
    super.key,
    required this.title,
  });

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      title: Text(title),
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
