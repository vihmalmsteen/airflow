# AIRFLOW

Dois ambientes:

- **dev:** usa uv + Makefile
- **prod:** usa pip + docker-compose

A melhor maneira de rodar `dev` no Windows é usando o [WSL](https://learn.microsoft.com/pt-br/windows/wsl/install):

- Abra o terminal e rode `wsl`
- Copiar o projeto para dentro do WSL (ex: `cp -r /mnt/c/Users/vitor/Desktop/airflow '~/Área de trabalho/airflow'`)
- Navegue até a pasta do projeto
- Crie o venv e instale as dependências: `uv sync`
- Rode `make start`
- `Webserver` abre em [localhost:8081](http://localhost:8081)
- Na pasta `migrations` configurada no Makefile para o Airflow standalone, terá as credenciais [criadas pelo Airflow](./migrations/simple_auth_manager_passwords.json.generated).
- **Notas:** Possivelmente será necessário instalar alguma lib Linux (make, git, etc). O path do projeto no wsl deve ser como confgurado no [airflow.cfg](./migrations/airflow.cfg#L8).

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
