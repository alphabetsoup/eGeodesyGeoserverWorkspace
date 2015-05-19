  DROP TABLE "mark_coordinates";
  DROP TABLE "comments";
  DROP TABLE "creation_dates";
  DROP TABLE "mark_measurements";
  DROP TABLE "mark_uncertainty";
  DROP TABLE "mark_horizontal";
  DROP TABLE "mark_vertical";
  DROP TABLE "mark_name";
  DROP TABLE "mark_description";
  DROP TABLE "adjustment";
  DROP TABLE "adjustment_type";
  DROP TABLE "v_class";
  DROP TABLE "v_order";
  DROP TABLE "v_tech";
  DROP TABLE "h_class";
  DROP TABLE "h_order";
  DROP TABLE "h_tech";
  DROP TABLE "datum";
  DROP TABLE "name_type";
  DROP TABLE "mark_status";



  CREATE TABLESPACE "TSMES4" LOCATION '/mnt/sda1/postgresql/data';

  CREATE TABLE "mark_status" 
   (	"status" CHAR(2) NOT NULL, 
	"status_txt" VARCHAR(30) NOT NULL, 
	 CONSTRAINT "pk_mark_status" PRIMARY KEY ("status")
  USING INDEX TABLESPACE "TSMES4"
   ) 
  TABLESPACE "TSMES4" ;

  CREATE TABLE "adjustment_type" 
   (    "adj_type" CHAR(3) NOT NULL, 
	"adj_type_txt" VARCHAR(40) NOT NULL, 
	 CONSTRAINT "pk_adjustment_adj_type" PRIMARY KEY ("adj_type")
  USING INDEX TABLESPACE "TSMES4"
   ) 
  TABLESPACE "TSMES4" ;

  CREATE TABLE "mark_description" 
   (	"mark_id" NUMERIC(15,0), 
	"status" CHAR(2), 
	"block_no" CHAR(5), 
	"last_surveyor" VARCHAR(30), 
	"used_date" DATE, 
	"beacon" CHAR(1), 
	"map_number" CHAR(8), 
	"sc_map" CHAR(6), 
	"trig" CHAR(1), 
	"plan_ref" VARCHAR(500), 
	"date_amg_avail" DATE, 
	"date_mga_avail" DATE, 
	 CONSTRAINT "pk_mark_description" PRIMARY KEY ("mark_id")
  USING INDEX TABLESPACE "TSMES4", 
	 CONSTRAINT "fk_mark_description_status" FOREIGN KEY ("status")
	  REFERENCES "mark_status" ("status")
   ) 
  TABLESPACE "TSMES4" ;


  CREATE TABLE "mark_measurements" 
   (	"mark_id" NUMERIC(15,0) NOT NULL, 
	"msr_types" VARCHAR(200), 
	 PRIMARY KEY ("mark_id")
  USING INDEX TABLESPACE "TSMES4", 
	 CONSTRAINT "fk_mark_measurements_mark_id" FOREIGN KEY ("mark_id")
	  REFERENCES "mark_description" ("mark_id") 
   ) 
  TABLESPACE "TSMES4" ;


  CREATE TABLE "name_type" 
   (	"name_type" CHAR(1) NOT NULL, 
	"name_type_txt" VARCHAR(30) NOT NULL, 
	 CONSTRAINT "pk_name_type" PRIMARY KEY ("name_type")
  USING INDEX TABLESPACE "TSMES4"
   ) 
  TABLESPACE "TSMES4" ;


  CREATE TABLE "mark_name" 
   (	"mark_name_id" NUMERIC(15,0) NOT NULL, 
	"mark_id" NUMERIC(15,0) NOT NULL, 
	"nine_fig" CHAR(9) NOT NULL, 
	"mark_name" VARCHAR(30) NOT NULL, 
	"name_type" CHAR(1) NOT NULL, 
	"best_name" CHAR(1), 
	 CONSTRAINT "fk_mark_name_mark_id" FOREIGN KEY ("mark_id")
	  REFERENCES "mark_description" ("mark_id") , 
	 CONSTRAINT "fk_mark_name_name_type" FOREIGN KEY ("name_type")
	  REFERENCES "name_type" ("name_type") 
   ) 
  TABLESPACE "TSMES4" ;

  
    CREATE TABLE "mark_uncertainty" 
   (	"mark_id" NUMERIC(15,0) NOT NULL, 
	"adj_id" NUMERIC(9,0), 
	"xx" NUMERIC(23,20), 
	"xy" NUMERIC(23,20), 
	"xz" NUMERIC(23,20), 
	"yy" NUMERIC(23,20), 
	"yz" NUMERIC(23,20), 
	"zz" NUMERIC(23,20), 
	 PRIMARY KEY ("mark_id")
  USING INDEX TABLESPACE "TSMES4", 
	 CONSTRAINT "fk_mark_uncertainty_mark_id" FOREIGN KEY ("mark_id")
	  REFERENCES "mark_description" ("mark_id") 
   ) 
  TABLESPACE "TSMES4" ;

  CREATE TABLE "comments" 
   (	"comments_id" NUMERIC(15,0) NOT NULL, 
	"mark_id" NUMERIC(15,0) NOT NULL, 
	"user_id" VARCHAR(30) NOT NULL, 
	"com_date" DATE, 
	"comments" VARCHAR(1000) NOT NULL, 
	 CONSTRAINT "fk_comments_mark_id" FOREIGN KEY ("mark_id")
	  REFERENCES "mark_description" ("mark_id") 
   ) 
  TABLESPACE "TSMES4" ;

  CREATE TABLE "creation_dates" 
   (	"mark_id" NUMERIC(15,0), 
	"earliest_date" DATE, 
	"installed_by" VARCHAR(60)
   ) 
  TABLESPACE "TSMES4" ;

  CREATE TABLE "datum" 
   (	"d_code" CHAR(5) NOT NULL, 
	"d_type" CHAR(1) NOT NULL, 
    "d_epsg_code" INTEGER NOT NULL,
	"d_description" VARCHAR(50) NOT NULL, 
	 CONSTRAINT "pk_datum" PRIMARY KEY ("d_code")
  USING INDEX TABLESPACE "TSMES4"
   ) 
  TABLESPACE "TSMES4" ;


 CREATE TABLE "adjustment" 
   (	"adj_id" NUMERIC(15,0) NOT NULL, 
	"adj_date" DATE, 
	"adj_d_code" CHAR(8), 
	"adj_epoch" DATE, 
	"adj_runby" VARCHAR(50), 
	"best_adj" CHAR(1), 
	"dof" NUMERIC(15,0), 
	"measurement_count" NUMERIC(15,0), 
	"unknowns_count" NUMERIC(15,0), 
	"chi_square" NUMERIC(15,4), 
	"sigma_zero" NUMERIC(15,4), 
	"lower_limit" NUMERIC(15,4), 
	"upper_limit" NUMERIC(15,4), 
	"confidence_interval" NUMERIC(5,2), 
	"adj_type" CHAR(5), 
	 PRIMARY KEY ("adj_id")
  USING INDEX TABLESPACE "TSMES4", 
	 CONSTRAINT "fk_adjustment_adj_type" FOREIGN KEY ("adj_type")
	  REFERENCES "adjustment_type" ("adj_type") 
   ) 
  TABLESPACE "TSMES4" ;


