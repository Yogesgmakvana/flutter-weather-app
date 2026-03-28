import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? data;
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getWeather("Ahmedabad");
  }

  Future<void> getWeather([String name = "Ahmedabad"]) async {
    try {
      final url = Uri.https(
        "api.openweathermap.org",
        "/data/2.5/weather",
        {
          "q": name,
          "appid": "7485469225f2ba175b970891c2ea5a7c",
          "units": "metric",
        },
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load weather");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null) {
      return const Scaffold(
        body: Center(child: Text("No Data Found")),
      );
    }

    List weatherList = data!['weather'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title:RichText(text: TextSpan(
          text:"World",style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 22,
              ),
          children: [
            TextSpan(
              text: "Weather",style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
                fontSize: 18,
              ),
            ),
          ]
        )),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          /// Background Image
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover, 
            ),
          ),

          /// Content
          SingleChildScrollView(
            child: Column(
              children: [
                 LottieBuilder.asset('assets/cloudy.json'),
                const SizedBox(height: 15),
               
                ///  Search Box
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search city...",
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (searchController.text.isEmpty) return;

                            setState(() {
                              isLoading = true;
                            });

                            getWeather(searchController.text);
                          },
                          icon: const Icon(Icons.search),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
                 
                ///  Main Card
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [Colors.cyanAccent, Colors.cyan],
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        /// City
                        Text(
                          "City: ${data!['name']}",
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 10),

                        /// Temperature
                        Card(
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Lottie.asset('assets/Temperature.json'),
                            ),
                            title: Text(
                              "Temperature: ${data!['main']['temp']} °C",
                            ),
                          ),
                        ),

                        /// Humidity
                        Card(
                          child: ListTile(
                            leading: Lottie.asset('assets/humidity.json'),
                            title: Text(
                              "Humidity: ${data!['main']['humidity']}%",
                            ),
                          ),
                        ),

                        /// Wind
                        Card(
                          child: ListTile(
                            leading: Lottie.asset('assets/Weather.json'),
                            title: Text(
                              "Wind Speed: ${data!['wind']['speed']} m/s",
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        ///  Weather List
                        SizedBox(
                          height: 150, 
                          child: ListView.builder(
                            itemCount: weatherList.length,
                            itemBuilder: (context, index) {
                              var weather = weatherList[index];

                              return Card(
                                child: ListTile(
                                  leading: Image.network(
                                    "https://openweathermap.org/img/wn/${weather['icon']}@2x.png",
                                  ),
                                  title: Text(weather['main']),
                                  subtitle: Text(weather['description']),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

               
              ],
            ),
          ),
        ],
      ),
    );
  }
}