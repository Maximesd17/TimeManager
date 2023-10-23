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

table users:
- username: string - required - not null
- email: string - required - not null - "X@X.X" 

table clocks:
- time: datetime - required - not null
- status: boolean - required - true (when clock'in) - not null
- user: user - required - not null

table workingtimes:
- start: datetime - required - not null - "YYYY-MM-DD HH:mm:ss"
- datetime - required - not null - "YYYY-MM-DD HH:mm:ss"
- user - required - not null
