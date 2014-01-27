OPTIONS (SKIP=1,ERRORS = 0)
load data
infile '../../data/USStates.csv'
APPEND into table STATES
TRAILING NULLCOLS
(
	STATE_ID	INTEGER EXTERNAL TERMINATED BY ',',
	STATE_NAME	CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	STATE_ABBR	CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
)