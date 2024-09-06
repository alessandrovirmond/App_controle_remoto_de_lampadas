import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'mqtt_callback.dart';

class MqttConnection {
  final String server;
  final String port;
  final String name;

  final String topicKeepALive;
  late final MqttServerClient client;
  late final MqttCallback callback;

  MqttConnection(
      {required this.server,
      required this.port,
      required this.topicKeepALive,
      required this.name}) {
    client = MqttServerClient(this.server, this.port);
    callback = MqttCallback(client);
  }

  Future<void> connect(Function()? onConnected, Function()? onDisconnected) async {
    Fluttertoast.showToast(msg:"Iniciando a Conexão");
    client.logging(on: false);
    client.keepAlivePeriod = 60;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = callback.onSubscribed;
    client.pongCallback = callback.pong;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(name)
        .withWillTopic('/server/connect')
        .withWillMessage('$name acabou de se conectar')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('Conectando');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
     Fluttertoast.showToast(msg: 'Error $e');
      client.disconnect();
    } on SocketException catch (e) {
      Fluttertoast.showToast(msg: 'Error $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      Fluttertoast.showToast(msg: "Cliente conectado");
    } else {
      Fluttertoast.showToast(msg: "ERRO");
      client.disconnect();
    }
  }

    // Função para publicar mensagens em um tópico específico
  void publishMessage(String topic, String message) {
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
      print("Mensagem publicada no tópico $topic: $message");
    } else {
      print("Cliente MQTT não está conectado.");
      Fluttertoast.showToast(msg: "Cliente não está conectado.");
    }
  }
}
