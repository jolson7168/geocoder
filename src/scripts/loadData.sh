#!/bin/bash
#as OS user oracle...

echo "`date` ======Oracle Configuration Log=====" > /u01/logs/oracleSetup.log
echo "`date` ======CREATING TABLESPACE...." >> /u01/logs/oracleSetup.log
echo "CREATE TABLESPACE geo NOLOGGING DATAFILE '/u01/oradata/xe/geo1.dbf' SIZE 250M,'/u01/oradata/xe/geo2.dbf' SIZE 250M,'/u01/oradata/xe/geo3.dbf' SIZE 250M,'/u01/oradata/xe/geo4.dbf' SIZE 250M autoextend on;" | sqlplus / as sysdba >> /u01/logs/oracleSetup.log

echo "`date` ======CREATING USER GEO...." >> /u01/logs/oracleSetup.log
echo 'create user geo identified by geo default tablespace geo;' | sqlplus / as sysdba >> /u01/logs/oracleSetup.log
echo 'grant all privileges to geo;' | sqlplus / as sysdba >> /u01/logs/oracleSetup.log

echo "`date` ======CREATING SCHEMA...." >> /u01/logs/oracleSetup.log
echo '@/u01/git/geocoder/src/sql/CreateSchema.sql;' |sqlplus geo/geo >> /u01/logs/oracleSetup.log

echo "`date` ======IMPORTING TABLE LOCATIONS...." >> /u01/logs/oracleSetup.log
/u01/git/geocoder/src/scripts/importcountries.sh geo geo >> /u01/logs/oracleSetup.log

echo "`date` ======INDEXING TABLE LOCATIONS...." >> /u01/logs/oracleSetup.log
echo '@/u01/git/geocoder/src/sql/CreateIndexes.sql;' |sqlplus geo/geo >> /u01/logs/oracleSetup.log

echo "`date` ======IMORTING TABLE STATES...." >> /u01/logs/oracleSetup.log
/u01/git/geocoder/src/scripts/importstates.sh geo geo >> /u01/logs/oracleSetup.log

echo "`date` ======EXECUTING POST IMPORT...." >> /u01/logs/oracleSetup.log
echo '@/u01/git/geocoder/src/sql/PostImport.sql;' |sqlplus geo/geo >> /u01/logs/oracleSetup.log

echo "`date` ======INSTALLING JSON PACKAGES...." >> /u01/logs/oracleSetup.log
echo '@/u01/download/json/install.sql;' |sqlplus geo/geo >> /u01/logs/oracleSetup.log

echo "`date` ======INSTALLING JSON SUPPORT PACKAGES...." >> /u01/logs/oracleSetup.log
echo '@/u01/download/json/addons/json_dyn.sql;' |sqlplus geo/geo >> /u01/logs/oracleSetup.log
echo '@/u01/download/json/addons/jsonml.sql;' |sqlplus geo/geo >> /u01/logs/oracleSetup.log
echo '@/u01/download/json/addons/json_xml.sql;' |sqlplus geo/geo >> /u01/logs/oracleSetup.log
echo '@/u01/download/json/addons/json_util_pkg.sql;' |sqlplus geo/geo >> /u01/logs/oracleSetup.log
echo '@/u01/download/json/addons/json_helper.sql;' |sqlplus geo/geo >> /u01/logs/oracleSetup.log


echo "`date` ======END Oracle Configuration Log=====" >> /u01/logs/oracleSetup.log
