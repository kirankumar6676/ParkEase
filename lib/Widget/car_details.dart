import 'package:flutter/material.dart';

class CarTile extends StatelessWidget {
  final String imageUrl;
  final String carName;
  final String carDetails;

  const CarTile({
    required this.imageUrl,
    required this.carName,
    required this.carDetails,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(imageUrl),
      title: Text(carName),
      subtitle: Text(carDetails),
    );
  }
}
