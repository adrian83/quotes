#!/bin/bash

configPath="./infra/local.json"

esVersion="6.4.1"
postgresVersion="11.1"

postgresEnvTemplatePath="./infra/env.db.template";
postgresEnvPath="./infra/env.db";
postgresInitScript="./infra/db.sql";


usage() {
	cat <<EOF

    Usage: $(basename $0) <command>

	run-docker 	runs docker daemon (systemd).
	run-infra 	infrastructure
				- docker image with elasticsearch:$esVersion
				- docker image with postgres:$postgresVersion
	init-db 	initialize database

EOF
	exit 1
}

run-docker() {
	set -e
		sudo systemctl start docker
	set +e
}


run-infra() {
	set -e
		run-elasticsearch
		run-postgres
	set +e
}

run-postgres() {
	set -e
		cp $postgresEnvTemplatePath $postgresEnvPath

		rawDb=$(jq '.postgres.database' $configPath)
		db=$(echo $rawDb | cut -d "\"" -f 2)

		rawUser=$(jq '.postgres.user' $configPath)
		user=$(echo $rawUser | cut -d "\"" -f 2)

		rawPass=$(jq '.postgres.password' $configPath)
		pass=$(echo $rawPass | cut -d "\"" -f 2)

		sed -i -e "s/--db-name--/${db}/g" $postgresEnvPath
		sed -i -e "s/--db-user--/${user}/g" $postgresEnvPath
		sed -i -e "s/--db-pass--/${pass}/g" $postgresEnvPath

		cat $postgresEnvPath

		dbPort=$(jq '.postgres.port' $configPath)

		docker run -p 5432:$dbPort --env-file=$postgresEnvPath -d postgres:$postgresVersion
	set +e
}

run-elasticsearch() {
	set -e
		esPort=$(jq '.elasticsearch.port' $configPath)
		
		echo docker run -d -p 9200:$esPort -p 9300:9300 -e \"discovery.type=single-node\" elasticsearch:$esVersion

		docker run -d -p 9200:$esPort -p 9300:9300 -e \"discovery.type=single-node\" elasticsearch:$esVersion
		
	set +e
}



CMD="$1"
shift
case "$CMD" in
	run-docker)
		run-docker
	;;
	run-infra)
		run-infra
	;;
	*)
		usage
	;;
esac
