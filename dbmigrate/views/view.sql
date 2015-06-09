drop view sites_simple;
drop view sitelogs_simple;
drop view position_timeseries;
drop view position_timeslice;
drop view nodes_simple;
drop view adjustments_simple;

create view sites_simple as
(
    select concat('site_',md.mark_id) as gid, 
    md.mark_id as site_id, 
    md.mark_id, 
    mn.nine_fig, mn.mark_name,
    ms.status_txt, md.used_date,
    nt.name_type_txt,
    ST_SETSRID(ST_POINT(mc.longitude, mc.latitude), datum.d_epsg_code) as geom
    from mark_description as md
    join mark_name as mn on mn.mark_id = md.mark_id
    join mark_coordinates as mc on mc.mark_id = md.mark_id
    join datum on datum.d_code = mc.datum_code
    join mark_status as ms on ms.status = md.status
    join name_type as nt on mn.name_type = nt.name_type
);

create view sitelogs_simple as
(
    select concat('sitelog_',md.mark_id) as gid, 
    ST_SETSRID(ST_POINT(mc.longitude, mc.latitude), datum.d_epsg_code) as geom
    from mark_description as md
    join mark_coordinates as mc on mc.mark_id = md.mark_id
    join datum on datum.d_code = mc.datum_code
);

create view nodes_simple as
(
    select concat('node_',md.mark_id) as gid, 
    concat('site_',md.mark_id) as at_site, 
    md.mark_id as node_id, 
    md.mark_id, 
    ms.status_txt, md.date_mga_avail,
    mc.organisation,
    mc.date_surv, mc.date_edit,
    at.adj_type_txt,
    ST_SETSRID(ST_POINT(mc.longitude, mc.latitude), datum.d_epsg_code) as geom
    from mark_description as md
    join mark_name as mn on mn.mark_id = md.mark_id
    join mark_coordinates as mc on mc.mark_id = md.mark_id
    join adjustment as a on a.adj_id = mc.adj_id
    join adjustment_type as at on a.adj_type = at.adj_type
    join datum on datum.d_code = mc.datum_code
    join mark_status as ms on ms.status = md.status
    join name_type as nt on mn.name_type = nt.name_type
);

create view position_timeseries as
(
    select concat('position_',md.mark_id) as gid, 
    concat('node_',md.mark_id) as at_node, 
    md.mark_id, 
    md.date_mga_avail,

    (
        select 
        datum.d_epsg_code
        from mark_coordinates as mc
        join datum on datum.d_code = mc.datum_code
        where md.mark_id = mc.mark_id
        order by mc.date_surv desc
        limit 1
    ) as d_epsg_code,

    (
        select 
        ms.status_txt
        from mark_status as ms
        where md.status = ms.status
        limit 1
    ) as status_txt,

    (
        select 
        ST_SETSRID(ST_POINT(mc.longitude, mc.latitude), datum.d_epsg_code)
        from mark_coordinates as mc
        join datum on datum.d_code = mc.datum_code
        where md.mark_id = mc.mark_id
        order by mc.date_surv desc
        limit 1
    ) as geom

    from mark_description as md

    group by md.mark_id
);
-- removed joins
--  join mark_name as mn on mn.mark_id = md.mark_id
--  join mark_status as ms on ms.status = md.status
--  join name_type as nt on mn.name_type = nt.name_type

-- coordinateinstances_simple is, for now, a copy of positions_simple with two modifications:
-- 1) gid begins with coordinateinstance_, the numerical part of the id is the same
-- 2) new column pid is the foreign key to positions_simple
-- Both positions_simple and coordinateinstances_simple will later change further, for now,
-- this is the minimum needed to demonstrate GeoServer feature chaning between positions and
-- coordinate instances.
create view position_timeslice as
(
    select concat('coordinateinstance_',mc.mark_coord_id) as gid, 
    concat('position_',mc.mark_id) as pid, 
    md.mark_id, 
    ms.status_txt, md.date_mga_avail,
    mc.date_surv, mc.date_edit,

    mc.mark_coord_id, 
    mc.adj_id as adj_id,
    mc.latitude,
    mc.longitude,
    mc.easting,
    mc.northing,
    mc.zone,
    mc.datum_code,
    mc.technique,
    mc.organisation,
    mc.h_order,
    mc.best_coords,
    mc.ellipsoid_height,
    mc.pos_uncertainty,
    datum.d_epsg_code,

    ST_SETSRID(ST_POINT(mc.longitude, mc.latitude), datum.d_epsg_code) as srs_loc

    from mark_description as md

    join mark_name as mn on mn.mark_id = md.mark_id
    join mark_coordinates as mc on mc.mark_id = md.mark_id
    join datum on datum.d_code = mc.datum_code
    join mark_status as ms on ms.status = md.status
    join name_type as nt on mn.name_type = nt.name_type
    join adjustment as a on a.adj_id = mc.adj_id
    join adjustment_type as at on a.adj_type = at.adj_type
);

create view adjustments_simple as
(
    select concat('adj_',a.adj_id) as gid, 
    a.adj_id,
    a.adj_date,
    a.adj_d_code,
    a.adj_epoch,
    a.adj_runby,
    a.best_adj,
    a.dof,
    a.measurement_count,
    a.unknowns_count,
    a.chi_square,
    a.sigma_zero,
    a.lower_limit,
    a.upper_limit,
    a.confidence_interval,
    a.adj_type, 
    at.adj_type_txt,
    datum.d_epsg_code,

    ST_SETSRID( ST_Extent(ST_POINT(mc.longitude,mc.latitude)), datum.d_epsg_code) as geom

    from adjustment as a

    left join mark_coordinates as mc on mc.adj_id = a.adj_id
    join datum on datum.d_code = a.adj_d_code
    inner join adjustment_type as at on at.adj_type = a.adj_type
    group by a.adj_id, at.adj_type_txt, datum.d_epsg_code
);
