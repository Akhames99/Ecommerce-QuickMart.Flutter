import 'package:ecommerce/Models/location_item_model.dart';
import 'package:flutter/material.dart';

class LocationItemWidget extends StatelessWidget {
  final double borderWidth;
  final Color borderColor;
  final VoidCallback onTap;
  final LocationItemModel location;
  const LocationItemWidget({
    super.key,
    required this.borderColor,
    required this.onTap,
    required this.location,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderWidth),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.city,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    '${location.city}, ${location.country}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0XFF41AB5D).withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                backgroundImage: AssetImage(location.locationImg),
                radius: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
