import "package:flutter/material.dart";

class ForeCastCard extends StatelessWidget {
  final String time;
  final IconData weatherIcon;
  final String weather;
  const ForeCastCard(
      {super.key,
      required this.time,
      required this.weatherIcon,
      required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 23),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              weatherIcon,
              size: 30,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              weather,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
