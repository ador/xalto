# xalto

Labeler


### Getting started

1. `postgrest` has to be installed, see http://postgrest.org/en/v6.0/tutorials/tut0.html

2. Start up PG with `./pg_start.sh`

3. Create the DB schema manually, if you haven't yet:
`sudo docker exec -it xalto psql -U postgres`
then and within the PG console, repeat hte SQL commands from schema.md

4. Start postgrest with 
`postgrest ./xalto-pgrest.conf`

5. Check if anonymous user can read the data, for example with
`curl http://localhost:3000/page`
(should show empty string, or data if you have added some pages)

6. Check if `xalto_user` can write data:

Generate a token with jwt.io according to http://postgrest.org/en/v6.0/tutorials/tut1.html
for `{"role": "xalto_user"}`

Test in a terminal (with the valid token): 

```
export TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoieGFsdG9fdXNlciJ9.RWhz34laUp_fOnZi9N-d7vUy1fDn5NdhUXnajFMLsBoZoo"

curl http://localhost:3000/dataset -X POST \
     -H "Authorization: Bearer $TOKEN"   \
     -H "Content-Type: application/json" \
     -d '{"name": "first-test-dataset"}'
```

Then the next curl command (with readonly user)
`curl http://localhost:3000/dataset`
should return 
`[{"id":1,"name":"first-test-dataset","created":"2019-11-25T20:04:45.178106"}]`


