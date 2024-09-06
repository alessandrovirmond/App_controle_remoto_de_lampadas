import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
class MqttCallback{

final MqttServerClient client;

  MqttCallback(this.client);



void onSubscribed(String topic) {
  print('$topic');
}


void onDisconnected() {
  print('Cliente Desconectado');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('Desconectado após Solicitação');
  }
}

void onConnected() {
  print('Conectado com Servidor Mqtt');
}

void pong() {
  print('PING');
}




}

