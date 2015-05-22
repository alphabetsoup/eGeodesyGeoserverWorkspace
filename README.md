#GeodesyML Sample Workspace for Geoserver

##Installation
First install Geoserver 2.7+ [http://geoserver.org/] and PostGIS [http://postgis.net/install/].

Create a PostGIS database:

    createdb -T template_postgis survey_marks

Then run the scripts in `./dbmigrate/` as follows:

    cd dbmigrate
    cat migrate/tables.sql seeds/*.sql views/view.sql > all.sql
    psql -d surveymarks -U postgres -W -f all.sql

#Usage

To test the queries, log in to the Geoserver web instance (usually at [http://localhost:8080/geoserver/web]), navigate to the Demos page [http://localhost:8080/geoserver/web/?wicket:bookmarkablePage=:org.geoserver.web.demo.DemoRequestsPage], select the WFS_GetFeature_geo_Position.xml from the drop-down list and click submit.
