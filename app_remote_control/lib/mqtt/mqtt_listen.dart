import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'mqtt_connection.dart';

class MqttListen {
  final MqttConnection mqttConnection;
  final String topic;
  late final MqttServerClient client;
  final Function(String) callback;
  late final StreamSubscription stream;

  MqttListen(
      {required this.mqttConnection,
      required this.topic,
      required this.callback}) {
    client = mqttConnection.client;
    client.subscribe(topic, MqttQos.atMostOnce);

    stream = client.updates!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = await MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message);
      print(pt);

      try {
        callback(pt);
      } catch (e) {
        print("ERROR Verificar:\n ${e}");
        callback("Erro");
      }
    });

    client.published!.listen((MqttPublishMessage message) {});
  }

  void dispose() {
    stream.pause();
    stream.cancel();
  }
}
