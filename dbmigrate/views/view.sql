drop view sites_simple;
drop view positions_simple;
drop view nodes_simple;
drop view adjustments_simple;

create view sites_simple as
(
    select concat('site_',md.mark_id) as gid, 
    md.mark_id, 
    mn.nine_fig, mn.mark_name,
    ms.status_txt, md.used_date,
    nt.name_type_txt,
    ST_SETSRID(ST_POINT(mc.longitude, mc.latitude), datum.d_epsg_code) as srs_loc
    from mark_description as md
    join mark_name as mn on mn.mark_id = md.mark_id
    join mark_coordinates as mc on mc.mark_id = md.mark_id
    join datum on datum.d_code = mc.datum_code
    join mark_status as ms on ms.status = md.status
    join name_type as nt on mn.name_type = nt.name_type
);

create view nodes_simple as
(
    select concat('node_',md.mark_id) as gid, 
    md.mark_id, 
    ms.status_txt, md.date_mga_avail,
    mc.organisation,
    mc.date_surv, mc.date_edit,
    ST_SETSRID(ST_POINT(mc.longitude, mc.latitude), datum.d_epsg_code) as srs_loc
    from mark_description as md
    join mark_name as mn on mn.mark_id = md.mark_id
    join mark_coordinates as mc on mc.mark_id = md.mark_id
    join datum on datum.d_code = mc.datum_code
    join mark_status as ms on ms.status = md.status
    join name_type as nt on mn.name_type = nt.name_type
);

create view positions_simple as
(
    select concat('position_',mc.mark_coord_id) as gid, 
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
    mc.date_surv,
    mc.date_edit,
    mc.h_order,
    mc.best_coords,
    mc.ellipsoid_height,
    mc.pos_uncertainty,

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
    select concat('position_',mc.mark_coord_id) as gid, 
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

    ST_SETSRID( ST_Extent(p.srs_loc), datum.d_epsg_code) as srs_envelope

    from adjustment as a

    join positions_simple as p on p.adj_id = a.adj_id
    join datum on datum.d_code = a.adj_d_code
    join adjustment_type as at on a.adj_type = at.adj_type
);
