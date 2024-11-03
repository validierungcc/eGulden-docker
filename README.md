**eGulden**

https://github.com/validierungcc/eGulden-docker

https://www.egulden.org



Example docker-compose.yml

     ---
    services:
        egulden:
            container_name: egulden
            image: vfvalidierung/egulden:latest
            restart: unless-stopped
            ports:
                - '11015:11015'
                - '127.0.0.1:21015:21015'
            volumes:
                - 'egulden:/egulden/.egulden'
    volumes:
       egulden:

**RPC Access**

    curl --user 'eguldenrpc:<password>' --data-binary '{"jsonrpc":"1.0","id":"curltext","method":"getinfo","params":[]}' -H "Content-Type: application/json" http://127.0.0.1:21015