CREATE TABLE "v_class" 
   (	"v_class" CHAR(2), 
	"v_class_txt" VARCHAR(40), 
	 CONSTRAINT "pk_v_class" PRIMARY KEY ("v_class")
  USING INDEX TABLESPACE "TSMES4"
   ) 
  TABLESPACE "TSMES4" ;


  CREATE TABLE "v_order" 
   (	"v_order" CHAR(2), 
	"v_order_txt" VARCHAR(30), 
	 CONSTRAINT "pk_v_order" PRIMARY KEY ("v_order")
  USING INDEX TABLESPACE "TSMES4"
   ) 
  TABLESPACE "TSMES4" ;


  CREATE TABLE "v_tech" 
   (	"v_tech" CHAR(3), 
	"v_tech_txt" VARCHAR(30), 
	 CONSTRAINT "pk_v_tech" PRIMARY KEY ("v_tech")
  USING INDEX TABLESPACE "TSMES4"
   ) 
  TABLESPACE "TSMES4" ;


  CREATE TABLE "h_class" 
   (	"h_class" CHAR(2), 
	"h_class_txt" VARCHAR(40), 
	 CONSTRAINT "pk_h_class" PRIMARY KEY ("h_class")
  USING INDEX TABLESPACE "TSMES4"
   ) 
  TABLESPACE "TSMES4" ;


  CREATE TABLE "h_order" 
   (	"h_order" CHAR(2), 
	"h_order_txt" VARCHAR(30), 
	 CONSTRAINT "pk_h_order" PRIMARY KEY ("h_order")
  USING INDEX TABLESPACE "TSMES4"
   ) 
  TABLESPACE "TSMES4" ;


  CREATE TABLE "h_tech" 
   (	"h_tech" CHAR(3), 
	"h_tech_txt" VARCHAR(30), 
	 CONSTRAINT "pk_h_tech" PRIMARY KEY ("h_tech")
  USING INDEX TABLESPACE "TSMES4"
   ) 
  TABLESPACE "TSMES4" ;


  CREATE TABLE "mark_horizontal" 
   (	"mark_h_id" NUMERIC(15,0) NOT NULL, 
	"mark_id" NUMERIC(15,0) NOT NULL, 
	"h_d_code" CHAR(5), 
	"h_class" CHAR(2), 
	"h_order" CHAR(2), 
	"h_technique" CHAR(3), 
	"h_organ" VARCHAR(30), 
	"x_coord" VARCHAR(10), 
	"y_coord" VARCHAR(11), 
	"zone" CHAR(2), 
	"h_date_surv" DATE, 
	"h_date_adj" DATE, 
	"h_date_edit" DATE, 
	"h_uncert" NUMERIC(6,3), 
	 CONSTRAINT "pk_mark_horizontal_mark_h_id" PRIMARY KEY ("mark_h_id")
  USING INDEX TABLESPACE "TSMES4", 
	 CONSTRAINT "fk_mark_horizontal_h_d_code" FOREIGN KEY ("h_d_code")
	  REFERENCES "datum" ("d_code") , 
	 CONSTRAINT "fk_mark_horizontal_h_class" FOREIGN KEY ("h_class")
	  REFERENCES "h_class" ("h_class") , 
	 CONSTRAINT "fk_mark_horizontal_h_order" FOREIGN KEY ("h_order")
	  REFERENCES "h_order" ("h_order") , 
	 CONSTRAINT "fk_mark_horizontal_h_tech" FOREIGN KEY ("h_technique")
	  REFERENCES "h_tech" ("h_tech") , 
	 CONSTRAINT "fk_mark_horizontal_mark_id" FOREIGN KEY ("mark_id")
	  REFERENCES "mark_description" ("mark_id") 
   ) 
  TABLESPACE "TSMES4" ;
  

 CREATE TABLE "mark_vertical" 
   (	"mark_v_id" NUMERIC(15,0) NOT NULL, 
	"mark_id" NUMERIC(15,0) NOT NULL, 
	"v_d_code" CHAR(5) NOT NULL, 
	"v_class" CHAR(2), 
	"v_order" CHAR(2), 
	"z_coord" VARCHAR(8) NOT NULL, 
	"v_technique" CHAR(3), 
	"v_date_surv" DATE, 
	"v_date_adj" DATE, 
	"v_date_edit" DATE, 
	"v_organ" VARCHAR(30), 
	"sec" CHAR(4), 
	"best_vert" CHAR(1), 
	"adj_id" NUMERIC(15,0), 
	"v_uncert" NUMERIC(6,3), 
	 CONSTRAINT "fk_mark_vertical_mark_id" FOREIGN KEY ("mark_id")
	  REFERENCES "mark_description" ("mark_id") , 
	 CONSTRAINT "fk_mark_vertical_v_d_code" FOREIGN KEY ("v_d_code")
	  REFERENCES "datum" ("d_code") , 
	 CONSTRAINT "fk_mark_vertical_v_class" FOREIGN KEY ("v_class")
	  REFERENCES "v_class" ("v_class") , 
	 CONSTRAINT "fk_mark_vertical_v_order" FOREIGN KEY ("v_order")
	  REFERENCES "v_order" ("v_order") , 
	 CONSTRAINT "fk_mark_vertical_v_tech" FOREIGN KEY ("v_technique")
	  REFERENCES "v_tech" ("v_tech") 
   ) 
  TABLESPACE "TSMES4" ;
  

