# Report Factory Installation Instructions

The fastest and easiest way to run *Report Factory* is by using *docker-compose*.

The bundle consists of three services:

  - db: [PostgresSQL database](https://hub.docker.com/_/postgres/)
  - server: [Rails 5 API](https://hub.docker.com/r/reportfactory/server/)
  - web: [React & Redux dashboard](https://hub.docker.com/r/reportfactory/web/)

## Getting Started

### Install Docker

Make sure you have *Docker* installed with *docker-compose*. Follow the official installation [guidelines](https://docs.docker.com/compose/install/).

### Download docker-compose.yml

You can find the most recent `docker-compose.yml` [here](https://raw.githubusercontent.com/igor-starostenko/report_factory/master/setup/docker-compose.yml)

### Configure environment

In the same directory with `docker-compose.yml` create a file `.env` with the following variables:
*COMPOSE_PROJECT_NAME*, *SECRET_KEY_BASE*, *POSTGRES_USER* and *POSTGRES_PASSWORD*.

 - *COMPOSE_PROJECT_NAME*: a name that would be added as prefix to every service;
 - *SECRET_KEY_BASE*: generate any random token. It is critical that you keep this value private in production;
 - *POSTGRES_USER*: any username that would be used to authenticate with the database;
 - *POSTGRES_PASSWORD*: password for the user required to authenticate with the database.

#### For example:

```
COMPOSE_PROJECT_NAME=report_factory

SECRET_KEY_BASE=10476e14f06e2653abdadab0b10d7fb2

POSTGRES_USER=your_user_name

POSTGRES_PASSWORD=your_password
```

### Start services

Run

```
  docker-compose up
```
Wait for it to pull all the images and start containers.

### Create database

Run

```
  docker-compose exec server rails db:create
```

and then

```
  docker-compose exec server rails db:migrate
```

### Configure

Now you can access web dashboard in your browser on `http://localhost:3001`

Rails api are available on `http://localhost:3000`.

You can login with admin user credentials:

| email               | password     |
|---------------------|--------------|
| **admin@admin.com** | **Welcome1** |

With admin permissions you can create other users and admins as well as projects. The initial admin user can be safely deleted later.

### Use

To submit reports you need to retrieve you user's `X-API-KEY`.

Currently there is only one adapter available for test reports:

 - [RSpec Adapter for Report Factory](https://github.com/igor-starostenko/report_factory-rspec)

