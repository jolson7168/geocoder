geocoder
========

An Oracle based geocoder designed to be run cheaply on EC2 to geocode info from Twitter profiles

Once setup, you'll have a web service that will return lat/long for city names (note: not lat/longs for street addresses) that can be run on a small or a micro instance on EC2.

e.g.  calling: https://myservice.com/geocode/chicago

returns: {"location":"chicago","latitude": 41.881944, "longitude":-87.627778}


Instructions
------------

1. Launch a copy of public ami ami-ae37c8c7 on EC2. This is a 64 bit version of Oracle XE that comes preinstalled with APEX. You can use a micro instance. 
Reference: http://www.pythian.com/blog/oracle-database-11g-xe-beta-amazon-ec2-image/

2. Once you have the DB and app server up, create an oracle user on the db, and create the db schema using ./src/sql/CreateSchema.sql 

3. Load the two tables in the schema with data. Data for the locations table comes from http://download.geonames.org/export/dump/Allcountries.zip. Data for the state table is in ./data/USStates.csv. The sqlldr scripts to load these datasets is in ./src/scripts

4. To be continued... 
