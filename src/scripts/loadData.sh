#!/bin/bash
#as OS user oracle...

echo "CREATE TABLESPACE geo NOLOGGING DATAFILE '/u01/oradata/xe/geo1.dbf' SIZE 250M,'/u01/oradata/xe/geo2.dbf' SIZE 250M,'/u01/oradata/xe/geo3.dbf' SIZE 250M,'/u01/oradata/xe/geo4.dbf' SIZE 250M autoextend on;" | sqlplus / as sysdba
echo 'create user geo identified by geo default tablespace geo;' | sqlplus / as sysdba
echo 'grant all privileges to geo;' | sqlplus / as sysdba

echo '@/u01/git/geocoder/src/sql/CreateSchema.sql;' |sqlplus geo/geo
/u01/git/geocoder/src/scripts/importcountries.sh geo geo
echo '@/u01/git/geocoder/src/sql/CreateIndexes.sql;' |sqlplus geo/geo
/u01/git/geocoder/src/scripts/importstates.sh geo geo
