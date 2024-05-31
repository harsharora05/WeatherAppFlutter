import "package:flutter/material.dart";

class AditionalInformationWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AditionalInformationWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 25),
        Text(label, style: const TextStyle(fontSize: 18)),
        Text(value, style: const TextStyle(fontSize: 15))
      ],
    );
  }
}
