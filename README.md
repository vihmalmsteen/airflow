# AIRFLOW

Dois ambientes:

- **dev:** usa uv + Makefile
- **prod:** usa pip + docker-compose

## dev

```bash
make migrate
make start
```
**Configs após `make migrate` em [airflow.cfg](./migrations/airflow.cfg):**

- Porta do [Airflow Webserver](./migrations/airflow.cfg#L1253) em 8081.
- Desabilitado [carregamento de exemplos](./migrations/airflow.cfg#L156).



## prod

```bash
ducker compose up -d
```

Porta do [Airflow Webserver](./docker-compose.yaml#L51) em 8080.
