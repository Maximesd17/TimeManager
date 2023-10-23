# Boostrap

## Project Creation

if phenix version > 16
```shell
$> mix phx.new XXX --app YYY --module ZZZ --no-html --no-assets
```

if phenix version <= 16
```shell
$> mix phx.new XXX --app YYY --module ZZZ --no-html --no-webpack
```

XXX: folder path for project

YYY: app name

ZZZ: module name


## Init PostgreSQL database
```shell
$> mix ecto.create
```

## Data schemas
- user:
    - first name
    - last name
- task:
    - title
    - description
    - status
    - user (from users table)

`task.user` gives information of the assigned user.

todo: generate and migrate schemas

## Routes

Create a CRUD for user management.

Router in the following file: ${PROJECT_ROOT}/lib/todo_list_web/router.ex

Must be similar to the following:

```
defmodule TodolistWeb.Router do
    use TodolistWeb, :router

    pipeline :api do
        plug :accepts , ["json"]
    end

    scope "/api", TodolistWeb do
        pipe_through :api
    end
end
```

Then, add in the `/api` scope the following:
`resources "/users", UserController, except: [:new, :edit]`

To manage the tasks, we create a sub scope in `/api`, being `/tasks`

In this new scope, create the following routes:
- GET /api/tasks
    - 200 if there is no error
- GET /api/tasks/:id
    - 200 if the task is found
    - 404 if the task is unknown
- POST /api/tasks
    - 201 if creation succeeds
    - 400 if there is an error
- DELETE /api/tasks/:id
- PUT /api/tasks/:id
- GET /api/tasks/users/:idUser
    - 200 if the task if found
    - 404 if the task is unknown

# Bootstrap notes

"--no-webpack" supported until phenix v1.6.

Since v1.7.9 it's now "--no-assets"

Error:

(Mix) Could not start application xmerl: could not find application file: xmerl.app

Solution:

```shell
$> sudo apt-get install erlang-xmerl
```

# Project

## Tables

### users
- username: string - required - not null
- email: string - required - not null - "X@X.X" 

### clocks:
- time: datetime - required - not null
- status: boolean - required - true (when clock'in) - not null
- user: user - required - not null

### workingtimes:
- start: datetime - required - not null - "YYYY-MM-DD HH:mm:ss"
- datetime - required - not null - "YYYY-MM-DD HH:mm:ss"
- user - required - not null

## Routes

**api default route**: `http://localhost:4000/api`

### User

- **GET** /users?email=XXX&username=YYY
- **GET** /users/:userID
- **POST** /users
- **PUT** /users/:userID
- **DELETE** /users/:userID

### Working Time

- **GET** /workingtimes/:userID?start=XXX&end=YYY
- **GET** /workingtimes/:userID/:id
- **POST** /workingtimes/:userID
- **PUT** /workingtimes/:id
- **DELETE** /workingtimes/:id

### Clocking

- **GET** /clocks/:userID
- **POST** /clocks/:userID

**WARNING !!**

The last `POST` (Clocking) handles both the departure and the arrival of users.

**Tips**

Use [Postman](https://www.postman.com/downloads/) for routes testing

## Work Done

Please keep this section at end of Project section !

- Create schemas/controllers thanks to the json generator `$> mix phx.gen.json ...`
- Edit the migration files located at ${PROJECT_ROOT}/priv/repo/migrations/<files_here.exs>` to fill requirements
- Do the migration `$> mix ecto.migrate`
- Edit router file locate at ${PROJECT_ROOT}/lib/{PROJECT_NAME}_web/router.ex and edit the "/api" scope as below

```
scope "/api", TimeManagerWeb do
  pipe_through :api
  resources "/users", UserController
  resources "/clocks", ClockController
  resources "/workingtimes", WorkingtimeController
end
```

**Careful to have the pipe_through as first line of scope**