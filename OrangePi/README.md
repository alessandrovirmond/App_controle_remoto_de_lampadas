# Código

## Projeto: Controle de GPIO via MQTT em Orange Pi

Este projeto demonstra como controlar os pinos GPIO de uma Orange Pi utilizando o protocolo MQTT. A aplicação é escrita em C e utiliza as bibliotecas WiringPi para manipulação dos pinos GPIO e Paho MQTT para comunicação MQTT.

## Visão Geral do Código

### Bibliotecas Utilizadas

- **`stdio.h`, `stdlib.h`, `string.h`, `unistd.h`**: Bibliotecas padrão da linguagem C para entrada/saída, alocação de memória, manipulação de strings, e funções de delay.
- **`wiringPi.h`**: Biblioteca usada para controlar os pinos GPIO na Orange Pi.
- **`MQTTClient.h`**: Biblioteca Paho MQTT usada para a comunicação com o broker MQTT.

### Definições Importantes

- **`ADDRESS`**: Define o endereço do broker MQTT (`tcp://services.rfidbrasil.com:1883`).
- **`CLIENTID`**: Define o identificador único para o cliente MQTT (`OrangePiClient`).
- **`TOPIC`**: Define o tópico MQTT ao qual o cliente irá se inscrever (`/teste_iot`).
- **`QOS`**: Define o nível de Qualidade de Serviço (QoS) para a comunicação MQTT (neste caso, 1).

### Funções do Código

#### 1. **`delivered(void *context, MQTTClient_deliveryToken dt)`**
   - Esta função é chamada quando uma mensagem enviada pelo cliente é confirmada como entregue pelo broker MQTT.
   - **`context`**: Contexto do cliente.
   - **`dt`**: Token de entrega da mensagem.

#### 2. **`msgarrvd(void *context, char *topicName, int topicLen, MQTTClient_message *message)`**
   - Esta função é chamada quando uma nova mensagem é recebida em um tópico ao qual o cliente está inscrito.
   - **`context`**: Contexto do cliente.
   - **`topicName`**: Nome do tópico no qual a mensagem foi recebida.
   - **`message`**: Mensagem recebida.

   - A função verifica o conteúdo da mensagem (`payload`) e controla o LED correspondente:
     - `"off1"`: Desliga o LED no pino 27.
     - `"on1"`: Liga o LED no pino 27.
     - `"off2"`: Desliga o LED no pino 26.
     - `"on2"`: Liga o LED no pino 26.
     - Caso o `payload` não corresponda a nenhum dos comandos, uma mensagem de erro é exibida.

#### 3. **`connlost(void *context, char *cause)`**
   - Esta função é chamada quando a conexão com o broker MQTT é perdida.
   - **`context`**: Contexto do cliente.
   - **`cause`**: Causa da desconexão.

   - A função simplesmente imprime uma mensagem indicando que a conexão foi perdida e a causa da perda.

#### 4. **`main(int argc, char* argv[])`**
   - Função principal do programa.
   - **Passos principais**:
     1. Inicializa o sistema de GPIO usando `wiringPiSetup()` e configura os pinos 27 e 26 como saída.
     2. Cria e configura o cliente MQTT, definindo o endereço do broker, ID do cliente e opções de conexão.
     3. Conecta-se ao broker MQTT e inscreve-se no tópico definido (`/teste_iot`).
     4. Entra em um loop infinito aguardando mensagens MQTT, processando-as quando chegam.
     5. Desconecta-se do broker MQTT e libera os recursos ao encerrar o programa.

### Fluxo de Execução

1. **Inicialização**: Configura os pinos GPIO e conecta ao broker MQTT.
2. **Inscrição**: Inscreve-se no tópico MQTT `/teste_iot`.
3. **Recepção e Processamento**: Aguardando mensagens MQTT e controla os LEDs baseando-se no conteúdo da mensagem.
4. **Desconexão**: Desconecta do broker MQTT quando o programa é encerrado.

## Como Utilizar

### Pré-requisitos

- **Orange Pi**: Certifique-se de que a Orange Pi está configurada com o sistema operacional Linux.
- **Bibliotecas**:
  - **WiringPi**: Instale utilizando `sudo apt-get install wiringpi`.
  - **Paho MQTT**: Instale utilizando `sudo apt-get install libpaho-mqtt3c-dev`.

### Compilação

Para compilar o código, utilize o seguinte comando:

```bash
gcc -o mqtt_gpio_control mqtt_gpio_control.c -lpaho-mqtt3c -lwiringPi
```

### Execução

Execute o programa com:

```bash
sudo ./mqtt_gpio_control
```

O programa tentará conectar-se ao broker MQTT, inscrever-se no tópico `/teste_iot` e aguardar mensagens que controlarão os LEDs nos pinos GPIO 27 e 26.

## Conclusão

Este código é um exemplo simples de como integrar comunicação MQTT e controle de GPIO em uma Orange Pi, ideal para projetos de IoT onde a interação com dispositivos físicos é controlada remotamente através de mensagens MQTT.