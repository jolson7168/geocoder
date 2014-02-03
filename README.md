geocoder
========

An Oracle based geocoder designed to be run cheaply on EC2 to geocode info from Twitter profiles

Once setup, you'll have a web service that will return lat/long for city names (note: not lat/longs for street addresses) that can be run on a small or a micro instance on EC2.

e.g.  calling: https://myservice.com/geocode/chicago

returns: {"location":"chicago","latitude": 41.881944, "longitude":-87.627778}

Please note the code in this repository is designed for a low-cost EC2 geocoder. It is designed for a micro instance. In the event you wish to pay for decent Oracle-level performance, you'll need to tweak the code to use an IOPS level EC2 instance, and tune the Oracle configuration script to set up a seperate tablespace for indexes, optimize RAM usage in the SGA, etc. The scripts and SQL here should provide a good start for that.

The dataset that gets loaded into Oracle to use as the basis for the city / coordinate lookup issourced from www.geonames.org. It has over 8 million worldwide cities.

Instructions
------------

1. Boot up a micro or small instance on EC2, and configure it for OracleXE. There are two bash shell scripts that automate this:

https://github.com/jolson7168/ec2-scripts/bootScripts/oracleXEInit.sh
https://github.com/jolson7168/ec2-scripts/initScripts/oracleXEBoot.sh 

This first script automates launching the ec2 instance. It has configurable parameters to set the instance size, availability zone, etc. It also references the second script, which will configure the machine for OracleXE. The second script will autmoatically execute when the first script launches the instance.

You'll need your AWS_KEY and your AWS_SECRET_KEY for oracleXEInit.sh. This script also will require an RSA public key on your AWS account, and an appropriate AWS security group set up (important ports for this: 22 (ssh), 8080 (Apex), 1521 (Oracle))

Also, to get the IP address of the machine once it has booted, use ec-describe-instances with the instance that is returned upon the execution of the first script.

2. Download OracleXE from http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html

Place the .zip file in /u01/download (/u01/download is created by the oracleXEBoot.sh script) as the oracle user.

NOTE: This step cannot be automated, because the user must agree to Oracle's license terms first.

3. Once OracleXE has been loaded onto the machine at /u01/download, execute /u01/git/oracle/scripts/install/XEinstall.sh as root. This will install and start OracleXE. It configures the SYS and SYSMAN passwords via the autoconfiguration script at /u01/git/oracle/scripts/install/OracleXESilentInst.iss, so PLEASE change the SYS and SYSMAN passwords when you get a chance.

Also, this will create a logfile in /u01/logs/XEsilentinstall.log which you can tail -f to see progress.

4. After OracleXE install and starts in step #3, the next step is to install a user and schema, and populate the schema with data. Execute /u01/git/geocoder/src/scripts/loadData.sh as the oracle OS user. This step will take several hours, as 8 million rows will be loaded into the GEO schema. When finished, you'll have a oracle user 'geo' with password 'geo', and the stored procedures to lookup the coordinates for a given set of inputs, a set of stored procedures to convert the Oracle recordset to JSON, and to pass it to the webservice managed by Apex.

Also, this will create a logfile in /u01/logs/oracleSetup.log which you can tail -f to see progress.


5. Test the web service:
    http://<EC2 IP ADDRESS>:8080/apex/geo.getcoords?OriginalLocation=Chicago,Illinois&InLocation=Chicago&Admin1=Illinois
   Should return:
    {"results":[{"ORIGINALLOCATION":"Chicago,Illinois","LOCATIONNAME":"Chicago","LATITUDE":41.85003,"LONGITUDE":-87.65005,"STATUS":"Found"}]}


To Dos
------------
1. Document the service call, especially how a collision is resolved (two cities named the same thing).
2. How do I put the oracle OS user in the sudoers group? Tried several ways, none worked. This would simplify a few steps
3. Calculate throughput (# of requests per second) on a t1.micro and m1.small instance so we can write a 'cost per geocode' equation
