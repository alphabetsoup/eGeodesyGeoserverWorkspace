create view sites_simple as
(select concat('site_',md.mark_id) as gid, md.mark_id, md.status, mn.nine_fig, mn.mark_name,
ST_SETSRID(ST_POINT(mc.longitude, mc.latitude), datum.d_epsg_code) as gda94_loc
from mark_description as md
join mark_name as mn on mn.mark_id = md.mark_id
join mark_coordinates as mc on mc.mark_id = md.mark_id
join datum on datum.d_code = mc.datum_code);
