# n4o-skosmos

This git repository contains information on how to start a RDF triple store, fill it with data using the [n4o-graph-importer](https://github.com/nfdi4objects/n4o-graph-importer) and access the (J)SKOS-vocabularies using [Skosmos](https://github.com/NatLibFi/Skosmos).

## Components

A [Skosmos](https://github.com/NatLibFi/Skosmos) instance consisting of:
- `skosmos-fuseki`: a RDF tiple store
- `fuseki-cache`: a Varnish Cache container
- `skosmos-web`: a web-based tool to access vocabularies

and an instance of:  
- [n4o-graph-importer](https://github.com/nfdi4objects/n4o-graph-importer): scripts to import data into the triple store

## Installation

First clone the repository. Before creating the docker containers it is necessary to provide a config file for Skosmos. This can be done by copying the default config file. To do this navigate to the repository root directory and run:

~~~sh
cp ./dockerfiles/config/config-docker-compose-default.ttl ./dockerfiles/config/config-docker-compose.ttl
~~~

Now the containers can be created running in the background with:

~~~sh
docker compose up -d
~~~

If locally cached containers already exist they can be updated using:

~~~sh
docker compose pull
~~~

Running containers can be stopped by:

~~~sh
docker compose down
~~~

or stopped and restarted with:

~~~sh
docker compose down -v
docker compose up --force-recreate
~~~

## Usage

The Skosmos web interface is by default accessable under <http://localhost:9090/> and the importer at <http://localhost:5020/>. 

The skript `init.sh` takes a list of terminologies with their uri and a download link in [JSKOS format](https://gbv.github.io/jskos/), see `terminologies.json` for an example, as first argument and registers them. It downloads the vocabularies from the given sources and adds them to the triple store using the importer. Afterwards the skirpt extends the `config-docker-compose.ttl` with the vocabulary information to make the (J)SKOS-vocabularies accessable by SKOSMOS.