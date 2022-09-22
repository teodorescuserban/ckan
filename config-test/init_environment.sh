#!/bin/sh

# Database Creation
psql --host=ckan-postgres --username=ckan --command="CREATE USER ${CKAN_POSTGRES_USER} WITH PASSWORD '${CKAN_POSTGRES_PWD}' NOSUPERUSER NOCREATEDB NOCREATEROLE;"
createdb --encoding=utf-8 --host=ckan-postgres --username=ckan --owner=${CKAN_POSTGRES_USER} ${CKAN_POSTGRES_DB}
psql --host=ckan-postgres --username=ckan --command="CREATE USER ${CKAN_DATASTORE_POSTGRES_READ_USER} WITH PASSWORD '${CKAN_DATASTORE_POSTGRES_READ_PWD}' NOSUPERUSER NOCREATEDB NOCREATEROLE;"
psql --host=ckan-postgres --username=ckan --command="CREATE USER ${CKAN_DATASTORE_POSTGRES_WRITE_USER} WITH PASSWORD '${CKAN_DATASTORE_POSTGRES_WRITE_PWD}' NOSUPERUSER NOCREATEDB NOCREATEROLE;"
createdb --encoding=utf-8 --host=ckan-postgres --username=ckan --owner=${CKAN_DATASTORE_POSTGRES_WRITE_USER} ${CKAN_DATASTORE_POSTGRES_DB}

# Database Initialization
ckan -c test-core-circle-ci.ini datastore set-permissions | psql --host=ckan-postgres --username=ckan
psql --host=ckan-postgres --username=ckan --dbname=${CKAN_DATASTORE_POSTGRES_DB} --command="CREATE extension tablefunc;"
ckan -c test-core-circle-ci.ini db init
gunzip .test_durations.gz
