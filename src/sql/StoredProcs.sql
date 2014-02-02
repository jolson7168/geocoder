/*
http://184.73.249.62:8080/apex/geo.getcoords?OriginalLocation=Chicago,Illinois&InLocation=Chicago&Admin1=Illinois
http://184.73.249.62:8080/apex/geo.getcoords?OriginalLocation=Chicago,Illinois&InLocation=Chicago&Admin1=Il
http://184.73.249.62:8080/apex/geo.getcoords?OriginalLocation=Chicago&InLocation=Chicago     --slow

http://184.73.249.62:8080/apex/geo.getcoords?OriginalLocation=Pittsburgh%20PA&InLocation=Pittsburgh%20PA
http://184.73.249.62:8080/apex/geo.getcoords?OriginalLocation=VT%0D&InLocation=VT%0D
*/

CREATE OR REPLACE PROCEDURE GEO.GETCOORDS(OriginalLocation nvarchar2, InLocation varchar2, Admin1 varchar2 default null)
IS
        ret json_list;
        jsonObj json;
        vSQL varchar2(4000);
        num integer;
	inL varchar2(1000);
	inO nvarchar2(1000);
	inA varchar2(1000);
BEGIN

	inO:= replace(OriginalLocation,'''','''''');
	inL:=replace(replace(InLocation,'''',''''''),chr(13),'');
	inA:=replace(replace(Admin1,'''',''''''),chr(13),'');
        jsonObj := json();
        vSQL := '';

	--Oracle insists on decoding 0xd as \f instead of \r. Bug?
	--if( instr(OriginalLocation,chr(13)) = (length(OriginalLocation)) ) then
	--	inO:=replace(inO,chr(13),chr(12));
	--end if;

if (Admin1 is null) then
    select count(*) into num from locations where upper(locationname) = upper(trim(InL));
    if (num <= 0) then
--inO or OriginalLocation???
        vSQL := 'select '||chr(39)||inO||chr(39)||' as originallocation,'||chr(39)||inL||chr(39)||' as Locationname, null as latitude, null as longitude,'||chr(39)||'Not Found'||chr(39)|| ' as status from dual';
    else
        vSQL := 'select '||chr(39)||inO||chr(39)||' as originallocation, locationname,latitude, longitude,'||chr(39)||'Found'||chr(39)|| ' as status from locations where (upper(locationname), population) in (select upper(locationname) as loc, max(population) as pop from locations where upper(locationname) = '||chr(39)||upper(trim(inL))||chr(39)||' group by upper(locationname))';
    end if;
elsif (length(trim(InA))>2) then
    select count(*) into num from locations where upper(locationname) = upper(trim(InL)) and upper(admin1Long)=upper(trim(InA));
    if (num <= 0) then
        vSQL := 'select '||chr(39)||inO||chr(39)||' as originallocation,'||chr(39)||inL||chr(39)||' as Locationname, null as latitude, null as longitude,'||chr(39)||'Not Found'||chr(39)|| ' as status from dual';
    else
        vSQL := 'select '||chr(39)||inO||chr(39)||' as originallocation, locationname,latitude, longitude,'||chr(39)||'Found'||chr(39)|| ' as status from locations where (upper(locationname), upper(admin1Long), population) in (select upper(locationname) as loc, upper(admin1Long) as admin1Long, max(population) as pop from locations where upper(locationname) = '||chr(39)||upper(trim(inL))||chr(39)||' and upper(admin1Long) = '||chr(39)||upper(trim(inA))||chr(39)|| 'group by upper(locationname), upper(admin1Long))';
    end if;
else
    select count(*) into num from locations where upper(locationname) = upper(trim(InL)) and upper(admin1)=upper(trim(InA));
    if (num <= 0) then
        vSQL := 'select '||chr(39)||inO||chr(39)||' as originallocation,'||chr(39)||inL||chr(39)||' as Locationname, null as latitude, null as longitude,'||chr(39)||'Not Found'||chr(39)|| ' as status from dual';
    else
        vSQL := 'select '||chr(39)||inO||chr(39)||' as originallocation, locationname,latitude, longitude,'||chr(39)||'Found'||chr(39)|| ' as status from locations where (upper(locationname), upper(admin1), population) in (select upper(locationname) as loc, upper(admin1) as admin1, max(population) as pop from locations where upper(locationname) = '||chr(39)||upper(trim(inL))||chr(39)||' and upper(admin1) = '||chr(39)||upper(trim(inA))||chr(39)|| 'group by upper(locationname), upper(admin1))';
    end if;
end if;
    ret := json_dyn.executeList(vSQL);
        jsonObj.put('results',ret);
        jsonObj.htp();
END;
/

/*

insert into locations
select
9000000,
'Netherlands',
'Netherlands',
'',
A.latitude,
A.longitude,
A.featureclass,
A.featurecode,
A.countrycode,
A.cc2,
A.admin1,
A.admin2,
A.admin3,
A.admin4,
A.population,
A.elevation,
A.dem,
A.timezone,
A.moddate

from (select * from locations where geonameid = 2759794) A
*/

/*

db.screennamesloc.update({location:"Rio,Brasil","geocodestatus":"Geocoding success"},{$unset:{geocodedate:1,coordinates:1,geocodestatus:1}},false,true);
*/

