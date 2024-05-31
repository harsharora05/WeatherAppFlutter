// ignore_for_file: depend_on_referenced_packages

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/ForeCastCard.dart';
import 'package:weather_app/additionalInfo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherAppScreen extends StatefulWidget {
  const WeatherAppScreen({super.key});

  @override
  State<WeatherAppScreen> createState() => _WeatherAppScreenState();
}

class _WeatherAppScreenState extends State<WeatherAppScreen> {
  late Future<Map<String, dynamic>> weather;
  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Mumbai';
      final result = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=937825140eb53b079029096b43a0fd92'));

      // print(result.body);
      final data = jsonDecode(result.body);

      if (data['cod'] != '200') {
        throw 'An Unexpected Error Occur';
      }
      // print(data['list'][0]['main']['temp']);

      return data;
    } catch (e) {
      throw (e).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            final data = snapshot.data!;
            final currentTemp = data['list'][0]['main']['temp'];
            final currentWeather = data['list'][0]['weather'][0]['main'];
            final currentHumidity = data['list'][0]['main']['humidity'];
            final currentPressure = data['list'][0]['main']['pressure'];
            final currentSpeed = data['list'][0]['wind']['speed'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  "$currentTemp°k",
                                  style: const TextStyle(fontSize: 40),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                Icon(
                                  currentWeather == 'Clouds' ||
                                          currentWeather == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 37,
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                Text(
                                  "$currentWeather",
                                  style: const TextStyle(fontSize: 25),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Hourly Forecast",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  // const SingleChildScrollView(  // instantly create cards which can hamper performance of your app
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       ForeCastCard(
                  //           weather: "Rain",
                  //           weatherIcon: Icons.cloud,
                  //           time: "09:00"),
                  //       ForeCastCard(
                  //           weather: "Rain",
                  //           weatherIcon: Icons.cloud,
                  //           time: "09:00"),
                  //       ForeCastCard(
                  //           weather: "Rain",
                  //           weatherIcon: Icons.cloud,
                  //           time: "09:00"),
                  //       ForeCastCard(
                  //           weather: "Rain",
                  //           weatherIcon: Icons.cloud,
                  //           time: "09:00"),
                  //       ForeCastCard(
                  //           weather: "Rain",
                  //           weatherIcon: Icons.cloud,
                  //           time: "09:00")
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                        //lazy loading use karke car bnayega taaki project ki performance hamper naa ho
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final time =
                              DateTime.parse(data['list'][index + 1]['dt_txt']);
                          final weatherIcon = data['list'][index + 1]['weather']
                                  [0]['main']
                              .toString();
                          final hourlytemp = data['list'][index + 1]['main']
                                  ['temp']
                              .toString();
                          return ForeCastCard(
                              time: DateFormat.j().format(time),
                              weatherIcon: weatherIcon == 'Clouds' ||
                                      weatherIcon == 'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              weather: hourlytemp);
                        }),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Additional Information",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AditionalInformationWidget(
                          icon: Icons.water_drop,
                          label: "Humidity",
                          value: "$currentHumidity"),
                      AditionalInformationWidget(
                          icon: Icons.air,
                          label: "Wind Speed",
                          value: "$currentSpeed"),
                      AditionalInformationWidget(
                          icon: Icons.beach_access,
                          label: "Pressure",
                          value: "$currentPressure"),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
