# n40-skosmos

## Build and stop

To start the container in the background run

    docker compose up -d

To stop the container

    docker compose down

To reset the container

    docker compose down -v
    docker compose up --force-recreate

To update the locally cached Docker images:

    docker compose pull