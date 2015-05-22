#GeodesyML Sample Workspace for Geoserver

##Installation
First install [Tomcat7](http://tomcat.apache.org/), [Geoserver 2.7+](http://geoserver.org/) as a *.war extension to Tomcat, and [PostGIS](http://postgis.net/install/).

Pull this repository:

    git clone https://github.com/alphabetsoup/eGeodesyGeoserverWorkspace.git

Set the permissions to all-write so that Geoserver can write to the workspace.

    sudo chmod -R 777 eGeodesyGeoserverWorkspace/

Assign the resultant directory eGeodesyGeoserverWorkspace as the current workspace in Geoserver. To do this, locate the web.xml file usually at the below location:

    cd /var/lib/tomcat7/webapps/geoserver/WEB-INF/
    sudo nano web.xml 

Locate and uncomment the following option, filling in the value with the path to your eGeodesyGeoserverWorkspace clone.

    <context-param>
        <param-name>GEOSERVER_DATA_DIR</param-name>
        <param-value>/path/to/eGeodesyGeoserverWorkspace</param-value>
    </context-param>

Create a PostGIS database:

    createdb -T template_postgis survey_marks

Then run the scripts in `./dbmigrate/` as follows:

    cd dbmigrate
    cat migrate/tables.sql seeds/*.sql views/view.sql > all.sql
    psql -d surveymarks -U postgres -W -f all.sql

#Usage

To test the queries, log in to the Geoserver web instance (usually [localhost:8080/geoserver/web](http://localhost:8080/geoserver/web)), navigate to the [Demos page](http://localhost:8080/geoserver/web/?wicket:bookmarkablePage=:org.geoserver.web.demo.DemoRequestsPage), select the WFS_GetFeature_geo_Position.xml from the drop-down list and click submit.
