# PostGRES Fun

## Prerequisites

- [`docker`](https://www.docker.com/)
- [`docker-compose`](https://docs.docker.com/engine/reference/commandline/compose/)
- [`pgcli`](https://www.pgcli.com/) (optional, use `psql` or a GUI app of your choice)

## Setup

```bash
$ docker-compose up -d db
[+] Running 2/2
 ✔ Network postgres_default  Created                                         0.0s
 ✔ Container postgres-db-1   Started                                         0.2s
```

## Run

```bash
$ pgcli postgresql://postgres:1234@localhost:5432/postgres
Server: PostgreSQL 15.2 (Debian 15.2-1.pgdg110+1)
Version: 4.0.1
Home: http://pgcli.com
postgres@localhost:postgres>
```

### Note regarding PGCLI command

```bash
$ pgcli postgresql://postgres:PASSWORD@localhost:PORT/POSTGRES_USER
#
```
