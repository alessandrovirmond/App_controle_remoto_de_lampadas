#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <wiringPi.h>
#include <MQTTClient.h>

#define ADDRESS     "tcp://lorem_impsum.com" // Endereço do servidor MQTT
#define CLIENTID    "OrangePiClient"
#define TOPIC       "/123"
#define QOS         1
#define TIMEOUT     10000L

// Define o pino GPIO para o LED
#define LED_PIN     27

volatile MQTTClient_deliveryToken deliveredtoken;

void delivered(void *context, MQTTClient_deliveryToken dt) {
    printf("Mensagem com token %d entregue\n", dt);
    deliveredtoken = dt;
}

int msgarrvd(void *context, char *topicName, int topicLen, MQTTClient_message *message) {
    char* payload = (char*)message->payload;
    printf("Mensagem recebida no tópico: %s\n", topicName);
    printf("Conteúdo: %s\n", payload);

    // Verifica o payload e controla o LED
    if (strcmp(payload, "off1") == 0) {
        printf("OFF\n");
        digitalWrite(27, HIGH);  // Liga o LED
    } else if (strcmp(payload, "on1") == 0) {
        printf("ON\n");
        digitalWrite(27, LOW);   // Desliga o LED
    } else if (strcmp(payload, "off2") == 0) {
        printf("OFF\n");
        digitalWrite(26, HIGH);  // Liga o LED
    } else if (strcmp(payload, "on2") == 0) {
        printf("ON\n");
        digitalWrite(26, LOW);   // Desliga o LED
    } else {
        printf("Payload desconhecido: %s\n", payload);
    }

    MQTTClient_freeMessage(&message);
    MQTTClient_free(topicName);
    return 1;
}

void connlost(void *context, char *cause) {
    printf("\nConexão perdida: %s\n", cause);
}

int main(int argc, char* argv[]) {
    MQTTClient client;
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    int rc;

    // Inicializa o wiringPi e configura o pino do LED como saída
    printf("Inicializando wiringPi...\n");
    wiringPiSetup();
    pinMode(LED_PIN, OUTPUT);
    pinMode(26,OUTPUT);
    digitalWrite(LED_PIN, LOW); // Inicialmente desliga o LED

    printf("Criando cliente MQTT...\n");
    MQTTClient_create(&client, ADDRESS, CLIENTID, MQTTCLIENT_PERSISTENCE_NONE, NULL);
    
    conn_opts.keepAliveInterval = 20;
    conn_opts.cleansession = 1;

    MQTTClient_setCallbacks(client, NULL, connlost, msgarrvd, delivered);
    
    printf("Tentando se conectar ao broker MQTT em %s...\n", ADDRESS);
    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS) {
        printf("Falha na conexão ao MQTT Broker, código de retorno %d\n", rc);
        exit(EXIT_FAILURE);
    }
    printf("Conectado ao MQTT Broker\n");

    printf("Inscrevendo no tópico %s...\n", TOPIC);
    MQTTClient_subscribe(client, TOPIC, QOS);

    printf("Aguardando mensagens...\n");
    while (1) {
        // Aguarda novas mensagens
        sleep(1);
    }

    printf("Desconectando do MQTT Broker...\n");
    MQTTClient_disconnect(client, 10000);
    MQTTClient_destroy(&client);
    return rc;
}