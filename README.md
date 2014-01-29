geocoder
========

An Oracle based geocoder designed to be run cheaply on EC2 to geocode info from Twitter profiles

Once setup, you'll have a web service that will return lat/long for city names (note: not lat/longs for street addresses) that can be run on a small or a micro instance on EC2.

e.g.  calling: https://myservice.com/geocode/chicago

returns: {"location":"chicago","latitude": 41.881944, "longitude":-87.627778}


Instructions
------------

1. Boot up a micro or small instance on EC2, and configure it for OracleXE. There are two bash shell scripts that automate this:

https://github.com/jolson7168/ec2-scripts/bootScripts/oracleXEInit.sh
https://github.com/jolson7168/ec2-scripts/initScripts/oracleXEBoot.sh 

This first script automates launching the ec2 instance. It has configurable parameters to set the instance size, availability zone, etc. It also references the second script, which will configure the machine for OracleXE. The second script will autmoatically execute when the first script launches the instance.

You'll need your AWS_KEY and your AWS_SECRET_KEY for oracleXEInit.sh. This script also will require an RSA public key on your AWS account.

Also, to get the IP address of the machine once it has booted, use ec-describe-instances with the instance that is returned upon the execution of the first script.

2. Download OracleXE from http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html

Place the .zip file in /u01/download (created by the oracleXEBoot.sh script) as the oracle user.

NOTE: This step cannot be automated, because the user must agree to Oracle's license terms first.

3. Once OracleXE has been loaded onto the machine at /u01/download, execute /u01/git/oracle/scripts/install/XEinstall.sh as root. This will install and start OracleXE.

4. Create an oracle user and schema for the geospatial data, then load the schema with needed data (should already be on the machine). Executing script /u01/git/geocoder/src/scripts/loadData.sh as OS user oracle will do all of this for you. 

This step will take 25-30 minutes, as there are 8 million rows of data to be bulk loaded into the (heavily indexed) locations table.

5. Load the stored procedures...

6. Configure APEX...

7. Test the web service....