CREATE TABLE "mark_coordinates" 
   (	"mark_id" NUMERIC(15,0) NOT NULL, 
	"mark_coord_id" NUMERIC(15,0) NOT NULL, 
	"adj_id" NUMERIC(15,0), 
	"latitude" NUMERIC(15,12), 
	"longitude" NUMERIC(15,12), 
	"ellipsoid_height" NUMERIC(10,5), 
	"easting" NUMERIC(15,5), 
	"northing" NUMERIC(15,5), 
	"zone" NUMERIC(2,0), 
	"datum_code" CHAR(5), 
	"technique" CHAR(3), 
	"organisation" VARCHAR(30), 
	"date_surv" DATE, 
	"date_edit" DATE, 
	"h_order" CHAR(2), 
	"pos_uncertainty" NUMERIC(6,3), 
	"best_coords" CHAR(1), 
	 PRIMARY KEY ("mark_coord_id") 
    USING INDEX TABLESPACE "TSMES4", 
	 CONSTRAINT "fk_mark_coordinates_mark_id" FOREIGN KEY ("mark_id")
	  REFERENCES "mark_description" ("mark_id"), 
	 CONSTRAINT "fk_mark_coordinates_datum_code" FOREIGN KEY ("datum_code")
	  REFERENCES "datum" ("d_code")
   )
  TABLESPACE "TSMES4" ;
