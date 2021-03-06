/*Creates a schema on Oracle that serves as the basis of an Oracle/Apex geocoding web service.*/
/*This is intended to be run on a small/micro AMI on EC2 to server a low level*/
/*geocoding load.*/

/*This was designed to turn Twitter profile information into a lat/long.*/

/*Data to populate locations can be found at http://download.geonames.org/export/dump/Allcountries.zip */
/*Data to populate states table is attached to the project as USStates.csv */

CREATE TABLE LOCATIONS  ( 
	GEONAMEID     	NUMBER(*, 0) NOT NULL,
	LOCATIONNAME  	VARCHAR2(500) NULL,
	ASCIINAME     	VARCHAR2(200) NULL,
	ALTERNATENAMES	CLOB NULL,
	LATITUDE      	NUMBER(15,8) NULL,
	LONGITUDE     	NUMBER(15,8) NULL,
	FEATURECLASS  	VARCHAR2(1) NULL,
	FEATURECODE   	VARCHAR2(10) NULL,
	COUNTRYCODE   	VARCHAR2(2) NULL,
	CC2           	VARCHAR2(60) NULL,
	ADMIN1        	VARCHAR2(100) NULL,
	ADMIN2        	VARCHAR2(100) NULL,
	ADMIN3        	VARCHAR2(100) NULL,
	ADMIN4        	VARCHAR2(100) NULL,
	POPULATION    	NUMBER(*, 0) NULL,
	ELEVATION     	NUMBER(*, 0) NULL,
	DEM           	NUMBER(*, 0) NULL,
	TIMEZONE      	VARCHAR2(40) NULL,
	MODDATE       	VARCHAR2(20) NULL,
	ADMIN1LONG    	VARCHAR2(200) NULL,
	PRIMARY KEY(GEONAMEID)
	NOT DEFERRABLE
	 VALIDATE
);

CREATE TABLE STATES  ( 
	STATE_ID  	NUMBER(*, 0) NOT NULL,
	STATE_NAME	VARCHAR2(32) NULL,
	STATE_ABBR	VARCHAR2(8) NULL,
	PRIMARY KEY(STATE_ID)
	NOT DEFERRABLE
	 VALIDATE
);


CREATE UNIQUE INDEX UK1_STATES
	ON STATES(UPPER("STATE_ABBR"));
sqlpl
