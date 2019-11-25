#!/bin/bash

# Start PG itself, with the given main password

# This will run the Docker instance as a daemon and expose port 5433 to the host
# system so that it looks like an ordinary PostgreSQL server.
sudo docker run --name xalto -p 5433:5432 -e POSTGRES_PASSWORD=$1 -d postgres
