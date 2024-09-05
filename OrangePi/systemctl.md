Para configurar o código para iniciar automaticamente no boot usando `systemd` no Orange Pi, você pode criar um serviço. Siga os passos abaixo:

### 1. Crie um Arquivo de Serviço

Primeiro, crie um arquivo de serviço na pasta `/etc/systemd/system/`. Vamos chamar esse serviço de `mqtt-gpio.service`.

```bash
sudo nano /etc/systemd/system/mqtt-gpio.service
```

### 2. Adicione o Conteúdo ao Arquivo de Serviço

Dentro do arquivo, adicione o seguinte conteúdo:

```ini
[Unit]
Description=MQTT GPIO Control Service
After=network.target

[Service]
ExecStart=/usr/local/bin/mqtt_gpio_control
WorkingDirectory=/home/user
Restart=on-failure
User=root

[Install]
WantedBy=multi-user.target
```

### 3. Salve e Feche o Arquivo

Salve as mudanças e saia do editor (`Ctrl + X`, depois `Y` e `Enter`).

### 4. Mova o Executável para o Diretório `/usr/local/bin/`

Certifique-se de que o seu binário compilado está em `/usr/local/bin/` para que o `systemd` possa encontrá-lo. Se o seu arquivo está em outro diretório, mova-o:

```bash
sudo mv /caminho/para/mqtt_gpio_control /usr/local/bin/
```

### 5. Configure o Serviço para Iniciar Automaticamente

Ative o serviço para iniciar automaticamente no boot:

```bash
sudo systemctl enable mqtt-gpio.service
```

### 6. Inicie o Serviço Manualmente

Se quiser iniciar o serviço imediatamente sem precisar reiniciar o sistema:

```bash
sudo systemctl start mqtt-gpio.service
```

### 7. Verifique o Status do Serviço

Para verificar se o serviço está rodando corretamente:

```bash
sudo systemctl status mqtt-gpio.service
```

### Conclusão

Agora, o serviço `mqtt-gpio` será iniciado automaticamente sempre que o sistema for inicializado, e ele controlará os pinos GPIO de acordo com as mensagens recebidas via MQTT.