import 'package:flutter/material.dart';

class SocialMediaButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onTap;

  const SocialMediaButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget IconNavbar(String path) {
      return Image.asset(path, height: 30, width: 30);
    }

    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconNavbar(iconPath),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
