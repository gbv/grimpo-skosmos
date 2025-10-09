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

First clone the repository and afterwards create the corresponding containers running in the background by running:

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

The skript `init.sh` registers the terminologies saved in `terminologies.json`, downloads the vocabularies from the given sources and adds them to the triple store using the importer. It furthermore extends the `config-docker-compose.ttl` with the vocabulary information to make the (J)SKOS-vocabularies accessable by SKOSMOS.