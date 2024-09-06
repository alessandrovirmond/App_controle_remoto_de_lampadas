
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:on_off/model/home_model.dart';
import 'package:on_off/mqtt/mqtt_listen.dart';
import '../mqtt/mqtt_connection.dart';
import 'package:rxdart/rxdart.dart';

class HomeController {
  late final MqttConnection client;
  late final MqttListen listen;
  Situation _situation = Situation();
  BehaviorSubject<Situation> _bloc = BehaviorSubject();
  Stream<Situation> get stream => _bloc.stream;

  HomeController() {
    init();
    _update();
  }

  Future<void> init() async {
    await _connectMqtt();
  }

  Future<void> _connectMqtt() async {
    client = MqttConnection(
      name: DateTime.now().millisecondsSinceEpoch.toString(),
      port: 'xxxx',
      server: "xx.xxxx.xxx",
      topicKeepALive: "/xxxxx",
    );

    

    await client.connect(() {
      _situation.mqtt = true;
      print("-------------MQTT CONECTADO");
      _update();
    }, () {
      _situation.mqtt = false;
      print("-------------MQTT DESCONECTADO");
      _update();
    });
  }

  void _update() {
    _bloc.sink.add(_situation);
  }


  void sendMessage(String topic, String message) {
    if (_situation.mqtt = true) {
      client.publishMessage(topic, message);
      print("Mensagem enviada para o tópico $topic: $message");
    } else {
      print("Cliente MQTT não está conectado.");
    }
  }
}
