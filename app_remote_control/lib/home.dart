import 'package:flutter/material.dart';
import 'package:on_off/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:on_off/controller/home_controller.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isButton1On = false; 
  bool isButton2On = false; 
  late HomeController homeController; 

  @override
  void initState() {
    super.initState();
    homeController = HomeController(); 
  }

  void toggleSwitch(int gpio, bool isOn) {
    setState(() {
      if (gpio == 0) {
        isButton1On = isOn;
      } else if (gpio == 1) {
        isButton2On = isOn;
      }
    });

    String message = (gpio == 0)
        ? (isOn ? "on1" : "off1") 
        : (isOn ? "on2" : "off2");

    String topic = "/teste_iot"; 
    homeController.sendMessage(topic, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 59, 108),
        title: const Text(
          'Controle remoto de lâmpadas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botão 1
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(
                    color: isButton1On ? Colors.green : Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: IconButton(
                  iconSize: 75,
                  style: IconButton.styleFrom(
                    side: BorderSide(
                      color: isButton1On ? Colors.green : Colors.grey,
                      width: 3.0,
                    ),
                  ),
                  onPressed: () => toggleSwitch(0, !isButton1On),
                  icon: Icon(
                    Icons.power_settings_new,
                    color: isButton1On ? Colors.green : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 200),
              // Botão 2
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(
                    color: isButton2On ? Colors.green : Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: IconButton(
                  iconSize: 75,
                  style: IconButton.styleFrom(
                    side: BorderSide(
                      color: isButton2On ? Colors.green : Colors.grey,
                      width: 3.0,
                    ),
                  ),
                  onPressed: () => toggleSwitch(1, !isButton2On),
                  icon: Icon(
                    Icons.power_settings_new,
                    color: isButton2On ? Colors.green : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
