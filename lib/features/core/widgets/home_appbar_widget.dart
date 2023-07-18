import 'package:flutter/material.dart';
import 'package:mylib_app/features/core/enums/space_sizedbox.dart';

class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String photoUrl;
  const HomeAppBarWidget({
    super.key,
    required this.photoUrl,
  });

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text("myLib"),
      actions: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed("/profile");
          },
          borderRadius: BorderRadius.circular(45),
          child: CircleAvatar(
            backgroundImage: NetworkImage(photoUrl),
          ),
        ),
        SpaceHorizontalSizedBox.m.value,
      ],
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
