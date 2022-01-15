import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:weather_app/service/weatherService.dart';
import 'package:weather_app/view/detailHourlyPage.dart';
import 'package:weather_app/view/weatherDetailPage.dart';
import 'package:weather_app/view/moreWeatherInfo.dart';
import 'package:weather_app/view/tomorrowPage.dart';

Weather currentTemp;
Weather tomorrowTemp;
List<Weather> todayWeather;
List<Weather> sevenDay;
String lat = "-25.30126";
String lon = "-49.16965";
String city = "Colombo";
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  getData() async{
    fetchData(lat, lon, city).then((value){
      currentTemp = value[0];
      todayWeather = value[1];
      tomorrowTemp = value[2];
      sevenDay = value[3];
      setState(() {
        
      });
    });
  }

@override
void initState() { 
  super.initState();
  getData();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: currentTemp==null ? Center(child: CircularProgressIndicator(),):Column(
        children: [CurrentWeather(getData), TodayWeather()],
      ),
    );
  }
}

class CurrentWeather extends StatefulWidget {
  final Function() updateData;
  CurrentWeather(this.updateData);
  @override
  _CurrentWeatherState createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {

bool searchBar = false;
bool updating = false;
var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(searchBar)
        setState(() {
          searchBar = false;
        });
      },
      child: GlowContainer(
        height: MediaQuery.of(context).size.height - 200,
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.only(top: 50, left: 30, right: 30),
        glowColor: Colors.lime.withOpacity(0.5),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        color: Colors.orange,
        spreadRadius: 1,
        child: Column(
          children: [
            Container(
              child: searchBar?
              TextField(
                focusNode: focusNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  fillColor: Colors.black54,
                  filled: true,
                  hintText:"Enter a city Name"
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value)async{
                  CityModel temp = await fetchCity(value);
                  if(temp==null){
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        backgroundColor: Color(0xff030317),
                        title:Text("City not found"),
                        content: Text("Please check the city name"),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                          }, child: Text("Ok"))
                        ],
                      );
                    });
                    searchBar = false;
                    return;
                  }
                  city = temp.name;
                  lat = temp.lat;
                  lon = temp.lon;
                  updating = true;
                  setState(() {
                    
                  });
                  widget.updateData();
                  searchBar = false;
                  updating = false;
                  setState(() {
                    
                  });
                },
              )
              :Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    CupertinoIcons.square_grid_2x2,
                    color: Colors.white,
                    size: 1,
                  ),
                  Row(
                    children: [
                      Icon(CupertinoIcons.map_fill, color: Colors.white),
                      GestureDetector(
                        onTap: (){
                          searchBar = true;
                          setState(() {

                          });
                          focusNode.requestFocus();
                        },
                        child: Text(
                          " " + city,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.more_vert, color: Colors.white, size: 1,)
                ],
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(top: 5),
            //   padding: EdgeInsets.all(5),
            //   decoration: BoxDecoration(
            //       border: Border.all(width: 0.2, color: Colors.white),
            //       borderRadius: BorderRadius.circular(30)),
            //   child: Text(
            //     updating?"Updating":"Updated",
            //     style: TextStyle(fontWeight: FontWeight.bold),
            //   ),
            // ),
            Container(
              height: 150,
              child: Stack(
                children: [
                  Image(
                    image: AssetImage(currentTemp.image),
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Center(
                        child: Column(
                      children: [
                        GlowText(
                          currentTemp.current.toString(),
                          style: TextStyle(
                            color: Colors.black54,
                              height: 0,
                              fontSize: 90,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(currentTemp.name,
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Text(currentTemp.day,
                            style: TextStyle(
                              fontSize: 18,
                            ))
                      ],
                    )),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.red,
            ),
            SizedBox(
              height: 10,
            ),
            MoreWeatherInfo(currentTemp)
          ],
        ),
      ),
    );
  }
}

class TodayWeather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return DetailHourlyPage(tomorrowTemp,todayWeather);
                      }));
                },
                child: Row(
                  children: [
                    Text(
                      "Hourly ",
                      style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                      size: 15,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return TomorrowPage(tomorrowTemp,sevenDay);
                      }));
                },
                child: Row(
                  children: [
                    Text(
                      "Tomorrow ",
                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                      size: 15,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return DetailPage(tomorrowTemp,sevenDay);
                  }));
                },
                child: Row(
                  children: [
                    Text(
                      "7 days ",
                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                      size: 15,
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 30,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WeatherWidget(todayWeather[0]),
                  WeatherWidget(todayWeather[1]),
                  WeatherWidget(todayWeather[2]),
                  WeatherWidget(todayWeather[3])
                ]),
          )
        ],
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  final Weather weather;
  WeatherWidget(this.weather);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(width: 0.3, color: Colors.white),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text(
            weather.current.toString() + "\u00B0",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 5,
          ),
          Image(
            image: AssetImage(weather.image),
            width: 45,
            height: 30,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            weather.time,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
