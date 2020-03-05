# acolita-jstackSeries
Script bash para coleta de thread dumps em série

# Como utilizar

A maneira mais fácil é executando uma vez o script

```bash
./jstackSeries.sh
```

Para que ele mostre os pids dos processos java que estão em execução na máquina.

```bash
Usage: jstackSeries <pid> [ <count> [ <delay> ] ]
    Defaults: count = 10, delay = 1 (seconds)

Running Java Programs

Command          Pid
jca464.jar       137
```

Depois disso, basta fazer uma nova execução passando o pid do processo

```bash
./jstackSeries.sh 8230
```

Na execução padrão ele irá realizar a coleta por 10 minutos, 300 arquivos, um a cada segundo.

Se tudo ocorrer bem, será gerado um arquivo zip com os artefatos gerados.

Se precisar de uma ajuda, nos envie a coleta para análise que nós entraremos em contato.
https://www.acolita.com.br/file-upload.html

# Créditos

Este script é baseado no script de mesmo nome em:
http://wiki.eclipse.org/How_to_report_a_deadlock#jstackSeries_--_jstack_sampling_in_fixed_time_intervals_.28tested_on_Linux.29
