Parece que o serviço está falhando ao iniciar. O erro `status=210/CHROOT` sugere que o serviço pode estar enfrentando problemas relacionados ao ambiente de execução ou permissões.

Aqui estão alguns passos para diagnosticar e corrigir o problema:

### 1. Verifique o Caminho do Executável

Certifique-se de que o executável está realmente no caminho `/usr/local/bin/mqtt_gpio_control`. Verifique com:

```bash
ls -l /usr/local/bin/mqtt_gpio_control
```

Se o arquivo não estiver lá, mova-o para esse diretório ou ajuste o caminho no arquivo de serviço.

### 2. Verifique as Permissões

Certifique-se de que o executável tem permissões de execução:

```bash
sudo chmod +x /usr/local/bin/mqtt_gpio_control
```

### 3. Verifique o Arquivo de Serviço

Verifique se o arquivo de serviço `/etc/systemd/system/mqtt-gpio.service` está correto. A configuração deve ter `ExecStart` apontando para o caminho correto e `User=root` se o executável precisar de permissões de root. Verifique se a `WorkingDirectory` é necessária e se o diretório especificado existe.

### 4. Teste o Executável Manualmente

Tente executar o binário manualmente para ver se ele apresenta erros:

```bash
sudo /usr/local/bin/mqtt_gpio_control
```

Isso pode ajudar a identificar problemas específicos com o binário ou a configuração.

### 5. Verifique os Logs do Serviço

Examine os logs do serviço para obter mais detalhes sobre o erro:

```bash
sudo journalctl -u mqtt-gpio.service
```

Isso pode fornecer informações mais específicas sobre o motivo pelo qual o serviço falhou.

### 6. Corrija o Problema Identificado

Baseado nas mensagens de erro e logs, faça as correções necessárias. Se o problema for relacionado ao ambiente (por exemplo, a necessidade de permissões específicas ou arquivos de configuração ausentes), ajuste o arquivo de serviço ou a configuração do seu ambiente.

### Exemplo Atualizado do Arquivo de Serviço

Aqui está uma configuração ajustada, assumindo que o binário deve rodar como root e você não precisa de um diretório de trabalho específico:

```ini
[Unit]
Description=MQTT GPIO Control Service
After=network.target

[Service]
ExecStart=/usr/local/bin/mqtt_gpio_control
Restart=on-failure
User=root

[Install]
WantedBy=multi-user.target
```

Depois de ajustar o arquivo de serviço, recarregue a configuração do `systemd` e reinicie o serviço:

```bash
sudo systemctl daemon-reload
sudo systemctl restart mqtt-gpio.service
```

Verifique o status novamente:

```bash
sudo systemctl status mqtt-gpio.service
```

Esses passos devem ajudar a resolver o problema e garantir que o serviço inicie corretamente no boot.