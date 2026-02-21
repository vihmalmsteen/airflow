# AIRFLOW

Dois ambientes:

- **dev:** usa `uv` + `Makefile`
- **prod:** usa `pip` + `docker-compose`

O Airflow não roda nativamente no windows, por isso a melhor maneira de rodar `dev` é usando o [WSL](https://learn.microsoft.com/pt-br/windows/wsl/install). O que significa que todo o projeto ficará dentro da distro (alterações, versionamento, etc). O melhor fluxo é para esse ambiente é:

- rodar wsl
- copiar projeto para dentro da distro
- fazer alterações
- push no wsl
- pull no windows

## Config inicial

### dev

**1. Configurar `wsl` e `make`:**

```bash
# ps1
wsl --list-online                           # checa as distros disponíveis (pegar Ubuntu)
wsl --install -d <distro>                   # instala a distro
wsl --list                                  # lista as distros instaladas
wsl --set-default <distro>                  # define a distro padrão
wsl --update                                # atualiza o wsl
wsl --set-default-version 2                 # define a versão do wsl
wsl                                         # Entrando na vm via terminal

# ubuntu
sudo apt update && sudo apt install make    # Instalar dependência `make` pra rodar `Makefile`
```

**2. Criar pasta do projeto dentro da distro de acordo com o diretório configurado no [airflow.cfg](./migrations/airflow.cfg#L8), dar permissões e copiar do windows:**

```bash
mkdir -p ~/"Área de trabalho/airflow"          # criando dir
sudo chmod 766 -R ~/"Área de trabalho/airflow" # permissões
```

**3. Copiar a pasta do projeto montada em `mnt` para a pasta criada e com permissões:**

```bash
cp -r "/mnt/c/Users/vitor/Desktop/airflow" ~/"Área de trabalho"
```

**4. Entrar na distro e rodar o projeto:**

- Abra o terminal e rode `wsl`
- Copiar o projeto montado dentro de `mnt` para dentro da pasta certa (ex: `cp -r /mnt/c/Users/vitor/Desktop/airflow ~/"Área de trabalho"`)
- Navegue até a pasta do projeto (ex: `cd ~/"Área de trabalho/airflow"`)
- Crie o venv e instale as dependências: `uv sync`
- Rode `make start`
- `Webserver` abre em [localhost:8081](http://localhost:8081)

### prod

- Docker
- `docker-compose up -d`
- `Webserver` abre em [localhost:8080](http://localhost:8080)

# Start

**3. Configurar pasta do projeto dentro da distro:**

- Abra o terminal e rode `wsl`
- Copiar o projeto montado dentro de `mnt` para dentro da pasta certa (ex: `cp -r /mnt/c/Users/vitor/Desktop/airflow ~/"Área de trabalho"`)
- Navegue até a pasta do projeto (ex: `cd ~/"Área de trabalho/airflow"`)
- Crie o venv e instale as dependências: `uv sync`
- Rode `make start`
- `Webserver` abre em [localhost:8081](http://localhost:8081)
- Na pasta `migrations` configurada no Makefile para o Airflow standalone, terá as credenciais [criadas pelo Airflow](./migrations/simple_auth_manager_passwords.json.generated).
- **Notas:** Possivelmente será necessário instalar alguma lib Linux (make, git, etc). O path do projeto no wsl deve ser como confgurado no [airflow.cfg](./migrations/airflow.cfg#L8).

### dev

```bash
# 1ª vez
make migrate
# startar
uv sync
make start
```
**Configs após `make migrate` em [airflow.cfg](./migrations/airflow.cfg):**

- Porta do [Airflow Webserver](./migrations/airflow.cfg#L1253) em 8081.
- Desabilitado [carregamento de exemplos](./migrations/airflow.cfg#L156).



### prod

```bash
ducker-compose up -d
```

Porta do [Airflow Webserver](./docker-compose.yaml#L51) em 8080.
