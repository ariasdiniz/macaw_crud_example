# CRUD application using MacawFramework, ActiveRecord and Sqlite3

This application is a simple CRUD created to demonstrate the MacawFramework. With this application
you can call GET, POST, PATCH and DELETE endpoints to get a list of existing persons in the database, creating
a new person and deleting an existing person in the database, respectively.

To run the application, just go to the application directory and run:

```shell
$ bundle install
```
and then
```shell
$ ruby main.rb
```

## GET
```curl
curl --location --request GET 'localhost:8080/list_all_people'
```
Using the above request you can list the people in the database.

## GET
```curl
curl --location --request GET 'localhost:8080/people/1'
```
Using the above request you can recover info about a specific person

## POST
```curl
curl --location --request POST 'localhost:8080/add_new_person' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "Billie Joe",
    "age": 50
}'
```
Using the above request you can create a new person in the database.

## PATCH
```curl
curl --location --request PATCH 'localhost:8080/people/1' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "Another Name",
    "age": 30
}'
```
Using the above request you can update an existing person in the database.

## DELETE
```curl
curl --location --request DELETE 'localhost:8080/delete_person' \
--header 'Content-Type: application/json' \
--data-raw '{
"id": 1
}'
```

## GET
```curl
curl --location --request GET 'localhost:8080/metrics'
```

Using the above request you can get the metrics collected by Prometheus.
