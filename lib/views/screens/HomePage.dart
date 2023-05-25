import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/controllers/providers/theme_provider.dart';
import 'package:weather_app/models/weather_api_helper.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/utils/images_path.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Weather?> getWeather;

  @override
  void initState() {
    super.initState();
    getWeather = APIHelper.apiHelper.fetchWeatherDetails();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).changeTheme();
            },
            icon: const Icon(Icons.light_mode),
          ),
        ],
      ),
      body: FutureBuilder(
        future: APIHelper.apiHelper.fetchWeatherDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error : ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            Weather? data = snapshot.data;
            return (data == null)
                ? const Center(
                    child: Text("No Data Available.."),
                  )
                : Stack(
                    children: [
                      Container(
                        height: _height,
                        width: _width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: (Provider.of<ThemeProvider>(context)
                                    .themeModel
                                    .isDark)
                                ? AssetImage(bgImageDark)
                                : AssetImage(bgImageLight),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.name,
                                style: TextStyle(
                                  fontSize: _height * 0.04,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: _height * 0.005,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Lat :  ${data.lat} °",
                                    style: TextStyle(
                                      fontSize: _height * 0.018,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: _width * 0.1,
                                  ),
                                  Text(
                                    "Lon :  ${data.lon} °",
                                    style: TextStyle(
                                      fontSize: _height * 0.018,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _height * 0.1,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                textBaseline: TextBaseline.alphabetic,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                children: [
                                  Text(
                                    "${data.temp_c}°",
                                    style: TextStyle(
                                      fontSize: _height * 0.08,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    data.condition,
                                    style: TextStyle(
                                      fontSize: _height * 0.025,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _height * 0.04,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  children: List.generate(
                                    data.hour.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.only(right: 28),
                                      child: Column(
                                        children: [
                                          (data.hour[DateTime.now().hour]
                                                          ['time']
                                                      .split("25")[1] ==
                                                  data.hour[index]['time']
                                                      .split("25")[1])
                                              ? Text(
                                                  "Now",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: _height * 0.022,
                                                  ),
                                                )
                                              : Text(
                                                  data.hour[index]['time']
                                                      .split("25")[1],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: _height * 0.022,
                                                  ),
                                                ),
                                          SizedBox(
                                            height: _height * 0.01,
                                          ),
                                          Image.network(
                                            "http:${data.hour[index]['condition']['icon']}",
                                            height: _height * 0.05,
                                            width: _height * 0.05,
                                          ),
                                          SizedBox(
                                            height: _height * 0.01,
                                          ),
                                          Text(
                                            "${data.hour[index]['temp_c']}°",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: _height * 0.022,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: _height * 0.05,
                              ),
                              Text(
                                "Weather details",
                                style: TextStyle(
                                  fontSize: _height * 0.02,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: _height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: _height * 0.18,
                                    width: _width * 0.45,
                                    decoration: BoxDecoration(
                                      color:
                                          (Provider.of<ThemeProvider>(context)
                                                  .themeModel
                                                  .isDark)
                                              ? Colors.black.withOpacity(0.4)
                                              : Colors.white.withOpacity(0.4),
                                      borderRadius:
                                          BorderRadius.circular(_height * 0.02),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.thermostat,
                                            size: _height * 0.04,
                                          ),
                                          SizedBox(
                                            height: _height * 0.035,
                                          ),
                                          Text(
                                            "Feels Like",
                                            style: TextStyle(
                                              fontSize: _height * 0.02,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  (Provider.of<ThemeProvider>(
                                                              context)
                                                          .themeModel
                                                          .isDark)
                                                      ? Colors.grey
                                                      : Colors.black54,
                                            ),
                                          ),
                                          SizedBox(
                                            height: _height * 0.003,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${data.feelslike_c}",
                                                style: TextStyle(
                                                  fontSize: _height * 0.03,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                width: _width * 0.01,
                                              ),
                                              Text(
                                                "°",
                                                style: TextStyle(
                                                  fontSize: _height * 0.03,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: _height * 0.18,
                                    width: _width * 0.45,
                                    decoration: BoxDecoration(
                                      color:
                                          (Provider.of<ThemeProvider>(context)
                                                  .themeModel
                                                  .isDark)
                                              ? Colors.black.withOpacity(0.4)
                                              : Colors.white.withOpacity(0.4),
                                      borderRadius:
                                          BorderRadius.circular(_height * 0.02),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.air,
                                            size: _height * 0.04,
                                          ),
                                          SizedBox(
                                            height: _height * 0.035,
                                          ),
                                          Text(
                                            "SW wind",
                                            style: TextStyle(
                                              fontSize: _height * 0.02,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  (Provider.of<ThemeProvider>(
                                                              context)
                                                          .themeModel
                                                          .isDark)
                                                      ? Colors.grey
                                                      : Colors.black54,
                                            ),
                                          ),
                                          SizedBox(
                                            height: _height * 0.003,
                                          ),
                                          Row(
                                            textBaseline:
                                                TextBaseline.ideographic,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            children: [
                                              Text(
                                                "${data.wind_kph}",
                                                style: TextStyle(
                                                  fontSize: _height * 0.03,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                width: _width * 0.01,
                                              ),
                                              Text(
                                                "km/h",
                                                style: TextStyle(
                                                  fontSize: _height * 0.02,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: _height * 0.18,
                                    width: _width * 0.45,
                                    decoration: BoxDecoration(
                                      color:
                                          (Provider.of<ThemeProvider>(context)
                                                  .themeModel
                                                  .isDark)
                                              ? Colors.black.withOpacity(0.4)
                                              : Colors.white.withOpacity(0.4),
                                      borderRadius:
                                          BorderRadius.circular(_height * 0.02),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.water_drop,
                                            size: _height * 0.04,
                                          ),
                                          SizedBox(
                                            height: _height * 0.035,
                                          ),
                                          Text(
                                            "Humidity",
                                            style: TextStyle(
                                              fontSize: _height * 0.02,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  (Provider.of<ThemeProvider>(
                                                              context)
                                                          .themeModel
                                                          .isDark)
                                                      ? Colors.grey
                                                      : Colors.black54,
                                            ),
                                          ),
                                          SizedBox(
                                            height: _height * 0.003,
                                          ),
                                          Row(
                                            textBaseline:
                                                TextBaseline.ideographic,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            children: [
                                              Text(
                                                "${data.humidity}",
                                                style: TextStyle(
                                                  fontSize: _height * 0.03,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                width: _width * 0.01,
                                              ),
                                              Text(
                                                "%",
                                                style: TextStyle(
                                                  fontSize: _height * 0.02,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: _height * 0.18,
                                    width: _width * 0.45,
                                    decoration: BoxDecoration(
                                      color:
                                          (Provider.of<ThemeProvider>(context)
                                                  .themeModel
                                                  .isDark)
                                              ? Colors.black.withOpacity(0.4)
                                              : Colors.white.withOpacity(0.4),
                                      borderRadius:
                                          BorderRadius.circular(_height * 0.02),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.light_mode_outlined,
                                            size: _height * 0.04,
                                          ),
                                          SizedBox(
                                            height: _height * 0.035,
                                          ),
                                          Text(
                                            "UV",
                                            style: TextStyle(
                                              fontSize: _height * 0.02,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  (Provider.of<ThemeProvider>(
                                                              context)
                                                          .themeModel
                                                          .isDark)
                                                      ? Colors.grey
                                                      : Colors.black54,
                                            ),
                                          ),
                                          SizedBox(
                                            height: _height * 0.003,
                                          ),
                                          Row(
                                            textBaseline:
                                                TextBaseline.ideographic,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            children: [
                                              Text(
                                                "${data.uv}",
                                                style: TextStyle(
                                                  fontSize: _height * 0.03,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                width: _width * 0.01,
                                              ),
                                              Text(
                                                "Very strong",
                                                style: TextStyle(
                                                  fontSize: _height * 0.02,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: _height * 0.18,
                                    width: _width * 0.45,
                                    decoration: BoxDecoration(
                                      color:
                                          (Provider.of<ThemeProvider>(context)
                                                  .themeModel
                                                  .isDark)
                                              ? Colors.black.withOpacity(0.4)
                                              : Colors.white.withOpacity(0.4),
                                      borderRadius:
                                          BorderRadius.circular(_height * 0.02),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.visibility,
                                            size: _height * 0.04,
                                          ),
                                          SizedBox(
                                            height: _height * 0.035,
                                          ),
                                          Text(
                                            "Visibility",
                                            style: TextStyle(
                                              fontSize: _height * 0.02,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  (Provider.of<ThemeProvider>(
                                                              context)
                                                          .themeModel
                                                          .isDark)
                                                      ? Colors.grey
                                                      : Colors.black54,
                                            ),
                                          ),
                                          SizedBox(
                                            height: _height * 0.003,
                                          ),
                                          Row(
                                            textBaseline:
                                                TextBaseline.ideographic,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            children: [
                                              Text(
                                                "${data.vis_km}",
                                                style: TextStyle(
                                                  fontSize: _height * 0.03,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                width: _width * 0.01,
                                              ),
                                              Text(
                                                "km",
                                                style: TextStyle(
                                                  fontSize: _height * 0.02,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: _height * 0.18,
                                    width: _width * 0.45,
                                    decoration: BoxDecoration(
                                      color:
                                          (Provider.of<ThemeProvider>(context)
                                                  .themeModel
                                                  .isDark)
                                              ? Colors.black.withOpacity(0.4)
                                              : Colors.white.withOpacity(0.4),
                                      borderRadius:
                                          BorderRadius.circular(_height * 0.02),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.wind_power,
                                            size: _height * 0.04,
                                          ),
                                          SizedBox(
                                            height: _height * 0.035,
                                          ),
                                          Text(
                                            "Air pressure",
                                            style: TextStyle(
                                              fontSize: _height * 0.02,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  (Provider.of<ThemeProvider>(
                                                              context)
                                                          .themeModel
                                                          .isDark)
                                                      ? Colors.grey
                                                      : Colors.black54,
                                            ),
                                          ),
                                          SizedBox(
                                            height: _height * 0.003,
                                          ),
                                          Row(
                                            textBaseline:
                                                TextBaseline.ideographic,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            children: [
                                              Text(
                                                "${data.pressure_mb}",
                                                style: TextStyle(
                                                  fontSize: _height * 0.03,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                width: _width * 0.01,
                                              ),
                                              Text(
                                                "hPa",
                                                style: TextStyle(
                                                  fontSize: _height * 0.02,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
