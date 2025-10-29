# grimpo-skosmos

> Knowledge Graph importer for Skosmos 

This repository contains scripts to start a RDF triple store, fill it with data using [n4o-graph-importer](https://github.com/nfdi4objects/n4o-graph-importer) (aka *grimpo*) and access the vocabularies using [Skosmos].

## Components

A [Skosmos] instance consisting of:
- `skosmos-fuseki`: a RDF tiple store
- `fuseki-cache`: a Varnish Cache container
- `skosmos-web`: a web-based tool to access vocabularies

and an instance of:
- [n4o-graph-importer]: a web service to import data into the triple store, in particular vocabularies described in [BARTOC], in SKOS and [JSKOS] format

## Installation

First clone the repository. Before creating the docker containers it is necessary to provide a config file for Skosmos at `dockerfiles/config/skosmos.ttl`. This can be done by copying the default config file. To do so, navigate to the repository root directory and run:

~~~sh
make
~~~

Now the containers can be created running in the background with:

~~~sh
docker compose up -d
~~~

Then import terminologies as [described below](#usage).

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

The skript `import-terminologies.sh` takes a JSON file listing terminologies, each with their BARTOC URI (`uri`) and a download link (`distributions[0].download`). See [`terminologies.json`](terminologies.json) for an example and [JSKOS] for reference. The script registers each terminology using [n4o-graph-importer] and passes the download link to download and add it to the triple store. Afterwards the skript updates Skosmos configuration in `skosmos.ttl` to make terminologies accessible via Skosmos.

It is also possible to register and add individual terminologies using `import-terminologies.sh`. To do so the skript takes both the BARTOC URI and a download link, in this order, as arguments. The new terminology will be register and added to the triple store and the Skosmos config.

Skosmos configuration is updated after each import. This update can also be triggered without import by passing a file with an empty JSON array.

## License

MIT license

[Skosmos]: https://github.com/NatLibFi/Skosmos
[BARTOC]: https://bartoc.org/
[JSKOS]: https://gbv.github.io/jskos/
[n4o-graph-importer]: https://github.com/nfdi4objects/n4o-graph-importer
