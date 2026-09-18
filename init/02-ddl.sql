
SET search_path TO incendies, public;

-- DROP SEQUENCE incendies.commune_id_commune_seq;

CREATE SEQUENCE incendies.commune_id_commune_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE incendies.experiment_id_seq;

CREATE SEQUENCE incendies.experiment_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE incendies.incendie_id_incendie_seq;

CREATE SEQUENCE incendies.incendie_id_incendie_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE incendies.localisation_id_localisation_seq;

CREATE SEQUENCE incendies.localisation_id_localisation_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE incendies.nature_id_seq;

CREATE SEQUENCE incendies.nature_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32767
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE incendies.precision_surface_id_seq;

CREATE SEQUENCE incendies.precision_surface_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32767
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE incendies.region_id_seq;

CREATE SEQUENCE incendies.region_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32767
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE incendies.type_cluster_id_seq;

CREATE SEQUENCE incendies.type_cluster_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32767
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE incendies.type_peuplement_id_seq;

CREATE SEQUENCE incendies.type_peuplement_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32767
	START 1
	CACHE 1
	NO CYCLE;-- incendies.commune_jour definition

-- Drop table

-- DROP TABLE incendies.commune_jour;

CREATE TABLE incendies.commune_jour (
	id_commune int4 NOT NULL,
	date_jour date NOT NULL,
	has_fire int2 NULL,
	nb_incendies_30j int4 NULL,
	nb_incendies_90j int4 NULL,
	nb_incendies_365j int4 NULL,
	surface_totale_5a int4 NULL,
	buffer_10km int4 NULL,
	buffer_20km int4 NULL,
	buffer_50km int4 NULL,
	CONSTRAINT pk_commune_jour PRIMARY KEY (id_commune, date_jour)
);


-- incendies.departement definition

-- Drop table

-- DROP TABLE incendies.departement;

CREATE TABLE incendies.departement (
	code varchar(10) NOT NULL,
	nom varchar(100) NULL,
	CONSTRAINT departement_pkey PRIMARY KEY (code)
);


-- incendies.localisation definition

-- Drop table

-- DROP TABLE incendies.localisation;

CREATE TABLE incendies.localisation (
	id_localisation serial4 NOT NULL,
	longitude numeric(9, 6) NULL,
	latitude numeric(9, 6) NULL,
	geom incendies.geometry(point, 4326) GENERATED ALWAYS AS (incendies.st_setsrid(incendies.st_makepoint(longitude::double precision, latitude::double precision), 4326)) STORED NULL,
	geom_m incendies.geometry(point, 2154) GENERATED ALWAYS AS (incendies.st_transform(incendies.st_setsrid(incendies.st_makepoint(longitude::double precision, latitude::double precision), 4326), 2154)) STORED NULL,
	CONSTRAINT localisation_pkey PRIMARY KEY (id_localisation)
);
CREATE INDEX idx_localisation_latitude ON incendies.localisation USING btree (latitude);
CREATE INDEX idx_localisation_longitude ON incendies.localisation USING btree (longitude);
CREATE INDEX localisation_geom_m_gix ON incendies.localisation USING gist (geom_m);


-- incendies.nature definition

-- Drop table

-- DROP TABLE incendies.nature;

CREATE TABLE incendies.nature (
	id smallserial NOT NULL,
	nom varchar(32) NULL,
	CONSTRAINT nature_pkey PRIMARY KEY (id)
);


-- incendies.precision_surface definition

-- Drop table

-- DROP TABLE incendies.precision_surface;

CREATE TABLE incendies.precision_surface (
	id smallserial NOT NULL,
	nom varchar(32) NULL,
	CONSTRAINT precision_surface_pkey PRIMARY KEY (id)
);


-- incendies.region definition

-- Drop table

-- DROP TABLE incendies.region;

CREATE TABLE incendies.region (
	id smallserial NOT NULL,
	code int2 NULL,
	nom varchar(32) NULL,
	CONSTRAINT region_pkey PRIMARY KEY (id)
);




-- incendies.tmp_commune definition

-- Drop table

-- DROP TABLE incendies.tmp_commune;

CREATE TABLE incendies.tmp_commune (
	code_insee varchar(10) NOT NULL,
	nom_standard varchar(100) NOT NULL,
	nom_sans_pronom varchar(100) NOT NULL,
	nom_a varchar(100) NOT NULL,
	nom_de varchar(100) NOT NULL,
	nom_sans_accent varchar(100) NOT NULL,
	nom_standard_majuscule varchar(100) NOT NULL,
	typecom varchar(10) NOT NULL,
	typecom_texte varchar(50) NOT NULL,
	reg_code int2 NOT NULL,
	reg_nom varchar(100) NOT NULL,
	dep_code varchar(10) NOT NULL,
	dep_nom varchar(100) NOT NULL,
	canton_code varchar(10) NULL,
	canton_nom varchar(100) NULL,
	epci_code varchar(20) NULL,
	epci_nom varchar(150) NULL,
	academie_code int2 NOT NULL,
	academie_nom varchar(100) NOT NULL,
	code_postal varchar(10) NULL,
	codes_postaux varchar(200) NULL,
	zone_emploi int4 NULL,
	code_insee_centre_zone_emploi varchar(10) NULL,
	code_unite_urbaine varchar(10) NULL,
	nom_unite_urbaine varchar(100) NULL,
	taille_unite_urbaine int2 NULL,
	type_commune_unite_urbaine varchar(50) NULL,
	statut_commune_unite_urbaine varchar(50) NULL,
	population int4 NOT NULL,
	superficie_hectare int4 NOT NULL,
	superficie_km2 int4 NOT NULL,
	densite numeric(10, 2) NULL,
	altitude_moyenne int2 NOT NULL,
	altitude_minimale int2 NOT NULL,
	altitude_maximale int2 NOT NULL,
	latitude_mairie numeric(9, 6) NOT NULL,
	longitude_mairie numeric(9, 6) NOT NULL,
	latitude_centre numeric(9, 6) NULL,
	longitude_centre numeric(9, 6) NULL,
	grille_densite int2 NOT NULL,
	grille_densite_texte varchar(50) NOT NULL,
	niveau_equipements_services int2 NULL,
	niveau_equipements_services_texte varchar(100) NULL,
	gentile varchar(100) NULL,
	url_wikipedia varchar(255) NULL,
	url_villedereve varchar(255) NOT NULL
);
CREATE INDEX idx_tmp_commune_code_insee ON incendies.tmp_commune USING btree (code_insee);
CREATE INDEX idx_tmp_commune_latitude_mairie ON incendies.tmp_commune USING btree (latitude_mairie);
CREATE INDEX idx_tmp_commune_longitude_mairie ON incendies.tmp_commune USING btree (longitude_mairie);


-- incendies.tmp_incendie definition

-- Drop table

-- DROP TABLE incendies.tmp_incendie;

CREATE TABLE incendies.tmp_incendie (
	annee int4 NOT NULL,
	numero int4 NOT NULL,
	departement varchar(10) NOT NULL,
	insee varchar(10) NOT NULL,
	nom_commune varchar(150) NULL,
	date_premiere_alerte varchar(30) NOT NULL,
	surface_parcourue int8 NOT NULL,
	surface_foret numeric(15, 2) NULL,
	surface_maquis_garrigues numeric(15, 2) NULL,
	autres_surfaces_naturelles numeric(15, 2) NULL,
	surfaces_agricoles numeric(15, 2) NULL,
	autres_surfaces numeric(15, 2) NULL,
	surface_autres_terres_boisees numeric(15, 2) NULL,
	surfaces_non_boisees_naturelles numeric(15, 2) NULL,
	surfaces_non_boisees_artificialisees numeric(15, 2) NULL,
	surfaces_non_boisees numeric(15, 2) NULL,
	precision_surfaces varchar(100) NULL,
	type_peuplement float4 NULL,
	nature varchar(100) NULL,
	deces_batimentstouches varchar(100) NULL,
	nombre_deces int2 NULL,
	nombre_batiments_totalement_detruits int2 NULL,
	nombre_batiments_partiellement_detruits int2 NULL,
	precision_donnee varchar(200) NULL
);
CREATE INDEX idx_tmp_incendie_insee ON incendies.tmp_incendie USING btree (insee);
CREATE INDEX idx_tmp_incendie_nature ON incendies.tmp_incendie USING btree (nature);
CREATE INDEX idx_tmp_incendie_precision_surfaces ON incendies.tmp_incendie USING btree (precision_surfaces);
CREATE INDEX idx_tmp_incendie_type_peuplement ON incendies.tmp_incendie USING btree (type_peuplement);


-- incendies.type_cluster definition

-- Drop table

-- DROP TABLE incendies.type_cluster;

CREATE TABLE incendies.type_cluster (
	id smallserial NOT NULL,
	nom varchar(32) NULL,
	CONSTRAINT type_cluster_pkey PRIMARY KEY (id)
);


-- incendies.type_peuplement definition

-- Drop table

-- DROP TABLE incendies.type_peuplement;

CREATE TABLE incendies.type_peuplement (
	id smallserial NOT NULL,
	nom varchar(32) NULL,
	CONSTRAINT type_peuplement_pkey PRIMARY KEY (id)
);


-- incendies."cluster" definition

-- Drop table

-- DROP TABLE incendies."cluster";

CREATE TABLE incendies."cluster" (
	id_localisation int4 NOT NULL,
	date_experiment timestamp NOT NULL,
	cluster_id varchar(50) NOT NULL,
	type_cluster int2 NOT NULL,
	CONSTRAINT cluster_pkey PRIMARY KEY (id_localisation, date_experiment),
	CONSTRAINT fk_cluster_id_localisation FOREIGN KEY (id_localisation) REFERENCES incendies.localisation(id_localisation),
	CONSTRAINT fk_cluster_type_cluster FOREIGN KEY (type_cluster) REFERENCES incendies.type_cluster(id)
);
CREATE INDEX fk_cluster_type_cluster ON incendies.cluster USING btree (type_cluster);


-- incendies.commune definition

-- Drop table

-- DROP TABLE incendies.commune;

CREATE TABLE incendies.commune (
	id_commune serial4 NOT NULL,
	code_insee varchar(10) NULL,
	localisation int4 NOT NULL,
	nom_standard varchar(100) NULL,
	region int2 NULL,
	departement varchar(10) NULL,
	population int4 NULL,
	superficie_hectare int4 NULL,
	densite numeric(10, 2) NULL,
	altitude_moyenne int2 NULL,
	altitude_minimale int2 NULL,
	altitude_maximale int2 NULL,
	CONSTRAINT commune_pkey PRIMARY KEY (id_commune),
	CONSTRAINT fk_commune_departement FOREIGN KEY (departement) REFERENCES incendies.departement(code),
	CONSTRAINT fk_commune_localisation FOREIGN KEY (localisation) REFERENCES incendies.localisation(id_localisation),
	CONSTRAINT fk_commune_region FOREIGN KEY (region) REFERENCES incendies.region(id)
);
CREATE INDEX fk_commune_departement ON incendies.commune USING btree (departement);
CREATE INDEX fk_commune_localisation ON incendies.commune USING btree (localisation);
CREATE INDEX fk_commune_region ON incendies.commune USING btree (region);


-- incendies.experiment definition

-- Drop table

-- DROP TABLE incendies.experiment;

CREATE TABLE incendies.experiment (
	id serial4 NOT NULL,
	date_experiment timestamp NOT NULL,
	type_cluster int2 NOT NULL,
	region int2 NOT NULL,
	eps float4 NULL,
	min_samples int4 NULL,
	CONSTRAINT experiment_pkey PRIMARY KEY (id),
	CONSTRAINT uq_experiment UNIQUE (date_experiment, type_cluster, region),
	CONSTRAINT fk_experiment_region FOREIGN KEY (region) REFERENCES incendies.region(id),
	CONSTRAINT fk_experiment_type_cluster FOREIGN KEY (type_cluster) REFERENCES incendies.type_cluster(id)
);


-- incendies.incendie definition

-- Drop table

-- DROP TABLE incendies.incendie;

CREATE TABLE incendies.incendie (
	id_incendie serial4 NOT NULL,
	localisation int4 NOT NULL,
	code_insee varchar(10) NOT NULL,
	date_premiere_alerte timestamp NOT NULL,
	annee int4 NOT NULL,
	surface_parcourue int4 NOT NULL,
	surface_foret int4 NULL,
	surface_maquis_garrigues int4 NULL,
	autres_surfaces_naturelles int4 NULL,
	surfaces_agricoles int4 NULL,
	autres_surfaces int4 NULL,
	surface_autres_terres_boisees int4 NULL,
	surfaces_non_boisees_naturelles int4 NULL,
	surfaces_non_boisees_artificialisees int4 NULL,
	surfaces_non_boisees int4 NULL,
	precision_surface int2 NOT NULL,
	type_peuplement int2 NOT NULL,
	nature int2 NOT NULL,
	CONSTRAINT incendie_pkey PRIMARY KEY (id_incendie),
	CONSTRAINT fk_incendie_localisation FOREIGN KEY (localisation) REFERENCES incendies.localisation(id_localisation),
	CONSTRAINT fk_incendie_nature FOREIGN KEY (nature) REFERENCES incendies.nature(id),
	CONSTRAINT fk_incendie_precision_surface FOREIGN KEY (precision_surface) REFERENCES incendies.precision_surface(id),
	CONSTRAINT fk_incendie_type_peuplement FOREIGN KEY (type_peuplement) REFERENCES incendies.type_peuplement(id)
);
CREATE INDEX fk_incendie_localisation ON incendies.incendie USING btree (localisation);
CREATE INDEX fk_incendie_nature ON incendies.incendie USING btree (nature);
CREATE INDEX fk_incendie_precision_surface ON incendies.incendie USING btree (precision_surface);
CREATE INDEX fk_incendie_type_peuplement ON incendies.incendie USING btree (type_peuplement);


-- incendies.affecte definition

-- Drop table

-- DROP TABLE incendies.affecte;

CREATE TABLE incendies.affecte (
	id_commune int4 NOT NULL,
	id_incendie int4 NOT NULL,
	date_impact timestamp NOT NULL,
	degre_impact varchar(50) NULL,
	CONSTRAINT affecte_pkey PRIMARY KEY (id_commune, id_incendie, date_impact),
	CONSTRAINT fk_affecte_id_commune FOREIGN KEY (id_commune) REFERENCES incendies.commune(id_commune),
	CONSTRAINT fk_affecte_id_incendie FOREIGN KEY (id_incendie) REFERENCES incendies.incendie(id_incendie)
);
CREATE INDEX fk_affecte_id_incendie ON incendies.affecte USING btree (id_incendie);


-- incendies.geography_columns source

CREATE OR REPLACE VIEW incendies.geography_columns
AS SELECT current_database() AS f_table_catalog,
    n.nspname AS f_table_schema,
    c.relname AS f_table_name,
    a.attname AS f_geography_column,
    incendies.postgis_typmod_dims(a.atttypmod) AS coord_dimension,
    incendies.postgis_typmod_srid(a.atttypmod) AS srid,
    incendies.postgis_typmod_type(a.atttypmod) AS type
   FROM pg_class c,
    pg_attribute a,
    pg_type t,
    pg_namespace n
  WHERE t.typname = 'geography'::name AND a.attisdropped = false AND a.atttypid = t.oid AND a.attrelid = c.oid AND c.relnamespace = n.oid AND (c.relkind = ANY (ARRAY['r'::"char", 'v'::"char", 'm'::"char", 'f'::"char", 'p'::"char"])) AND NOT pg_is_other_temp_schema(c.relnamespace) AND has_table_privilege(c.oid, 'SELECT'::text);


-- incendies.geometry_columns source

CREATE OR REPLACE VIEW incendies.geometry_columns
AS SELECT current_database()::character varying(256) AS f_table_catalog,
    n.nspname AS f_table_schema,
    c.relname AS f_table_name,
    a.attname AS f_geometry_column,
    COALESCE(incendies.postgis_typmod_dims(a.atttypmod), sn.ndims, 2) AS coord_dimension,
    COALESCE(NULLIF(incendies.postgis_typmod_srid(a.atttypmod), 0), sr.srid, 0) AS srid,
    replace(replace(COALESCE(NULLIF(upper(incendies.postgis_typmod_type(a.atttypmod)), 'GEOMETRY'::text), st.type, 'GEOMETRY'::text), 'ZM'::text, ''::text), 'Z'::text, ''::text)::character varying(30) AS type
   FROM pg_class c
     JOIN pg_attribute a ON a.attrelid = c.oid AND NOT a.attisdropped
     JOIN pg_namespace n ON c.relnamespace = n.oid
     JOIN pg_type t ON a.atttypid = t.oid
     LEFT JOIN ( SELECT s.connamespace,
            s.conrelid,
            s.conkey,
            replace(split_part(s.consrc, ''''::text, 2), ')'::text, ''::text) AS type
           FROM ( SELECT pg_constraint.connamespace,
                    pg_constraint.conrelid,
                    pg_constraint.conkey,
                    pg_get_constraintdef(pg_constraint.oid) AS consrc
                   FROM pg_constraint) s
          WHERE s.consrc ~~* '%geometrytype(% = %'::text) st ON st.connamespace = n.oid AND st.conrelid = c.oid AND (a.attnum = ANY (st.conkey))
     LEFT JOIN ( SELECT s.connamespace,
            s.conrelid,
            s.conkey,
            replace(split_part(s.consrc, ' = '::text, 2), ')'::text, ''::text)::integer AS ndims
           FROM ( SELECT pg_constraint.connamespace,
                    pg_constraint.conrelid,
                    pg_constraint.conkey,
                    pg_get_constraintdef(pg_constraint.oid) AS consrc
                   FROM pg_constraint) s
          WHERE s.consrc ~~* '%ndims(% = %'::text) sn ON sn.connamespace = n.oid AND sn.conrelid = c.oid AND (a.attnum = ANY (sn.conkey))
     LEFT JOIN ( SELECT s.connamespace,
            s.conrelid,
            s.conkey,
            replace(replace(split_part(s.consrc, ' = '::text, 2), ')'::text, ''::text), '('::text, ''::text)::integer AS srid
           FROM ( SELECT pg_constraint.connamespace,
                    pg_constraint.conrelid,
                    pg_constraint.conkey,
                    pg_get_constraintdef(pg_constraint.oid) AS consrc
                   FROM pg_constraint) s
          WHERE s.consrc ~~* '%srid(% = %'::text) sr ON sr.connamespace = n.oid AND sr.conrelid = c.oid AND (a.attnum = ANY (sr.conkey))
  WHERE (c.relkind = ANY (ARRAY['r'::"char", 'v'::"char", 'm'::"char", 'f'::"char", 'p'::"char"])) AND NOT c.relname = 'raster_columns'::name AND t.typname = 'geometry'::name AND NOT pg_is_other_temp_schema(c.relnamespace) AND has_table_privilege(c.oid, 'SELECT'::text);



-- DROP FUNCTION incendies._postgis_deprecate(text, text, text);

CREATE OR REPLACE FUNCTION incendies._postgis_deprecate(oldname text, newname text, version text)
 RETURNS void
 LANGUAGE plpgsql
 IMMUTABLE STRICT COST 250
AS $function$
DECLARE
  curver_text text;
BEGIN
  --
  -- Raises a NOTICE if it was deprecated in this version,
  -- a WARNING if in a previous version (only up to minor version checked)
  --
	curver_text := '3.5.2';
	IF pg_catalog.split_part(curver_text,'.',1)::int > pg_catalog.split_part(version,'.',1)::int OR
	   ( pg_catalog.split_part(curver_text,'.',1) = pg_catalog.split_part(version,'.',1) AND
		 pg_catalog.split_part(curver_text,'.',2) != split_part(version,'.',2) )
	THEN
	  RAISE WARNING '% signature was deprecated in %. Please use %', oldname, version, newname;
	ELSE
	  RAISE DEBUG '% signature was deprecated in %. Please use %', oldname, version, newname;
	END IF;
END;
$function$
;

-- DROP FUNCTION incendies._postgis_index_extent(regclass, text);

CREATE OR REPLACE FUNCTION incendies._postgis_index_extent(tbl regclass, col text)
 RETURNS incendies.box2d
 LANGUAGE c
 STABLE STRICT
AS '$libdir/postgis-3', $function$_postgis_gserialized_index_extent$function$
;

-- DROP FUNCTION incendies._postgis_join_selectivity(regclass, text, regclass, text, text);

CREATE OR REPLACE FUNCTION incendies._postgis_join_selectivity(regclass, text, regclass, text, text DEFAULT '2'::text)
 RETURNS double precision
 LANGUAGE c
 PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$_postgis_gserialized_joinsel$function$
;

-- DROP FUNCTION incendies._postgis_pgsql_version();

CREATE OR REPLACE FUNCTION incendies._postgis_pgsql_version()
 RETURNS text
 LANGUAGE sql
 STABLE
AS $function$
	SELECT CASE WHEN pg_catalog.split_part(s,'.',1)::integer > 9 THEN pg_catalog.split_part(s,'.',1) || '0'
	ELSE pg_catalog.split_part(s,'.', 1) || pg_catalog.split_part(s,'.', 2) END AS v
	FROM pg_catalog.substring(version(), E'PostgreSQL ([0-9\\.]+)') AS s;
$function$
;

-- DROP FUNCTION incendies._postgis_scripts_pgsql_version();

CREATE OR REPLACE FUNCTION incendies._postgis_scripts_pgsql_version()
 RETURNS text
 LANGUAGE sql
 IMMUTABLE
AS $function$SELECT '170'::text AS version$function$
;

-- DROP FUNCTION incendies._postgis_selectivity(regclass, text, incendies.geometry, text);

CREATE OR REPLACE FUNCTION incendies._postgis_selectivity(tbl regclass, att_name text, geom incendies.geometry, mode text DEFAULT '2'::text)
 RETURNS double precision
 LANGUAGE c
 PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$_postgis_gserialized_sel$function$
;

-- DROP FUNCTION incendies._postgis_stats(regclass, text, text);

CREATE OR REPLACE FUNCTION incendies._postgis_stats(tbl regclass, att_name text, text DEFAULT '2'::text)
 RETURNS text
 LANGUAGE c
 PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$_postgis_gserialized_stats$function$
;

-- DROP FUNCTION incendies._st_3ddfullywithin(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies._st_3ddfullywithin(geom1 incendies.geometry, geom2 incendies.geometry, double precision)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$LWGEOM_dfullywithin3d$function$
;

-- DROP FUNCTION incendies._st_3ddwithin(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies._st_3ddwithin(geom1 incendies.geometry, geom2 incendies.geometry, double precision)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$LWGEOM_dwithin3d$function$
;

-- DROP FUNCTION incendies._st_3dintersects(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_3dintersects(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_3DIntersects$function$
;

-- DROP FUNCTION incendies._st_asgml(int4, incendies.geometry, int4, int4, text, text);

CREATE OR REPLACE FUNCTION incendies._st_asgml(integer, incendies.geometry, integer, integer, text, text)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asGML$function$
;

-- DROP FUNCTION incendies._st_asx3d(int4, incendies.geometry, int4, int4, text);

CREATE OR REPLACE FUNCTION incendies._st_asx3d(integer, incendies.geometry, integer, integer, text)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asX3D$function$
;

-- DROP FUNCTION incendies._st_bestsrid(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies._st_bestsrid(incendies.geography, incendies.geography)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$geography_bestsrid$function$
;

-- DROP FUNCTION incendies._st_bestsrid(incendies.geography);

CREATE OR REPLACE FUNCTION incendies._st_bestsrid(incendies.geography)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$geography_bestsrid$function$
;

-- DROP FUNCTION incendies._st_concavehull(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_concavehull(param_inputgeom incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE plpgsql
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS $function$
	DECLARE
	vexhull incendies.geometry;
	var_resultgeom incendies.geometry;
	var_inputgeom incendies.geometry;
	vexring incendies.geometry;
	cavering incendies.geometry;
	cavept incendies.geometry[];
	seglength double precision;
	var_tempgeom incendies.geometry;
	scale_factor float := 1;
	i integer;
	BEGIN
		-- First compute the ConvexHull of the geometry
		vexhull := incendies.ST_ConvexHull(param_inputgeom);
		var_inputgeom := param_inputgeom;
		--A point really has no concave hull
		IF incendies.ST_GeometryType(vexhull) = 'ST_Point' OR incendies.ST_GeometryType(vexHull) = 'ST_LineString' THEN
			RETURN vexhull;
		END IF;

		-- convert the hull perimeter to a linestring so we can manipulate individual points
		vexring := CASE WHEN incendies.ST_GeometryType(vexhull) = 'ST_LineString' THEN vexhull ELSE incendies.ST_ExteriorRing(vexhull) END;
		IF abs(incendies.ST_X(incendies.ST_PointN(vexring,1))) < 1 THEN --scale the geometry to prevent stupid precision errors - not sure it works so make low for now
			scale_factor := 100;
			vexring := incendies.ST_Scale(vexring, scale_factor,scale_factor);
			var_inputgeom := incendies.ST_Scale(var_inputgeom, scale_factor, scale_factor);
			--RAISE NOTICE 'Scaling';
		END IF;
		seglength := incendies.ST_Length(vexring)/least(incendies.ST_NPoints(vexring)*2,1000) ;

		vexring := incendies.ST_Segmentize(vexring, seglength);
		-- find the point on the original geom that is closest to each point of the convex hull and make a new linestring out of it.
		cavering := incendies.ST_Collect(
			ARRAY(

				SELECT
					incendies.ST_ClosestPoint(var_inputgeom, pt ) As the_geom
					FROM (
						SELECT  incendies.ST_PointN(vexring, n ) As pt, n
							FROM
							generate_series(1, incendies.ST_NPoints(vexring) ) As n
						) As pt

				)
			)
		;

		var_resultgeom := incendies.ST_MakeLine(geom)
			FROM incendies.ST_Dump(cavering) As foo;

		IF incendies.ST_IsSimple(var_resultgeom) THEN
			var_resultgeom := incendies.ST_MakePolygon(var_resultgeom);
			--RAISE NOTICE 'is Simple: %', var_resultgeom;
		ELSE 
			--RAISE NOTICE 'is not Simple: %', var_resultgeom;
			var_resultgeom := incendies.ST_ConvexHull(var_resultgeom);
		END IF;

		IF scale_factor > 1 THEN -- scale the result back
			var_resultgeom := incendies.ST_Scale(var_resultgeom, 1/scale_factor, 1/scale_factor);
		END IF;

		-- make sure result covers original (#3638)
		-- Using ST_UnaryUnion since SFCGAL doesn't replace with its own implementation
		-- and SFCGAL one chokes for some reason
		var_resultgeom := incendies.ST_UnaryUnion(incendies.ST_Collect(param_inputgeom, var_resultgeom) );
		RETURN var_resultgeom;

	END;
$function$
;

-- DROP FUNCTION incendies._st_contains(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_contains(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$contains$function$
;

-- DROP FUNCTION incendies._st_containsproperly(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_containsproperly(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$containsproperly$function$
;

-- DROP FUNCTION incendies._st_coveredby(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies._st_coveredby(geog1 incendies.geography, geog2 incendies.geography)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$geography_coveredby$function$
;

-- DROP FUNCTION incendies._st_coveredby(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_coveredby(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$coveredby$function$
;

-- DROP FUNCTION incendies._st_covers(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_covers(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$covers$function$
;

-- DROP FUNCTION incendies._st_covers(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies._st_covers(geog1 incendies.geography, geog2 incendies.geography)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$geography_covers$function$
;

-- DROP FUNCTION incendies._st_crosses(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_crosses(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$crosses$function$
;

-- DROP FUNCTION incendies._st_dfullywithin(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies._st_dfullywithin(geom1 incendies.geometry, geom2 incendies.geometry, double precision)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$LWGEOM_dfullywithin$function$
;

-- DROP FUNCTION incendies._st_distancetree(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies._st_distancetree(incendies.geography, incendies.geography)
 RETURNS double precision
 LANGUAGE sql
 IMMUTABLE STRICT
AS $function$SELECT incendies._ST_DistanceTree($1, $2, 0.0, true)$function$
;

-- DROP FUNCTION incendies._st_distancetree(incendies.geography, incendies.geography, float8, bool);

CREATE OR REPLACE FUNCTION incendies._st_distancetree(incendies.geography, incendies.geography, double precision, boolean)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE STRICT COST 5000
AS '$libdir/postgis-3', $function$geography_distance_tree$function$
;

-- DROP FUNCTION incendies._st_distanceuncached(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies._st_distanceuncached(incendies.geography, incendies.geography)
 RETURNS double precision
 LANGUAGE sql
 IMMUTABLE STRICT
AS $function$SELECT incendies._ST_DistanceUnCached($1, $2, 0.0, true)$function$
;

-- DROP FUNCTION incendies._st_distanceuncached(incendies.geography, incendies.geography, bool);

CREATE OR REPLACE FUNCTION incendies._st_distanceuncached(incendies.geography, incendies.geography, boolean)
 RETURNS double precision
 LANGUAGE sql
 IMMUTABLE STRICT
AS $function$SELECT incendies._ST_DistanceUnCached($1, $2, 0.0, $3)$function$
;

-- DROP FUNCTION incendies._st_distanceuncached(incendies.geography, incendies.geography, float8, bool);

CREATE OR REPLACE FUNCTION incendies._st_distanceuncached(incendies.geography, incendies.geography, double precision, boolean)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE STRICT COST 5000
AS '$libdir/postgis-3', $function$geography_distance_uncached$function$
;

-- DROP FUNCTION incendies._st_dwithin(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies._st_dwithin(geom1 incendies.geometry, geom2 incendies.geometry, double precision)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$LWGEOM_dwithin$function$
;

-- DROP FUNCTION incendies._st_dwithin(incendies.geography, incendies.geography, float8, bool);

CREATE OR REPLACE FUNCTION incendies._st_dwithin(geog1 incendies.geography, geog2 incendies.geography, tolerance double precision, use_spheroid boolean DEFAULT true)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$geography_dwithin$function$
;

-- DROP FUNCTION incendies._st_dwithinuncached(incendies.geography, incendies.geography, float8);

CREATE OR REPLACE FUNCTION incendies._st_dwithinuncached(incendies.geography, incendies.geography, double precision)
 RETURNS boolean
 LANGUAGE sql
 IMMUTABLE
AS $function$SELECT $1 OPERATOR(incendies.&&) incendies._ST_Expand($2,$3) AND $2 OPERATOR(incendies.&&) incendies._ST_Expand($1,$3) AND incendies._ST_DWithinUnCached($1, $2, $3, true)$function$
;

-- DROP FUNCTION incendies._st_dwithinuncached(incendies.geography, incendies.geography, float8, bool);

CREATE OR REPLACE FUNCTION incendies._st_dwithinuncached(incendies.geography, incendies.geography, double precision, boolean)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE STRICT COST 5000
AS '$libdir/postgis-3', $function$geography_dwithin_uncached$function$
;

-- DROP FUNCTION incendies._st_equals(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_equals(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_Equals$function$
;

-- DROP FUNCTION incendies._st_expand(incendies.geography, float8);

CREATE OR REPLACE FUNCTION incendies._st_expand(incendies.geography, double precision)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$geography_expand$function$
;

-- DROP FUNCTION incendies._st_geomfromgml(text, int4);

CREATE OR REPLACE FUNCTION incendies._st_geomfromgml(text, integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$geom_from_gml$function$
;

-- DROP FUNCTION incendies._st_intersects(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_intersects(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_Intersects$function$
;

-- DROP FUNCTION incendies._st_linecrossingdirection(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_linecrossingdirection(line1 incendies.geometry, line2 incendies.geometry)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_LineCrossingDirection$function$
;

-- DROP FUNCTION incendies._st_longestline(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_longestline(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_longestline2d$function$
;

-- DROP FUNCTION incendies._st_maxdistance(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_maxdistance(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_maxdistance2d_linestring$function$
;

-- DROP FUNCTION incendies._st_orderingequals(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_orderingequals(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$LWGEOM_same$function$
;

-- DROP FUNCTION incendies._st_overlaps(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_overlaps(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$overlaps$function$
;

-- DROP FUNCTION incendies._st_pointoutside(incendies.geography);

CREATE OR REPLACE FUNCTION incendies._st_pointoutside(incendies.geography)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE STRICT
AS '$libdir/postgis-3', $function$geography_point_outside$function$
;

-- DROP FUNCTION incendies._st_sortablehash(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_sortablehash(geom incendies.geometry)
 RETURNS bigint
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$_ST_SortableHash$function$
;

-- DROP FUNCTION incendies._st_touches(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_touches(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$touches$function$
;

-- DROP FUNCTION incendies._st_voronoi(incendies.geometry, incendies.geometry, float8, bool);

CREATE OR REPLACE FUNCTION incendies._st_voronoi(g1 incendies.geometry, clip incendies.geometry DEFAULT NULL::incendies.geometry, tolerance double precision DEFAULT 0.0, return_polygons boolean DEFAULT true)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 5000
AS '$libdir/postgis-3', $function$ST_Voronoi$function$
;

-- DROP FUNCTION incendies._st_within(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies._st_within(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE
AS $function$SELECT incendies._ST_Contains($2,$1)$function$
;

-- DROP FUNCTION incendies.addgeometrycolumn(varchar, varchar, int4, varchar, int4, bool);

CREATE OR REPLACE FUNCTION incendies.addgeometrycolumn(table_name character varying, column_name character varying, new_srid integer, new_type character varying, new_dim integer, use_typmod boolean DEFAULT true)
 RETURNS text
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
	ret  text;
BEGIN
	SELECT incendies.AddGeometryColumn('','',$1,$2,$3,$4,$5, $6) into ret;
	RETURN ret;
END;
$function$
;

-- DROP FUNCTION incendies.addgeometrycolumn(varchar, varchar, varchar, varchar, int4, varchar, int4, bool);

CREATE OR REPLACE FUNCTION incendies.addgeometrycolumn(catalog_name character varying, schema_name character varying, table_name character varying, column_name character varying, new_srid_in integer, new_type character varying, new_dim integer, use_typmod boolean DEFAULT true)
 RETURNS text
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
	rec RECORD;
	sr varchar;
	real_schema name;
	sql text;
	new_srid integer;

BEGIN

	-- Verify geometry type
	IF (postgis_type_name(new_type,new_dim) IS NULL )
	THEN
		RAISE EXCEPTION 'Invalid type name "%(%)" - valid ones are:
	POINT, MULTIPOINT,
	LINESTRING, MULTILINESTRING,
	POLYGON, MULTIPOLYGON,
	CIRCULARSTRING, COMPOUNDCURVE, MULTICURVE,
	CURVEPOLYGON, MULTISURFACE,
	GEOMETRY, GEOMETRYCOLLECTION,
	POINTM, MULTIPOINTM,
	LINESTRINGM, MULTILINESTRINGM,
	POLYGONM, MULTIPOLYGONM,
	CIRCULARSTRINGM, COMPOUNDCURVEM, MULTICURVEM
	CURVEPOLYGONM, MULTISURFACEM, TRIANGLE, TRIANGLEM,
	POLYHEDRALSURFACE, POLYHEDRALSURFACEM, TIN, TINM
	or GEOMETRYCOLLECTIONM', new_type, new_dim;
		RETURN 'fail';
	END IF;

	-- Verify dimension
	IF ( (new_dim >4) OR (new_dim <2) ) THEN
		RAISE EXCEPTION 'invalid dimension';
		RETURN 'fail';
	END IF;

	IF ( (new_type LIKE '%M') AND (new_dim!=3) ) THEN
		RAISE EXCEPTION 'TypeM needs 3 dimensions';
		RETURN 'fail';
	END IF;

	-- Verify SRID
	IF ( new_srid_in > 0 ) THEN
		IF new_srid_in > 998999 THEN
			RAISE EXCEPTION 'AddGeometryColumn() - SRID must be <= %', 998999;
		END IF;
		new_srid := new_srid_in;
		SELECT SRID INTO sr FROM incendies.spatial_ref_sys WHERE SRID = new_srid;
		IF NOT FOUND THEN
			RAISE EXCEPTION 'AddGeometryColumn() - invalid SRID';
			RETURN 'fail';
		END IF;
	ELSE
		new_srid := incendies.ST_SRID('POINT EMPTY'::incendies.geometry);
		IF ( new_srid_in != new_srid ) THEN
			RAISE NOTICE 'SRID value % converted to the officially unknown SRID value %', new_srid_in, new_srid;
		END IF;
	END IF;

	-- Verify schema
	IF ( schema_name IS NOT NULL AND schema_name != '' ) THEN
		sql := 'SELECT nspname FROM pg_namespace ' ||
			'WHERE text(nspname) = ' || quote_literal(schema_name) ||
			'LIMIT 1';
		RAISE DEBUG '%', sql;
		EXECUTE sql INTO real_schema;

		IF ( real_schema IS NULL ) THEN
			RAISE EXCEPTION 'Schema % is not a valid schemaname', quote_literal(schema_name);
			RETURN 'fail';
		END IF;
	END IF;

	IF ( real_schema IS NULL ) THEN
		RAISE DEBUG 'Detecting schema';
		sql := 'SELECT n.nspname AS schemaname ' ||
			'FROM pg_catalog.pg_class c ' ||
			  'JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace ' ||
			'WHERE c.relkind = ' || quote_literal('r') ||
			' AND n.nspname NOT IN (' || quote_literal('pg_catalog') || ', ' || quote_literal('pg_toast') || ')' ||
			' AND pg_catalog.pg_table_is_visible(c.oid)' ||
			' AND c.relname = ' || quote_literal(table_name);
		RAISE DEBUG '%', sql;
		EXECUTE sql INTO real_schema;

		IF ( real_schema IS NULL ) THEN
			RAISE EXCEPTION 'Table % does not occur in the search_path', quote_literal(table_name);
			RETURN 'fail';
		END IF;
	END IF;

	-- Add geometry column to table
	IF use_typmod THEN
		 sql := 'ALTER TABLE ' ||
			quote_ident(real_schema) || '.' || quote_ident(table_name)
			|| ' ADD COLUMN ' || quote_ident(column_name) ||
			' geometry(' || incendies.postgis_type_name(new_type, new_dim) || ', ' || new_srid::text || ')';
		RAISE DEBUG '%', sql;
	ELSE
		sql := 'ALTER TABLE ' ||
			quote_ident(real_schema) || '.' || quote_ident(table_name)
			|| ' ADD COLUMN ' || quote_ident(column_name) ||
			' geometry ';
		RAISE DEBUG '%', sql;
	END IF;
	EXECUTE sql;

	IF NOT use_typmod THEN
		-- Add table CHECKs
		sql := 'ALTER TABLE ' ||
			quote_ident(real_schema) || '.' || quote_ident(table_name)
			|| ' ADD CONSTRAINT '
			|| quote_ident('enforce_srid_' || column_name)
			|| ' CHECK (st_srid(' || quote_ident(column_name) ||
			') = ' || new_srid::text || ')' ;
		RAISE DEBUG '%', sql;
		EXECUTE sql;

		sql := 'ALTER TABLE ' ||
			quote_ident(real_schema) || '.' || quote_ident(table_name)
			|| ' ADD CONSTRAINT '
			|| quote_ident('enforce_dims_' || column_name)
			|| ' CHECK (st_ndims(' || quote_ident(column_name) ||
			') = ' || new_dim::text || ')' ;
		RAISE DEBUG '%', sql;
		EXECUTE sql;

		IF ( NOT (new_type = 'GEOMETRY')) THEN
			sql := 'ALTER TABLE ' ||
				quote_ident(real_schema) || '.' || quote_ident(table_name) || ' ADD CONSTRAINT ' ||
				quote_ident('enforce_geotype_' || column_name) ||
				' CHECK (GeometryType(' ||
				quote_ident(column_name) || ')=' ||
				quote_literal(new_type) || ' OR (' ||
				quote_ident(column_name) || ') is null)';
			RAISE DEBUG '%', sql;
			EXECUTE sql;
		END IF;
	END IF;

	RETURN
		real_schema || '.' ||
		table_name || '.' || column_name ||
		' SRID:' || new_srid::text ||
		' TYPE:' || new_type ||
		' DIMS:' || new_dim::text || ' ';
END;
$function$
;

-- DROP FUNCTION incendies.addgeometrycolumn(varchar, varchar, varchar, int4, varchar, int4, bool);

CREATE OR REPLACE FUNCTION incendies.addgeometrycolumn(schema_name character varying, table_name character varying, column_name character varying, new_srid integer, new_type character varying, new_dim integer, use_typmod boolean DEFAULT true)
 RETURNS text
 LANGUAGE plpgsql
 STABLE STRICT
AS $function$
DECLARE
	ret  text;
BEGIN
	SELECT incendies.AddGeometryColumn('',$1,$2,$3,$4,$5,$6,$7) into ret;
	RETURN ret;
END;
$function$
;

-- DROP FUNCTION incendies.box(incendies.box3d);

CREATE OR REPLACE FUNCTION incendies.box(incendies.box3d)
 RETURNS box
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$BOX3D_to_BOX$function$
;

-- DROP FUNCTION incendies.box(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.box(incendies.geometry)
 RETURNS box
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_to_BOX$function$
;

-- DROP FUNCTION incendies.box2d(incendies.box3d);

CREATE OR REPLACE FUNCTION incendies.box2d(incendies.box3d)
 RETURNS incendies.box2d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$BOX3D_to_BOX2D$function$
;

-- DROP FUNCTION incendies.box2d(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.box2d(incendies.geometry)
 RETURNS incendies.box2d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_to_BOX2D$function$
;

-- DROP FUNCTION incendies.box2d_in(cstring);

CREATE OR REPLACE FUNCTION incendies.box2d_in(cstring)
 RETURNS incendies.box2d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$BOX2D_in$function$
;

-- DROP FUNCTION incendies.box2d_out(incendies.box2d);

CREATE OR REPLACE FUNCTION incendies.box2d_out(incendies.box2d)
 RETURNS cstring
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$BOX2D_out$function$
;

-- DROP FUNCTION incendies.box2df_in(cstring);

CREATE OR REPLACE FUNCTION incendies.box2df_in(cstring)
 RETURNS incendies.box2df
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$box2df_in$function$
;

-- DROP FUNCTION incendies.box2df_out(incendies.box2df);

CREATE OR REPLACE FUNCTION incendies.box2df_out(incendies.box2df)
 RETURNS cstring
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$box2df_out$function$
;

-- DROP FUNCTION incendies.box3d(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.box3d(incendies.geometry)
 RETURNS incendies.box3d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_to_BOX3D$function$
;

-- DROP FUNCTION incendies.box3d(incendies.box2d);

CREATE OR REPLACE FUNCTION incendies.box3d(incendies.box2d)
 RETURNS incendies.box3d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$BOX2D_to_BOX3D$function$
;

-- DROP FUNCTION incendies.box3d_in(cstring);

CREATE OR REPLACE FUNCTION incendies.box3d_in(cstring)
 RETURNS incendies.box3d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$BOX3D_in$function$
;

-- DROP FUNCTION incendies.box3d_out(incendies.box3d);

CREATE OR REPLACE FUNCTION incendies.box3d_out(incendies.box3d)
 RETURNS cstring
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$BOX3D_out$function$
;

-- DROP FUNCTION incendies.box3dtobox(incendies.box3d);

CREATE OR REPLACE FUNCTION incendies.box3dtobox(incendies.box3d)
 RETURNS box
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$BOX3D_to_BOX$function$
;

-- DROP FUNCTION incendies."bytea"(incendies.geography);

CREATE OR REPLACE FUNCTION incendies.bytea(incendies.geography)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_to_bytea$function$
;

-- DROP FUNCTION incendies."bytea"(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.bytea(incendies.geometry)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_to_bytea$function$
;

-- DROP FUNCTION incendies.contains_2d(incendies.geometry, incendies.box2df);

CREATE OR REPLACE FUNCTION incendies.contains_2d(incendies.geometry, incendies.box2df)
 RETURNS boolean
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 1
AS $function$SELECT $2 OPERATOR(incendies.@) $1;$function$
;

-- DROP FUNCTION incendies.contains_2d(incendies.box2df, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.contains_2d(incendies.box2df, incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_contains_box2df_geom_2d$function$
;

-- DROP FUNCTION incendies.contains_2d(incendies.box2df, incendies.box2df);

CREATE OR REPLACE FUNCTION incendies.contains_2d(incendies.box2df, incendies.box2df)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_contains_box2df_box2df_2d$function$
;

-- DROP FUNCTION incendies.dropgeometrycolumn(varchar, varchar, varchar);

CREATE OR REPLACE FUNCTION incendies.dropgeometrycolumn(schema_name character varying, table_name character varying, column_name character varying)
 RETURNS text
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
	ret text;
BEGIN
	SELECT incendies.DropGeometryColumn('',$1,$2,$3) into ret;
	RETURN ret;
END;
$function$
;

-- DROP FUNCTION incendies.dropgeometrycolumn(varchar, varchar, varchar, varchar);

CREATE OR REPLACE FUNCTION incendies.dropgeometrycolumn(catalog_name character varying, schema_name character varying, table_name character varying, column_name character varying)
 RETURNS text
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
	myrec RECORD;
	okay boolean;
	real_schema name;

BEGIN

	-- Find, check or fix schema_name
	IF ( schema_name != '' ) THEN
		okay = false;

		FOR myrec IN SELECT nspname FROM pg_namespace WHERE text(nspname) = schema_name LOOP
			okay := true;
		END LOOP;

		IF ( okay <>  true ) THEN
			RAISE NOTICE 'Invalid schema name - using current_schema()';
			SELECT current_schema() into real_schema;
		ELSE
			real_schema = schema_name;
		END IF;
	ELSE
		SELECT current_schema() into real_schema;
	END IF;

	-- Find out if the column is in the geometry_columns table
	okay = false;
	FOR myrec IN SELECT * from incendies.geometry_columns where f_table_schema = text(real_schema) and f_table_name = table_name and f_geometry_column = column_name LOOP
		okay := true;
	END LOOP;
	IF (okay <> true) THEN
		RAISE EXCEPTION 'column not found in geometry_columns table';
		RETURN false;
	END IF;

	-- Remove table column
	EXECUTE 'ALTER TABLE ' || quote_ident(real_schema) || '.' ||
		quote_ident(table_name) || ' DROP COLUMN ' ||
		quote_ident(column_name);

	RETURN real_schema || '.' || table_name || '.' || column_name ||' effectively removed.';

END;
$function$
;

-- DROP FUNCTION incendies.dropgeometrycolumn(varchar, varchar);

CREATE OR REPLACE FUNCTION incendies.dropgeometrycolumn(table_name character varying, column_name character varying)
 RETURNS text
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
	ret text;
BEGIN
	SELECT incendies.DropGeometryColumn('','',$1,$2) into ret;
	RETURN ret;
END;
$function$
;

-- DROP FUNCTION incendies.dropgeometrytable(varchar);

CREATE OR REPLACE FUNCTION incendies.dropgeometrytable(table_name character varying)
 RETURNS text
 LANGUAGE sql
 STRICT
AS $function$ SELECT incendies.DropGeometryTable('','',$1) $function$
;

-- DROP FUNCTION incendies.dropgeometrytable(varchar, varchar, varchar);

CREATE OR REPLACE FUNCTION incendies.dropgeometrytable(catalog_name character varying, schema_name character varying, table_name character varying)
 RETURNS text
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
	real_schema name;

BEGIN

	IF ( schema_name = '' ) THEN
		SELECT current_schema() into real_schema;
	ELSE
		real_schema = schema_name;
	END IF;

	-- TODO: Should we warn if table doesn't exist probably instead just saying dropped
	-- Remove table
	EXECUTE 'DROP TABLE IF EXISTS '
		|| quote_ident(real_schema) || '.' ||
		quote_ident(table_name) || ' RESTRICT';

	RETURN
		real_schema || '.' ||
		table_name ||' dropped.';

END;
$function$
;

-- DROP FUNCTION incendies.dropgeometrytable(varchar, varchar);

CREATE OR REPLACE FUNCTION incendies.dropgeometrytable(schema_name character varying, table_name character varying)
 RETURNS text
 LANGUAGE sql
 STRICT
AS $function$ SELECT incendies.DropGeometryTable('',$1,$2) $function$
;

-- DROP FUNCTION incendies."equals"(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.equals(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_Equals$function$
;

-- DROP FUNCTION incendies.find_srid(varchar, varchar, varchar);

CREATE OR REPLACE FUNCTION incendies.find_srid(character varying, character varying, character varying)
 RETURNS integer
 LANGUAGE plpgsql
 STABLE PARALLEL SAFE STRICT
AS $function$
DECLARE
	schem varchar =  $1;
	tabl varchar = $2;
	sr int4;
BEGIN
-- if the table contains a . and the schema is empty
-- split the table into a schema and a table
-- otherwise drop through to default behavior
	IF ( schem = '' and strpos(tabl,'.') > 0 ) THEN
	 schem = substr(tabl,1,strpos(tabl,'.')-1);
	 tabl = substr(tabl,length(schem)+2);
	END IF;

	select SRID into sr from incendies.geometry_columns where (f_table_schema = schem or schem = '') and f_table_name = tabl and f_geometry_column = $3;
	IF NOT FOUND THEN
	   RAISE EXCEPTION 'find_srid() - could not find the corresponding SRID - is the geometry registered in the GEOMETRY_COLUMNS table?  Is there an uppercase/lowercase mismatch?';
	END IF;
	return sr;
END;
$function$
;

-- DROP FUNCTION incendies.geog_brin_inclusion_add_value(internal, internal, internal, internal);

CREATE OR REPLACE FUNCTION incendies.geog_brin_inclusion_add_value(internal, internal, internal, internal)
 RETURNS boolean
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$geog_brin_inclusion_add_value$function$
;

-- DROP FUNCTION incendies.geog_brin_inclusion_merge(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geog_brin_inclusion_merge(internal, internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$geog_brin_inclusion_merge$function$
;

-- DROP FUNCTION incendies.geography(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geography(incendies.geometry)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_from_geometry$function$
;

-- DROP FUNCTION incendies.geography(bytea);

CREATE OR REPLACE FUNCTION incendies.geography(bytea)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_from_binary$function$
;

-- DROP FUNCTION incendies.geography(incendies.geography, int4, bool);

CREATE OR REPLACE FUNCTION incendies.geography(incendies.geography, integer, boolean)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_enforce_typmod$function$
;

-- DROP FUNCTION incendies.geography_analyze(internal);

CREATE OR REPLACE FUNCTION incendies.geography_analyze(internal)
 RETURNS boolean
 LANGUAGE c
 STRICT
AS '$libdir/postgis-3', $function$gserialized_analyze_nd$function$
;

-- DROP FUNCTION incendies.geography_cmp(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies.geography_cmp(incendies.geography, incendies.geography)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_cmp$function$
;

-- DROP FUNCTION incendies.geography_distance_knn(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies.geography_distance_knn(incendies.geography, incendies.geography)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 100
AS '$libdir/postgis-3', $function$geography_distance_knn$function$
;

-- DROP FUNCTION incendies.geography_eq(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies.geography_eq(incendies.geography, incendies.geography)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_eq$function$
;

-- DROP FUNCTION incendies.geography_ge(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies.geography_ge(incendies.geography, incendies.geography)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_ge$function$
;

-- DROP FUNCTION incendies.geography_gist_compress(internal);

CREATE OR REPLACE FUNCTION incendies.geography_gist_compress(internal)
 RETURNS internal
 LANGUAGE c
AS '$libdir/postgis-3', $function$gserialized_gist_compress$function$
;

-- DROP FUNCTION incendies.geography_gist_consistent(internal, incendies.geography, int4);

CREATE OR REPLACE FUNCTION incendies.geography_gist_consistent(internal, incendies.geography, integer)
 RETURNS boolean
 LANGUAGE c
AS '$libdir/postgis-3', $function$gserialized_gist_consistent$function$
;

-- DROP FUNCTION incendies.geography_gist_decompress(internal);

CREATE OR REPLACE FUNCTION incendies.geography_gist_decompress(internal)
 RETURNS internal
 LANGUAGE c
AS '$libdir/postgis-3', $function$gserialized_gist_decompress$function$
;

-- DROP FUNCTION incendies.geography_gist_distance(internal, incendies.geography, int4);

CREATE OR REPLACE FUNCTION incendies.geography_gist_distance(internal, incendies.geography, integer)
 RETURNS double precision
 LANGUAGE c
AS '$libdir/postgis-3', $function$gserialized_gist_geog_distance$function$
;

-- DROP FUNCTION incendies.geography_gist_penalty(internal, internal, internal);

CREATE OR REPLACE FUNCTION incendies.geography_gist_penalty(internal, internal, internal)
 RETURNS internal
 LANGUAGE c
AS '$libdir/postgis-3', $function$gserialized_gist_penalty$function$
;

-- DROP FUNCTION incendies.geography_gist_picksplit(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geography_gist_picksplit(internal, internal)
 RETURNS internal
 LANGUAGE c
AS '$libdir/postgis-3', $function$gserialized_gist_picksplit$function$
;

-- DROP FUNCTION incendies.geography_gist_same(incendies.box2d, incendies.box2d, internal);

CREATE OR REPLACE FUNCTION incendies.geography_gist_same(incendies.box2d, incendies.box2d, internal)
 RETURNS internal
 LANGUAGE c
AS '$libdir/postgis-3', $function$gserialized_gist_same$function$
;

-- DROP FUNCTION incendies.geography_gist_union(bytea, internal);

CREATE OR REPLACE FUNCTION incendies.geography_gist_union(bytea, internal)
 RETURNS internal
 LANGUAGE c
AS '$libdir/postgis-3', $function$gserialized_gist_union$function$
;

-- DROP FUNCTION incendies.geography_gt(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies.geography_gt(incendies.geography, incendies.geography)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_gt$function$
;

-- DROP FUNCTION incendies.geography_in(cstring, oid, int4);

CREATE OR REPLACE FUNCTION incendies.geography_in(cstring, oid, integer)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_in$function$
;

-- DROP FUNCTION incendies.geography_le(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies.geography_le(incendies.geography, incendies.geography)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_le$function$
;

-- DROP FUNCTION incendies.geography_lt(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies.geography_lt(incendies.geography, incendies.geography)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_lt$function$
;

-- DROP FUNCTION incendies.geography_out(incendies.geography);

CREATE OR REPLACE FUNCTION incendies.geography_out(incendies.geography)
 RETURNS cstring
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_out$function$
;

-- DROP FUNCTION incendies.geography_overlaps(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies.geography_overlaps(incendies.geography, incendies.geography)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_overlaps$function$
;

-- DROP FUNCTION incendies.geography_recv(internal, oid, int4);

CREATE OR REPLACE FUNCTION incendies.geography_recv(internal, oid, integer)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_recv$function$
;

-- DROP FUNCTION incendies.geography_send(incendies.geography);

CREATE OR REPLACE FUNCTION incendies.geography_send(incendies.geography)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_send$function$
;

-- DROP FUNCTION incendies.geography_spgist_choose_nd(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geography_spgist_choose_nd(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_choose_nd$function$
;

-- DROP FUNCTION incendies.geography_spgist_compress_nd(internal);

CREATE OR REPLACE FUNCTION incendies.geography_spgist_compress_nd(internal)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_compress_nd$function$
;

-- DROP FUNCTION incendies.geography_spgist_config_nd(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geography_spgist_config_nd(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_config_nd$function$
;

-- DROP FUNCTION incendies.geography_spgist_inner_consistent_nd(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geography_spgist_inner_consistent_nd(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_inner_consistent_nd$function$
;

-- DROP FUNCTION incendies.geography_spgist_leaf_consistent_nd(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geography_spgist_leaf_consistent_nd(internal, internal)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_leaf_consistent_nd$function$
;

-- DROP FUNCTION incendies.geography_spgist_picksplit_nd(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geography_spgist_picksplit_nd(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_picksplit_nd$function$
;

-- DROP FUNCTION incendies.geography_typmod_in(_cstring);

CREATE OR REPLACE FUNCTION incendies.geography_typmod_in(cstring[])
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_typmod_in$function$
;

-- DROP FUNCTION incendies.geography_typmod_out(int4);

CREATE OR REPLACE FUNCTION incendies.geography_typmod_out(integer)
 RETURNS cstring
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$postgis_typmod_out$function$
;

-- DROP FUNCTION incendies.geom2d_brin_inclusion_add_value(internal, internal, internal, internal);

CREATE OR REPLACE FUNCTION incendies.geom2d_brin_inclusion_add_value(internal, internal, internal, internal)
 RETURNS boolean
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$geom2d_brin_inclusion_add_value$function$
;

-- DROP FUNCTION incendies.geom2d_brin_inclusion_merge(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geom2d_brin_inclusion_merge(internal, internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$geom2d_brin_inclusion_merge$function$
;

-- DROP FUNCTION incendies.geom3d_brin_inclusion_add_value(internal, internal, internal, internal);

CREATE OR REPLACE FUNCTION incendies.geom3d_brin_inclusion_add_value(internal, internal, internal, internal)
 RETURNS boolean
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$geom3d_brin_inclusion_add_value$function$
;

-- DROP FUNCTION incendies.geom3d_brin_inclusion_merge(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geom3d_brin_inclusion_merge(internal, internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$geom3d_brin_inclusion_merge$function$
;

-- DROP FUNCTION incendies.geom4d_brin_inclusion_add_value(internal, internal, internal, internal);

CREATE OR REPLACE FUNCTION incendies.geom4d_brin_inclusion_add_value(internal, internal, internal, internal)
 RETURNS boolean
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$geom4d_brin_inclusion_add_value$function$
;

-- DROP FUNCTION incendies.geom4d_brin_inclusion_merge(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geom4d_brin_inclusion_merge(internal, internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$geom4d_brin_inclusion_merge$function$
;

-- DROP FUNCTION incendies.geometry(incendies.geography);

CREATE OR REPLACE FUNCTION incendies.geometry(incendies.geography)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geometry_from_geography$function$
;

-- DROP FUNCTION incendies.geometry(incendies.box2d);

CREATE OR REPLACE FUNCTION incendies.geometry(incendies.box2d)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$BOX2D_to_LWGEOM$function$
;

-- DROP FUNCTION incendies.geometry(point);

CREATE OR REPLACE FUNCTION incendies.geometry(point)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$point_to_geometry$function$
;

-- DROP FUNCTION incendies.geometry(polygon);

CREATE OR REPLACE FUNCTION incendies.geometry(polygon)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$polygon_to_geometry$function$
;

-- DROP FUNCTION incendies.geometry(path);

CREATE OR REPLACE FUNCTION incendies.geometry(path)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$path_to_geometry$function$
;

-- DROP FUNCTION incendies.geometry(bytea);

CREATE OR REPLACE FUNCTION incendies.geometry(bytea)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_from_bytea$function$
;

-- DROP FUNCTION incendies.geometry(text);

CREATE OR REPLACE FUNCTION incendies.geometry(text)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$parse_WKT_lwgeom$function$
;

-- DROP FUNCTION incendies.geometry(incendies.geometry, int4, bool);

CREATE OR REPLACE FUNCTION incendies.geometry(incendies.geometry, integer, boolean)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geometry_enforce_typmod$function$
;

-- DROP FUNCTION incendies.geometry(incendies.box3d);

CREATE OR REPLACE FUNCTION incendies.geometry(incendies.box3d)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$BOX3D_to_LWGEOM$function$
;

-- DROP FUNCTION incendies.geometry_above(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_above(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_above_2d$function$
;

-- DROP FUNCTION incendies.geometry_analyze(internal);

CREATE OR REPLACE FUNCTION incendies.geometry_analyze(internal)
 RETURNS boolean
 LANGUAGE c
 STRICT
AS '$libdir/postgis-3', $function$gserialized_analyze_nd$function$
;

-- DROP FUNCTION incendies.geometry_below(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_below(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_below_2d$function$
;

-- DROP FUNCTION incendies.geometry_cmp(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_cmp(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$lwgeom_cmp$function$
;

-- DROP FUNCTION incendies.geometry_contained_3d(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_contained_3d(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_contained_3d$function$
;

-- DROP FUNCTION incendies.geometry_contains(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_contains(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_contains_2d$function$
;

-- DROP FUNCTION incendies.geometry_contains_3d(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_contains_3d(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_contains_3d$function$
;

-- DROP FUNCTION incendies.geometry_contains_nd(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_contains_nd(incendies.geometry, incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_contains$function$
;

-- DROP FUNCTION incendies.geometry_distance_box(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_distance_box(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_distance_box_2d$function$
;

-- DROP FUNCTION incendies.geometry_distance_centroid(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_distance_centroid(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_Distance$function$
;

-- DROP FUNCTION incendies.geometry_distance_centroid_nd(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_distance_centroid_nd(incendies.geometry, incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_distance_nd$function$
;

-- DROP FUNCTION incendies.geometry_distance_cpa(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_distance_cpa(incendies.geometry, incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_DistanceCPA$function$
;

-- DROP FUNCTION incendies.geometry_eq(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_eq(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$lwgeom_eq$function$
;

-- DROP FUNCTION incendies.geometry_ge(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_ge(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$lwgeom_ge$function$
;

-- DROP FUNCTION incendies.geometry_gist_compress_2d(internal);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_compress_2d(internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_compress_2d$function$
;

-- DROP FUNCTION incendies.geometry_gist_compress_nd(internal);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_compress_nd(internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_compress$function$
;

-- DROP FUNCTION incendies.geometry_gist_consistent_2d(internal, incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_consistent_2d(internal, incendies.geometry, integer)
 RETURNS boolean
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_consistent_2d$function$
;

-- DROP FUNCTION incendies.geometry_gist_consistent_nd(internal, incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_consistent_nd(internal, incendies.geometry, integer)
 RETURNS boolean
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_consistent$function$
;

-- DROP FUNCTION incendies.geometry_gist_decompress_2d(internal);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_decompress_2d(internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_decompress_2d$function$
;

-- DROP FUNCTION incendies.geometry_gist_decompress_nd(internal);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_decompress_nd(internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_decompress$function$
;

-- DROP FUNCTION incendies.geometry_gist_distance_2d(internal, incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_distance_2d(internal, incendies.geometry, integer)
 RETURNS double precision
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_distance_2d$function$
;

-- DROP FUNCTION incendies.geometry_gist_distance_nd(internal, incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_distance_nd(internal, incendies.geometry, integer)
 RETURNS double precision
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_distance$function$
;

-- DROP FUNCTION incendies.geometry_gist_penalty_2d(internal, internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_penalty_2d(internal, internal, internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_penalty_2d$function$
;

-- DROP FUNCTION incendies.geometry_gist_penalty_nd(internal, internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_penalty_nd(internal, internal, internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_penalty$function$
;

-- DROP FUNCTION incendies.geometry_gist_picksplit_2d(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_picksplit_2d(internal, internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_picksplit_2d$function$
;

-- DROP FUNCTION incendies.geometry_gist_picksplit_nd(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_picksplit_nd(internal, internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_picksplit$function$
;

-- DROP FUNCTION incendies.geometry_gist_same_2d(incendies.geometry, incendies.geometry, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_same_2d(geom1 incendies.geometry, geom2 incendies.geometry, internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_same_2d$function$
;

-- DROP FUNCTION incendies.geometry_gist_same_nd(incendies.geometry, incendies.geometry, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_same_nd(incendies.geometry, incendies.geometry, internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_same$function$
;

-- DROP FUNCTION incendies.geometry_gist_sortsupport_2d(internal);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_sortsupport_2d(internal)
 RETURNS void
 LANGUAGE c
 STRICT
AS '$libdir/postgis-3', $function$gserialized_gist_sortsupport_2d$function$
;

-- DROP FUNCTION incendies.geometry_gist_union_2d(bytea, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_union_2d(bytea, internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_union_2d$function$
;

-- DROP FUNCTION incendies.geometry_gist_union_nd(bytea, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_gist_union_nd(bytea, internal)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_union$function$
;

-- DROP FUNCTION incendies.geometry_gt(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_gt(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$lwgeom_gt$function$
;

-- DROP FUNCTION incendies.geometry_hash(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_hash(incendies.geometry)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$lwgeom_hash$function$
;

-- DROP FUNCTION incendies.geometry_in(cstring);

CREATE OR REPLACE FUNCTION incendies.geometry_in(cstring)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_in$function$
;

-- DROP FUNCTION incendies.geometry_le(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_le(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$lwgeom_le$function$
;

-- DROP FUNCTION incendies.geometry_left(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_left(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_left_2d$function$
;

-- DROP FUNCTION incendies.geometry_lt(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_lt(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$lwgeom_lt$function$
;

-- DROP FUNCTION incendies.geometry_neq(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_neq(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$lwgeom_neq$function$
;

-- DROP FUNCTION incendies.geometry_out(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_out(incendies.geometry)
 RETURNS cstring
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_out$function$
;

-- DROP FUNCTION incendies.geometry_overabove(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_overabove(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_overabove_2d$function$
;

-- DROP FUNCTION incendies.geometry_overbelow(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_overbelow(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_overbelow_2d$function$
;

-- DROP FUNCTION incendies.geometry_overlaps(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_overlaps(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_overlaps_2d$function$
;

-- DROP FUNCTION incendies.geometry_overlaps_3d(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_overlaps_3d(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_overlaps_3d$function$
;

-- DROP FUNCTION incendies.geometry_overlaps_nd(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_overlaps_nd(incendies.geometry, incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_overlaps$function$
;

-- DROP FUNCTION incendies.geometry_overleft(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_overleft(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_overleft_2d$function$
;

-- DROP FUNCTION incendies.geometry_overright(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_overright(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_overright_2d$function$
;

-- DROP FUNCTION incendies.geometry_recv(internal);

CREATE OR REPLACE FUNCTION incendies.geometry_recv(internal)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_recv$function$
;

-- DROP FUNCTION incendies.geometry_right(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_right(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_right_2d$function$
;

-- DROP FUNCTION incendies.geometry_same(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_same(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_same_2d$function$
;

-- DROP FUNCTION incendies.geometry_same_3d(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_same_3d(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_same_3d$function$
;

-- DROP FUNCTION incendies.geometry_same_nd(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_same_nd(incendies.geometry, incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_same$function$
;

-- DROP FUNCTION incendies.geometry_send(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_send(incendies.geometry)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_send$function$
;

-- DROP FUNCTION incendies.geometry_sortsupport(internal);

CREATE OR REPLACE FUNCTION incendies.geometry_sortsupport(internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$lwgeom_sortsupport$function$
;

-- DROP FUNCTION incendies.geometry_spgist_choose_2d(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_choose_2d(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_choose_2d$function$
;

-- DROP FUNCTION incendies.geometry_spgist_choose_3d(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_choose_3d(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_choose_3d$function$
;

-- DROP FUNCTION incendies.geometry_spgist_choose_nd(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_choose_nd(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_choose_nd$function$
;

-- DROP FUNCTION incendies.geometry_spgist_compress_2d(internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_compress_2d(internal)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_compress_2d$function$
;

-- DROP FUNCTION incendies.geometry_spgist_compress_3d(internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_compress_3d(internal)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_compress_3d$function$
;

-- DROP FUNCTION incendies.geometry_spgist_compress_nd(internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_compress_nd(internal)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_compress_nd$function$
;

-- DROP FUNCTION incendies.geometry_spgist_config_2d(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_config_2d(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_config_2d$function$
;

-- DROP FUNCTION incendies.geometry_spgist_config_3d(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_config_3d(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_config_3d$function$
;

-- DROP FUNCTION incendies.geometry_spgist_config_nd(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_config_nd(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_config_nd$function$
;

-- DROP FUNCTION incendies.geometry_spgist_inner_consistent_2d(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_inner_consistent_2d(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_inner_consistent_2d$function$
;

-- DROP FUNCTION incendies.geometry_spgist_inner_consistent_3d(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_inner_consistent_3d(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_inner_consistent_3d$function$
;

-- DROP FUNCTION incendies.geometry_spgist_inner_consistent_nd(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_inner_consistent_nd(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_inner_consistent_nd$function$
;

-- DROP FUNCTION incendies.geometry_spgist_leaf_consistent_2d(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_leaf_consistent_2d(internal, internal)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_leaf_consistent_2d$function$
;

-- DROP FUNCTION incendies.geometry_spgist_leaf_consistent_3d(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_leaf_consistent_3d(internal, internal)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_leaf_consistent_3d$function$
;

-- DROP FUNCTION incendies.geometry_spgist_leaf_consistent_nd(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_leaf_consistent_nd(internal, internal)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_leaf_consistent_nd$function$
;

-- DROP FUNCTION incendies.geometry_spgist_picksplit_2d(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_picksplit_2d(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_picksplit_2d$function$
;

-- DROP FUNCTION incendies.geometry_spgist_picksplit_3d(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_picksplit_3d(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_picksplit_3d$function$
;

-- DROP FUNCTION incendies.geometry_spgist_picksplit_nd(internal, internal);

CREATE OR REPLACE FUNCTION incendies.geometry_spgist_picksplit_nd(internal, internal)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_spgist_picksplit_nd$function$
;

-- DROP FUNCTION incendies.geometry_typmod_in(_cstring);

CREATE OR REPLACE FUNCTION incendies.geometry_typmod_in(cstring[])
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geometry_typmod_in$function$
;

-- DROP FUNCTION incendies.geometry_typmod_out(int4);

CREATE OR REPLACE FUNCTION incendies.geometry_typmod_out(integer)
 RETURNS cstring
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$postgis_typmod_out$function$
;

-- DROP FUNCTION incendies.geometry_within(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_within(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_within_2d$function$
;

-- DROP FUNCTION incendies.geometry_within_nd(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometry_within_nd(incendies.geometry, incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_within$function$
;

-- DROP FUNCTION incendies.geometrytype(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.geometrytype(incendies.geometry)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_getTYPE$function$
;

-- DROP FUNCTION incendies.geometrytype(incendies.geography);

CREATE OR REPLACE FUNCTION incendies.geometrytype(incendies.geography)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_getTYPE$function$
;

-- DROP FUNCTION incendies.geomfromewkb(bytea);

CREATE OR REPLACE FUNCTION incendies.geomfromewkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOMFromEWKB$function$
;

-- DROP FUNCTION incendies.geomfromewkt(text);

CREATE OR REPLACE FUNCTION incendies.geomfromewkt(text)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$parse_WKT_lwgeom$function$
;

-- DROP FUNCTION incendies.get_proj4_from_srid(int4);

CREATE OR REPLACE FUNCTION incendies.get_proj4_from_srid(integer)
 RETURNS text
 LANGUAGE plpgsql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$
	BEGIN
	RETURN proj4text::text FROM incendies.spatial_ref_sys WHERE srid= $1;
	END;
	$function$
;

-- DROP FUNCTION incendies.gidx_in(cstring);

CREATE OR REPLACE FUNCTION incendies.gidx_in(cstring)
 RETURNS incendies.gidx
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gidx_in$function$
;

-- DROP FUNCTION incendies.gidx_out(incendies.gidx);

CREATE OR REPLACE FUNCTION incendies.gidx_out(incendies.gidx)
 RETURNS cstring
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gidx_out$function$
;

-- DROP FUNCTION incendies.gserialized_gist_joinsel_2d(internal, oid, internal, int2);

CREATE OR REPLACE FUNCTION incendies.gserialized_gist_joinsel_2d(internal, oid, internal, smallint)
 RETURNS double precision
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_joinsel_2d$function$
;

-- DROP FUNCTION incendies.gserialized_gist_joinsel_nd(internal, oid, internal, int2);

CREATE OR REPLACE FUNCTION incendies.gserialized_gist_joinsel_nd(internal, oid, internal, smallint)
 RETURNS double precision
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_joinsel_nd$function$
;

-- DROP FUNCTION incendies.gserialized_gist_sel_2d(internal, oid, internal, int4);

CREATE OR REPLACE FUNCTION incendies.gserialized_gist_sel_2d(internal, oid, internal, integer)
 RETURNS double precision
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_sel_2d$function$
;

-- DROP FUNCTION incendies.gserialized_gist_sel_nd(internal, oid, internal, int4);

CREATE OR REPLACE FUNCTION incendies.gserialized_gist_sel_nd(internal, oid, internal, integer)
 RETURNS double precision
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/postgis-3', $function$gserialized_gist_sel_nd$function$
;

-- DROP FUNCTION incendies.is_contained_2d(incendies.box2df, incendies.box2df);

CREATE OR REPLACE FUNCTION incendies.is_contained_2d(incendies.box2df, incendies.box2df)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_contains_box2df_box2df_2d$function$
;

-- DROP FUNCTION incendies.is_contained_2d(incendies.box2df, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.is_contained_2d(incendies.box2df, incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_within_box2df_geom_2d$function$
;

-- DROP FUNCTION incendies.is_contained_2d(incendies.geometry, incendies.box2df);

CREATE OR REPLACE FUNCTION incendies.is_contained_2d(incendies.geometry, incendies.box2df)
 RETURNS boolean
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 1
AS $function$SELECT $2 OPERATOR(incendies.~) $1;$function$
;

-- DROP FUNCTION incendies."json"(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies."json"(incendies.geometry)
 RETURNS json
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geometry_to_json$function$
;

-- DROP FUNCTION incendies."jsonb"(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.jsonb(incendies.geometry)
 RETURNS jsonb
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geometry_to_jsonb$function$
;

-- DROP FUNCTION incendies.overlaps_2d(incendies.box2df, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.overlaps_2d(incendies.box2df, incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_overlaps_box2df_geom_2d$function$
;

-- DROP FUNCTION incendies.overlaps_2d(incendies.box2df, incendies.box2df);

CREATE OR REPLACE FUNCTION incendies.overlaps_2d(incendies.box2df, incendies.box2df)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_contains_box2df_box2df_2d$function$
;

-- DROP FUNCTION incendies.overlaps_2d(incendies.geometry, incendies.box2df);

CREATE OR REPLACE FUNCTION incendies.overlaps_2d(incendies.geometry, incendies.box2df)
 RETURNS boolean
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 1
AS $function$SELECT $2 OPERATOR(incendies.&&) $1;$function$
;

-- DROP FUNCTION incendies.overlaps_geog(incendies.geography, incendies.gidx);

CREATE OR REPLACE FUNCTION incendies.overlaps_geog(incendies.geography, incendies.gidx)
 RETURNS boolean
 LANGUAGE sql
 IMMUTABLE STRICT
AS $function$SELECT $2 OPERATOR(incendies.&&) $1;$function$
;

-- DROP FUNCTION incendies.overlaps_geog(incendies.gidx, incendies.gidx);

CREATE OR REPLACE FUNCTION incendies.overlaps_geog(incendies.gidx, incendies.gidx)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE STRICT
AS '$libdir/postgis-3', $function$gserialized_gidx_gidx_overlaps$function$
;

-- DROP FUNCTION incendies.overlaps_geog(incendies.gidx, incendies.geography);

CREATE OR REPLACE FUNCTION incendies.overlaps_geog(incendies.gidx, incendies.geography)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE STRICT
AS '$libdir/postgis-3', $function$gserialized_gidx_geog_overlaps$function$
;

-- DROP FUNCTION incendies.overlaps_nd(incendies.gidx, incendies.gidx);

CREATE OR REPLACE FUNCTION incendies.overlaps_nd(incendies.gidx, incendies.gidx)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_gidx_gidx_overlaps$function$
;

-- DROP FUNCTION incendies.overlaps_nd(incendies.geometry, incendies.gidx);

CREATE OR REPLACE FUNCTION incendies.overlaps_nd(incendies.geometry, incendies.gidx)
 RETURNS boolean
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 1
AS $function$SELECT $2 OPERATOR(incendies.&&&) $1;$function$
;

-- DROP FUNCTION incendies.overlaps_nd(incendies.gidx, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.overlaps_nd(incendies.gidx, incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$gserialized_gidx_geom_overlaps$function$
;

-- DROP FUNCTION incendies."path"(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.path(incendies.geometry)
 RETURNS path
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geometry_to_path$function$
;

-- DROP FUNCTION incendies.pgis_asflatgeobuf_finalfn(internal);

CREATE OR REPLACE FUNCTION incendies.pgis_asflatgeobuf_finalfn(internal)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_asflatgeobuf_finalfn$function$
;

-- DROP FUNCTION incendies.pgis_asflatgeobuf_transfn(internal, anyelement);

CREATE OR REPLACE FUNCTION incendies.pgis_asflatgeobuf_transfn(internal, anyelement)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$pgis_asflatgeobuf_transfn$function$
;

-- DROP FUNCTION incendies.pgis_asflatgeobuf_transfn(internal, anyelement, bool);

CREATE OR REPLACE FUNCTION incendies.pgis_asflatgeobuf_transfn(internal, anyelement, boolean)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$pgis_asflatgeobuf_transfn$function$
;

-- DROP FUNCTION incendies.pgis_asflatgeobuf_transfn(internal, anyelement, bool, text);

CREATE OR REPLACE FUNCTION incendies.pgis_asflatgeobuf_transfn(internal, anyelement, boolean, text)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$pgis_asflatgeobuf_transfn$function$
;

-- DROP FUNCTION incendies.pgis_asgeobuf_finalfn(internal);

CREATE OR REPLACE FUNCTION incendies.pgis_asgeobuf_finalfn(internal)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_asgeobuf_finalfn$function$
;

-- DROP FUNCTION incendies.pgis_asgeobuf_transfn(internal, anyelement, text);

CREATE OR REPLACE FUNCTION incendies.pgis_asgeobuf_transfn(internal, anyelement, text)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$pgis_asgeobuf_transfn$function$
;

-- DROP FUNCTION incendies.pgis_asgeobuf_transfn(internal, anyelement);

CREATE OR REPLACE FUNCTION incendies.pgis_asgeobuf_transfn(internal, anyelement)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$pgis_asgeobuf_transfn$function$
;

-- DROP FUNCTION incendies.pgis_asmvt_combinefn(internal, internal);

CREATE OR REPLACE FUNCTION incendies.pgis_asmvt_combinefn(internal, internal)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_asmvt_combinefn$function$
;

-- DROP FUNCTION incendies.pgis_asmvt_deserialfn(bytea, internal);

CREATE OR REPLACE FUNCTION incendies.pgis_asmvt_deserialfn(bytea, internal)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_asmvt_deserialfn$function$
;

-- DROP FUNCTION incendies.pgis_asmvt_finalfn(internal);

CREATE OR REPLACE FUNCTION incendies.pgis_asmvt_finalfn(internal)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_asmvt_finalfn$function$
;

-- DROP FUNCTION incendies.pgis_asmvt_serialfn(internal);

CREATE OR REPLACE FUNCTION incendies.pgis_asmvt_serialfn(internal)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_asmvt_serialfn$function$
;

-- DROP FUNCTION incendies.pgis_asmvt_transfn(internal, anyelement, text, int4, text);

CREATE OR REPLACE FUNCTION incendies.pgis_asmvt_transfn(internal, anyelement, text, integer, text)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_asmvt_transfn$function$
;

-- DROP FUNCTION incendies.pgis_asmvt_transfn(internal, anyelement, text, int4);

CREATE OR REPLACE FUNCTION incendies.pgis_asmvt_transfn(internal, anyelement, text, integer)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_asmvt_transfn$function$
;

-- DROP FUNCTION incendies.pgis_asmvt_transfn(internal, anyelement, text, int4, text, text);

CREATE OR REPLACE FUNCTION incendies.pgis_asmvt_transfn(internal, anyelement, text, integer, text, text)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_asmvt_transfn$function$
;

-- DROP FUNCTION incendies.pgis_asmvt_transfn(internal, anyelement);

CREATE OR REPLACE FUNCTION incendies.pgis_asmvt_transfn(internal, anyelement)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_asmvt_transfn$function$
;

-- DROP FUNCTION incendies.pgis_asmvt_transfn(internal, anyelement, text);

CREATE OR REPLACE FUNCTION incendies.pgis_asmvt_transfn(internal, anyelement, text)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_asmvt_transfn$function$
;

-- DROP FUNCTION incendies.pgis_geometry_accum_transfn(internal, incendies.geometry, float8, int4);

CREATE OR REPLACE FUNCTION incendies.pgis_geometry_accum_transfn(internal, incendies.geometry, double precision, integer)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$pgis_geometry_accum_transfn$function$
;

-- DROP FUNCTION incendies.pgis_geometry_accum_transfn(internal, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.pgis_geometry_accum_transfn(internal, incendies.geometry)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$pgis_geometry_accum_transfn$function$
;

-- DROP FUNCTION incendies.pgis_geometry_accum_transfn(internal, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.pgis_geometry_accum_transfn(internal, incendies.geometry, double precision)
 RETURNS internal
 LANGUAGE c
 PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$pgis_geometry_accum_transfn$function$
;

-- DROP FUNCTION incendies.pgis_geometry_clusterintersecting_finalfn(internal);

CREATE OR REPLACE FUNCTION incendies.pgis_geometry_clusterintersecting_finalfn(internal)
 RETURNS incendies.geometry[]
 LANGUAGE c
 PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_geometry_clusterintersecting_finalfn$function$
;

-- DROP FUNCTION incendies.pgis_geometry_clusterwithin_finalfn(internal);

CREATE OR REPLACE FUNCTION incendies.pgis_geometry_clusterwithin_finalfn(internal)
 RETURNS incendies.geometry[]
 LANGUAGE c
 PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_geometry_clusterwithin_finalfn$function$
;

-- DROP FUNCTION incendies.pgis_geometry_collect_finalfn(internal);

CREATE OR REPLACE FUNCTION incendies.pgis_geometry_collect_finalfn(internal)
 RETURNS incendies.geometry
 LANGUAGE c
 PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_geometry_collect_finalfn$function$
;

-- DROP FUNCTION incendies.pgis_geometry_coverageunion_finalfn(internal);

CREATE OR REPLACE FUNCTION incendies.pgis_geometry_coverageunion_finalfn(internal)
 RETURNS incendies.geometry
 LANGUAGE c
 PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_geometry_coverageunion_finalfn$function$
;

-- DROP FUNCTION incendies.pgis_geometry_makeline_finalfn(internal);

CREATE OR REPLACE FUNCTION incendies.pgis_geometry_makeline_finalfn(internal)
 RETURNS incendies.geometry
 LANGUAGE c
 PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_geometry_makeline_finalfn$function$
;

-- DROP FUNCTION incendies.pgis_geometry_polygonize_finalfn(internal);

CREATE OR REPLACE FUNCTION incendies.pgis_geometry_polygonize_finalfn(internal)
 RETURNS incendies.geometry
 LANGUAGE c
 PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_geometry_polygonize_finalfn$function$
;

-- DROP FUNCTION incendies.pgis_geometry_union_parallel_combinefn(internal, internal);

CREATE OR REPLACE FUNCTION incendies.pgis_geometry_union_parallel_combinefn(internal, internal)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE
AS '$libdir/postgis-3', $function$pgis_geometry_union_parallel_combinefn$function$
;

-- DROP FUNCTION incendies.pgis_geometry_union_parallel_deserialfn(bytea, internal);

CREATE OR REPLACE FUNCTION incendies.pgis_geometry_union_parallel_deserialfn(bytea, internal)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$pgis_geometry_union_parallel_deserialfn$function$
;

-- DROP FUNCTION incendies.pgis_geometry_union_parallel_finalfn(internal);

CREATE OR REPLACE FUNCTION incendies.pgis_geometry_union_parallel_finalfn(internal)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$pgis_geometry_union_parallel_finalfn$function$
;

-- DROP FUNCTION incendies.pgis_geometry_union_parallel_serialfn(internal);

CREATE OR REPLACE FUNCTION incendies.pgis_geometry_union_parallel_serialfn(internal)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$pgis_geometry_union_parallel_serialfn$function$
;

-- DROP FUNCTION incendies.pgis_geometry_union_parallel_transfn(internal, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.pgis_geometry_union_parallel_transfn(internal, incendies.geometry)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE
AS '$libdir/postgis-3', $function$pgis_geometry_union_parallel_transfn$function$
;

-- DROP FUNCTION incendies.pgis_geometry_union_parallel_transfn(internal, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.pgis_geometry_union_parallel_transfn(internal, incendies.geometry, double precision)
 RETURNS internal
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$pgis_geometry_union_parallel_transfn$function$
;

-- DROP FUNCTION incendies.point(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.point(incendies.geometry)
 RETURNS point
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geometry_to_point$function$
;

-- DROP FUNCTION incendies.polygon(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.polygon(incendies.geometry)
 RETURNS polygon
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geometry_to_polygon$function$
;

-- DROP FUNCTION incendies.populate_geometry_columns(oid, bool);

CREATE OR REPLACE FUNCTION incendies.populate_geometry_columns(tbl_oid oid, use_typmod boolean DEFAULT true)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
	gcs		 RECORD;
	gc		  RECORD;
	gc_old	  RECORD;
	gsrid	   integer;
	gndims	  integer;
	gtype	   text;
	query	   text;
	gc_is_valid boolean;
	inserted	integer;
	constraint_successful boolean := false;

BEGIN
	inserted := 0;

	-- Iterate through all geometry columns in this table
	FOR gcs IN
	SELECT n.nspname, c.relname, a.attname, c.relkind
		FROM pg_class c,
			 pg_attribute a,
			 pg_type t,
			 pg_namespace n
		WHERE c.relkind IN('r', 'f', 'p')
		AND t.typname = 'geometry'
		AND a.attisdropped = false
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND n.nspname NOT ILIKE 'pg_temp%'
		AND c.oid = tbl_oid
	LOOP

		RAISE DEBUG 'Processing column %.%.%', gcs.nspname, gcs.relname, gcs.attname;

		gc_is_valid := true;
		-- Find the srid, coord_dimension, and type of current geometry
		-- in geometry_columns -- which is now a view

		SELECT type, srid, coord_dimension, gcs.relkind INTO gc_old
			FROM geometry_columns
			WHERE f_table_schema = gcs.nspname AND f_table_name = gcs.relname AND f_geometry_column = gcs.attname;

		IF upper(gc_old.type) = 'GEOMETRY' THEN
		-- This is an unconstrained geometry we need to do something
		-- We need to figure out what to set the type by inspecting the data
			EXECUTE 'SELECT incendies.ST_srid(' || quote_ident(gcs.attname) || ') As srid, incendies.GeometryType(' || quote_ident(gcs.attname) || ') As type, incendies.ST_NDims(' || quote_ident(gcs.attname) || ') As dims ' ||
					 ' FROM ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) ||
					 ' WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1;'
				INTO gc;
			IF gc IS NULL THEN -- there is no data so we can not determine geometry type
				RAISE WARNING 'No data in table %.%, so no information to determine geometry type and srid', gcs.nspname, gcs.relname;
				RETURN 0;
			END IF;
			gsrid := gc.srid; gtype := gc.type; gndims := gc.dims;

			IF use_typmod THEN
				BEGIN
					EXECUTE 'ALTER TABLE ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || ' ALTER COLUMN ' || quote_ident(gcs.attname) ||
						' TYPE geometry(' || postgis_type_name(gtype, gndims, true) || ', ' || gsrid::text  || ') ';
					inserted := inserted + 1;
				EXCEPTION
						WHEN invalid_parameter_value OR feature_not_supported THEN
						RAISE WARNING 'Could not convert ''%'' in ''%.%'' to use typmod with srid %, type %: %', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname), gsrid, postgis_type_name(gtype, gndims, true), SQLERRM;
							gc_is_valid := false;
				END;

			ELSE
				-- Try to apply srid check to column
				constraint_successful = false;
				IF (gsrid > 0 AND postgis_constraint_srid(gcs.nspname, gcs.relname,gcs.attname) IS NULL ) THEN
					BEGIN
						EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) ||
								 ' ADD CONSTRAINT ' || quote_ident('enforce_srid_' || gcs.attname) ||
								 ' CHECK (ST_srid(' || quote_ident(gcs.attname) || ') = ' || gsrid || ')';
						constraint_successful := true;
					EXCEPTION
						WHEN check_violation THEN
							RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not apply constraint CHECK (st_srid(%) = %)', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname), quote_ident(gcs.attname), gsrid;
							gc_is_valid := false;
					END;
				END IF;

				-- Try to apply ndims check to column
				IF (gndims IS NOT NULL AND postgis_constraint_dims(gcs.nspname, gcs.relname,gcs.attname) IS NULL ) THEN
					BEGIN
						EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
								 ADD CONSTRAINT ' || quote_ident('enforce_dims_' || gcs.attname) || '
								 CHECK (st_ndims(' || quote_ident(gcs.attname) || ') = '||gndims||')';
						constraint_successful := true;
					EXCEPTION
						WHEN check_violation THEN
							RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not apply constraint CHECK (st_ndims(%) = %)', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname), quote_ident(gcs.attname), gndims;
							gc_is_valid := false;
					END;
				END IF;

				-- Try to apply geometrytype check to column
				IF (gtype IS NOT NULL AND postgis_constraint_type(gcs.nspname, gcs.relname,gcs.attname) IS NULL ) THEN
					BEGIN
						EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
						ADD CONSTRAINT ' || quote_ident('enforce_geotype_' || gcs.attname) || '
						CHECK (geometrytype(' || quote_ident(gcs.attname) || ') = ' || quote_literal(gtype) || ')';
						constraint_successful := true;
					EXCEPTION
						WHEN check_violation THEN
							-- No geometry check can be applied. This column contains a number of geometry types.
							RAISE WARNING 'Could not add geometry type check (%) to table column: %.%.%', gtype, quote_ident(gcs.nspname),quote_ident(gcs.relname),quote_ident(gcs.attname);
					END;
				END IF;
				 --only count if we were successful in applying at least one constraint
				IF constraint_successful THEN
					inserted := inserted + 1;
				END IF;
			END IF;
		END IF;

	END LOOP;

	RETURN inserted;
END

$function$
;

-- DROP FUNCTION incendies.populate_geometry_columns(bool);

CREATE OR REPLACE FUNCTION incendies.populate_geometry_columns(use_typmod boolean DEFAULT true)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
	inserted	integer;
	oldcount	integer;
	probed	  integer;
	stale	   integer;
	gcs		 RECORD;
	gc		  RECORD;
	gsrid	   integer;
	gndims	  integer;
	gtype	   text;
	query	   text;
	gc_is_valid boolean;

BEGIN
	SELECT count(*) INTO oldcount FROM incendies.geometry_columns;
	inserted := 0;

	-- Count the number of geometry columns in all tables and views
	SELECT count(DISTINCT c.oid) INTO probed
	FROM pg_class c,
		 pg_attribute a,
		 pg_type t,
		 pg_namespace n
	WHERE c.relkind IN('r','v','f', 'p')
		AND t.typname = 'geometry'
		AND a.attisdropped = false
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND n.nspname NOT ILIKE 'pg_temp%' AND c.relname != 'raster_columns' ;

	-- Iterate through all non-dropped geometry columns
	RAISE DEBUG 'Processing Tables.....';

	FOR gcs IN
	SELECT DISTINCT ON (c.oid) c.oid, n.nspname, c.relname
		FROM pg_class c,
			 pg_attribute a,
			 pg_type t,
			 pg_namespace n
		WHERE c.relkind IN( 'r', 'f', 'p')
		AND t.typname = 'geometry'
		AND a.attisdropped = false
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND n.nspname NOT ILIKE 'pg_temp%' AND c.relname != 'raster_columns'
	LOOP

		inserted := inserted + incendies.populate_geometry_columns(gcs.oid, use_typmod);
	END LOOP;

	IF oldcount > inserted THEN
		stale = oldcount-inserted;
	ELSE
		stale = 0;
	END IF;

	RETURN 'probed:' ||probed|| ' inserted:'||inserted;
END

$function$
;

-- DROP FUNCTION incendies.postgis_addbbox(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.postgis_addbbox(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_addBBOX$function$
;

-- DROP FUNCTION incendies.postgis_cache_bbox();

CREATE OR REPLACE FUNCTION incendies.postgis_cache_bbox()
 RETURNS trigger
 LANGUAGE c
AS '$libdir/postgis-3', $function$cache_bbox$function$
;

-- DROP FUNCTION incendies.postgis_constraint_dims(text, text, text);

CREATE OR REPLACE FUNCTION incendies.postgis_constraint_dims(geomschema text, geomtable text, geomcolumn text)
 RETURNS integer
 LANGUAGE sql
 STABLE PARALLEL SAFE STRICT COST 250
AS $function$
SELECT  replace(split_part(s.consrc, ' = ', 2), ')', '')::integer
		 FROM pg_class c, pg_namespace n, pg_attribute a
		 , (SELECT connamespace, conrelid, conkey, pg_get_constraintdef(oid) As consrc
			FROM pg_constraint) AS s
		 WHERE n.nspname = $1
		 AND c.relname = $2
		 AND a.attname = $3
		 AND a.attrelid = c.oid
		 AND s.connamespace = n.oid
		 AND s.conrelid = c.oid
		 AND a.attnum = ANY (s.conkey)
		 AND s.consrc LIKE '%ndims(% = %';
$function$
;

-- DROP FUNCTION incendies.postgis_constraint_srid(text, text, text);

CREATE OR REPLACE FUNCTION incendies.postgis_constraint_srid(geomschema text, geomtable text, geomcolumn text)
 RETURNS integer
 LANGUAGE sql
 STABLE PARALLEL SAFE STRICT COST 250
AS $function$
SELECT replace(replace(split_part(s.consrc, ' = ', 2), ')', ''), '(', '')::integer
		 FROM pg_class c, pg_namespace n, pg_attribute a
		 , (SELECT connamespace, conrelid, conkey, pg_get_constraintdef(oid) As consrc
			FROM pg_constraint) AS s
		 WHERE n.nspname = $1
		 AND c.relname = $2
		 AND a.attname = $3
		 AND a.attrelid = c.oid
		 AND s.connamespace = n.oid
		 AND s.conrelid = c.oid
		 AND a.attnum = ANY (s.conkey)
		 AND s.consrc LIKE '%srid(% = %';
$function$
;

-- DROP FUNCTION incendies.postgis_constraint_type(text, text, text);

CREATE OR REPLACE FUNCTION incendies.postgis_constraint_type(geomschema text, geomtable text, geomcolumn text)
 RETURNS character varying
 LANGUAGE sql
 STABLE PARALLEL SAFE STRICT COST 250
AS $function$
SELECT  replace(split_part(s.consrc, '''', 2), ')', '')::varchar
		 FROM pg_class c, pg_namespace n, pg_attribute a
		 , (SELECT connamespace, conrelid, conkey, pg_get_constraintdef(oid) As consrc
			FROM pg_constraint) AS s
		 WHERE n.nspname = $1
		 AND c.relname = $2
		 AND a.attname = $3
		 AND a.attrelid = c.oid
		 AND s.connamespace = n.oid
		 AND s.conrelid = c.oid
		 AND a.attnum = ANY (s.conkey)
		 AND s.consrc LIKE '%geometrytype(% = %';
$function$
;

-- DROP FUNCTION incendies.postgis_dropbbox(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.postgis_dropbbox(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_dropBBOX$function$
;

-- DROP FUNCTION incendies.postgis_extensions_upgrade(text);

CREATE OR REPLACE FUNCTION incendies.postgis_extensions_upgrade(target_version text DEFAULT NULL::text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
	rec record;
	sql text;
	var_schema text;
BEGIN

	FOR rec IN
		SELECT name, default_version, installed_version
		FROM pg_catalog.pg_available_extensions
		WHERE name IN (
			'postgis',
			'postgis_raster',
			'postgis_sfcgal',
			'postgis_topology',
			'postgis_tiger_geocoder'
		)
		ORDER BY length(name) -- this is to make sure 'postgis' is first !
	LOOP --{

		IF target_version IS NULL THEN
			target_version := rec.default_version;
		END IF;

		IF rec.installed_version IS NULL THEN --{
			-- If the support installed by available extension
			-- is found unpackaged, we package it
			IF --{
				 -- PostGIS is always available (this function is part of it)
				 rec.name = 'postgis'

				 -- PostGIS raster is available if type 'raster' exists
				 OR ( rec.name = 'postgis_raster' AND EXISTS (
							SELECT 1 FROM pg_catalog.pg_type
							WHERE typname = 'raster' ) )

				 -- PostGIS SFCGAL is available if
				 -- 'postgis_sfcgal_version' function exists
				 OR ( rec.name = 'postgis_sfcgal' AND EXISTS (
							SELECT 1 FROM pg_catalog.pg_proc
							WHERE proname = 'postgis_sfcgal_version' ) )

				 -- PostGIS Topology is available if
				 -- 'topology.topology' table exists
				 -- NOTE: watch out for https://trac.osgeo.org/postgis/ticket/2503
				 OR ( rec.name = 'postgis_topology' AND EXISTS (
							SELECT 1 FROM pg_catalog.pg_class c
							JOIN pg_catalog.pg_namespace n ON (c.relnamespace = n.oid )
							WHERE n.nspname = 'topology' AND c.relname = 'topology') )

				 OR ( rec.name = 'postgis_tiger_geocoder' AND EXISTS (
							SELECT 1 FROM pg_catalog.pg_class c
							JOIN pg_catalog.pg_namespace n ON (c.relnamespace = n.oid )
							WHERE n.nspname = 'tiger' AND c.relname = 'geocode_settings') )
			THEN --}{ -- the code is unpackaged
				-- Force install in same schema as postgis
				SELECT INTO var_schema n.nspname
				  FROM pg_namespace n, pg_proc p
				  WHERE p.proname = 'postgis_full_version'
					AND n.oid = p.pronamespace
				  LIMIT 1;
				IF rec.name NOT IN('postgis_topology', 'postgis_tiger_geocoder')
				THEN
					sql := format(
							  'CREATE EXTENSION %1$I SCHEMA %2$I VERSION unpackaged;'
							  'ALTER EXTENSION %1$I UPDATE TO %3$I',
							  rec.name, var_schema, target_version);
				ELSE
					sql := format(
							 'CREATE EXTENSION %1$I VERSION unpackaged;'
							 'ALTER EXTENSION %1$I UPDATE TO %2$I',
							 rec.name, target_version);
				END IF;
				RAISE NOTICE 'Packaging and updating %', rec.name;
				RAISE DEBUG '%', sql;
				EXECUTE sql;
			ELSE
				RAISE DEBUG 'Skipping % (not in use)', rec.name;
			END IF; --}
		ELSE -- The code is already packaged, upgrade it --}{
			sql = format(
				'ALTER EXTENSION %1$I UPDATE TO "ANY";'
				'ALTER EXTENSION %1$I UPDATE TO %2$I',
				rec.name, target_version
				);
			RAISE NOTICE 'Updating extension % %', rec.name, rec.installed_version;
			RAISE DEBUG '%', sql;
			EXECUTE sql;
		END IF; --}

	END LOOP; --}

	RETURN format(
		'Upgrade to version %s completed, run SELECT postgis_full_version(); for details',
		target_version
	);


END
$function$
;

-- DROP FUNCTION incendies.postgis_full_version();

CREATE OR REPLACE FUNCTION incendies.postgis_full_version()
 RETURNS text
 LANGUAGE plpgsql
 IMMUTABLE
AS $function$
DECLARE
	libver text;
	librev text;
	projver text;
	projver_compiled text;
	geosver text;
	geosver_compiled text;
	sfcgalver text;
	gdalver text := NULL;
	libxmlver text;
	liblwgeomver text;
	dbproc text;
	relproc text;
	fullver text;
	rast_lib_ver text := NULL;
	rast_scr_ver text := NULL;
	topo_scr_ver text := NULL;
	json_lib_ver text;
	protobuf_lib_ver text;
	wagyu_lib_ver text;
	sfcgal_lib_ver text;
	sfcgal_scr_ver text;
	pgsql_scr_ver text;
	pgsql_ver text;
	core_is_extension bool;
BEGIN
	SELECT incendies.postgis_lib_version() INTO libver;
	SELECT incendies.postgis_proj_version() INTO projver;
	SELECT incendies.postgis_geos_version() INTO geosver;
	SELECT incendies.postgis_geos_compiled_version() INTO geosver_compiled;
	SELECT incendies.postgis_proj_compiled_version() INTO projver_compiled;
	SELECT incendies.postgis_libjson_version() INTO json_lib_ver;
	SELECT incendies.postgis_libprotobuf_version() INTO protobuf_lib_ver;
	SELECT incendies.postgis_wagyu_version() INTO wagyu_lib_ver;
	SELECT incendies._postgis_scripts_pgsql_version() INTO pgsql_scr_ver;
	SELECT incendies._postgis_pgsql_version() INTO pgsql_ver;
	BEGIN
		SELECT incendies.postgis_gdal_version() INTO gdalver;
	EXCEPTION
		WHEN undefined_function THEN
			RAISE DEBUG 'Function postgis_gdal_version() not found.  Is raster support enabled and rtpostgis.sql installed?';
	END;
	BEGIN
		SELECT incendies.postgis_sfcgal_full_version() INTO sfcgalver;
		BEGIN
			SELECT incendies.postgis_sfcgal_scripts_installed() INTO sfcgal_scr_ver;
		EXCEPTION
			WHEN undefined_function THEN
				sfcgal_scr_ver := 'missing';
		END;
	EXCEPTION
		WHEN undefined_function THEN
			RAISE DEBUG 'Function postgis_sfcgal_scripts_installed() not found. Is sfcgal support enabled and sfcgal.sql installed?';
	END;
	SELECT incendies.postgis_liblwgeom_version() INTO liblwgeomver;
	SELECT incendies.postgis_libxml_version() INTO libxmlver;
	SELECT incendies.postgis_scripts_installed() INTO dbproc;
	SELECT incendies.postgis_scripts_released() INTO relproc;
	SELECT incendies.postgis_lib_revision() INTO librev;
	BEGIN
		SELECT topology.postgis_topology_scripts_installed() INTO topo_scr_ver;
	EXCEPTION
		WHEN undefined_function OR invalid_schema_name THEN
			RAISE DEBUG 'Function postgis_topology_scripts_installed() not found. Is topology support enabled and topology.sql installed?';
		WHEN insufficient_privilege THEN
			RAISE NOTICE 'Topology support cannot be inspected. Is current user granted USAGE on schema "topology" ?';
		WHEN OTHERS THEN
			RAISE NOTICE 'Function postgis_topology_scripts_installed() could not be called: % (%)', SQLERRM, SQLSTATE;
	END;

	BEGIN
		SELECT postgis_raster_scripts_installed() INTO rast_scr_ver;
	EXCEPTION
		WHEN undefined_function THEN
			RAISE DEBUG 'Function postgis_raster_scripts_installed() not found. Is raster support enabled and rtpostgis.sql installed?';
		WHEN OTHERS THEN
			RAISE NOTICE 'Function postgis_raster_scripts_installed() could not be called: % (%)', SQLERRM, SQLSTATE;
	END;

	BEGIN
		SELECT incendies.postgis_raster_lib_version() INTO rast_lib_ver;
	EXCEPTION
		WHEN undefined_function THEN
			RAISE DEBUG 'Function postgis_raster_lib_version() not found. Is raster support enabled and rtpostgis.sql installed?';
		WHEN OTHERS THEN
			RAISE NOTICE 'Function postgis_raster_lib_version() could not be called: % (%)', SQLERRM, SQLSTATE;
	END;

	fullver = 'POSTGIS="' || libver;

	IF  librev IS NOT NULL THEN
		fullver = fullver || ' ' || librev;
	END IF;

	fullver = fullver || '"';

	IF EXISTS (
		SELECT * FROM pg_catalog.pg_extension
		WHERE extname = 'postgis')
	THEN
			fullver = fullver || ' [EXTENSION]';
			core_is_extension := true;
	ELSE
			core_is_extension := false;
	END IF;

	IF liblwgeomver != relproc THEN
		fullver = fullver || ' (liblwgeom version mismatch: "' || liblwgeomver || '")';
	END IF;

	fullver = fullver || ' PGSQL="' || pgsql_scr_ver || '"';
	IF pgsql_scr_ver != pgsql_ver THEN
		fullver = fullver || ' (procs need upgrade for use with PostgreSQL "' || pgsql_ver || '")';
	END IF;

	IF  geosver IS NOT NULL THEN
		fullver = fullver || ' GEOS="' || geosver || '"';
		IF (string_to_array(geosver, '.'))[1:2] != (string_to_array(geosver_compiled, '.'))[1:2]
		THEN
			fullver = format('%s (compiled against GEOS %s)', fullver, geosver_compiled);
		END IF;
	END IF;

	IF  sfcgalver IS NOT NULL THEN
		fullver = fullver || ' SFCGAL="' || sfcgalver || '"';
	END IF;

	IF  projver IS NOT NULL THEN
		fullver = fullver || ' PROJ="' || projver || '"';
		IF (string_to_array(projver, '.'))[1:3] != (string_to_array(projver_compiled, '.'))[1:3]
		THEN
			fullver = format('%s (compiled against PROJ %s)', fullver, projver_compiled);
		END IF;
	END IF;

	IF  gdalver IS NOT NULL THEN
		fullver = fullver || ' GDAL="' || gdalver || '"';
	END IF;

	IF  libxmlver IS NOT NULL THEN
		fullver = fullver || ' LIBXML="' || libxmlver || '"';
	END IF;

	IF json_lib_ver IS NOT NULL THEN
		fullver = fullver || ' LIBJSON="' || json_lib_ver || '"';
	END IF;

	IF protobuf_lib_ver IS NOT NULL THEN
		fullver = fullver || ' LIBPROTOBUF="' || protobuf_lib_ver || '"';
	END IF;

	IF wagyu_lib_ver IS NOT NULL THEN
		fullver = fullver || ' WAGYU="' || wagyu_lib_ver || '"';
	END IF;

	IF dbproc != relproc THEN
		fullver = fullver || ' (core procs from "' || dbproc || '" need upgrade)';
	END IF;

	IF topo_scr_ver IS NOT NULL THEN
		fullver = fullver || ' TOPOLOGY';
		IF topo_scr_ver != relproc THEN
			fullver = fullver || ' (topology procs from "' || topo_scr_ver || '" need upgrade)';
		END IF;
		IF core_is_extension AND NOT EXISTS (
			SELECT * FROM pg_catalog.pg_extension
			WHERE extname = 'postgis_topology')
		THEN
				fullver = fullver || ' [UNPACKAGED!]';
		END IF;
	END IF;

	IF rast_lib_ver IS NOT NULL THEN
		fullver = fullver || ' RASTER';
		IF rast_lib_ver != relproc THEN
			fullver = fullver || ' (raster lib from "' || rast_lib_ver || '" need upgrade)';
		END IF;
		IF core_is_extension AND NOT EXISTS (
			SELECT * FROM pg_catalog.pg_extension
			WHERE extname = 'postgis_raster')
		THEN
				fullver = fullver || ' [UNPACKAGED!]';
		END IF;
	END IF;

	IF rast_scr_ver IS NOT NULL AND rast_scr_ver != relproc THEN
		fullver = fullver || ' (raster procs from "' || rast_scr_ver || '" need upgrade)';
	END IF;

	IF sfcgal_scr_ver IS NOT NULL AND sfcgal_scr_ver != relproc THEN
		fullver = fullver || ' (sfcgal procs from "' || sfcgal_scr_ver || '" need upgrade)';
	END IF;

	-- Check for the presence of deprecated functions
	IF EXISTS ( SELECT oid FROM pg_catalog.pg_proc WHERE proname LIKE '%_deprecated_by_postgis_%' )
	THEN
		fullver = fullver || ' (deprecated functions exist, upgrade is not complete)';
	END IF;

	RETURN fullver;
END
$function$
;

-- DROP FUNCTION incendies.postgis_geos_compiled_version();

CREATE OR REPLACE FUNCTION incendies.postgis_geos_compiled_version()
 RETURNS text
 LANGUAGE c
 IMMUTABLE
AS '$libdir/postgis-3', $function$postgis_geos_compiled_version$function$
;

-- DROP FUNCTION incendies.postgis_geos_noop(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.postgis_geos_noop(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$GEOSnoop$function$
;

-- DROP FUNCTION incendies.postgis_geos_version();

CREATE OR REPLACE FUNCTION incendies.postgis_geos_version()
 RETURNS text
 LANGUAGE c
 IMMUTABLE
AS '$libdir/postgis-3', $function$postgis_geos_version$function$
;

-- DROP FUNCTION incendies.postgis_getbbox(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.postgis_getbbox(incendies.geometry)
 RETURNS incendies.box2d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_to_BOX2DF$function$
;

-- DROP FUNCTION incendies.postgis_hasbbox(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.postgis_hasbbox(incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_hasBBOX$function$
;

-- DROP FUNCTION incendies.postgis_index_supportfn(internal);

CREATE OR REPLACE FUNCTION incendies.postgis_index_supportfn(internal)
 RETURNS internal
 LANGUAGE c
AS '$libdir/postgis-3', $function$postgis_index_supportfn$function$
;

-- DROP FUNCTION incendies.postgis_lib_build_date();

CREATE OR REPLACE FUNCTION incendies.postgis_lib_build_date()
 RETURNS text
 LANGUAGE c
 IMMUTABLE
AS '$libdir/postgis-3', $function$postgis_lib_build_date$function$
;

-- DROP FUNCTION incendies.postgis_lib_revision();

CREATE OR REPLACE FUNCTION incendies.postgis_lib_revision()
 RETURNS text
 LANGUAGE c
 IMMUTABLE
AS '$libdir/postgis-3', $function$postgis_lib_revision$function$
;

-- DROP FUNCTION incendies.postgis_lib_version();

CREATE OR REPLACE FUNCTION incendies.postgis_lib_version()
 RETURNS text
 LANGUAGE c
 IMMUTABLE
AS '$libdir/postgis-3', $function$postgis_lib_version$function$
;

-- DROP FUNCTION incendies.postgis_libjson_version();

CREATE OR REPLACE FUNCTION incendies.postgis_libjson_version()
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$postgis_libjson_version$function$
;

-- DROP FUNCTION incendies.postgis_liblwgeom_version();

CREATE OR REPLACE FUNCTION incendies.postgis_liblwgeom_version()
 RETURNS text
 LANGUAGE c
 IMMUTABLE
AS '$libdir/postgis-3', $function$postgis_liblwgeom_version$function$
;

-- DROP FUNCTION incendies.postgis_libprotobuf_version();

CREATE OR REPLACE FUNCTION incendies.postgis_libprotobuf_version()
 RETURNS text
 LANGUAGE c
 IMMUTABLE STRICT
AS '$libdir/postgis-3', $function$postgis_libprotobuf_version$function$
;

-- DROP FUNCTION incendies.postgis_libxml_version();

CREATE OR REPLACE FUNCTION incendies.postgis_libxml_version()
 RETURNS text
 LANGUAGE c
 IMMUTABLE
AS '$libdir/postgis-3', $function$postgis_libxml_version$function$
;

-- DROP FUNCTION incendies.postgis_noop(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.postgis_noop(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_noop$function$
;

-- DROP FUNCTION incendies.postgis_proj_compiled_version();

CREATE OR REPLACE FUNCTION incendies.postgis_proj_compiled_version()
 RETURNS text
 LANGUAGE c
 IMMUTABLE
AS '$libdir/postgis-3', $function$postgis_proj_compiled_version$function$
;

-- DROP FUNCTION incendies.postgis_proj_version();

CREATE OR REPLACE FUNCTION incendies.postgis_proj_version()
 RETURNS text
 LANGUAGE c
 IMMUTABLE
AS '$libdir/postgis-3', $function$postgis_proj_version$function$
;

-- DROP FUNCTION incendies.postgis_scripts_build_date();

CREATE OR REPLACE FUNCTION incendies.postgis_scripts_build_date()
 RETURNS text
 LANGUAGE sql
 IMMUTABLE
AS $function$SELECT '2025-01-19 06:35:59'::text AS version$function$
;

-- DROP FUNCTION incendies.postgis_scripts_installed();

CREATE OR REPLACE FUNCTION incendies.postgis_scripts_installed()
 RETURNS text
 LANGUAGE sql
 IMMUTABLE
AS $function$ SELECT trim('3.5.2'::text || $rev$ dea6d0a $rev$) AS version $function$
;

-- DROP FUNCTION incendies.postgis_scripts_released();

CREATE OR REPLACE FUNCTION incendies.postgis_scripts_released()
 RETURNS text
 LANGUAGE c
 IMMUTABLE
AS '$libdir/postgis-3', $function$postgis_scripts_released$function$
;

-- DROP FUNCTION incendies.postgis_srs(text, text);

CREATE OR REPLACE FUNCTION incendies.postgis_srs(auth_name text, auth_srid text)
 RETURNS TABLE(auth_name text, auth_srid text, srname text, srtext text, proj4text text, point_sw incendies.geometry, point_ne incendies.geometry)
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$postgis_srs_entry$function$
;

-- DROP FUNCTION incendies.postgis_srs_all();

CREATE OR REPLACE FUNCTION incendies.postgis_srs_all()
 RETURNS TABLE(auth_name text, auth_srid text, srname text, srtext text, proj4text text, point_sw incendies.geometry, point_ne incendies.geometry)
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$postgis_srs_entry_all$function$
;

-- DROP FUNCTION incendies.postgis_srs_codes(text);

CREATE OR REPLACE FUNCTION incendies.postgis_srs_codes(auth_name text)
 RETURNS SETOF text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$postgis_srs_codes$function$
;

-- DROP FUNCTION incendies.postgis_srs_search(incendies.geometry, text);

CREATE OR REPLACE FUNCTION incendies.postgis_srs_search(bounds incendies.geometry, authname text DEFAULT 'EPSG'::text)
 RETURNS TABLE(auth_name text, auth_srid text, srname text, srtext text, proj4text text, point_sw incendies.geometry, point_ne incendies.geometry)
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$postgis_srs_search$function$
;

-- DROP FUNCTION incendies.postgis_svn_version();

CREATE OR REPLACE FUNCTION incendies.postgis_svn_version()
 RETURNS text
 LANGUAGE sql
 IMMUTABLE
AS $function$
	SELECT incendies._postgis_deprecate(
		'postgis_svn_version', 'postgis_lib_revision', '3.1.0');
	SELECT incendies.postgis_lib_revision();
$function$
;

-- DROP FUNCTION incendies.postgis_transform_geometry(incendies.geometry, text, text, int4);

CREATE OR REPLACE FUNCTION incendies.postgis_transform_geometry(geom incendies.geometry, text, text, integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$transform_geom$function$
;

-- DROP FUNCTION incendies.postgis_transform_pipeline_geometry(incendies.geometry, text, bool, int4);

CREATE OR REPLACE FUNCTION incendies.postgis_transform_pipeline_geometry(geom incendies.geometry, pipeline text, forward boolean, to_srid integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$transform_pipeline_geom$function$
;

-- DROP FUNCTION incendies.postgis_type_name(varchar, int4, bool);

CREATE OR REPLACE FUNCTION incendies.postgis_type_name(geomname character varying, coord_dimension integer, use_new_name boolean DEFAULT true)
 RETURNS character varying
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS $function$
	SELECT CASE WHEN $3 THEN new_name ELSE old_name END As geomname
	FROM
	( VALUES
			('GEOMETRY', 'Geometry', 2),
			('GEOMETRY', 'GeometryZ', 3),
			('GEOMETRYM', 'GeometryM', 3),
			('GEOMETRY', 'GeometryZM', 4),

			('GEOMETRYCOLLECTION', 'GeometryCollection', 2),
			('GEOMETRYCOLLECTION', 'GeometryCollectionZ', 3),
			('GEOMETRYCOLLECTIONM', 'GeometryCollectionM', 3),
			('GEOMETRYCOLLECTION', 'GeometryCollectionZM', 4),

			('POINT', 'Point', 2),
			('POINT', 'PointZ', 3),
			('POINTM','PointM', 3),
			('POINT', 'PointZM', 4),

			('MULTIPOINT','MultiPoint', 2),
			('MULTIPOINT','MultiPointZ', 3),
			('MULTIPOINTM','MultiPointM', 3),
			('MULTIPOINT','MultiPointZM', 4),

			('POLYGON', 'Polygon', 2),
			('POLYGON', 'PolygonZ', 3),
			('POLYGONM', 'PolygonM', 3),
			('POLYGON', 'PolygonZM', 4),

			('MULTIPOLYGON', 'MultiPolygon', 2),
			('MULTIPOLYGON', 'MultiPolygonZ', 3),
			('MULTIPOLYGONM', 'MultiPolygonM', 3),
			('MULTIPOLYGON', 'MultiPolygonZM', 4),

			('MULTILINESTRING', 'MultiLineString', 2),
			('MULTILINESTRING', 'MultiLineStringZ', 3),
			('MULTILINESTRINGM', 'MultiLineStringM', 3),
			('MULTILINESTRING', 'MultiLineStringZM', 4),

			('LINESTRING', 'LineString', 2),
			('LINESTRING', 'LineStringZ', 3),
			('LINESTRINGM', 'LineStringM', 3),
			('LINESTRING', 'LineStringZM', 4),

			('CIRCULARSTRING', 'CircularString', 2),
			('CIRCULARSTRING', 'CircularStringZ', 3),
			('CIRCULARSTRINGM', 'CircularStringM' ,3),
			('CIRCULARSTRING', 'CircularStringZM', 4),

			('COMPOUNDCURVE', 'CompoundCurve', 2),
			('COMPOUNDCURVE', 'CompoundCurveZ', 3),
			('COMPOUNDCURVEM', 'CompoundCurveM', 3),
			('COMPOUNDCURVE', 'CompoundCurveZM', 4),

			('CURVEPOLYGON', 'CurvePolygon', 2),
			('CURVEPOLYGON', 'CurvePolygonZ', 3),
			('CURVEPOLYGONM', 'CurvePolygonM', 3),
			('CURVEPOLYGON', 'CurvePolygonZM', 4),

			('MULTICURVE', 'MultiCurve', 2),
			('MULTICURVE', 'MultiCurveZ', 3),
			('MULTICURVEM', 'MultiCurveM', 3),
			('MULTICURVE', 'MultiCurveZM', 4),

			('MULTISURFACE', 'MultiSurface', 2),
			('MULTISURFACE', 'MultiSurfaceZ', 3),
			('MULTISURFACEM', 'MultiSurfaceM', 3),
			('MULTISURFACE', 'MultiSurfaceZM', 4),

			('POLYHEDRALSURFACE', 'PolyhedralSurface', 2),
			('POLYHEDRALSURFACE', 'PolyhedralSurfaceZ', 3),
			('POLYHEDRALSURFACEM', 'PolyhedralSurfaceM', 3),
			('POLYHEDRALSURFACE', 'PolyhedralSurfaceZM', 4),

			('TRIANGLE', 'Triangle', 2),
			('TRIANGLE', 'TriangleZ', 3),
			('TRIANGLEM', 'TriangleM', 3),
			('TRIANGLE', 'TriangleZM', 4),

			('TIN', 'Tin', 2),
			('TIN', 'TinZ', 3),
			('TINM', 'TinM', 3),
			('TIN', 'TinZM', 4) )
			 As g(old_name, new_name, coord_dimension)
	WHERE (upper(old_name) = upper($1) OR upper(new_name) = upper($1))
		AND coord_dimension = $2;
$function$
;

-- DROP FUNCTION incendies.postgis_typmod_dims(int4);

CREATE OR REPLACE FUNCTION incendies.postgis_typmod_dims(integer)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$postgis_typmod_dims$function$
;

-- DROP FUNCTION incendies.postgis_typmod_srid(int4);

CREATE OR REPLACE FUNCTION incendies.postgis_typmod_srid(integer)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$postgis_typmod_srid$function$
;

-- DROP FUNCTION incendies.postgis_typmod_type(int4);

CREATE OR REPLACE FUNCTION incendies.postgis_typmod_type(integer)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$postgis_typmod_type$function$
;

-- DROP FUNCTION incendies.postgis_version();

CREATE OR REPLACE FUNCTION incendies.postgis_version()
 RETURNS text
 LANGUAGE c
 IMMUTABLE
AS '$libdir/postgis-3', $function$postgis_version$function$
;

-- DROP FUNCTION incendies.postgis_wagyu_version();

CREATE OR REPLACE FUNCTION incendies.postgis_wagyu_version()
 RETURNS text
 LANGUAGE c
 IMMUTABLE
AS '$libdir/postgis-3', $function$postgis_wagyu_version$function$
;

-- DROP FUNCTION incendies.spheroid_in(cstring);

CREATE OR REPLACE FUNCTION incendies.spheroid_in(cstring)
 RETURNS incendies.spheroid
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$ellipsoid_in$function$
;

-- DROP FUNCTION incendies.spheroid_out(incendies.spheroid);

CREATE OR REPLACE FUNCTION incendies.spheroid_out(incendies.spheroid)
 RETURNS cstring
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$ellipsoid_out$function$
;

-- DROP FUNCTION incendies.st_3dclosestpoint(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_3dclosestpoint(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_closestpoint3d$function$
;

-- DROP FUNCTION incendies.st_3ddfullywithin(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_3ddfullywithin(geom1 incendies.geometry, geom2 incendies.geometry, double precision)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$LWGEOM_dfullywithin3d$function$
;

-- DROP FUNCTION incendies.st_3ddistance(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_3ddistance(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_3DDistance$function$
;

-- DROP FUNCTION incendies.st_3ddwithin(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_3ddwithin(geom1 incendies.geometry, geom2 incendies.geometry, double precision)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$LWGEOM_dwithin3d$function$
;

-- DROP AGGREGATE incendies.st_3dextent(incendies.geometry);

CREATE OR REPLACE AGGREGATE incendies.st_3dextent(incendies.geometry) (
	SFUNC = incendies.st_combinebbox,
	STYPE = incendies.box3d
);

-- DROP FUNCTION incendies.st_3dintersects(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_3dintersects(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$ST_3DIntersects$function$
;

-- DROP FUNCTION incendies.st_3dlength(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_3dlength(incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_length_linestring$function$
;

-- DROP FUNCTION incendies.st_3dlineinterpolatepoint(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_3dlineinterpolatepoint(incendies.geometry, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_3DLineInterpolatePoint$function$
;

-- DROP FUNCTION incendies.st_3dlongestline(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_3dlongestline(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_longestline3d$function$
;

-- DROP FUNCTION incendies.st_3dmakebox(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_3dmakebox(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.box3d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$BOX3D_construct$function$
;

-- DROP FUNCTION incendies.st_3dmaxdistance(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_3dmaxdistance(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_maxdistance3d$function$
;

-- DROP FUNCTION incendies.st_3dperimeter(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_3dperimeter(incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_perimeter_poly$function$
;

-- DROP FUNCTION incendies.st_3dshortestline(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_3dshortestline(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_shortestline3d$function$
;

-- DROP FUNCTION incendies.st_addmeasure(incendies.geometry, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_addmeasure(incendies.geometry, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_AddMeasure$function$
;

-- DROP FUNCTION incendies.st_addpoint(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_addpoint(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_addpoint$function$
;

-- DROP FUNCTION incendies.st_addpoint(incendies.geometry, incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_addpoint(geom1 incendies.geometry, geom2 incendies.geometry, integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_addpoint$function$
;

-- DROP FUNCTION incendies.st_affine(incendies.geometry, float8, float8, float8, float8, float8, float8, float8, float8, float8, float8, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_affine(incendies.geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_affine$function$
;

-- DROP FUNCTION incendies.st_affine(incendies.geometry, float8, float8, float8, float8, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_affine(incendies.geometry, double precision, double precision, double precision, double precision, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_Affine($1,  $2, $3, 0,  $4, $5, 0,  0, 0, 1,  $6, $7, 0)$function$
;

-- DROP FUNCTION incendies.st_angle(incendies.geometry, incendies.geometry, incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_angle(pt1 incendies.geometry, pt2 incendies.geometry, pt3 incendies.geometry, pt4 incendies.geometry DEFAULT '0101000000000000000000F87F000000000000F87F'::incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_angle$function$
;

-- DROP FUNCTION incendies.st_angle(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_angle(line1 incendies.geometry, line2 incendies.geometry)
 RETURNS double precision
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_Angle(incendies.St_StartPoint($1), incendies.ST_EndPoint($1), incendies.ST_StartPoint($2), incendies.ST_EndPoint($2))$function$
;

-- DROP FUNCTION incendies.st_area(incendies.geography, bool);

CREATE OR REPLACE FUNCTION incendies.st_area(geog incendies.geography, use_spheroid boolean DEFAULT true)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$geography_area$function$
;

-- DROP FUNCTION incendies.st_area(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_area(incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_Area$function$
;

-- DROP FUNCTION incendies.st_area(text);

CREATE OR REPLACE FUNCTION incendies.st_area(text)
 RETURNS double precision
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$ SELECT incendies.ST_Area($1::incendies.geometry);  $function$
;

-- DROP FUNCTION incendies.st_area2d(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_area2d(incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_Area$function$
;

-- DROP FUNCTION incendies.st_asbinary(incendies.geometry, text);

CREATE OR REPLACE FUNCTION incendies.st_asbinary(incendies.geometry, text)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_asBinary$function$
;

-- DROP FUNCTION incendies.st_asbinary(incendies.geography, text);

CREATE OR REPLACE FUNCTION incendies.st_asbinary(incendies.geography, text)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$LWGEOM_asBinary$function$
;

-- DROP FUNCTION incendies.st_asbinary(incendies.geography);

CREATE OR REPLACE FUNCTION incendies.st_asbinary(incendies.geography)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_asBinary$function$
;

-- DROP FUNCTION incendies.st_asbinary(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_asbinary(incendies.geometry)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_asBinary$function$
;

-- DROP FUNCTION incendies.st_asencodedpolyline(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_asencodedpolyline(geom incendies.geometry, nprecision integer DEFAULT 5)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asEncodedPolyline$function$
;

-- DROP FUNCTION incendies.st_asewkb(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_asewkb(incendies.geometry)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$WKBFromLWGEOM$function$
;

-- DROP FUNCTION incendies.st_asewkb(incendies.geometry, text);

CREATE OR REPLACE FUNCTION incendies.st_asewkb(incendies.geometry, text)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$WKBFromLWGEOM$function$
;

-- DROP FUNCTION incendies.st_asewkt(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_asewkt(incendies.geometry, integer)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asEWKT$function$
;

-- DROP FUNCTION incendies.st_asewkt(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_asewkt(incendies.geometry)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asEWKT$function$
;

-- DROP FUNCTION incendies.st_asewkt(text);

CREATE OR REPLACE FUNCTION incendies.st_asewkt(text)
 RETURNS text
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$ SELECT incendies.ST_AsEWKT($1::incendies.geometry);  $function$
;

-- DROP FUNCTION incendies.st_asewkt(incendies.geography, int4);

CREATE OR REPLACE FUNCTION incendies.st_asewkt(incendies.geography, integer)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asEWKT$function$
;

-- DROP FUNCTION incendies.st_asewkt(incendies.geography);

CREATE OR REPLACE FUNCTION incendies.st_asewkt(incendies.geography)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asEWKT$function$
;

-- DROP AGGREGATE incendies.st_asflatgeobuf(anyelement, bool);

-- Aggregate function incendies.st_asflatgeobuf(anyelement, bool)
-- ERROR: more than one function named "incendies.st_asflatgeobuf";

-- DROP AGGREGATE incendies.st_asflatgeobuf(anyelement);

-- Aggregate function incendies.st_asflatgeobuf(anyelement)
-- ERROR: more than one function named "incendies.st_asflatgeobuf";

-- DROP AGGREGATE incendies.st_asflatgeobuf(anyelement, bool, text);

-- Aggregate function incendies.st_asflatgeobuf(anyelement, bool, text)
-- ERROR: more than one function named "incendies.st_asflatgeobuf";

-- DROP AGGREGATE incendies.st_asgeobuf(anyelement);

-- Aggregate function incendies.st_asgeobuf(anyelement)
-- ERROR: more than one function named "incendies.st_asgeobuf";

-- DROP AGGREGATE incendies.st_asgeobuf(anyelement, text);

-- Aggregate function incendies.st_asgeobuf(anyelement, text)
-- ERROR: more than one function named "incendies.st_asgeobuf";

-- DROP FUNCTION incendies.st_asgeojson(incendies.geometry, int4, int4);

CREATE OR REPLACE FUNCTION incendies.st_asgeojson(geom incendies.geometry, maxdecimaldigits integer DEFAULT 9, options integer DEFAULT 8)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asGeoJson$function$
;

-- DROP FUNCTION incendies.st_asgeojson(text);

CREATE OR REPLACE FUNCTION incendies.st_asgeojson(text)
 RETURNS text
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$ SELECT incendies.ST_AsGeoJson($1::incendies.geometry, 9, 0);  $function$
;

-- DROP FUNCTION incendies.st_asgeojson(record, text, int4, bool, text);

CREATE OR REPLACE FUNCTION incendies.st_asgeojson(r record, geom_column text DEFAULT ''::text, maxdecimaldigits integer DEFAULT 9, pretty_bool boolean DEFAULT false, id_column text DEFAULT ''::text)
 RETURNS text
 LANGUAGE c
 STABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_AsGeoJsonRow$function$
;

-- DROP FUNCTION incendies.st_asgeojson(incendies.geography, int4, int4);

CREATE OR REPLACE FUNCTION incendies.st_asgeojson(geog incendies.geography, maxdecimaldigits integer DEFAULT 9, options integer DEFAULT 0)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geography_as_geojson$function$
;

-- DROP FUNCTION incendies.st_asgml(int4, incendies.geometry, int4, int4, text, text);

CREATE OR REPLACE FUNCTION incendies.st_asgml(version integer, geom incendies.geometry, maxdecimaldigits integer DEFAULT 15, options integer DEFAULT 0, nprefix text DEFAULT NULL::text, id text DEFAULT NULL::text)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asGML$function$
;

-- DROP FUNCTION incendies.st_asgml(int4, incendies.geography, int4, int4, text, text);

CREATE OR REPLACE FUNCTION incendies.st_asgml(version integer, geog incendies.geography, maxdecimaldigits integer DEFAULT 15, options integer DEFAULT 0, nprefix text DEFAULT 'gml'::text, id text DEFAULT ''::text)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geography_as_gml$function$
;

-- DROP FUNCTION incendies.st_asgml(incendies.geography, int4, int4, text, text);

CREATE OR REPLACE FUNCTION incendies.st_asgml(geog incendies.geography, maxdecimaldigits integer DEFAULT 15, options integer DEFAULT 0, nprefix text DEFAULT 'gml'::text, id text DEFAULT ''::text)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geography_as_gml$function$
;

-- DROP FUNCTION incendies.st_asgml(text);

CREATE OR REPLACE FUNCTION incendies.st_asgml(text)
 RETURNS text
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$ SELECT incendies._ST_AsGML(2,$1::incendies.geometry,15,0, NULL, NULL);  $function$
;

-- DROP FUNCTION incendies.st_asgml(incendies.geometry, int4, int4);

CREATE OR REPLACE FUNCTION incendies.st_asgml(geom incendies.geometry, maxdecimaldigits integer DEFAULT 15, options integer DEFAULT 0)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asGML$function$
;

-- DROP FUNCTION incendies.st_ashexewkb(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_ashexewkb(incendies.geometry)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_asHEXEWKB$function$
;

-- DROP FUNCTION incendies.st_ashexewkb(incendies.geometry, text);

CREATE OR REPLACE FUNCTION incendies.st_ashexewkb(incendies.geometry, text)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_asHEXEWKB$function$
;

-- DROP FUNCTION incendies.st_askml(text);

CREATE OR REPLACE FUNCTION incendies.st_askml(text)
 RETURNS text
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$ SELECT incendies.ST_AsKML($1::incendies.geometry, 15);  $function$
;

-- DROP FUNCTION incendies.st_askml(incendies.geography, int4, text);

CREATE OR REPLACE FUNCTION incendies.st_askml(geog incendies.geography, maxdecimaldigits integer DEFAULT 15, nprefix text DEFAULT ''::text)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geography_as_kml$function$
;

-- DROP FUNCTION incendies.st_askml(incendies.geometry, int4, text);

CREATE OR REPLACE FUNCTION incendies.st_askml(geom incendies.geometry, maxdecimaldigits integer DEFAULT 15, nprefix text DEFAULT ''::text)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asKML$function$
;

-- DROP FUNCTION incendies.st_aslatlontext(incendies.geometry, text);

CREATE OR REPLACE FUNCTION incendies.st_aslatlontext(geom incendies.geometry, tmpl text DEFAULT ''::text)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_to_latlon$function$
;

-- DROP FUNCTION incendies.st_asmarc21(incendies.geometry, text);

CREATE OR REPLACE FUNCTION incendies.st_asmarc21(geom incendies.geometry, format text DEFAULT 'hdddmmss'::text)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_AsMARC21$function$
;

-- DROP AGGREGATE incendies.st_asmvt(anyelement, text, int4);

-- Aggregate function incendies.st_asmvt(anyelement, text, int4)
-- ERROR: more than one function named "incendies.st_asmvt";

-- DROP AGGREGATE incendies.st_asmvt(anyelement, text, int4, text);

-- Aggregate function incendies.st_asmvt(anyelement, text, int4, text)
-- ERROR: more than one function named "incendies.st_asmvt";

-- DROP AGGREGATE incendies.st_asmvt(anyelement, text, int4, text, text);

-- Aggregate function incendies.st_asmvt(anyelement, text, int4, text, text)
-- ERROR: more than one function named "incendies.st_asmvt";

-- DROP AGGREGATE incendies.st_asmvt(anyelement, text);

-- Aggregate function incendies.st_asmvt(anyelement, text)
-- ERROR: more than one function named "incendies.st_asmvt";

-- DROP AGGREGATE incendies.st_asmvt(anyelement);

-- Aggregate function incendies.st_asmvt(anyelement)
-- ERROR: more than one function named "incendies.st_asmvt";

-- DROP FUNCTION incendies.st_asmvtgeom(incendies.geometry, incendies.box2d, int4, int4, bool);

CREATE OR REPLACE FUNCTION incendies.st_asmvtgeom(geom incendies.geometry, bounds incendies.box2d, extent integer DEFAULT 4096, buffer integer DEFAULT 256, clip_geom boolean DEFAULT true)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$ST_AsMVTGeom$function$
;

-- DROP FUNCTION incendies.st_assvg(incendies.geometry, int4, int4);

CREATE OR REPLACE FUNCTION incendies.st_assvg(geom incendies.geometry, rel integer DEFAULT 0, maxdecimaldigits integer DEFAULT 15)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asSVG$function$
;

-- DROP FUNCTION incendies.st_assvg(text);

CREATE OR REPLACE FUNCTION incendies.st_assvg(text)
 RETURNS text
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$ SELECT incendies.ST_AsSVG($1::incendies.geometry,0,15);  $function$
;

-- DROP FUNCTION incendies.st_assvg(incendies.geography, int4, int4);

CREATE OR REPLACE FUNCTION incendies.st_assvg(geog incendies.geography, rel integer DEFAULT 0, maxdecimaldigits integer DEFAULT 15)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geography_as_svg$function$
;

-- DROP FUNCTION incendies.st_astext(incendies.geography);

CREATE OR REPLACE FUNCTION incendies.st_astext(incendies.geography)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asText$function$
;

-- DROP FUNCTION incendies.st_astext(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_astext(incendies.geometry, integer)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asText$function$
;

-- DROP FUNCTION incendies.st_astext(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_astext(incendies.geometry)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asText$function$
;

-- DROP FUNCTION incendies.st_astext(text);

CREATE OR REPLACE FUNCTION incendies.st_astext(text)
 RETURNS text
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$ SELECT incendies.ST_AsText($1::incendies.geometry);  $function$
;

-- DROP FUNCTION incendies.st_astext(incendies.geography, int4);

CREATE OR REPLACE FUNCTION incendies.st_astext(incendies.geography, integer)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_asText$function$
;

-- DROP FUNCTION incendies.st_astwkb(incendies._geometry, _int8, int4, int4, int4, bool, bool);

CREATE OR REPLACE FUNCTION incendies.st_astwkb(geom incendies.geometry[], ids bigint[], prec integer DEFAULT NULL::integer, prec_z integer DEFAULT NULL::integer, prec_m integer DEFAULT NULL::integer, with_sizes boolean DEFAULT NULL::boolean, with_boxes boolean DEFAULT NULL::boolean)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$TWKBFromLWGEOMArray$function$
;

-- DROP FUNCTION incendies.st_astwkb(incendies.geometry, int4, int4, int4, bool, bool);

CREATE OR REPLACE FUNCTION incendies.st_astwkb(geom incendies.geometry, prec integer DEFAULT NULL::integer, prec_z integer DEFAULT NULL::integer, prec_m integer DEFAULT NULL::integer, with_sizes boolean DEFAULT NULL::boolean, with_boxes boolean DEFAULT NULL::boolean)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$TWKBFromLWGEOM$function$
;

-- DROP FUNCTION incendies.st_asx3d(incendies.geometry, int4, int4);

CREATE OR REPLACE FUNCTION incendies.st_asx3d(geom incendies.geometry, maxdecimaldigits integer DEFAULT 15, options integer DEFAULT 0)
 RETURNS text
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE COST 250
AS $function$SELECT incendies._ST_AsX3D(3,$1,$2,$3,'');$function$
;

-- DROP FUNCTION incendies.st_azimuth(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_azimuth(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_azimuth$function$
;

-- DROP FUNCTION incendies.st_azimuth(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies.st_azimuth(geog1 incendies.geography, geog2 incendies.geography)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geography_azimuth$function$
;

-- DROP FUNCTION incendies.st_bdmpolyfromtext(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_bdmpolyfromtext(text, integer)
 RETURNS incendies.geometry
 LANGUAGE plpgsql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline incendies.geometry;
	geom incendies.geometry;
BEGIN
	mline := incendies.ST_MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION 'Input is not a MultiLinestring';
	END IF;

	geom := incendies.ST_Multi(incendies.ST_BuildArea(mline));

	RETURN geom;
END;
$function$
;

-- DROP FUNCTION incendies.st_bdpolyfromtext(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_bdpolyfromtext(text, integer)
 RETURNS incendies.geometry
 LANGUAGE plpgsql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline incendies.geometry;
	geom incendies.geometry;
BEGIN
	mline := incendies.ST_MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION 'Input is not a MultiLinestring';
	END IF;

	geom := incendies.ST_BuildArea(mline);

	IF incendies.GeometryType(geom) != 'POLYGON'
	THEN
		RAISE EXCEPTION 'Input returns more then a single polygon, try using BdMPolyFromText instead';
	END IF;

	RETURN geom;
END;
$function$
;

-- DROP FUNCTION incendies.st_boundary(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_boundary(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$boundary$function$
;

-- DROP FUNCTION incendies.st_boundingdiagonal(incendies.geometry, bool);

CREATE OR REPLACE FUNCTION incendies.st_boundingdiagonal(geom incendies.geometry, fits boolean DEFAULT false)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$ST_BoundingDiagonal$function$
;

-- DROP FUNCTION incendies.st_box2dfromgeohash(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_box2dfromgeohash(text, integer DEFAULT NULL::integer)
 RETURNS incendies.box2d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$box2d_from_geohash$function$
;

-- DROP FUNCTION incendies.st_buffer(incendies.geography, float8, int4);

CREATE OR REPLACE FUNCTION incendies.st_buffer(incendies.geography, double precision, integer)
 RETURNS incendies.geography
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$SELECT incendies.geography(incendies.ST_Transform(incendies.ST_Buffer(incendies.ST_Transform(incendies.geometry($1), incendies._ST_BestSRID($1)), $2, $3), incendies.ST_SRID($1)))$function$
;

-- DROP FUNCTION incendies.st_buffer(incendies.geography, float8, text);

CREATE OR REPLACE FUNCTION incendies.st_buffer(incendies.geography, double precision, text)
 RETURNS incendies.geography
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$SELECT incendies.geography(incendies.ST_Transform(incendies.ST_Buffer(incendies.ST_Transform(incendies.geometry($1), incendies._ST_BestSRID($1)), $2, $3), incendies.ST_SRID($1)))$function$
;

-- DROP FUNCTION incendies.st_buffer(incendies.geometry, float8, text);

CREATE OR REPLACE FUNCTION incendies.st_buffer(geom incendies.geometry, radius double precision, options text DEFAULT ''::text)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$buffer$function$
;

-- DROP FUNCTION incendies.st_buffer(incendies.geometry, float8, int4);

CREATE OR REPLACE FUNCTION incendies.st_buffer(geom incendies.geometry, radius double precision, quadsegs integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS $function$ SELECT incendies.ST_Buffer($1, $2, CAST('quad_segs='||CAST($3 AS text) as text)) $function$
;

-- DROP FUNCTION incendies.st_buffer(text, float8);

CREATE OR REPLACE FUNCTION incendies.st_buffer(text, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$ SELECT incendies.ST_Buffer($1::incendies.geometry, $2);  $function$
;

-- DROP FUNCTION incendies.st_buffer(text, float8, text);

CREATE OR REPLACE FUNCTION incendies.st_buffer(text, double precision, text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$ SELECT incendies.ST_Buffer($1::incendies.geometry, $2, $3);  $function$
;

-- DROP FUNCTION incendies.st_buffer(text, float8, int4);

CREATE OR REPLACE FUNCTION incendies.st_buffer(text, double precision, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$ SELECT incendies.ST_Buffer($1::incendies.geometry, $2, $3);  $function$
;

-- DROP FUNCTION incendies.st_buffer(incendies.geography, float8);

CREATE OR REPLACE FUNCTION incendies.st_buffer(incendies.geography, double precision)
 RETURNS incendies.geography
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$SELECT incendies.geography(incendies.ST_Transform(incendies.ST_Buffer(incendies.ST_Transform(incendies.geometry($1), incendies._ST_BestSRID($1)), $2), incendies.ST_SRID($1)))$function$
;

-- DROP FUNCTION incendies.st_buildarea(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_buildarea(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_BuildArea$function$
;

-- DROP FUNCTION incendies.st_centroid(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_centroid(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$centroid$function$
;

-- DROP FUNCTION incendies.st_centroid(text);

CREATE OR REPLACE FUNCTION incendies.st_centroid(text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$ SELECT incendies.ST_Centroid($1::incendies.geometry);  $function$
;

-- DROP FUNCTION incendies.st_centroid(incendies.geography, bool);

CREATE OR REPLACE FUNCTION incendies.st_centroid(incendies.geography, use_spheroid boolean DEFAULT true)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geography_centroid$function$
;

-- DROP FUNCTION incendies.st_chaikinsmoothing(incendies.geometry, int4, bool);

CREATE OR REPLACE FUNCTION incendies.st_chaikinsmoothing(incendies.geometry, integer DEFAULT 1, boolean DEFAULT false)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_ChaikinSmoothing$function$
;

-- DROP FUNCTION incendies.st_cleangeometry(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_cleangeometry(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_CleanGeometry$function$
;

-- DROP FUNCTION incendies.st_clipbybox2d(incendies.geometry, incendies.box2d);

CREATE OR REPLACE FUNCTION incendies.st_clipbybox2d(geom incendies.geometry, box incendies.box2d)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_ClipByBox2d$function$
;

-- DROP FUNCTION incendies.st_closestpoint(incendies.geography, incendies.geography, bool);

CREATE OR REPLACE FUNCTION incendies.st_closestpoint(incendies.geography, incendies.geography, use_spheroid boolean DEFAULT true)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_closestpoint$function$
;

-- DROP FUNCTION incendies.st_closestpoint(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_closestpoint(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_closestpoint$function$
;

-- DROP FUNCTION incendies.st_closestpoint(text, text);

CREATE OR REPLACE FUNCTION incendies.st_closestpoint(text, text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE
AS $function$ SELECT incendies.ST_ClosestPoint($1::incendies.geometry, $2::incendies.geometry);  $function$
;

-- DROP FUNCTION incendies.st_closestpointofapproach(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_closestpointofapproach(incendies.geometry, incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_ClosestPointOfApproach$function$
;

-- DROP WINDOW incendies.st_clusterdbscan(incendies.geometry, float8, int4);

CREATE OR REPLACE FUNCTION incendies.st_clusterdbscan(incendies.geometry, eps double precision, minpoints integer)
 RETURNS integer
 LANGUAGE c
 WINDOW IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_ClusterDBSCAN$function$
;

-- DROP FUNCTION incendies.st_clusterintersecting(incendies._geometry);

CREATE OR REPLACE FUNCTION incendies.st_clusterintersecting(incendies.geometry[])
 RETURNS incendies.geometry[]
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$clusterintersecting_garray$function$
;

-- DROP AGGREGATE incendies.st_clusterintersecting(incendies.geometry);

-- Aggregate function incendies.st_clusterintersecting(incendies.geometry)
-- ERROR: more than one function named "incendies.st_clusterintersecting";

-- DROP WINDOW incendies.st_clusterintersectingwin(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_clusterintersectingwin(incendies.geometry)
 RETURNS integer
 LANGUAGE c
 WINDOW IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_ClusterIntersectingWin$function$
;

-- DROP WINDOW incendies.st_clusterkmeans(incendies.geometry, int4, float8);

CREATE OR REPLACE FUNCTION incendies.st_clusterkmeans(geom incendies.geometry, k integer, max_radius double precision DEFAULT NULL::double precision)
 RETURNS integer
 LANGUAGE c
 WINDOW STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_ClusterKMeans$function$
;

-- DROP AGGREGATE incendies.st_clusterwithin(incendies.geometry, float8);

-- Aggregate function incendies.st_clusterwithin(incendies.geometry, float8)
-- ERROR: more than one function named "incendies.st_clusterwithin";

-- DROP FUNCTION incendies.st_clusterwithin(incendies._geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_clusterwithin(incendies.geometry[], double precision)
 RETURNS incendies.geometry[]
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$cluster_within_distance_garray$function$
;

-- DROP WINDOW incendies.st_clusterwithinwin(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_clusterwithinwin(incendies.geometry, distance double precision)
 RETURNS integer
 LANGUAGE c
 WINDOW IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_ClusterWithinWin$function$
;

-- DROP FUNCTION incendies.st_collect(incendies._geometry);

CREATE OR REPLACE FUNCTION incendies.st_collect(incendies.geometry[])
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_collect_garray$function$
;

-- DROP FUNCTION incendies.st_collect(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_collect(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$LWGEOM_collect$function$
;

-- DROP AGGREGATE incendies.st_collect(incendies.geometry);

-- Aggregate function incendies.st_collect(incendies.geometry)
-- ERROR: more than one function named "incendies.st_collect";

-- DROP FUNCTION incendies.st_collectionextract(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_collectionextract(incendies.geometry, integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_CollectionExtract$function$
;

-- DROP FUNCTION incendies.st_collectionextract(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_collectionextract(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_CollectionExtract$function$
;

-- DROP FUNCTION incendies.st_collectionhomogenize(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_collectionhomogenize(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_CollectionHomogenize$function$
;

-- DROP FUNCTION incendies.st_combinebbox(incendies.box2d, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_combinebbox(incendies.box2d, incendies.geometry)
 RETURNS incendies.box2d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE
AS '$libdir/postgis-3', $function$BOX2D_combine$function$
;

-- DROP FUNCTION incendies.st_combinebbox(incendies.box3d, incendies.box3d);

CREATE OR REPLACE FUNCTION incendies.st_combinebbox(incendies.box3d, incendies.box3d)
 RETURNS incendies.box3d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$BOX3D_combine_BOX3D$function$
;

-- DROP FUNCTION incendies.st_combinebbox(incendies.box3d, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_combinebbox(incendies.box3d, incendies.geometry)
 RETURNS incendies.box3d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$BOX3D_combine$function$
;

-- DROP FUNCTION incendies.st_concavehull(incendies.geometry, float8, bool);

CREATE OR REPLACE FUNCTION incendies.st_concavehull(param_geom incendies.geometry, param_pctconvex double precision, param_allow_holes boolean DEFAULT false)
 RETURNS incendies.geometry
 LANGUAGE plpgsql
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS $function$
	DECLARE
		var_convhull incendies.geometry := incendies.ST_ForceSFS(incendies.ST_ConvexHull(param_geom));
		var_param_geom incendies.geometry := incendies.ST_ForceSFS(param_geom);
		var_initarea float := incendies.ST_Area(var_convhull);
		var_newarea float := var_initarea;
		var_div integer := 6; 
		var_tempgeom incendies.geometry;
		var_tempgeom2 incendies.geometry;
		var_cent incendies.geometry;
		var_geoms incendies.geometry[4]; 
		var_enline incendies.geometry;
		var_resultgeom incendies.geometry;
		var_atempgeoms incendies.geometry[];
		var_buf float := 1; 
	BEGIN
		-- We start with convex hull as our base
		var_resultgeom := var_convhull;

		IF param_pctconvex = 1 THEN
			-- this is the same as asking for the convex hull
			return var_resultgeom;
		ELSIF incendies.ST_GeometryType(var_param_geom) = 'ST_Polygon' THEN -- it is as concave as it is going to get
			IF param_allow_holes THEN -- leave the holes
				RETURN var_param_geom;
			ELSE -- remove the holes
				var_resultgeom := incendies.ST_MakePolygon(incendies.ST_ExteriorRing(var_param_geom));
				RETURN var_resultgeom;
			END IF;
		END IF;
		IF incendies.ST_Dimension(var_resultgeom) > 1 AND param_pctconvex BETWEEN 0 and 0.99 THEN
		-- get linestring that forms envelope of geometry
			var_enline := incendies.ST_Boundary(incendies.ST_Envelope(var_param_geom));
			var_buf := incendies.ST_Length(var_enline)/1000.0;
			IF incendies.ST_GeometryType(var_param_geom) = 'ST_MultiPoint' AND incendies.ST_NumGeometries(var_param_geom) BETWEEN 4 and 200 THEN
			-- we make polygons out of points since they are easier to cave in.
			-- Note we limit to between 4 and 200 points because this process is slow and gets quadratically slow
				var_buf := sqrt(incendies.ST_Area(var_convhull)*0.8/(incendies.ST_NumGeometries(var_param_geom)*incendies.ST_NumGeometries(var_param_geom)));
				var_atempgeoms := ARRAY(SELECT geom FROM incendies.ST_DumpPoints(var_param_geom));
				-- 5 and 10 and just fudge factors
				var_tempgeom := incendies.ST_Union(ARRAY(SELECT geom
						FROM (
						-- fuse near neighbors together
						SELECT DISTINCT ON (i) i,  incendies.ST_Distance(var_atempgeoms[i],var_atempgeoms[j]), incendies.ST_Buffer(incendies.ST_MakeLine(var_atempgeoms[i], var_atempgeoms[j]) , var_buf*5, 'quad_segs=3') As geom
								FROM generate_series(1,array_upper(var_atempgeoms, 1)) As i
									INNER JOIN generate_series(1,array_upper(var_atempgeoms, 1)) As j
										ON (
								 NOT incendies.ST_Intersects(var_atempgeoms[i],var_atempgeoms[j])
									AND incendies.ST_DWithin(var_atempgeoms[i],var_atempgeoms[j], var_buf*10)
									)
								UNION ALL
						-- catch the ones with no near neighbors
								SELECT i, 0, incendies.ST_Buffer(var_atempgeoms[i] , var_buf*10, 'quad_segs=3') As geom
								FROM generate_series(1,array_upper(var_atempgeoms, 1)) As i
									LEFT JOIN generate_series(ceiling(array_upper(var_atempgeoms,1)/2)::integer,array_upper(var_atempgeoms, 1)) As j
										ON (
								 NOT incendies.ST_Intersects(var_atempgeoms[i],var_atempgeoms[j])
									AND incendies.ST_DWithin(var_atempgeoms[i],var_atempgeoms[j], var_buf*10)
									)
									WHERE j IS NULL
								ORDER BY 1, 2
							) As foo	) );
				IF incendies.ST_IsValid(var_tempgeom) AND incendies.ST_GeometryType(var_tempgeom) = 'ST_Polygon' THEN
					var_tempgeom := incendies.ST_ForceSFS(incendies.ST_Intersection(var_tempgeom, var_convhull));
					IF param_allow_holes THEN
						var_param_geom := var_tempgeom;
					ELSIF incendies.ST_GeometryType(var_tempgeom) = 'ST_Polygon' THEN
						var_param_geom := incendies.ST_ForceSFS(incendies.ST_MakePolygon(incendies.ST_ExteriorRing(var_tempgeom)));
					ELSE
						var_param_geom := incendies.ST_ForceSFS(incendies.ST_ConvexHull(var_param_geom));
					END IF;
					-- make sure result covers original (#3638)
					var_param_geom := incendies.ST_Union(param_geom, var_param_geom);
					return var_param_geom;
				ELSIF incendies.ST_IsValid(var_tempgeom) THEN
					var_param_geom := incendies.ST_ForceSFS(incendies.ST_Intersection(var_tempgeom, var_convhull));
				END IF;
			END IF;

			IF incendies.ST_GeometryType(var_param_geom) = 'ST_Polygon' THEN
				IF NOT param_allow_holes THEN
					var_param_geom := incendies.ST_ForceSFS(incendies.ST_MakePolygon(incendies.ST_ExteriorRing(var_param_geom)));
				END IF;
				-- make sure result covers original (#3638)
				--var_param_geom := incendies.ST_Union(param_geom, var_param_geom);
				return var_param_geom;
			END IF;
			var_cent := incendies.ST_Centroid(var_param_geom);
			IF (incendies.ST_XMax(var_enline) - incendies.ST_XMin(var_enline) ) > var_buf AND (incendies.ST_YMax(var_enline) - incendies.ST_YMin(var_enline) ) > var_buf THEN
					IF incendies.ST_Dwithin(incendies.ST_Centroid(var_convhull) , incendies.ST_Centroid(incendies.ST_Envelope(var_param_geom)), var_buf/2) THEN
				-- If the geometric dimension is > 1 and the object is symmetric (cutting at centroid will not work -- offset a bit)
						var_cent := incendies.ST_Translate(var_cent, (incendies.ST_XMax(var_enline) - incendies.ST_XMin(var_enline))/1000,  (incendies.ST_YMAX(var_enline) - incendies.ST_YMin(var_enline))/1000);
					ELSE
						-- uses closest point on geometry to centroid. I can't explain why we are doing this
						var_cent := incendies.ST_ClosestPoint(var_param_geom,var_cent);
					END IF;
					IF incendies.ST_DWithin(var_cent, var_enline,var_buf) THEN
						var_cent := incendies.ST_centroid(incendies.ST_Envelope(var_param_geom));
					END IF;
					-- break envelope into 4 triangles about the centroid of the geometry and returned the clipped geometry in each quadrant
					FOR i in 1 .. 4 LOOP
					   var_geoms[i] := incendies.ST_MakePolygon(incendies.ST_MakeLine(ARRAY[incendies.ST_PointN(var_enline,i), incendies.ST_PointN(var_enline,i+1), var_cent, incendies.ST_PointN(var_enline,i)]));
					   var_geoms[i] := incendies.ST_ForceSFS(incendies.ST_Intersection(var_param_geom, incendies.ST_Buffer(var_geoms[i],var_buf)));
					   IF incendies.ST_IsValid(var_geoms[i]) THEN

					   ELSE
							var_geoms[i] := incendies.ST_BuildArea(incendies.ST_MakeLine(ARRAY[incendies.ST_PointN(var_enline,i), incendies.ST_PointN(var_enline,i+1), var_cent, incendies.ST_PointN(var_enline,i)]));
					   END IF;
					END LOOP;
					var_tempgeom := incendies.ST_Union(ARRAY[incendies.ST_ConvexHull(var_geoms[1]), incendies.ST_ConvexHull(var_geoms[2]) , incendies.ST_ConvexHull(var_geoms[3]), incendies.ST_ConvexHull(var_geoms[4])]);
					--RAISE NOTICE 'Curr vex % ', incendies.ST_AsText(var_tempgeom);
					IF incendies.ST_Area(var_tempgeom) <= var_newarea AND incendies.ST_IsValid(var_tempgeom)  THEN --AND incendies.ST_GeometryType(var_tempgeom) ILIKE '%Polygon'

						var_tempgeom := incendies.ST_Buffer(incendies.ST_ConcaveHull(var_geoms[1],least(param_pctconvex + param_pctconvex/var_div),true),var_buf, 'quad_segs=2');
						FOR i IN 1 .. 4 LOOP
							var_geoms[i] := incendies.ST_Buffer(incendies.ST_ConcaveHull(var_geoms[i],least(param_pctconvex + param_pctconvex/var_div),true), var_buf, 'quad_segs=2');
							IF incendies.ST_IsValid(var_geoms[i]) Then
								var_tempgeom := incendies.ST_Union(var_tempgeom, var_geoms[i]);
							ELSE
								RAISE NOTICE 'Not valid % %', i, incendies.ST_AsText(var_tempgeom);
								var_tempgeom := incendies.ST_Union(var_tempgeom, incendies.ST_ConvexHull(var_geoms[i]));
							END IF;
						END LOOP;

						--RAISE NOTICE 'Curr concave % ', incendies.ST_AsText(var_tempgeom);
						IF incendies.ST_IsValid(var_tempgeom) THEN
							var_resultgeom := var_tempgeom;
						END IF;
						var_newarea := incendies.ST_Area(var_resultgeom);
					ELSIF incendies.ST_IsValid(var_tempgeom) THEN
						var_resultgeom := var_tempgeom;
					END IF;

					IF incendies.ST_NumGeometries(var_resultgeom) > 1  THEN
						var_tempgeom := incendies._ST_ConcaveHull(var_resultgeom);
						IF incendies.ST_IsValid(var_tempgeom) AND incendies.ST_GeometryType(var_tempgeom) ILIKE 'ST_Polygon' THEN
							var_resultgeom := var_tempgeom;
						ELSE
							var_resultgeom := incendies.ST_Buffer(var_tempgeom,var_buf, 'quad_segs=2');
						END IF;
					END IF;
					IF param_allow_holes = false THEN
					-- only keep exterior ring since we do not want holes
						var_resultgeom := incendies.ST_MakePolygon(incendies.ST_ExteriorRing(var_resultgeom));
					END IF;
				ELSE
					var_resultgeom := incendies.ST_Buffer(var_resultgeom,var_buf);
				END IF;
				var_resultgeom := incendies.ST_ForceSFS(incendies.ST_Intersection(var_resultgeom, incendies.ST_ConvexHull(var_param_geom)));
			ELSE
				-- dimensions are too small to cut
				var_resultgeom := incendies._ST_ConcaveHull(var_param_geom);
			END IF;

			RETURN var_resultgeom;
	END;
$function$
;

-- DROP FUNCTION incendies.st_contains(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_contains(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$contains$function$
;

-- DROP FUNCTION incendies.st_containsproperly(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_containsproperly(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$containsproperly$function$
;

-- DROP FUNCTION incendies.st_convexhull(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_convexhull(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$convexhull$function$
;

-- DROP FUNCTION incendies.st_coorddim(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_coorddim(geometry incendies.geometry)
 RETURNS smallint
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_ndims$function$
;

-- DROP WINDOW incendies.st_coverageinvalidedges(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_coverageinvalidedges(geom incendies.geometry, tolerance double precision DEFAULT 0.0)
 RETURNS incendies.geometry
 LANGUAGE c
 WINDOW IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_CoverageInvalidEdges$function$
;

-- DROP WINDOW incendies.st_coveragesimplify(incendies.geometry, float8, bool);

CREATE OR REPLACE FUNCTION incendies.st_coveragesimplify(geom incendies.geometry, tolerance double precision, simplifyboundary boolean DEFAULT true)
 RETURNS incendies.geometry
 LANGUAGE c
 WINDOW IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_CoverageSimplify$function$
;

-- DROP AGGREGATE incendies.st_coverageunion(incendies.geometry);

-- Aggregate function incendies.st_coverageunion(incendies.geometry)
-- ERROR: more than one function named "incendies.st_coverageunion";

-- DROP FUNCTION incendies.st_coverageunion(incendies._geometry);

CREATE OR REPLACE FUNCTION incendies.st_coverageunion(incendies.geometry[])
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_CoverageUnion$function$
;

-- DROP FUNCTION incendies.st_coveredby(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies.st_coveredby(geog1 incendies.geography, geog2 incendies.geography)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$geography_coveredby$function$
;

-- DROP FUNCTION incendies.st_coveredby(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_coveredby(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$coveredby$function$
;

-- DROP FUNCTION incendies.st_coveredby(text, text);

CREATE OR REPLACE FUNCTION incendies.st_coveredby(text, text)
 RETURNS boolean
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE
AS $function$ SELECT incendies.ST_CoveredBy($1::incendies.geometry, $2::incendies.geometry);  $function$
;

-- DROP FUNCTION incendies.st_covers(text, text);

CREATE OR REPLACE FUNCTION incendies.st_covers(text, text)
 RETURNS boolean
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE
AS $function$ SELECT incendies.ST_Covers($1::incendies.geometry, $2::incendies.geometry);  $function$
;

-- DROP FUNCTION incendies.st_covers(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_covers(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$covers$function$
;

-- DROP FUNCTION incendies.st_covers(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies.st_covers(geog1 incendies.geography, geog2 incendies.geography)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$geography_covers$function$
;

-- DROP FUNCTION incendies.st_cpawithin(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_cpawithin(incendies.geometry, incendies.geometry, double precision)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_CPAWithin$function$
;

-- DROP FUNCTION incendies.st_crosses(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_crosses(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$crosses$function$
;

-- DROP FUNCTION incendies.st_curven(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_curven(geometry incendies.geometry, i integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_CurveN$function$
;

-- DROP FUNCTION incendies.st_curvetoline(incendies.geometry, float8, int4, int4);

CREATE OR REPLACE FUNCTION incendies.st_curvetoline(geom incendies.geometry, tol double precision DEFAULT 32, toltype integer DEFAULT 0, flags integer DEFAULT 0)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_CurveToLine$function$
;

-- DROP FUNCTION incendies.st_delaunaytriangles(incendies.geometry, float8, int4);

CREATE OR REPLACE FUNCTION incendies.st_delaunaytriangles(g1 incendies.geometry, tolerance double precision DEFAULT 0.0, flags integer DEFAULT 0)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_DelaunayTriangles$function$
;

-- DROP FUNCTION incendies.st_dfullywithin(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_dfullywithin(geom1 incendies.geometry, geom2 incendies.geometry, double precision)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$LWGEOM_dfullywithin$function$
;

-- DROP FUNCTION incendies.st_difference(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_difference(geom1 incendies.geometry, geom2 incendies.geometry, gridsize double precision DEFAULT '-1.0'::numeric)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_Difference$function$
;

-- DROP FUNCTION incendies.st_dimension(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_dimension(incendies.geometry)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_dimension$function$
;

-- DROP FUNCTION incendies.st_disjoint(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_disjoint(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$disjoint$function$
;

-- DROP FUNCTION incendies.st_distance(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_distance(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_Distance$function$
;

-- DROP FUNCTION incendies.st_distance(text, text);

CREATE OR REPLACE FUNCTION incendies.st_distance(text, text)
 RETURNS double precision
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$ SELECT incendies.ST_Distance($1::incendies.geometry, $2::incendies.geometry);  $function$
;

-- DROP FUNCTION incendies.st_distance(incendies.geography, incendies.geography, bool);

CREATE OR REPLACE FUNCTION incendies.st_distance(geog1 incendies.geography, geog2 incendies.geography, use_spheroid boolean DEFAULT true)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$geography_distance$function$
;

-- DROP FUNCTION incendies.st_distancecpa(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_distancecpa(incendies.geometry, incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_DistanceCPA$function$
;

-- DROP FUNCTION incendies.st_distancesphere(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_distancesphere(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS double precision
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$select incendies.ST_distance( incendies.geography($1), incendies.geography($2),false)$function$
;

-- DROP FUNCTION incendies.st_distancesphere(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_distancesphere(geom1 incendies.geometry, geom2 incendies.geometry, radius double precision)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE STRICT COST 5000
AS '$libdir/postgis-3', $function$LWGEOM_distance_sphere$function$
;

-- DROP FUNCTION incendies.st_distancespheroid(incendies.geometry, incendies.geometry, incendies.spheroid);

CREATE OR REPLACE FUNCTION incendies.st_distancespheroid(geom1 incendies.geometry, geom2 incendies.geometry, incendies.spheroid)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_distance_ellipsoid$function$
;

-- DROP FUNCTION incendies.st_distancespheroid(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_distancespheroid(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_distance_ellipsoid$function$
;

-- DROP FUNCTION incendies.st_dump(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_dump(incendies.geometry)
 RETURNS SETOF incendies.geometry_dump
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_dump$function$
;

-- DROP FUNCTION incendies.st_dumppoints(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_dumppoints(incendies.geometry)
 RETURNS SETOF incendies.geometry_dump
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$LWGEOM_dumppoints$function$
;

-- DROP FUNCTION incendies.st_dumprings(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_dumprings(incendies.geometry)
 RETURNS SETOF incendies.geometry_dump
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_dump_rings$function$
;

-- DROP FUNCTION incendies.st_dumpsegments(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_dumpsegments(incendies.geometry)
 RETURNS SETOF incendies.geometry_dump
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$LWGEOM_dumpsegments$function$
;

-- DROP FUNCTION incendies.st_dwithin(text, text, float8);

CREATE OR REPLACE FUNCTION incendies.st_dwithin(text, text, double precision)
 RETURNS boolean
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE
AS $function$ SELECT incendies.ST_DWithin($1::incendies.geometry, $2::incendies.geometry, $3);  $function$
;

-- DROP FUNCTION incendies.st_dwithin(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_dwithin(geom1 incendies.geometry, geom2 incendies.geometry, double precision)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$LWGEOM_dwithin$function$
;

-- DROP FUNCTION incendies.st_dwithin(incendies.geography, incendies.geography, float8, bool);

CREATE OR REPLACE FUNCTION incendies.st_dwithin(geog1 incendies.geography, geog2 incendies.geography, tolerance double precision, use_spheroid boolean DEFAULT true)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$geography_dwithin$function$
;

-- DROP FUNCTION incendies.st_endpoint(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_endpoint(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_endpoint_linestring$function$
;

-- DROP FUNCTION incendies.st_envelope(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_envelope(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_envelope$function$
;

-- DROP FUNCTION incendies.st_equals(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_equals(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$ST_Equals$function$
;

-- DROP FUNCTION incendies.st_estimatedextent(text, text);

CREATE OR REPLACE FUNCTION incendies.st_estimatedextent(text, text)
 RETURNS incendies.box2d
 LANGUAGE c
 STABLE STRICT
AS '$libdir/postgis-3', $function$gserialized_estimated_extent$function$
;

-- DROP FUNCTION incendies.st_estimatedextent(text, text, text, bool);

CREATE OR REPLACE FUNCTION incendies.st_estimatedextent(text, text, text, boolean)
 RETURNS incendies.box2d
 LANGUAGE c
 STABLE STRICT
AS '$libdir/postgis-3', $function$gserialized_estimated_extent$function$
;

-- DROP FUNCTION incendies.st_estimatedextent(text, text, text);

CREATE OR REPLACE FUNCTION incendies.st_estimatedextent(text, text, text)
 RETURNS incendies.box2d
 LANGUAGE c
 STABLE STRICT
AS '$libdir/postgis-3', $function$gserialized_estimated_extent$function$
;

-- DROP FUNCTION incendies.st_expand(incendies.geometry, float8, float8, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_expand(geom incendies.geometry, dx double precision, dy double precision, dz double precision DEFAULT 0, dm double precision DEFAULT 0)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_expand$function$
;

-- DROP FUNCTION incendies.st_expand(incendies.box3d, float8);

CREATE OR REPLACE FUNCTION incendies.st_expand(incendies.box3d, double precision)
 RETURNS incendies.box3d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$BOX3D_expand$function$
;

-- DROP FUNCTION incendies.st_expand(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_expand(incendies.geometry, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_expand$function$
;

-- DROP FUNCTION incendies.st_expand(incendies.box2d, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_expand(box incendies.box2d, dx double precision, dy double precision)
 RETURNS incendies.box2d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$BOX2D_expand$function$
;

-- DROP FUNCTION incendies.st_expand(incendies.box2d, float8);

CREATE OR REPLACE FUNCTION incendies.st_expand(incendies.box2d, double precision)
 RETURNS incendies.box2d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$BOX2D_expand$function$
;

-- DROP FUNCTION incendies.st_expand(incendies.box3d, float8, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_expand(box incendies.box3d, dx double precision, dy double precision, dz double precision DEFAULT 0)
 RETURNS incendies.box3d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$BOX3D_expand$function$
;

-- DROP AGGREGATE incendies.st_extent(incendies.geometry);

CREATE OR REPLACE AGGREGATE incendies.st_extent(incendies.geometry) (
	SFUNC = incendies.st_combinebbox,
	STYPE = incendies.box3d,
	FINALFUNC = incendies.box2d,
	FINALFUNC_MODIFY = READ_ONLY
);

-- DROP FUNCTION incendies.st_exteriorring(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_exteriorring(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_exteriorring_polygon$function$
;

-- DROP FUNCTION incendies.st_filterbym(incendies.geometry, float8, float8, bool);

CREATE OR REPLACE FUNCTION incendies.st_filterbym(incendies.geometry, double precision, double precision DEFAULT NULL::double precision, boolean DEFAULT false)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$LWGEOM_FilterByM$function$
;

-- DROP FUNCTION incendies.st_findextent(text, text, text);

CREATE OR REPLACE FUNCTION incendies.st_findextent(text, text, text)
 RETURNS incendies.box2d
 LANGUAGE plpgsql
 STABLE PARALLEL SAFE STRICT
AS $function$
DECLARE
	schemaname alias for $1;
	tablename alias for $2;
	columnname alias for $3;
	myrec RECORD;
BEGIN
	FOR myrec IN EXECUTE 'SELECT incendies.ST_Extent("' || columnname || '") As extent FROM "' || schemaname || '"."' || tablename || '"' LOOP
		return myrec.extent;
	END LOOP;
END;
$function$
;

-- DROP FUNCTION incendies.st_findextent(text, text);

CREATE OR REPLACE FUNCTION incendies.st_findextent(text, text)
 RETURNS incendies.box2d
 LANGUAGE plpgsql
 STABLE PARALLEL SAFE STRICT
AS $function$
DECLARE
	tablename alias for $1;
	columnname alias for $2;
	myrec RECORD;

BEGIN
	FOR myrec IN EXECUTE 'SELECT incendies.ST_Extent("' || columnname || '") As extent FROM "' || tablename || '"' LOOP
		return myrec.extent;
	END LOOP;
END;
$function$
;

-- DROP FUNCTION incendies.st_flipcoordinates(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_flipcoordinates(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_FlipCoordinates$function$
;

-- DROP FUNCTION incendies.st_force2d(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_force2d(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_force_2d$function$
;

-- DROP FUNCTION incendies.st_force3d(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_force3d(geom incendies.geometry, zvalue double precision DEFAULT 0.0)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_Force3DZ($1, $2)$function$
;

-- DROP FUNCTION incendies.st_force3dm(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_force3dm(geom incendies.geometry, mvalue double precision DEFAULT 0.0)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_force_3dm$function$
;

-- DROP FUNCTION incendies.st_force3dz(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_force3dz(geom incendies.geometry, zvalue double precision DEFAULT 0.0)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_force_3dz$function$
;

-- DROP FUNCTION incendies.st_force4d(incendies.geometry, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_force4d(geom incendies.geometry, zvalue double precision DEFAULT 0.0, mvalue double precision DEFAULT 0.0)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_force_4d$function$
;

-- DROP FUNCTION incendies.st_forcecollection(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_forcecollection(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_force_collection$function$
;

-- DROP FUNCTION incendies.st_forcecurve(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_forcecurve(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_force_curve$function$
;

-- DROP FUNCTION incendies.st_forcepolygonccw(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_forcepolygonccw(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$ SELECT incendies.ST_Reverse(incendies.ST_ForcePolygonCW($1)) $function$
;

-- DROP FUNCTION incendies.st_forcepolygoncw(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_forcepolygoncw(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_force_clockwise_poly$function$
;

-- DROP FUNCTION incendies.st_forcerhr(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_forcerhr(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_force_clockwise_poly$function$
;

-- DROP FUNCTION incendies.st_forcesfs(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_forcesfs(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_force_sfs$function$
;

-- DROP FUNCTION incendies.st_forcesfs(incendies.geometry, text);

CREATE OR REPLACE FUNCTION incendies.st_forcesfs(incendies.geometry, version text)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_force_sfs$function$
;

-- DROP FUNCTION incendies.st_frechetdistance(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_frechetdistance(geom1 incendies.geometry, geom2 incendies.geometry, double precision DEFAULT '-1'::integer)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_FrechetDistance$function$
;

-- DROP FUNCTION incendies.st_fromflatgeobuf(anyelement, bytea);

CREATE OR REPLACE FUNCTION incendies.st_fromflatgeobuf(anyelement, bytea)
 RETURNS SETOF anyelement
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$pgis_fromflatgeobuf$function$
;

-- DROP FUNCTION incendies.st_fromflatgeobuftotable(text, text, bytea);

CREATE OR REPLACE FUNCTION incendies.st_fromflatgeobuftotable(text, text, bytea)
 RETURNS void
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$pgis_tablefromflatgeobuf$function$
;

-- DROP FUNCTION incendies.st_generatepoints(incendies.geometry, int4, int4);

CREATE OR REPLACE FUNCTION incendies.st_generatepoints(area incendies.geometry, npoints integer, seed integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_GeneratePoints$function$
;

-- DROP FUNCTION incendies.st_generatepoints(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_generatepoints(area incendies.geometry, npoints integer)
 RETURNS incendies.geometry
 LANGUAGE c
 PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_GeneratePoints$function$
;

-- DROP FUNCTION incendies.st_geogfromtext(text);

CREATE OR REPLACE FUNCTION incendies.st_geogfromtext(text)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geography_from_text$function$
;

-- DROP FUNCTION incendies.st_geogfromwkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_geogfromwkb(bytea)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$geography_from_binary$function$
;

-- DROP FUNCTION incendies.st_geographyfromtext(text);

CREATE OR REPLACE FUNCTION incendies.st_geographyfromtext(text)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geography_from_text$function$
;

-- DROP FUNCTION incendies.st_geohash(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_geohash(geom incendies.geometry, maxchars integer DEFAULT 0)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_GeoHash$function$
;

-- DROP FUNCTION incendies.st_geohash(incendies.geography, int4);

CREATE OR REPLACE FUNCTION incendies.st_geohash(geog incendies.geography, maxchars integer DEFAULT 0)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_GeoHash$function$
;

-- DROP FUNCTION incendies.st_geomcollfromtext(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_geomcollfromtext(text, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$
	SELECT CASE
	WHEN incendies.geometrytype(incendies.ST_GeomFromText($1, $2)) = 'GEOMETRYCOLLECTION'
	THEN incendies.ST_GeomFromText($1,$2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_geomcollfromtext(text);

CREATE OR REPLACE FUNCTION incendies.st_geomcollfromtext(text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$
	SELECT CASE
	WHEN incendies.geometrytype(incendies.ST_GeomFromText($1)) = 'GEOMETRYCOLLECTION'
	THEN incendies.ST_GeomFromText($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_geomcollfromwkb(bytea, int4);

CREATE OR REPLACE FUNCTION incendies.st_geomcollfromwkb(bytea, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE
	WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1, $2)) = 'GEOMETRYCOLLECTION'
	THEN incendies.ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_geomcollfromwkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_geomcollfromwkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE
	WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1)) = 'GEOMETRYCOLLECTION'
	THEN incendies.ST_GeomFromWKB($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_geometricmedian(incendies.geometry, float8, int4, bool);

CREATE OR REPLACE FUNCTION incendies.st_geometricmedian(g incendies.geometry, tolerance double precision DEFAULT NULL::double precision, max_iter integer DEFAULT 10000, fail_if_not_converged boolean DEFAULT false)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 5000
AS '$libdir/postgis-3', $function$ST_GeometricMedian$function$
;

-- DROP FUNCTION incendies.st_geometryfromtext(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_geometryfromtext(text, integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_from_text$function$
;

-- DROP FUNCTION incendies.st_geometryfromtext(text);

CREATE OR REPLACE FUNCTION incendies.st_geometryfromtext(text)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_from_text$function$
;

-- DROP FUNCTION incendies.st_geometryn(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_geometryn(incendies.geometry, integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_geometryn_collection$function$
;

-- DROP FUNCTION incendies.st_geometrytype(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_geometrytype(incendies.geometry)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geometry_geometrytype$function$
;

-- DROP FUNCTION incendies.st_geomfromewkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_geomfromewkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOMFromEWKB$function$
;

-- DROP FUNCTION incendies.st_geomfromewkt(text);

CREATE OR REPLACE FUNCTION incendies.st_geomfromewkt(text)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$parse_WKT_lwgeom$function$
;

-- DROP FUNCTION incendies.st_geomfromgeohash(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_geomfromgeohash(text, integer DEFAULT NULL::integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE COST 50
AS $function$ SELECT CAST(incendies.ST_Box2dFromGeoHash($1, $2) AS geometry); $function$
;

-- DROP FUNCTION incendies.st_geomfromgeojson(jsonb);

CREATE OR REPLACE FUNCTION incendies.st_geomfromgeojson(jsonb)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$SELECT incendies.ST_GeomFromGeoJson($1::text)$function$
;

-- DROP FUNCTION incendies.st_geomfromgeojson(text);

CREATE OR REPLACE FUNCTION incendies.st_geomfromgeojson(text)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geom_from_geojson$function$
;

-- DROP FUNCTION incendies.st_geomfromgeojson(json);

CREATE OR REPLACE FUNCTION incendies.st_geomfromgeojson(json)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$SELECT incendies.ST_GeomFromGeoJson($1::text)$function$
;

-- DROP FUNCTION incendies.st_geomfromgml(text);

CREATE OR REPLACE FUNCTION incendies.st_geomfromgml(text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$SELECT incendies._ST_GeomFromGML($1, 0)$function$
;

-- DROP FUNCTION incendies.st_geomfromgml(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_geomfromgml(text, integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geom_from_gml$function$
;

-- DROP FUNCTION incendies.st_geomfromkml(text);

CREATE OR REPLACE FUNCTION incendies.st_geomfromkml(text)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geom_from_kml$function$
;

-- DROP FUNCTION incendies.st_geomfrommarc21(text);

CREATE OR REPLACE FUNCTION incendies.st_geomfrommarc21(marc21xml text)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 500
AS '$libdir/postgis-3', $function$ST_GeomFromMARC21$function$
;

-- DROP FUNCTION incendies.st_geomfromtext(text);

CREATE OR REPLACE FUNCTION incendies.st_geomfromtext(text)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_from_text$function$
;

-- DROP FUNCTION incendies.st_geomfromtext(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_geomfromtext(text, integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_from_text$function$
;

-- DROP FUNCTION incendies.st_geomfromtwkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_geomfromtwkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOMFromTWKB$function$
;

-- DROP FUNCTION incendies.st_geomfromwkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_geomfromwkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_from_WKB$function$
;

-- DROP FUNCTION incendies.st_geomfromwkb(bytea, int4);

CREATE OR REPLACE FUNCTION incendies.st_geomfromwkb(bytea, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_SetSRID(incendies.ST_GeomFromWKB($1), $2)$function$
;

-- DROP FUNCTION incendies.st_gmltosql(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_gmltosql(text, integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geom_from_gml$function$
;

-- DROP FUNCTION incendies.st_gmltosql(text);

CREATE OR REPLACE FUNCTION incendies.st_gmltosql(text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$SELECT incendies._ST_GeomFromGML($1, 0)$function$
;

-- DROP FUNCTION incendies.st_hasarc(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_hasarc(geometry incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_has_arc$function$
;

-- DROP FUNCTION incendies.st_hasm(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_hasm(incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_hasm$function$
;

-- DROP FUNCTION incendies.st_hasz(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_hasz(incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_hasz$function$
;

-- DROP FUNCTION incendies.st_hausdorffdistance(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_hausdorffdistance(geom1 incendies.geometry, geom2 incendies.geometry, double precision)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$hausdorffdistancedensify$function$
;

-- DROP FUNCTION incendies.st_hausdorffdistance(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_hausdorffdistance(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$hausdorffdistance$function$
;

-- DROP FUNCTION incendies.st_hexagon(float8, int4, int4, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_hexagon(size double precision, cell_i integer, cell_j integer, origin incendies.geometry DEFAULT '010100000000000000000000000000000000000000'::incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_Hexagon$function$
;

-- DROP FUNCTION incendies.st_hexagongrid(in float8, in incendies.geometry, out incendies.geometry, out int4, out int4);

CREATE OR REPLACE FUNCTION incendies.st_hexagongrid(size double precision, bounds incendies.geometry, OUT geom incendies.geometry, OUT i integer, OUT j integer)
 RETURNS SETOF record
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_ShapeGrid$function$
;

-- DROP FUNCTION incendies.st_interiorringn(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_interiorringn(incendies.geometry, integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_interiorringn_polygon$function$
;

-- DROP FUNCTION incendies.st_interpolatepoint(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_interpolatepoint(line incendies.geometry, point incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_InterpolatePoint$function$
;

-- DROP FUNCTION incendies.st_intersection(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies.st_intersection(incendies.geography, incendies.geography)
 RETURNS incendies.geography
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$SELECT incendies.geography(incendies.ST_Transform(incendies.ST_Intersection(incendies.ST_Transform(incendies.geometry($1), incendies._ST_BestSRID($1, $2)), incendies.ST_Transform(incendies.geometry($2), incendies._ST_BestSRID($1, $2))), incendies.ST_SRID($1)))$function$
;

-- DROP FUNCTION incendies.st_intersection(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_intersection(geom1 incendies.geometry, geom2 incendies.geometry, gridsize double precision DEFAULT '-1'::integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_Intersection$function$
;

-- DROP FUNCTION incendies.st_intersection(text, text);

CREATE OR REPLACE FUNCTION incendies.st_intersection(text, text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS $function$ SELECT incendies.ST_Intersection($1::incendies.geometry, $2::incendies.geometry);  $function$
;

-- DROP FUNCTION incendies.st_intersects(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_intersects(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$ST_Intersects$function$
;

-- DROP FUNCTION incendies.st_intersects(incendies.geography, incendies.geography);

CREATE OR REPLACE FUNCTION incendies.st_intersects(geog1 incendies.geography, geog2 incendies.geography)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$geography_intersects$function$
;

-- DROP FUNCTION incendies.st_intersects(text, text);

CREATE OR REPLACE FUNCTION incendies.st_intersects(text, text)
 RETURNS boolean
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE
AS $function$ SELECT incendies.ST_Intersects($1::incendies.geometry, $2::incendies.geometry);  $function$
;

-- DROP FUNCTION incendies.st_inversetransformpipeline(incendies.geometry, text, int4);

CREATE OR REPLACE FUNCTION incendies.st_inversetransformpipeline(geom incendies.geometry, pipeline text, to_srid integer DEFAULT 0)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS $function$SELECT incendies.postgis_transform_pipeline_geometry($1, $2, FALSE, $3)$function$
;

-- DROP FUNCTION incendies.st_isclosed(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_isclosed(incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_isclosed$function$
;

-- DROP FUNCTION incendies.st_iscollection(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_iscollection(incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$ST_IsCollection$function$
;

-- DROP FUNCTION incendies.st_isempty(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_isempty(incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_isempty$function$
;

-- DROP FUNCTION incendies.st_ispolygonccw(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_ispolygonccw(incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_IsPolygonCCW$function$
;

-- DROP FUNCTION incendies.st_ispolygoncw(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_ispolygoncw(incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_IsPolygonCW$function$
;

-- DROP FUNCTION incendies.st_isring(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_isring(incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$isring$function$
;

-- DROP FUNCTION incendies.st_issimple(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_issimple(incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$issimple$function$
;

-- DROP FUNCTION incendies.st_isvalid(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_isvalid(incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$isvalid$function$
;

-- DROP FUNCTION incendies.st_isvalid(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_isvalid(incendies.geometry, integer)
 RETURNS boolean
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS $function$SELECT (incendies.ST_isValidDetail($1, $2)).valid$function$
;

-- DROP FUNCTION incendies.st_isvaliddetail(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_isvaliddetail(geom incendies.geometry, flags integer DEFAULT 0)
 RETURNS incendies.valid_detail
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$isvaliddetail$function$
;

-- DROP FUNCTION incendies.st_isvalidreason(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_isvalidreason(incendies.geometry, integer)
 RETURNS text
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS $function$
	SELECT CASE WHEN valid THEN 'Valid Geometry' ELSE reason END FROM (
		SELECT (incendies.ST_isValidDetail($1, $2)).*
	) foo
	$function$
;

-- DROP FUNCTION incendies.st_isvalidreason(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_isvalidreason(incendies.geometry)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$isvalidreason$function$
;

-- DROP FUNCTION incendies.st_isvalidtrajectory(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_isvalidtrajectory(incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_IsValidTrajectory$function$
;

-- DROP FUNCTION incendies.st_largestemptycircle(in incendies.geometry, in float8, in incendies.geometry, out incendies.geometry, out incendies.geometry, out float8);

CREATE OR REPLACE FUNCTION incendies.st_largestemptycircle(geom incendies.geometry, tolerance double precision DEFAULT 0.0, boundary incendies.geometry DEFAULT '0101000000000000000000F87F000000000000F87F'::incendies.geometry, OUT center incendies.geometry, OUT nearest incendies.geometry, OUT radius double precision)
 RETURNS record
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_LargestEmptyCircle$function$
;

-- DROP FUNCTION incendies.st_length(incendies.geography, bool);

CREATE OR REPLACE FUNCTION incendies.st_length(geog incendies.geography, use_spheroid boolean DEFAULT true)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geography_length$function$
;

-- DROP FUNCTION incendies.st_length(text);

CREATE OR REPLACE FUNCTION incendies.st_length(text)
 RETURNS double precision
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$ SELECT incendies.ST_Length($1::incendies.geometry);  $function$
;

-- DROP FUNCTION incendies.st_length(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_length(incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_length2d_linestring$function$
;

-- DROP FUNCTION incendies.st_length2d(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_length2d(incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_length2d_linestring$function$
;

-- DROP FUNCTION incendies.st_length2dspheroid(incendies.geometry, incendies.spheroid);

CREATE OR REPLACE FUNCTION incendies.st_length2dspheroid(incendies.geometry, incendies.spheroid)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_length2d_ellipsoid$function$
;

-- DROP FUNCTION incendies.st_lengthspheroid(incendies.geometry, incendies.spheroid);

CREATE OR REPLACE FUNCTION incendies.st_lengthspheroid(incendies.geometry, incendies.spheroid)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_length_ellipsoid_linestring$function$
;

-- DROP FUNCTION incendies.st_letters(text, json);

CREATE OR REPLACE FUNCTION incendies.st_letters(letters text, font json DEFAULT NULL::json)
 RETURNS incendies.geometry
 LANGUAGE plpgsql
 IMMUTABLE PARALLEL SAFE COST 250
 SET standard_conforming_strings TO 'on'
AS $function$
DECLARE
  letterarray text[];
  letter text;
  geom geometry;
  prevgeom geometry = NULL;
  adjustment float8 = 0.0;
  position float8 = 0.0;
  text_height float8 = 100.0;
  width float8;
  m_width float8;
  spacing float8;
  dist float8;
  wordarr geometry[];
  wordgeom geometry;
  -- geometry has been run through replace(encode(st_astwkb(geom),'base64'), E'\n', '')
  font_default_height float8 = 1000.0;
  font_default json = '{
  "!":"BgACAQhUrgsTFOQCABQAExELiwi5AgAJiggBYQmJCgAOAg4CDAIOBAoEDAYKBgoGCggICAgICAgGCgYKBgoGCgQMBAoECgQMAgoADAIKAAoADAEKAAwBCgMKAQwDCgMKAwoFCAUKBwgHBgcIBwYJBgkECwYJBAsCDQILAg0CDQANAQ0BCwELAwsDCwUJBQkFCQcHBwcHBwcFCQUJBQkFCQMLAwkDCQMLAQkACwEJAAkACwIJAAsCCQQJAgsECQQJBAkGBwYJCAcIBQgHCAUKBQoDDAUKAQwDDgEMAQ4BDg==",
  "&":"BgABAskBygP+BowEAACZAmcAANsCAw0FDwUNBQ0FDQcLBw0HCwcLCQsJCwkLCQkJCwsJCwkLCQ0HCwcNBw8HDQUPBQ8DDwMRAw8DEQERAREBEQERABcAFQIXAhUCEwQVBBMGEwYTBhEIEQgPChEKDwoPDA0MDQwNDgsOCRAJEAkQBxAHEgUSBRQFFAMUAxQBFgEWARgAigEAFAISABICEgQQAhAEEAQQBg4GEAoOCg4MDg4ODgwSDgsMCwoJDAcMBwwFDgUMAw4DDgEOARABDgEQARIBEAASAHgAIAQeBB4GHAgaChoMGA4WDhYQFBISEhISDhQQFAwWDBYKFgoYBhgIGAQYBBgCGgAaABgBGAMYAxYHFgUWCRYJFAsUCxIPEg0SERARDhMOFQwVDBcIGQYbBhsCHQIfAR+dAgAADAAKAQoBCgEIAwgFBgUGBQYHBAUEBwQHAgcCBwIHAAcABwAHAQcBBwMHAwUDBwUFBQUHBQUBBwMJAQkBCQAJAJcBAAUCBQAFAgUEBQIDBAUEAwQDBgMEAQYDBgEGAAgBBgAKSeECAJ8BFi84HUQDQCAAmAKNAQAvExMx",
  "\"":"BgACAQUmwguEAgAAkwSDAgAAlAQBBfACAIACAACTBP8BAACUBA==",
  "''":"BgABAQUmwguEAgAAkwSDAgAAlAQ=",
  "(":"BgABAUOQBNwLDScNKw0rCysLLwsxCTEJMwc1BzcHNwM7AzsDPwE/AEEANwI1AjMEMwIzBjEGLwYvCC0ILQgrCCkKKQonCicMJbkCAAkqCSoHLAksBywFLgcuBS4FMAMwAzADMgEwATQBMgA0ADwCOgI6BDoEOAY4BjYINgg2CjQKMgoyCjIMMAwwDi7AAgA=",
  ")":"BgABAUMQ3Au6AgAOLQwvDC8KMQoxCjEKMwg1CDUGNQY3BDcEOQI5AjkAOwAzATEBMQExAy8DLwMvBS8FLQctBS0HKwktBykJKwkpswIADCYKKAooCioIKggsCC4ILgYwBjAGMgQ0AjQCNAI2ADgAQgFAAz4DPAM8BzgHOAc2CTQJMgsyCzALLg0sDSoNKg==",
  "+":"BgABAQ3IBOwGALcBuAEAANUBtwEAALcB0wEAALgBtwEAANYBuAEAALgB1AEA",
  "/":"BgABAQVCAoIDwAuyAgCFA78LrQIA",
  "4":"BgABAhDkBr4EkgEAEREApwJ/AADxARIR5QIAEhIA9AHdAwAA7ALIA9AG6gIAEREA8QYFqwIAAIIDwwH/AgABxAEA",
  "v":"BgABASDmA5AEPu4CROwBExb6AgAZFdMC0wgUFaECABIU0wLWCBcW+AIAExVE6wEEFQQXBBUEFwQVBBUEFwQVBBUEFwQVBBUEFwQXBBUEFwYA",
  ",":"BgABAWMYpAEADgIOAgwCDgQMBAoGDAYKBgoICAgICAgICAoGCgYKBAoEDAQKBAoCDAIKAgwCCgAKAAwACgEMAQoBCgMMAwoDCgUKBQgFCgUIBwYJCAcGCQYJBAsGCQQLAg0CCwINAg0AAwABAAMAAwADAQMAAwADAAMBBQAFAQcBBwEHAwcBCQMJAQsDCwMLAw0FDQMNBQ8FDwURBxMFEwkTBxcJFwkXswEAIMgBCQYJBgkGBwYJCAcIBQgHCgUKBQoFDAEMAwwBDgEOABA=",
  "-":"BgABAQUq0AMArALEBAAAqwLDBAA=",
  ".":"BgABAWFOrAEADgIOAg4CDgQMBAoGDAYKBgoICAgKCAgIBgoGCgYKBgoEDAQKBAwECgIMAAwCDAAMAAwBCgAMAQoDDAMKAwoDCgUKBQgFCgUIBwgJBgcICQYJBgsGCQQLAg0CDQINAA0ADQENAQ0BCwMNAwkFCwUJBQkHBwcJBwUHBwkFCQUJBQkDCwMJAwsDCQELAAsBCwALAAsCCQALAgkECwQJBAkECQYJBgcGBwgJBgcKBQgHCgUKBQwFCgEOAwwBDgEOAA4=",
  "0":"BgABAoMB+APaCxwAHAEaARoDFgMYBRYFFAcUBxIJEgkQCRALEAsOCwwNDA0MDQoPCg0IDwgPBhEGDwYRBA8EEQIRAhMCEQITABMA4QUAEQETAREBEQMRAxEFEQURBREHDwkPBw8JDwsNCw0LDQ0NDQsNCw8JEQkRCREJEwcTBxUFFQUVAxUDFwEXARkAGQAZAhcCFwQXBBUGEwYTCBMIEQoRCg8KDwoPDA0MDQ4NDgsOCQ4JEAkQBxAHEAUSBRIDEgMSAxIDEgESARQAEgDiBQASAhQCEgISBBIEEgYSBhIGEggQChAIEAoQDBAMDgwODg4ODA4MEgwQChIKEggUCBQIFgYWBBYGGAQYAhgCGgILZIcDHTZBEkMRHTUA4QUeOUITRBIePADiBQ==",
  "2":"BgABAWpUwALUA44GAAoBCAEKAQgDBgMGBQYFBgUEBwQFBAUCBwIHAgUABwAHAAUBBwMFAQcFBQMHBQUHBQcFBwMJAwkBCQELAQsAC68CAAAUAhIAFAISBBQCEgQUBBIEEgYUCBIGEAgSChAKEAoQDBAMDg4ODgwQDBIMEgoSChQIFggWCBgGGAQaAhwCHAIWABQBFgEUARQDFAMSAxQFEgUSBxIHEAkQCRALDgsODQ4NDA8KDwwRCBMKEwgTBhUGFwQXBBcEGwAbABsAHQEftwPJBdIDAACpAhIPzwYAFBIArgI=",
  "1":"BgABARCsBLALAJ0LEhERADcA2QEANwATABQSAOYIpwEAALgCERKEBAASABER",
  "3":"BgABAZ0B/gbEC/sB0QQOAwwBDAMMAwwFCgMKBQoFCgUIBwoFCAcICQgJBgkICQYLCAsECwYLBA0GDwINBA8CDwQRAhECEQITABUCFQAVAH0AEQETAREBEQETAxEDEQURBREFDwcRBw8JDwkNCQ8LDQsNDQsNCw0LDwsPCREJEQcRBxMFFQUVBRUDFwEXARkAGQAZAhkCFwQVBBUEEwYTCBEIEQgRCg0MDwoNDA0OCw4LDgkQCRAHEAkQBRAFEgUSAxIDFAMSAxYBFAEWARYAFqQCAAALAgkCCQQHAgcGBwYHBgUIBQYDCAMIAwYDCAEIAQgACAAIAAgCCAIIAgYCCAQIBAgGBgYEBgQIBAoCCgAKAAwAvAEABgEIAAYBBgMGAwQDBgMEBQQDBAUCBQQFAgUABwIFAJkBAACmAaIB3ALbAgAREQDmAhIRggYA",
  "5":"BgABAaAB0APgBxIAFAESABIBEgMSARADEgMQAxIFEAcOBRAHDgkOCQ4JDgsMCwwLCgsKDQoPCA0IDwgPBhEEEwYTAhMEFwIXABcAiQIAEwETABEBEQMTAxEDDwMRBQ8FDwUPBw8JDQcNCQ0LDQsLCwsNCw0JDwkPCREHEQcTBxMFEwMVAxcDGQEZARkAFwAVAhUCFQQTBBMGEwYRCBEIDwoPCg8KDQwNDA0MCw4LDgkOCRAJEAcOBxAHEgUQBRIDEAMSAxIBEgEUARIAFLgCAAAFAgUABQIFBAUCBQQDBAUEAwYDBgMIAwgBCAEIAQoACAAIAgYACAQGAgQEBgQEBAQGBAQCBgIGAgYCBgIIAAYA4AEABgEIAAYBBgMGAQQDBgMEAwQFBAMCBQQFAgUABwIFAPkBAG+OAQCCBRESAgAAAuYFABMRAK8CjQMAAJ8BNgA=",
  "7":"BgABAQrQBsILhQOvCxQR7wIAEhK+AvYIiwMAAKgCERKwBgA=",
  "6":"BgABAsYBnAOqBxgGFgYYBBYEFgIWABQBFgEUAxQDFAUUBRIFEAcSCRAJEAkOCw4NDgsMDQoPCg8KDwgRCBEGEQYRBBMCEwITAhUAkwIBAAERAREBEQEPAxEFEQMPBREFDwcPBw8HDwkNCQ0LDQsNCwsNCw0LDQkPCQ8JDwcRBxEHEwUTAxMFFQEXAxcBGQAVABUCEwIVBBMEEQYTBhEIEQgPChEKDQoPDA0MDQwNDgsOCxALDgkQCRAHEgcQBxIFEgUSBRIBFAMSARIBFAASAOIFABACEgIQAhIEEAQQBhIGEAYQCBAKEAgOChAMDgwMDA4ODA4MDgwODBAKEAoQChIIEggSBhQGFgYUAhYCGAIYABoAGAEYARYBFgMUBRQFEgUSBxAHEAcQCQ4LDgkMCwwNDA0KDQgPCg0GEQgPBhEEEQQRBBMEEwITAhMCFQIVABWrAgAACgEIAQoBCAEGAwYDBgUGBQQFBAUEBQQFAgUABwIFAAUABwEFAAUBBQMFAwUDBQMFBQMFAwUBBQEHAQkBBwAJAJcBDUbpBDASFi4A4AETLC8SBQAvERUrAN8BFC0yEQQA",
  "8":"BgABA9gB6gPYCxYAFAEUARYBEgMUBRQFEgUSBxIHEAcSCQ4JEAkOCw4LDgsMDQwNCg0KDQoPCg8IDwgPBhEGEQQPBBMCEQIRABMAQwAxAA8BEQEPAREDDwMRAw8FEQUPBxEJDwkPCQ8NDw0PDQ8IBwYHCAcGBwgHBgkGBwYJBgcECQYJBAkGCQQJBAsECwQLBA0CCwINAg8CDwIPAA8AaQATAREBEwERAxEFEQURBREHEQcPBw8JDwkPCw8LDQsNDQ0LCw0LDwsNCQ8JDwcPBw8HEQURAxEFEQMRARMBEwFDABEAEwIRAhEEEQQRBg8GEQgPCA8KDwoPCg0MDQwNDAsOCw4LDgkQCRAJDgkQBxIHEAcSBRADEgMUAxIBFAEUABQAagAOAhAADgIOAg4EDAIOBAwEDAQMBgwECgYMBAoGCAYKBgoGCggKBgoICgYICAoICA0MCwwLDgsOCRAHEAcQBxIFEgUSAxIDEgMSARABEgASADIARAASAhICEgQSAhIGEAYSBhAIEAgQCBAKDgoODA4MDgwMDgwODA4KEAwQCBIKEggSCBQIFAYUBBQEFgQWAhYCGAANT78EFis0EwYANBIYLgC0ARcsMRQFADERGS0AswELogHtAhcuNxA3DRkvALMBGjE6ETYSGDIAtAE=",
  "9":"BgABAsYBpASeBBcFFQUXAxUDFQEVABMCFQITBBMEEwYRBhMGDwgRCg8KDwoNDA0OCwwNDgkQCRAJEAcSBxIFEgUSAxQBFAEUARYAlAICAAISAhICEgQSAhAGEgQQBhIGEAgSCA4IEAoOChAMDAwODAwODA4MEAoOChAKEAgSCBIIFAYUBBQGFgIYBBgCGgAWABYBFAEWAxQDEgUUBRIHEgcQCRIJEAkOCw4LDgsODQwNDA0MDwoPCg8IDwgRCBEGEQYRBhEEEQITAhECEwARAOEFAA8BEQEPAREDDwMPBREFDwUPBw8JDwcNCQ8LDQsLCw0NCw0LDQsNCw8JEQkPCREHEQcTBRMFEwUTARUBFQEXABkAFwIXAhcCFQQTBhMGEQYRCA8IDwgNCg8MCwoLDAsOCQ4JDgkQBxAHEAUQBRIFEgMSAxQDFAEUAxQAFgEWABamAgAACwIJAgkCCQIHBAcEBwYFBgUGAwYDBgMGAQgBBgEIAAgABgIIAgYCBgQGBAYEBgYGBgQIBAgECAIKAgoCCgAMAJgBDUXqBC8RFS0A3wEUKzARBgAwEhYsAOABEy4xEgMA",
  ":":"BgACAWE0rAEADgIOAg4CDgQMBAoGDAYKBgoICAgKCAgIBgoGCgYKBgoEDAQKBAwECgIMAAwCDAAMAAwBCgAMAQoDDAMKAwoDCgUKBQgFCgUIBwgJBgcICQYJBgsGCQQLAg0CDQINAA0ADQENAQ0BCwMNAwkFCwUJBQkHBwcJBwUHBwkFCQUJBQkDCwMJAwsDCQELAAsBCwALAAsCCQALAgkECwQJBAkECQYJBgcGBwgJBgcKBQgHCgUKBQwFCgEOAwwBDgEOAA4BYQDqBAAOAg4CDgIOBAwECgYMBgoGCggICAoICAgGCgYKBgoGCgQMBAoEDAQKAgwADAIMAAwADAEKAAwBCgMMAwoDCgMKBQoFCAUKBQgHCAkGBwgJBgkGCwYJBAsCDQINAg0ADQANAQ0BDQELAw0DCQULBQkFCQcHBwkHBQcHCQUJBQkFCQMLAwkDCwEJAwsACwELAAsACwIJAAsECQILBAkECQQJBgkGBwYHCAkGBwoFCAcKBQoFDAUKAQ4DDAEOAQ4ADg==",
  "x":"BgABARHmAoAJMIMBNLUBNrYBMIQB1AIA9QG/BI4CvwTVAgA5hgFBwAFFxwE1fdUCAI4CwATzAcAE1AIA",
  ";":"BgACAWEslgYADgIOAg4CDgQMBAoGDAYKBgoICAgKCAgIBgoGCgYKBgoEDAQKBAwECgIMAAwCDAAMAAwBCgAMAQoDDAMKAwoDCgUKBQgFCgUIBwgJBgcICQYJBgsGCQQLAg0CDQINAA0ADQENAQ0BCwMNAwkFCwUJBQkHBwcJBwUHBwkFCQUJBQkDCwMJAwsBCQMLAAsBCwALAAsCCQALBAkCCwQJBAkECQYJBgcGBwgJBgcKBQgHCgUKBQwFCgEOAwwBDgEOAA4BYwjxBAAOAg4CDAIOBAwECgYMBgoGCggICAgICAgICgYKBgoECgQMBAoECgIMAgoCDAIKAAoADAAKAQwBCgEKAwwDCgMKBQoFCAUKBQgHBgkIBwYJBgkECwYJBAsCDQILAg0CDQADAAEAAwADAAMBAwADAAMAAwEFAAUBBwEHAQcDBwEJAwkBCwMLAwsDDQUNAw0FDwUPBREHEwUTCRMHFwkXCRezAQAgyAEJBgkGCQYHBgkIBwgFCAcKBQoFCgUMAQwDDAEOAQ4AEA==",
  "=":"BgACAQUawAUA5gHEBAAA5QHDBAABBQC5AgDsAcQEAADrAcMEAA==",
  "B":"BgABA2e2BMQLFgAUARQBFAEUAxIDEgUSBRIFEAcQBxAJDgkOCQ4LDgsMCwwNDA0KDQgNCg0IDwYPBg8GDwQRBBEEEQIRAhMAEwAHAAkABwEHAAkBCQAHAQkBCQEHAQkBCQMJAwcDCQMJAwkFBwUJAwkHCQUHBQkHCQcJBwcHBwkHBwcJBwsHCQUQBQ4FDgcOCQ4JDAkMCwoNCg0IDwgRBhMEFQQXAhcCGwDJAQEvAysFJwklDSMPHREbFRkXFRsTHw8fCyUJJwcrAy0B6wMAEhIAoAsREuYDAAiRAYEElgEAKioSSA1EOR6JAQAA0wEJkAGPBSwSEiwAzAETKikSjwEAAMUCkAEA",
  "A":"BgABAg/KBfIBqQIAN98BEhHzAgAWEuwCngsREvwCABMR8gKdCxIR8QIAFBI54AEFlwGCBk3TA6ABAE3UAwMA",
  "?":"BgACAe4BsgaYCAAZABkBFwEXBRUDEwUTBxEHEQcPCQ8JDQkNCQ0LCwsLCwsLCQsJCwcNBwsHDQcLBQsFDQULAwkFCwMLAwkDCQMBAAABAQABAAEBAQABAAEAAQABAAABAQAAAQEAEwcBAQABAAMBAwADAAUABQAFAAcABwAFAAcABwAFAgcABQAHAAUAW7cCAABcABgBFgAUAhQAFAISAhACEAIQBA4EDgQMBgwGDAYMBgoICgYKCAgKCggICAgKBgoICgYMCAwGDAgOBg4GEAYQBgIAAgIEAAICBAACAgQCBAIKBAoGCAQKBggIBgYICAYIBggGCgQIBAoECAQKAggCCgIKAAgACgAKAAgBCAEKAwgDCAMIAwgFBgMIBQYHBAUGBQQFBAcCBQQHAgcCCQIHAgkCBwAJAgkACQAJAAkBCQAJAQsACQELAQsDCwELAwsDCwMLAwsDCwULAwsFCwMLBV2YAgYECAQKBAwGDAQMBhAIEAYSBhIIEgYUBhIEFgYUBBYEFgQWAhgCFgIYABYAGAAYARgBGAMWBRYHFgcWCRYLFA0IBQYDCAUIBwYFCAcGBwgHBgcICQYJCAkGCQYJCAsGCwYLBgsGDQYNBA0GDQQNBA8EDwQPAg8EEQIRAhEAEQITAWGpBesGAA4CDgIOAg4EDAQKBgwGCgYKCAgICggICAYKBgoGCgYKBAwECgQMBAoCDAAMAgwADAAMAQoADAEKAwwDCgMKAwoFCgUIBQoFCAcICQYHCAkGCQYLBgkECwINAg0CDQANAA0BDQENAQsDDQMJBQsFCQUJBwcHCQcFBwcJBQkFCQUJAwsDCQMLAwkBCwALAQsACwALAgkACwIJBAsECQQJBAkGCQYHBgcICQYHCgUIBwoFCgUMBQoBDgMMAQ4BDgAO",
  "C":"BgABAWmmA4ADAAUCBQAFAgUEBQIDBAUEAwQDBgMEAQYDBgEGAAgBBgDWAgAAwQLVAgATABMCEQITBBEEEQQRBhEIEQgPCA8KDwoNCg0MDQwNDAsOCw4LDgkOCxAHEAkQBxIHEgUSBRIDEgEUARIBFAAUAMIFABQCFAISBBQEEgQSBhIIEggSCBAKEAoQCg4MDgwODA4ODA4MDgwQDA4KEggQChIIEggSBhIGFAQSAhQCEgIUAMYCAADBAsUCAAUABwEFAAUBBQMDAQUDAwMDAwMFAQMDBQEFAAUBBwAFAMEF",
  "L":"BgABAQmcBhISEdkFABIQALQLwgIAAIEJ9AIAAK8C",
  "D":"BgABAkeyBMQLFAAUARIBFAESAxIDEgMSBRIFEAcQBxAHDgkOCQ4LDgsMCwwNDA0KDwoPCg8IDwgRCBEGEwQTBBMEEwIVAhUAFwDBBQAXARcBFwMTAxUDEwUTBxEHEQcPCQ8JDwkNCw0LCwsLDQsNCQ0JDQcPBw8HDwcRBREFEQMRAxEDEwERARMBEwDfAwASEgCgCxES4AMACT6BAxEuKxKLAQAAvwaMAQAsEhIsAMIF",
  "F":"BgABARGABoIJ2QIAAIECsgIAEhIA4QIRErECAACvBBIR5QIAEhIAsgucBQASEgDlAhES",
  "E":"BgABARRkxAuWBQAQEgDlAhES0QIAAP0BtgIAEhIA5wIRFLUCAAD/AfACABISAOUCERLDBQASEgCyCw==",
  "G":"BgABAZsBjgeIAgMNBQ8FDQUNBQ0HCwcNBwsHCwkLCQsJCwsJCwsLCQsJDQkLBw0HDwcNBw8FDwUPAw8DEQMPAxEBEQERARMBEQAXABUCFwIVAhMEFQQTBhMGEwYRCBEIDwoRCg8KDwwNDA0MDQ4LDgkQCRAJEAcQBxIFEgUUBRQDFAMUARYBFgEYAMoFABQCFAASBBQCEgQSBBIEEgYSBhAGEAgQCBAKDgoOCg4MDgwMDgwOChAKEAoSCBIIFAgUBhQEGAYWAhgEGAIaAOoCAAC3AukCAAcABwEFAQUBBQMFAwMFAwUDBQEFAQcBBQEFAQUABwAFAMUFAAUCBwIFAgUCBQQFBAMGBQYDBgUGAwgDBgMIAQgDCAEIAQoBCAEIAAgACgAIAAgCCAIIAggECgQGBAgECAYIBgC6AnEAAJwCmAMAAJcF",
  "H":"BgABARbSB7ILAQAAnwsSEeUCABISAOAE5QEAAN8EEhHlAgASEgCiCxEQ5gIAEREA/QPmAQAAgAQPEOYCABER",
  "I":"BgABAQmuA7ILAJ8LFBHtAgAUEgCgCxMS7gIAExE=",
  "J":"BgABAWuqB7ILALEIABEBEwERAREDEwMRAxEFEQURBw8HEQcPCQ0LDwsNCw0NDQ0LDwsPCxEJEQkTCRMJFQcVBxcFFwMZAxsBGwEbAB8AHQIbAhsEGQYXBhcGFQgTCBMKEwoRDA8KDwwNDA0OCw4LDgkQCRAJEAcQBRIFEgUSAxQDEgESARIBFAESABIAgAEREtoCABERAn8ACQIHBAcEBwYHBgUIBQoDCgMKAwoDDAEKAQwBCgEMAAwACgAMAgoCDAIKBAoECgYKBggGBgYGCAQGBAgCCgAIALIIERLmAgAREQ==",
  "M":"BgACAQRm1gsUABMAAAABE5wIAQDBCxIR5QIAEhIA6gIK5gLVAe0B1wHuAQztAgDhAhIR5QIAEhIAxAsUAPoDtwT4A7YEFgA=",
  "K":"BgABAVXMCRoLBQsDCQMLAwsDCwMLAwsBCwELAQsBCwELAQ0ACwELAAsADQALAg0ACwILAA0CCwILAgsCDQQLBAsECwYNBAsGCwYLCAsGCwgJCgsICQoJCgkMCQwJDAkOCRALEAkQCRKZAdICUQAAiwQSEecCABQSAKALExLoAgAREQC3BEIA+AG4BAEAERKCAwAREdkCzQXGAYUDCA0KDQgJCgkMBwoFDAUMAQwBDgAMAg4CDAQOBAwGDghmlQI=",
  "O":"BgABAoMBsATaCxwAHAEaARoDGgMYBRYFFgcWBxQJEgkSCRILEAsODQ4NDg0MDwoNDA8KDwgPCBEIDwYRBg8GEQQRAhMCEQITABMA0QUAEQETAREBEQMTBREFEQURBxEHDwcRCQ8LDQsPCw0NDQ0NDwsPCw8LEQkTCRMJEwkVBxUHFwUXAxkDGQEbARsAGwAZAhkCGQQXBhcGFQYVCBUIEwoRChEMEQoRDA8MDQ4NDg0OCxAJEAsQCRAHEgcSBxIFFAMSAxIDEgEUARIAEgDSBQASAhQCEgISBBIEEgYSBhIIEggQCBAKEgwODBAMEA4ODg4QDhIMEAwSChQKFAgUCBYIFgYYBBoGGgQcAh4CHgILggGLAylCWxZbFSlBANEFKklcGVwYKkwA0gU=",
  "N":"BgABAQ+YA/oEAOUEEhHVAgASEgC+CxQAwATnBQDIBRMS2AIAExEAzQsRAL8ElgU=",
  "P":"BgABAkqoB5AGABcBFQEVAxMDEwMTBREHEQcRBw8JDwkNCQ0LDQsNCwsNCw0JDQkNCQ8HDwcPBxEFEQURAxEDEQMTAREBEwETAH8AAIMDEhHlAgASEgCgCxES1AMAFAAUARIAFAESAxIDEgMSAxIFEAUQBRAHDgkOCQ4JDgsMCwwNDA0KDQoNCg8IDwgRCBEGEwQTBBUEFQIXAhkAGQCzAgnBAsoCESwrEn8AANUDgAEALBISLgDYAg==",
  "R":"BgABAj9msgsREvYDABQAFAESARQBEgESAxIDEgUSBRAFEAcQBw4JDgkOCQ4LDAsMDQwLCg0KDwoNCA8IDwgPBhEEEwYTAhMEFQIXABcAowIAEwEVARMDEwMTBRMFEQcTBxELEQsRDQ8PDREPEQ0VC8QB/QMSEfkCABQSiQGyA3EAALEDFBHnAgASEgCgCwnCAscFogEALhISLACqAhEsLRKhAQAApQM=",
  "Q":"BgABA4YBvAniAbkB8wGZAYABBQUFAwUFBQUHBQUDBwUFBQcFBQMHBQcDBwUJAwcDCQMJAwkDCQMJAQsDCwMLAQsDCwENAw0BDQEPAA8BDwAPABsAGwIZAhcEGQQXBBUGFQgVCBMIEQoTChEKDwwPDA8ODQ4NDgsQCxAJEAkQBxIHEgUSBRQFFAMUARQDFAEWABYAxgUAEgIUAhICEgQSBBIGEgYSCBIIEAgQChIMDgwQDBAODg4OEA4SDBAMEgoUChQIFAgWCBYGGAQaBhoEHAIeAh4CHAAcARoBGgMaAxgFFgUWBxYHFAkSCRIJEgsQCw4NDg0ODQwPCg0MDwoPCA8IEQgPBhEGDwYRBBECEwIRAhMAEwC7BdgBrwEImQSyAwC6AylAWxZbFSk/AP0BjAK7AQeLAoMCGEc4J0wHVBbvAaYBAEM=",
  "S":"BgABAYMC8gOEBxIFEgUQBxIFEgcSBxIJEgcSCRIJEAkQCRALEAsOCw4NDg0MDQ4PDA0KEQoPChEKEQgRCBMGFQQTBBcCFQAXABkBEwARAREBEQMPAQ8DDwMPAw0DDQUNAw0FCwULBwsFCwUJBwsFCQcHBQkHCQUHBwcHBwUHBwUFBQcHBwUHAwcFEQsRCxMJEwkTBxMFEwUVBRUDFQMVARMBFwEVABUAFQIVAhUCFQQVBBUEEwYVBhMIEwgTCBMIEwgRCBMKEQgRCmK6AgwFDgUMAw4FEAUOBRAFEAUQBRAFEAMSAw4DEAMQAxABEAEOAQ4AEAIMAg4CDgQMBAwGCggKCAoKBgwGDgYQBBACCgAMAAoBCAMKBQgFCAcIBwgJCAsGCQgLCA0IDQgNCA8IDQgPCA8IDwgPChEIDwgPCBEKDwoPDBEMDwwPDg8ODw4NEA0QCxALEgsSCRIHEgcUBRQFGAUYAxgBGgEcAR4CJAYkBiAIIAweDBwQHBAYEhgUFBYUFhQWEBoQGg4aDBwKHAoeBh4GIAQgAiACIgEiASIFIgUiBSAJIgkgCyINZ58CBwQJAgkECwQLAgsECwINBA0CDQQNAg0CDQALAg0ADQANAAsBCwELAQsDCwULBQkFCQcHBwcJBwkFCwMLAw0BDQENAAsCCwQLBAkGCQgJCAkKBwoJCgcMBQoHDAcMBQwF",
  "V":"BgABARG2BM4DXrYEbKwDERL0AgAVEesCnQsSEfsCABQS8QKeCxES8gIAExFuqwNgtQQEAA==",
  "T":"BgABAQskxAv0BgAAtQKVAgAA+wgSEeUCABISAPwImwIAALYC",
  "U":"BgABAW76B7ALAKMIABcBFwMXARUFFQUTBxMHEwkRCREJEQsPDQ0LDw0NDwsPCw8LEQkPCRMJEQcTBxMFEwUVBRUDEwMXARUBFQEXABUAEwIVAhMCFQQTBBUEEwYTBhMIEwgRChEIEQwRDA8MDw4PDg0OCxANEAsSCRIJEgcUBxQHFAMWBRYBGAEYARgApggBAREU9AIAExMAAgClCAALAgkECQQHBAcIBwgHCAUKBQoDCgMKAwwBCgEMAQwADAAMAgoCDAIKAgoECgQKBggGCAYICAYKBAgCCgIMAgwApggAARMU9AIAExM=",
  "X":"BgABARmsCBISEYkDABQSS54BWYICXYkCRZUBEhGJAwAUEtYCzgXVAtIFExKIAwATEVClAVj3AVb0AVKqAREShgMAERHXAtEF2ALNBQ==",
  "W":"BgABARuODcQLERHpAp8LFBHlAgASEnW8A2+7AxIR6wIAFBKNA6ALERKSAwATEdQB7wZigARZ8AIREugCAA8RaKsDYsMDXsoDaqYDExLqAgA=",
  "Y":"BgABARK4BcQLhgMAERHnAvMGAKsEEhHnAgAUEgCsBOkC9AYREoYDABERWOEBUJsCUqICVtwBERI=",
  "Z":"BgABAQmAB8QLnwOBCaADAADBAusGAMgDggmhAwAAwgLGBgA=",
  "`":"BgABAQfqAd4JkQHmAQAOlgJCiAGpAgALiwIA",
  "c":"BgABAW3UA84GBQAFAQUABQEFAwMBBQMDAwMDAwUBAwMFAQUABQEHAAUAnQMABQIFAAUCBQQFAgMEBQQDBAMGAwQBBgMGAQYABgEGAPABABoMAMsCGw7tAQATABMCEwARAhMEEQIPBBEEDwQPBg8IDwYNCA0KDQoNCgsMCwwLDAkOCRAHDgcQBxIFEgUUBRQDFAEWAxgBGAAYAKQDABQCFAISBBQCEgYSBhAGEggQCBAIEAoQCg4MDAwODAwODAwKDgwQCg4IEAgQCBAIEAYSBhIGEgQSAhQCFAIUAOABABwOAM0CGQzbAQA=",
  "a":"BgABApoB8AYCxwF+BwkHCQcJCQkHBwkHBwcJBQkFBwUJBQkFCQMHBQkDCQMJAwcDCQEHAQkBBwEJAQcABwAHAQcABQAHAAUBBQAFABMAEwITAhEEEwQPBBEGDwgPCA0IDwoLCg0KCwwLDAsMCQ4JDgkOBw4HEAcQBRAFEAUSAxADEgESAxIBFAESABQAFAISAhQCEgQSBBIEEgYSBhIIEAgQChAIDgwODA4MDg4MDgwODBAMEAoSCBIKEggUCBQGFgYWBBgEGAIaAhoAcgAADgEMAQoBCgEIAwgDBgUEBQQFBAcCBwIHAgkCCQAJAKsCABcPAMwCHAvCAgAUABYBEgAUARIDFAMQAxIDEAUSBQ4FEAcOCRAJDAkOCwwLDA0MCwoNCg8IDwgPCA8GEQYRBhMEEwIXAhUCFwAZAIMGFwAKmQLqA38ATxchQwgnGiMwD1AMUDYAdg==",
  "b":"BgABAkqmBIIJGAAYARYBFgEUAxQDEgUSBRIFEAcQCQ4HDgkOCw4LDAsMDQoNCg0KDQgPBg8GDwYRBBEEEQQTBBECEwIVAhMAFQD/AgAZARcBFwEXAxUDEwUTBREFEQcPBw8JDwkNCQ0LDQsLCwsNCQ0JDQcPBw8HDwURAxEDEQMTAxMBEwMVARUAFQHPAwAUEgCWCxEY5gIAERkAowKCAQAJOvECESwrEn8AAJsEgAEALBISLgCeAw==",
  "d":"BgABAkryBgDLAXAREQ8NEQ0PDREJDwkRBw8FDwURAw8DDwERAw8BEQEPACMCHwQfCB0MGw4bEhcUFxgVGhEeDSANJAkmBSgDKgEuAIADABYCFAIUAhQCFAQUBBIGEgYSBhAIEAgQCBAKDgoODAwMDAwMDgoOCg4KEAgQCBIGEgYSBhQEFgQWBBYCGAIYAHwAAKQCERrmAgARFwCnCxcADOsCugJGMgDmA3sAKxERLQCfAwolHBUmBSQKBAA=",
  "e":"BgABAqMBigP+AgAJAgkCCQQHBAcGBwYFCAUIBQgDCgMIAQoDCAEKAQoACgAKAAoCCAIKAggECgQIBAgGCAYGBgQIBAoECAIKAAyiAgAAGQEXARcBFwMVBRMFEwURBxEHDwcPCQ8LDQkNCwsNCw0LDQkNBw8JDwcPBQ8FEQURAxEDEwMTAxMBFQAVARcALwIrBCkIJwwlDiESHxQbGBkaFR4TIA0iCyQJKAMqASwAggMAFAIUABIEFAISBBIEEgQSBhIGEAgQCBAIEAoODA4MDgwODgwQDBAKEAoSChIIFAgUCBYGGAQYBhoCGgQcAh4ALgEqAygFJgkkDSANHhEaFRgXFBsSHQ4fDCUIJwQpAi0AGQEXAxcDFQcTBRMJEQkPCw8LDQ0PDQsNDQ8LEQsRCxEJEwkTCRMJEwcTBxUHFQUVBRUHFQUVBRUHFwcVBRUHCs4BkAMfOEUURxEfMwBvbBhAGBwaBiA=",
  "h":"BgABAUHYBJAGAAYBBgAGAQYDBgEEAwYDBAMEBQQDAgUEBQIFAAUCBQB1AAC5BhIT5wIAFhQAlAsRGOYCABEZAKMCeAAYABgBFgEWARQDFAMSBRIFEgUQBxAJDgcOCQ4LDgsMCwwNCg0KDQoNCA8GDwYPBhEEEQQRBBMEEQITAhUCEwAVAO0FFhPnAgAUEgD+BQ==",
  "g":"BgABArkBkAeACQCNCw8ZERkRFxEVExMVERUPFQ8XDRcLGQkZBxsFGwUdAR0BDQALAA0ADQINAAsCDQANAg0CDQILAg0EDQINBA0GDQQNBg0EDQYNCA0GDwgNCA0IDQgPCg0KDwwNDA8MDw4PDqIB7gEQDRALEAkQCQ4JEAcOBw4FDgUOAwwFDgMMAQwBDAEMAQwACgEKAAoACAIIAAgCCAIGAggCBgIGBAYCBgQEAgYEAqIBAQADAAEBAwADAAMABQADAAUAAwAFAAMABQAFAAMABQA3ABMAEwIRAhMCEQQRBBEEEQYRBg8IDwgPCA0KDQoNCg0MCwwLDgsOCQ4JDgkQBxAHEgcSBRIDFAMWAxQBFgEYABgA/gIAFgIWAhQEFgQUBBIGFAgSCBIIEAoSChAKDgwODA4MDg4MDgwODA4KEAgQCBAIEgYSBhIEEgYSBBQCEgIUAhQCOgAQABABDgEQAQ4BEAMOAw4FDgUOBQwFDgcMBQ4HDAkMB4oBUBgACbsCzQYAnAR/AC0RES0AnQMSKy4RgAEA",
  "f":"BgABAUH8A6QJBwAHAAUABwEFAQcBBQEFAwUDBQMDAwMDAwUDAwMFAQUAwQHCAQAWEgDZAhUUwQEAAOMEFhftAgAWFADKCQoSChIKEAoQCg4KDgwOCgwMDAoKDAwMCgwIDAgMCAwIDAYOCAwEDgYMBA4GDAIOBA4CDgQOAg4CDgAOAg4ADgC2AQAcDgDRAhkQowEA",
  "i":"BgACAQlQABISALoIERLqAgAREQC5CBIR6QIAAWELyAoADgIOAgwEDgIKBgwGCgYKCAoGCAgICggIBggGCgYKBAoECgQMBAoCDAIMAgwCDAAMAAwADAEMAQoBDAMKAwoDCgUKBQgFCgUIBwgHCAcICQgJBgkECwQJBA0CCwANAA0ADQELAQ0BCwMJBQsFCQUJBwkFBwcHBwcJBQcFCQUJBQkDCQMLAwkBCwELAQsACwALAAsCCwILAgkCCwIJBAkECQQJBgcGCQYHCAcIBwgHCgUKBQwFCgMMAQwBDgEMAA4=",
  "j":"BgACAWFKyAoADgIOAgwEDgIKBgwGCgYKCAoGCAgICggIBggGCgYKBAoECgQMBAoCDAIMAgwCDAAMAAwADAEMAQoBDAMKAwoDCgUKBQgFCgUIBwgHCAcICQgJBgkECwQJBA0CCwANAA0ADQELAQ0BCwMJBQsFCQUJBwkFBwcHBwcJBQcFCQUJBQkDCQMLAwkBCwELAQsACwALAAsCCwILAgkCCwIJBAkECQQJBgcGCQYHCAcIBwgHCgUKBQwFCgMMAQwBDgEMAA4BO+YCnwwJEQkRCQ8JDwsNCQ0LDQkLCwsJCQsLCQkLBwsHCwcLBwsFCwcNAwsFDQMLBQ0BDQMNAQ0DDQENAQ0ADQENAA0AVwAbDQDSAhoPQgAIAAgABgAIAgYCCAIGAgYEBgQGBAQEBAQEBgQEBAYCBgC4CRES6gIAEREAowo=",
  "k":"BgABARKoA/QFIAC0AYoD5gIAjwK5BJICwwTfAgDDAbIDFwAAnwMSEeUCABISAJILERLmAgAREQCvBQ==",
  "n":"BgABAW1yggmQAU8GBAgEBgQGBgYCCAQGBAYEBgQIAgYECAQGAggEBgIIBAgCCAQIAggCCAIIAgoACAIKAAgCCgAKAgoADAAKAgwAFgAWARQAFAEUAxQDFAMSAxIFEgUQBRIHEAkOBxAJDgsOCwwLDA0MDQoPCA8IEQgRBhEGEwYVBBUEFQIXAhkCGQDtBRQR5QIAFBAA/AUACAEIAQYBCAMGBQQFBgUEBwQFBAcCBwIHAgcCCQIHAAcACQAHAQcABwMHAQUDBwMFAwUFBQUDBQEFAwcBBwAHAPkFEhHjAgASEgDwCBAA",
  "m":"BgABAZoBfoIJigFbDAwMCg4KDggOCA4IDgYQBhAGEAQQBBAEEAISAhACEgAmASQDJAciCyANHhEcFRwXDg4QDBAKEAwQCBAKEggSBhIGEgYSBBQEEgIUAhICFAAUABQBEgEUARIDEgMSAxIFEgUQBxAHEAcQBw4JDgkOCw4LDAsMDQoNCg8KDwgPCBEIEQYRBBMEEwQTAhMCFQAVAP0FEhHlAgASEgCCBgAIAQgBBgEGAwYFBgUEBQQHBAUEBwIHAgcCBwIJAAcABwAJAAcBBwEHAQUBBwMFAwUDBQMDBQMFAwUBBQEHAQcAgQYSEeUCABISAIIGAAgBCAEGAQYDBgUGBQQFBAcEBQQHAgcCBwIHAgkABwAHAAkABwEHAQcBBQEHAwUDBQMFAwMFAwUDBQEFAQcBBwCBBhIR5QIAEhIA8AgYAA==",
  "l":"BgABAQnAAwDrAgASFgDWCxEa6gIAERkA0wsUFw==",
  "y":"BgABAZ8BogeNAg8ZERkRFxEVExMVERUPFQ8XDRcLGQkZBxsFGwUdAR0BDQALAA0ADQINAAsCDQANAg0CDQILAg0EDQINBA0GDQQNBg0EDQYNCA0GDwgNCA0IDQgPCg0KDwwNDA8MDw4PDqIB7gEQDRALEAkQCQ4JEAcOBw4FDgUOAwwFDgMMAQwBDAEMAQwACgEKAAoACAIIAAgCCAIGAggCBgIGBAYCBgQEAgYEAqIBAQADAAEBAwADAAMABQADAAUAAwAFAAMABQAFAAMABQA3ABMAEwIRABECEwQRAg8EEQQPBBEGDwgNCA8IDQgNCg0MDQwLDAkOCw4JDgcQBxAHEgUSBRQFFAMWARgDGAEaABwA9AUTEuQCABEPAP8FAAUCBQAFAgUEBQIDBAUEAwQDBgMEAQYDBgEGAAgBBgCAAQAAvAYREuICABMPAP0K",
  "q":"BgABAmj0A4YJFgAWARQAEgESAxADEAMOAw4FDgUMBQ4HDgcOBwwJDgmeAU4A2QwWGesCABYaAN4DAwADAAMBAwADAAUAAwADAAMABQAFAAUABwAHAQcACQAVABUCFQATAhUCEwQRAhMEEQQRBhEGDwgPCA8IDQoNDA0MCwwLDgkOCRAJEAkQBxIHEgUUBRYDFgMYARoBGgAcAP4CABYCFgIWBBYEFAQSBhQIEggSCBAKEgoQDA4MDgwODg4ODBAMDgwQChIIEAoSCBIGEgYUBhQEFAQWAhYCFgIWAApbkQYSKy4ReAAAjARTEjkRHykJMwDvAg==",
  "p":"BgABAmiCBIYJFgAWARYBFAEWAxQDEgUUBRIFEgcSBxAJEAkQCQ4LDgsOCwwNDA0KDwoPCg8IEQgRCBEGEwQTBhMCFQQVAhUAFQD9AgAbARkBFwMXAxcDEwUTBxMHEQcRCQ8JDQsNCw0LCw0LDQkPCQ0JDwURBxEFEQURAxMDEQMTARUBEwEVARUBFQAJAAcABwAFAAcABQAFAAMAAwADAAUAAwIDAAMAAwIDAADdAxYZ6wIAFhoA2gyeAU0OCgwIDgoMCA4GDgYMBg4GDgQQBBAEEgQUAhQCFgIWAApcoQMJNB8qNxJVEQCLBHgALhISLADwAg==",
  "o":"BgABAoMB8gOICRYAFgEWARQBFgMUAxIDFAUSBRIHEgcQBxAJEAkOCw4LDgsMDQwNCg8KDwoPCg8IEQgRBhMGEwQTBBMCFQIVABcAiwMAFwEVARUDEwMTAxMFEwcRBxEHDwkPCQ8LDQsNCw0NCw0LDwkNCw8HEQkPBxEHEQcRBRMFEwMTAxUDFQEVABUAFQAVAhUCFQITBBMEEwYTBhEGEQgRCA8KDwoPCg0KDQwNDAsOCw4JDgkQCRAJEgcSBxIFFAUUAxQDFgEWARYAFgCMAwAYAhYCFgQUBBQEFAYUCBIIEggQChAKEAwODA4MDg4MDgwQCg4KEgoQChIIEggSBhQGEgYUBBYEFAIWAhYCFgALYv0CHTZBFEMRHTcAjwMcNUITQhIiOACQAw==",
  "r":"BgACAQRigAkQAA8AAAABShAAhAFXDAwODAwKDgoOCBAIDgYQBhAEEAQQBBAEEAISABACEAAQAA4BEAAQARADEAEQAxADEAUSBRIHFAcUCxQLFA0WDVJFsQHzAQsMDQwLCgkICwgLCAkGCQYJBAkGBwIJBAcCBwQHAAcCBwAFAgcABQAHAQUABQEFAQUBBQEDAQUBAwMDAQMDAwEAmwYSEeMCABISAO4IEAA=",
  "u":"BgABAV2KBwGPAVANCQsHDQcNBw0FCwUNBQ0FDQMPAw8DEQMTARMBFQEVABUAFQITABMEEwITBBMEEQQRBhEGDwYRCA8KDQgPCg0MDQwLDAsOCRALDgcQBxIHEgUUBRQFFAMWAxgBGAEYARoA7gUTEuYCABMPAPsFAAcCBwIFBAcCBQYDBgUGAwgDBgMIAQgBCAEIAQoBCAAIAAoACAIIAggCCAIGBAgEBgQGBgYGBAYCBgQIAggACAD6BRES5AIAEREA7wgPAA==",
  "s":"BgABAasC/gLwBQoDCgMMBQ4DDgUOBRAFEAUSBRAHEgcQCRIJEAkSCxALEAsQDRANDg0ODw4PDA8MDwoRChEIEwYTBBcCFQIXABkBGQEXAxcFFQUTBRMHEwcRCREJDwkNCQ8LDQ0LCwsNCw0JDQkPBw8HDwUPBREDEQMRAREDEQETABEBEwARABMADwIRABECEQIRBBMCEwQVBBUEFQYVBhMIFwgVChUKFQxgsAIIAwYDCAMKAQgDCAMKAQoDCgEKAwoBCgMKAQwDCgEKAwoBDAMKAQoBCgEMAQoACgEKAAoBCgAKAQgACgAIAQgABgoECAIKAgoCCgAMAQoBDAUEBwIHBAcEBwIHBAkECQQJBAkECQYLBAkGCwYJBgsGCwYJCAsGCwgJBgsICQgLCAkICwgJCgkKCQoJCgcKCQwHDAcMBwwFDAcMAw4FDAMOAw4BDgMQARAAEAESABIAEgIQAg4CDgIOBA4CDgQMBAwEDAQMBgoECgYKBgoGCgYIBggGCAgIBggGBgYIBgYGBgYGBgYGBAgGBgQIBAYECAQQChIIEggSBhIEEgQSBBQCFAISABQAEgASABIAEgESARIBEAEQAxIDDgMQAxADDgUOBQwDDAMMAwoDCAMIAQYBe6cCAwIDAgUAAwIFAgUCBwIFAgcCBQIHAgUCBwIHAAUCBwIHAgUABwIHAgcABQIHAAcCBwAFAgUABQIFAAUABQIDAAEAAQABAQEAAQEBAQEBAQEBAQEDAQEAAwEBAQMAAwEDAAMBAwADAQMAAwABAQMAAwADAAEAAwIBAAMCAQQDAgE=",
  "t":"BgABAUe8BLACWAAaEADRAhsOaQANAA0ADwINAA0CDQANAg0CDQINBA0CCwYNBA0GCwYNBgsIDQgLCAsKCwgJDAsKCQwJDAkOCQ4HEAcSBxIHEgUUAOAEawAVEQDWAhYTbAAAygIVFOYCABUXAMUCogEAFhQA1QIVEqEBAADzAwIFBAMEBQQDBAMEAwYDBgMGAwYBCAEGAQgBBgEIAAgA",
  "w":"BgABARz8BsAEINYCKNgBERLuAgARD+8B3QgSEc0CABQSW7YCV7UCFBHJAgASEpMC3AgREvACABERmAHxBDDaAVeYAxES7gIAEREo1QE81wIIAA==",
  "z":"BgABAQ6cA9AGuQIAFw8AzAIaC9QFAAAr9wKjBuACABYQAMsCGQyZBgCaA9AG"
   }';
BEGIN

  IF font IS NULL THEN
    font := font_default;
  END IF;

  -- For character spacing, use m as guide size
  geom := ST_GeomFromTWKB(decode(font->>'m', 'base64'));
  m_width := ST_XMax(geom) - ST_XMin(geom);
  spacing := m_width / 12;

  letterarray := regexp_split_to_array(replace(letters, ' ', E'\t'), E'');
  FOREACH letter IN ARRAY letterarray
  LOOP
    geom := ST_GeomFromTWKB(decode(font->>(letter), 'base64'));
    -- Chars are not already zeroed out, so do it now
    geom := ST_Translate(geom, -1 * ST_XMin(geom), 0.0);
    -- unknown characters are treated as spaces
    IF geom IS NULL THEN
      -- spaces are a "quarter m" in width
      width := m_width / 3.5;
    ELSE
      width := (ST_XMax(geom) - ST_XMin(geom));
    END IF;
    geom := ST_Translate(geom, position, 0.0);
    -- Tighten up spacing when characters have a large gap
    -- between them like Yo or To
    adjustment := 0.0;
    IF prevgeom IS NOT NULL AND geom IS NOT NULL THEN
      dist = ST_Distance(prevgeom, geom);
      IF dist > spacing THEN
        adjustment = spacing - dist;
        geom := ST_Translate(geom, adjustment, 0.0);
      END IF;
    END IF;
    prevgeom := geom;
    position := position + width + spacing + adjustment;
    wordarr := array_append(wordarr, geom);
  END LOOP;
  -- apply the start point and scaling options
  wordgeom := ST_CollectionExtract(ST_Collect(wordarr));
  wordgeom := ST_Scale(wordgeom,
                text_height/font_default_height,
                text_height/font_default_height);
  return wordgeom;
END;
$function$
;

-- DROP FUNCTION incendies.st_linecrossingdirection(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_linecrossingdirection(line1 incendies.geometry, line2 incendies.geometry)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$ST_LineCrossingDirection$function$
;

-- DROP FUNCTION incendies.st_lineextend(incendies.geometry, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_lineextend(geom incendies.geometry, distance_forward double precision, distance_backward double precision DEFAULT 0.0)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$geometry_line_extend$function$
;

-- DROP FUNCTION incendies.st_linefromencodedpolyline(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_linefromencodedpolyline(txtin text, nprecision integer DEFAULT 5)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$line_from_encoded_polyline$function$
;

-- DROP FUNCTION incendies.st_linefrommultipoint(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_linefrommultipoint(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_line_from_mpoint$function$
;

-- DROP FUNCTION incendies.st_linefromtext(text);

CREATE OR REPLACE FUNCTION incendies.st_linefromtext(text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromText($1)) = 'LINESTRING'
	THEN incendies.ST_GeomFromText($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_linefromtext(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_linefromtext(text, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromText($1, $2)) = 'LINESTRING'
	THEN incendies.ST_GeomFromText($1,$2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_linefromwkb(bytea, int4);

CREATE OR REPLACE FUNCTION incendies.st_linefromwkb(bytea, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1, $2)) = 'LINESTRING'
	THEN incendies.ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_linefromwkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_linefromwkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1)) = 'LINESTRING'
	THEN incendies.ST_GeomFromWKB($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_lineinterpolatepoint(text, float8);

CREATE OR REPLACE FUNCTION incendies.st_lineinterpolatepoint(text, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE
AS $function$ SELECT incendies.ST_LineInterpolatePoint($1::incendies.geometry, $2);  $function$
;

-- DROP FUNCTION incendies.st_lineinterpolatepoint(incendies.geography, float8, bool);

CREATE OR REPLACE FUNCTION incendies.st_lineinterpolatepoint(incendies.geography, double precision, use_spheroid boolean DEFAULT true)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_line_interpolate_point$function$
;

-- DROP FUNCTION incendies.st_lineinterpolatepoint(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_lineinterpolatepoint(incendies.geometry, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_line_interpolate_point$function$
;

-- DROP FUNCTION incendies.st_lineinterpolatepoints(incendies.geography, float8, bool, bool);

CREATE OR REPLACE FUNCTION incendies.st_lineinterpolatepoints(incendies.geography, double precision, use_spheroid boolean DEFAULT true, repeat boolean DEFAULT true)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_line_interpolate_point$function$
;

-- DROP FUNCTION incendies.st_lineinterpolatepoints(text, float8);

CREATE OR REPLACE FUNCTION incendies.st_lineinterpolatepoints(text, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE
AS $function$ SELECT incendies.ST_LineInterpolatePoints($1::incendies.geometry, $2);  $function$
;

-- DROP FUNCTION incendies.st_lineinterpolatepoints(incendies.geometry, float8, bool);

CREATE OR REPLACE FUNCTION incendies.st_lineinterpolatepoints(incendies.geometry, double precision, repeat boolean DEFAULT true)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_line_interpolate_point$function$
;

-- DROP FUNCTION incendies.st_linelocatepoint(incendies.geography, incendies.geography, bool);

CREATE OR REPLACE FUNCTION incendies.st_linelocatepoint(incendies.geography, incendies.geography, use_spheroid boolean DEFAULT true)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_line_locate_point$function$
;

-- DROP FUNCTION incendies.st_linelocatepoint(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_linelocatepoint(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_line_locate_point$function$
;

-- DROP FUNCTION incendies.st_linelocatepoint(text, text);

CREATE OR REPLACE FUNCTION incendies.st_linelocatepoint(text, text)
 RETURNS double precision
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE
AS $function$ SELECT incendies.ST_LineLocatePoint($1::incendies.geometry, $2::incendies.geometry);  $function$
;

-- DROP FUNCTION incendies.st_linemerge(incendies.geometry, bool);

CREATE OR REPLACE FUNCTION incendies.st_linemerge(incendies.geometry, boolean)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$linemerge$function$
;

-- DROP FUNCTION incendies.st_linemerge(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_linemerge(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$linemerge$function$
;

-- DROP FUNCTION incendies.st_linestringfromwkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_linestringfromwkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1)) = 'LINESTRING'
	THEN incendies.ST_GeomFromWKB($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_linestringfromwkb(bytea, int4);

CREATE OR REPLACE FUNCTION incendies.st_linestringfromwkb(bytea, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1, $2)) = 'LINESTRING'
	THEN incendies.ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_linesubstring(incendies.geography, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_linesubstring(incendies.geography, double precision, double precision)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_line_substring$function$
;

-- DROP FUNCTION incendies.st_linesubstring(incendies.geometry, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_linesubstring(incendies.geometry, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_line_substring$function$
;

-- DROP FUNCTION incendies.st_linesubstring(text, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_linesubstring(text, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE
AS $function$ SELECT incendies.ST_LineSubstring($1::incendies.geometry, $2, $3);  $function$
;

-- DROP FUNCTION incendies.st_linetocurve(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_linetocurve(geometry incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$LWGEOM_line_desegmentize$function$
;

-- DROP FUNCTION incendies.st_locatealong(incendies.geometry, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_locatealong(geometry incendies.geometry, measure double precision, leftrightoffset double precision DEFAULT 0.0)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_LocateAlong$function$
;

-- DROP FUNCTION incendies.st_locatebetween(incendies.geometry, float8, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_locatebetween(geometry incendies.geometry, frommeasure double precision, tomeasure double precision, leftrightoffset double precision DEFAULT 0.0)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_LocateBetween$function$
;

-- DROP FUNCTION incendies.st_locatebetweenelevations(incendies.geometry, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_locatebetweenelevations(geometry incendies.geometry, fromelevation double precision, toelevation double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_LocateBetweenElevations$function$
;

-- DROP FUNCTION incendies.st_longestline(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_longestline(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS $function$SELECT incendies._ST_LongestLine(incendies.ST_ConvexHull($1), incendies.ST_ConvexHull($2))$function$
;

-- DROP FUNCTION incendies.st_m(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_m(incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_m_point$function$
;

-- DROP FUNCTION incendies.st_makebox2d(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_makebox2d(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.box2d
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$BOX2D_construct$function$
;

-- DROP FUNCTION incendies.st_makeenvelope(float8, float8, float8, float8, int4);

CREATE OR REPLACE FUNCTION incendies.st_makeenvelope(double precision, double precision, double precision, double precision, integer DEFAULT 0)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_MakeEnvelope$function$
;

-- DROP FUNCTION incendies.st_makeline(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_makeline(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_makeline$function$
;

-- DROP FUNCTION incendies.st_makeline(incendies._geometry);

CREATE OR REPLACE FUNCTION incendies.st_makeline(incendies.geometry[])
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_makeline_garray$function$
;

-- DROP AGGREGATE incendies.st_makeline(incendies.geometry);

-- Aggregate function incendies.st_makeline(incendies.geometry)
-- ERROR: more than one function named "incendies.st_makeline";

-- DROP FUNCTION incendies.st_makepoint(float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_makepoint(double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_makepoint$function$
;

-- DROP FUNCTION incendies.st_makepoint(float8, float8, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_makepoint(double precision, double precision, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_makepoint$function$
;

-- DROP FUNCTION incendies.st_makepoint(float8, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_makepoint(double precision, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_makepoint$function$
;

-- DROP FUNCTION incendies.st_makepointm(float8, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_makepointm(double precision, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_makepoint3dm$function$
;

-- DROP FUNCTION incendies.st_makepolygon(incendies.geometry, incendies._geometry);

CREATE OR REPLACE FUNCTION incendies.st_makepolygon(incendies.geometry, incendies.geometry[])
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_makepoly$function$
;

-- DROP FUNCTION incendies.st_makepolygon(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_makepolygon(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_makepoly$function$
;

-- DROP FUNCTION incendies.st_makevalid(incendies.geometry, text);

CREATE OR REPLACE FUNCTION incendies.st_makevalid(geom incendies.geometry, params text)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_MakeValid$function$
;

-- DROP FUNCTION incendies.st_makevalid(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_makevalid(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_MakeValid$function$
;

-- DROP FUNCTION incendies.st_maxdistance(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_maxdistance(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS double precision
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS $function$SELECT incendies._ST_MaxDistance(incendies.ST_ConvexHull($1), incendies.ST_ConvexHull($2))$function$
;

-- DROP FUNCTION incendies.st_maximuminscribedcircle(in incendies.geometry, out incendies.geometry, out incendies.geometry, out float8);

CREATE OR REPLACE FUNCTION incendies.st_maximuminscribedcircle(incendies.geometry, OUT center incendies.geometry, OUT nearest incendies.geometry, OUT radius double precision)
 RETURNS record
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_MaximumInscribedCircle$function$
;

-- DROP AGGREGATE incendies.st_memcollect(incendies.geometry);

CREATE OR REPLACE AGGREGATE incendies.st_memcollect(incendies.geometry) (
	SFUNC = incendies.st_collect,
	STYPE = incendies.geometry
);

-- DROP FUNCTION incendies.st_memsize(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_memsize(incendies.geometry)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_mem_size$function$
;

-- DROP AGGREGATE incendies.st_memunion(incendies.geometry);

CREATE OR REPLACE AGGREGATE incendies.st_memunion(incendies.geometry) (
	SFUNC = incendies.st_union,
	STYPE = incendies.geometry
);

-- DROP FUNCTION incendies.st_minimumboundingcircle(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_minimumboundingcircle(inputgeom incendies.geometry, segs_per_quarter integer DEFAULT 48)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_MinimumBoundingCircle$function$
;

-- DROP FUNCTION incendies.st_minimumboundingradius(in incendies.geometry, out incendies.geometry, out float8);

CREATE OR REPLACE FUNCTION incendies.st_minimumboundingradius(incendies.geometry, OUT center incendies.geometry, OUT radius double precision)
 RETURNS record
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_MinimumBoundingRadius$function$
;

-- DROP FUNCTION incendies.st_minimumclearance(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_minimumclearance(incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_MinimumClearance$function$
;

-- DROP FUNCTION incendies.st_minimumclearanceline(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_minimumclearanceline(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_MinimumClearanceLine$function$
;

-- DROP FUNCTION incendies.st_mlinefromtext(text);

CREATE OR REPLACE FUNCTION incendies.st_mlinefromtext(text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromText($1)) = 'MULTILINESTRING'
	THEN incendies.ST_GeomFromText($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_mlinefromtext(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_mlinefromtext(text, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$
	SELECT CASE
	WHEN incendies.geometrytype(incendies.ST_GeomFromText($1, $2)) = 'MULTILINESTRING'
	THEN incendies.ST_GeomFromText($1,$2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_mlinefromwkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_mlinefromwkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1)) = 'MULTILINESTRING'
	THEN incendies.ST_GeomFromWKB($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_mlinefromwkb(bytea, int4);

CREATE OR REPLACE FUNCTION incendies.st_mlinefromwkb(bytea, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1, $2)) = 'MULTILINESTRING'
	THEN incendies.ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_mpointfromtext(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_mpointfromtext(text, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromText($1, $2)) = 'MULTIPOINT'
	THEN ST_GeomFromText($1, $2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_mpointfromtext(text);

CREATE OR REPLACE FUNCTION incendies.st_mpointfromtext(text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromText($1)) = 'MULTIPOINT'
	THEN incendies.ST_GeomFromText($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_mpointfromwkb(bytea, int4);

CREATE OR REPLACE FUNCTION incendies.st_mpointfromwkb(bytea, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1, $2)) = 'MULTIPOINT'
	THEN incendies.ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_mpointfromwkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_mpointfromwkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1)) = 'MULTIPOINT'
	THEN incendies.ST_GeomFromWKB($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_mpolyfromtext(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_mpolyfromtext(text, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromText($1, $2)) = 'MULTIPOLYGON'
	THEN incendies.ST_GeomFromText($1,$2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_mpolyfromtext(text);

CREATE OR REPLACE FUNCTION incendies.st_mpolyfromtext(text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromText($1)) = 'MULTIPOLYGON'
	THEN incendies.ST_GeomFromText($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_mpolyfromwkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_mpolyfromwkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1)) = 'MULTIPOLYGON'
	THEN incendies.ST_GeomFromWKB($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_mpolyfromwkb(bytea, int4);

CREATE OR REPLACE FUNCTION incendies.st_mpolyfromwkb(bytea, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
	THEN incendies.ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_multi(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_multi(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_force_multi$function$
;

-- DROP FUNCTION incendies.st_multilinefromwkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_multilinefromwkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1)) = 'MULTILINESTRING'
	THEN incendies.ST_GeomFromWKB($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_multilinestringfromtext(text);

CREATE OR REPLACE FUNCTION incendies.st_multilinestringfromtext(text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$SELECT incendies.ST_MLineFromText($1)$function$
;

-- DROP FUNCTION incendies.st_multilinestringfromtext(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_multilinestringfromtext(text, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$SELECT incendies.ST_MLineFromText($1, $2)$function$
;

-- DROP FUNCTION incendies.st_multipointfromtext(text);

CREATE OR REPLACE FUNCTION incendies.st_multipointfromtext(text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$SELECT incendies.ST_MPointFromText($1)$function$
;

-- DROP FUNCTION incendies.st_multipointfromwkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_multipointfromwkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1)) = 'MULTIPOINT'
	THEN incendies.ST_GeomFromWKB($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_multipointfromwkb(bytea, int4);

CREATE OR REPLACE FUNCTION incendies.st_multipointfromwkb(bytea, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1,$2)) = 'MULTIPOINT'
	THEN incendies.ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_multipolyfromwkb(bytea, int4);

CREATE OR REPLACE FUNCTION incendies.st_multipolyfromwkb(bytea, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
	THEN incendies.ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_multipolyfromwkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_multipolyfromwkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1)) = 'MULTIPOLYGON'
	THEN incendies.ST_GeomFromWKB($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_multipolygonfromtext(text);

CREATE OR REPLACE FUNCTION incendies.st_multipolygonfromtext(text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$SELECT incendies.ST_MPolyFromText($1)$function$
;

-- DROP FUNCTION incendies.st_multipolygonfromtext(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_multipolygonfromtext(text, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$SELECT incendies.ST_MPolyFromText($1, $2)$function$
;

-- DROP FUNCTION incendies.st_ndims(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_ndims(incendies.geometry)
 RETURNS smallint
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_ndims$function$
;

-- DROP FUNCTION incendies.st_node(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_node(g incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_Node$function$
;

-- DROP FUNCTION incendies.st_normalize(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_normalize(geom incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_Normalize$function$
;

-- DROP FUNCTION incendies.st_npoints(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_npoints(incendies.geometry)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_npoints$function$
;

-- DROP FUNCTION incendies.st_nrings(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_nrings(incendies.geometry)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_nrings$function$
;

-- DROP FUNCTION incendies.st_numcurves(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_numcurves(geometry incendies.geometry)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_NumCurves$function$
;

-- DROP FUNCTION incendies.st_numgeometries(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_numgeometries(incendies.geometry)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_numgeometries_collection$function$
;

-- DROP FUNCTION incendies.st_numinteriorring(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_numinteriorring(incendies.geometry)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_numinteriorrings_polygon$function$
;

-- DROP FUNCTION incendies.st_numinteriorrings(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_numinteriorrings(incendies.geometry)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_numinteriorrings_polygon$function$
;

-- DROP FUNCTION incendies.st_numpatches(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_numpatches(incendies.geometry)
 RETURNS integer
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.ST_GeometryType($1) = 'ST_PolyhedralSurface'
	THEN incendies.ST_NumGeometries($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_numpoints(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_numpoints(incendies.geometry)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_numpoints_linestring$function$
;

-- DROP FUNCTION incendies.st_offsetcurve(incendies.geometry, float8, text);

CREATE OR REPLACE FUNCTION incendies.st_offsetcurve(line incendies.geometry, distance double precision, params text DEFAULT ''::text)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_OffsetCurve$function$
;

-- DROP FUNCTION incendies.st_orderingequals(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_orderingequals(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$LWGEOM_same$function$
;

-- DROP FUNCTION incendies.st_orientedenvelope(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_orientedenvelope(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_OrientedEnvelope$function$
;

-- DROP FUNCTION incendies.st_overlaps(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_overlaps(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$overlaps$function$
;

-- DROP FUNCTION incendies.st_patchn(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_patchn(incendies.geometry, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.ST_GeometryType($1) = 'ST_PolyhedralSurface'
	THEN incendies.ST_GeometryN($1, $2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_perimeter(incendies.geography, bool);

CREATE OR REPLACE FUNCTION incendies.st_perimeter(geog incendies.geography, use_spheroid boolean DEFAULT true)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geography_perimeter$function$
;

-- DROP FUNCTION incendies.st_perimeter(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_perimeter(incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_perimeter2d_poly$function$
;

-- DROP FUNCTION incendies.st_perimeter2d(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_perimeter2d(incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_perimeter2d_poly$function$
;

-- DROP FUNCTION incendies.st_point(float8, float8, int4);

CREATE OR REPLACE FUNCTION incendies.st_point(double precision, double precision, srid integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_Point$function$
;

-- DROP FUNCTION incendies.st_point(float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_point(double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_makepoint$function$
;

-- DROP FUNCTION incendies.st_pointfromgeohash(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_pointfromgeohash(text, integer DEFAULT NULL::integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 50
AS '$libdir/postgis-3', $function$point_from_geohash$function$
;

-- DROP FUNCTION incendies.st_pointfromtext(text);

CREATE OR REPLACE FUNCTION incendies.st_pointfromtext(text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromText($1)) = 'POINT'
	THEN incendies.ST_GeomFromText($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_pointfromtext(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_pointfromtext(text, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromText($1, $2)) = 'POINT'
	THEN incendies.ST_GeomFromText($1, $2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_pointfromwkb(bytea, int4);

CREATE OR REPLACE FUNCTION incendies.st_pointfromwkb(bytea, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1, $2)) = 'POINT'
	THEN incendies.ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_pointfromwkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_pointfromwkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1)) = 'POINT'
	THEN incendies.ST_GeomFromWKB($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_pointinsidecircle(incendies.geometry, float8, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_pointinsidecircle(incendies.geometry, double precision, double precision, double precision)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_inside_circle_point$function$
;

-- DROP FUNCTION incendies.st_pointm(float8, float8, float8, int4);

CREATE OR REPLACE FUNCTION incendies.st_pointm(xcoordinate double precision, ycoordinate double precision, mcoordinate double precision, srid integer DEFAULT 0)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_PointM$function$
;

-- DROP FUNCTION incendies.st_pointn(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_pointn(incendies.geometry, integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_pointn_linestring$function$
;

-- DROP FUNCTION incendies.st_pointonsurface(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_pointonsurface(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$pointonsurface$function$
;

-- DROP FUNCTION incendies.st_points(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_points(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_Points$function$
;

-- DROP FUNCTION incendies.st_pointz(float8, float8, float8, int4);

CREATE OR REPLACE FUNCTION incendies.st_pointz(xcoordinate double precision, ycoordinate double precision, zcoordinate double precision, srid integer DEFAULT 0)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_PointZ$function$
;

-- DROP FUNCTION incendies.st_pointzm(float8, float8, float8, float8, int4);

CREATE OR REPLACE FUNCTION incendies.st_pointzm(xcoordinate double precision, ycoordinate double precision, zcoordinate double precision, mcoordinate double precision, srid integer DEFAULT 0)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_PointZM$function$
;

-- DROP FUNCTION incendies.st_polyfromtext(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_polyfromtext(text, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromText($1, $2)) = 'POLYGON'
	THEN incendies.ST_GeomFromText($1, $2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_polyfromtext(text);

CREATE OR REPLACE FUNCTION incendies.st_polyfromtext(text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromText($1)) = 'POLYGON'
	THEN incendies.ST_GeomFromText($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_polyfromwkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_polyfromwkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1)) = 'POLYGON'
	THEN incendies.ST_GeomFromWKB($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_polyfromwkb(bytea, int4);

CREATE OR REPLACE FUNCTION incendies.st_polyfromwkb(bytea, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1, $2)) = 'POLYGON'
	THEN incendies.ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_polygon(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_polygon(incendies.geometry, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT incendies.ST_SetSRID(incendies.ST_MakePolygon($1), $2)
	$function$
;

-- DROP FUNCTION incendies.st_polygonfromtext(text, int4);

CREATE OR REPLACE FUNCTION incendies.st_polygonfromtext(text, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$SELECT incendies.ST_PolyFromText($1, $2)$function$
;

-- DROP FUNCTION incendies.st_polygonfromtext(text);

CREATE OR REPLACE FUNCTION incendies.st_polygonfromtext(text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS $function$SELECT incendies.ST_PolyFromText($1)$function$
;

-- DROP FUNCTION incendies.st_polygonfromwkb(bytea);

CREATE OR REPLACE FUNCTION incendies.st_polygonfromwkb(bytea)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1)) = 'POLYGON'
	THEN incendies.ST_GeomFromWKB($1)
	ELSE NULL END
	$function$
;

-- DROP FUNCTION incendies.st_polygonfromwkb(bytea, int4);

CREATE OR REPLACE FUNCTION incendies.st_polygonfromwkb(bytea, integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$
	SELECT CASE WHEN incendies.geometrytype(incendies.ST_GeomFromWKB($1,$2)) = 'POLYGON'
	THEN incendies.ST_GeomFromWKB($1, $2)
	ELSE NULL END
	$function$
;

-- DROP AGGREGATE incendies.st_polygonize(incendies.geometry);

-- Aggregate function incendies.st_polygonize(incendies.geometry)
-- ERROR: more than one function named "incendies.st_polygonize";

-- DROP FUNCTION incendies.st_polygonize(incendies._geometry);

CREATE OR REPLACE FUNCTION incendies.st_polygonize(incendies.geometry[])
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$polygonize_garray$function$
;

-- DROP FUNCTION incendies.st_project(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_project(geom1 incendies.geometry, geom2 incendies.geometry, distance double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$geometry_project_geometry$function$
;

-- DROP FUNCTION incendies.st_project(incendies.geography, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_project(geog incendies.geography, distance double precision, azimuth double precision)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$geography_project$function$
;

-- DROP FUNCTION incendies.st_project(incendies.geography, incendies.geography, float8);

CREATE OR REPLACE FUNCTION incendies.st_project(geog_from incendies.geography, geog_to incendies.geography, distance double precision)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geography_project_geography$function$
;

-- DROP FUNCTION incendies.st_project(incendies.geometry, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_project(geom1 incendies.geometry, distance double precision, azimuth double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$geometry_project_direction$function$
;

-- DROP FUNCTION incendies.st_quantizecoordinates(incendies.geometry, int4, int4, int4, int4);

CREATE OR REPLACE FUNCTION incendies.st_quantizecoordinates(g incendies.geometry, prec_x integer, prec_y integer DEFAULT NULL::integer, prec_z integer DEFAULT NULL::integer, prec_m integer DEFAULT NULL::integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE COST 250
AS '$libdir/postgis-3', $function$ST_QuantizeCoordinates$function$
;

-- DROP FUNCTION incendies.st_reduceprecision(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_reduceprecision(geom incendies.geometry, gridsize double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_ReducePrecision$function$
;

-- DROP FUNCTION incendies.st_relate(incendies.geometry, incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_relate(geom1 incendies.geometry, geom2 incendies.geometry, integer)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$relate_full$function$
;

-- DROP FUNCTION incendies.st_relate(incendies.geometry, incendies.geometry, text);

CREATE OR REPLACE FUNCTION incendies.st_relate(geom1 incendies.geometry, geom2 incendies.geometry, text)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$relate_pattern$function$
;

-- DROP FUNCTION incendies.st_relate(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_relate(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$relate_full$function$
;

-- DROP FUNCTION incendies.st_relatematch(text, text);

CREATE OR REPLACE FUNCTION incendies.st_relatematch(text, text)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_RelateMatch$function$
;

-- DROP FUNCTION incendies.st_removeirrelevantpointsforview(incendies.geometry, incendies.box2d, bool);

CREATE OR REPLACE FUNCTION incendies.st_removeirrelevantpointsforview(incendies.geometry, incendies.box2d, boolean DEFAULT false)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_RemoveIrrelevantPointsForView$function$
;

-- DROP FUNCTION incendies.st_removepoint(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_removepoint(incendies.geometry, integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_removepoint$function$
;

-- DROP FUNCTION incendies.st_removerepeatedpoints(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_removerepeatedpoints(geom incendies.geometry, tolerance double precision DEFAULT 0.0)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_RemoveRepeatedPoints$function$
;

-- DROP FUNCTION incendies.st_removesmallparts(incendies.geometry, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_removesmallparts(incendies.geometry, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_RemoveSmallParts$function$
;

-- DROP FUNCTION incendies.st_reverse(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_reverse(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_reverse$function$
;

-- DROP FUNCTION incendies.st_rotate(incendies.geometry, float8, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_rotate(incendies.geometry, double precision, incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_Affine($1,  cos($2), -sin($2), 0,  sin($2),  cos($2), 0, 0, 0, 1, incendies.ST_X($3) - cos($2) * incendies.ST_X($3) + sin($2) * incendies.ST_Y($3), incendies.ST_Y($3) - sin($2) * incendies.ST_X($3) - cos($2) * incendies.ST_Y($3), 0)$function$
;

-- DROP FUNCTION incendies.st_rotate(incendies.geometry, float8, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_rotate(incendies.geometry, double precision, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_Affine($1,  cos($2), -sin($2), 0,  sin($2),  cos($2), 0, 0, 0, 1,	$3 - cos($2) * $3 + sin($2) * $4, $4 - sin($2) * $3 - cos($2) * $4, 0)$function$
;

-- DROP FUNCTION incendies.st_rotate(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_rotate(incendies.geometry, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_Affine($1,  cos($2), -sin($2), 0,  sin($2), cos($2), 0,  0, 0, 1,  0, 0, 0)$function$
;

-- DROP FUNCTION incendies.st_rotatex(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_rotatex(incendies.geometry, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_Affine($1, 1, 0, 0, 0, cos($2), -sin($2), 0, sin($2), cos($2), 0, 0, 0)$function$
;

-- DROP FUNCTION incendies.st_rotatey(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_rotatey(incendies.geometry, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_Affine($1,  cos($2), 0, sin($2),  0, 1, 0,  -sin($2), 0, cos($2), 0,  0, 0)$function$
;

-- DROP FUNCTION incendies.st_rotatez(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_rotatez(incendies.geometry, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_Rotate($1, $2)$function$
;

-- DROP FUNCTION incendies.st_scale(incendies.geometry, float8, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_scale(incendies.geometry, double precision, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_Scale($1, incendies.ST_MakePoint($2, $3, $4))$function$
;

-- DROP FUNCTION incendies.st_scale(incendies.geometry, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_scale(incendies.geometry, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_Scale($1, $2, $3, 1)$function$
;

-- DROP FUNCTION incendies.st_scale(incendies.geometry, incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_scale(incendies.geometry, incendies.geometry, origin incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_Scale$function$
;

-- DROP FUNCTION incendies.st_scale(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_scale(incendies.geometry, incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_Scale$function$
;

-- DROP FUNCTION incendies.st_scroll(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_scroll(incendies.geometry, incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_Scroll$function$
;

-- DROP FUNCTION incendies.st_segmentize(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_segmentize(incendies.geometry, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_segmentize2d$function$
;

-- DROP FUNCTION incendies.st_segmentize(incendies.geography, float8);

CREATE OR REPLACE FUNCTION incendies.st_segmentize(geog incendies.geography, max_segment_length double precision)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$geography_segmentize$function$
;

-- DROP FUNCTION incendies.st_seteffectivearea(incendies.geometry, float8, int4);

CREATE OR REPLACE FUNCTION incendies.st_seteffectivearea(incendies.geometry, double precision DEFAULT '-1'::integer, integer DEFAULT 1)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$LWGEOM_SetEffectiveArea$function$
;

-- DROP FUNCTION incendies.st_setpoint(incendies.geometry, int4, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_setpoint(incendies.geometry, integer, incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_setpoint_linestring$function$
;

-- DROP FUNCTION incendies.st_setsrid(incendies.geography, int4);

CREATE OR REPLACE FUNCTION incendies.st_setsrid(geog incendies.geography, srid integer)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_set_srid$function$
;

-- DROP FUNCTION incendies.st_setsrid(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_setsrid(geom incendies.geometry, srid integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_set_srid$function$
;

-- DROP FUNCTION incendies.st_sharedpaths(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_sharedpaths(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_SharedPaths$function$
;

-- DROP FUNCTION incendies.st_shiftlongitude(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_shiftlongitude(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_longitude_shift$function$
;

-- DROP FUNCTION incendies.st_shortestline(incendies.geography, incendies.geography, bool);

CREATE OR REPLACE FUNCTION incendies.st_shortestline(incendies.geography, incendies.geography, use_spheroid boolean DEFAULT true)
 RETURNS incendies.geography
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$geography_shortestline$function$
;

-- DROP FUNCTION incendies.st_shortestline(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_shortestline(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_shortestline2d$function$
;

-- DROP FUNCTION incendies.st_shortestline(text, text);

CREATE OR REPLACE FUNCTION incendies.st_shortestline(text, text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE
AS $function$ SELECT incendies.ST_ShortestLine($1::incendies.geometry, $2::incendies.geometry);  $function$
;

-- DROP FUNCTION incendies.st_simplify(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_simplify(incendies.geometry, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_simplify2d$function$
;

-- DROP FUNCTION incendies.st_simplify(incendies.geometry, float8, bool);

CREATE OR REPLACE FUNCTION incendies.st_simplify(incendies.geometry, double precision, boolean)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_simplify2d$function$
;

-- DROP FUNCTION incendies.st_simplifypolygonhull(incendies.geometry, float8, bool);

CREATE OR REPLACE FUNCTION incendies.st_simplifypolygonhull(geom incendies.geometry, vertex_fraction double precision, is_outer boolean DEFAULT true)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_SimplifyPolygonHull$function$
;

-- DROP FUNCTION incendies.st_simplifypreservetopology(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_simplifypreservetopology(incendies.geometry, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$topologypreservesimplify$function$
;

-- DROP FUNCTION incendies.st_simplifyvw(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_simplifyvw(incendies.geometry, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$LWGEOM_SetEffectiveArea$function$
;

-- DROP FUNCTION incendies.st_snap(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_snap(geom1 incendies.geometry, geom2 incendies.geometry, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_Snap$function$
;

-- DROP FUNCTION incendies.st_snaptogrid(incendies.geometry, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_snaptogrid(incendies.geometry, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_SnapToGrid($1, 0, 0, $2, $3)$function$
;

-- DROP FUNCTION incendies.st_snaptogrid(incendies.geometry, float8, float8, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_snaptogrid(incendies.geometry, double precision, double precision, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_snaptogrid$function$
;

-- DROP FUNCTION incendies.st_snaptogrid(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_snaptogrid(incendies.geometry, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_SnapToGrid($1, 0, 0, $2, $2)$function$
;

-- DROP FUNCTION incendies.st_snaptogrid(incendies.geometry, incendies.geometry, float8, float8, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_snaptogrid(geom1 incendies.geometry, geom2 incendies.geometry, double precision, double precision, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_snaptogrid_pointoff$function$
;

-- DROP FUNCTION incendies.st_split(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_split(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_Split$function$
;

-- DROP FUNCTION incendies.st_square(float8, int4, int4, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_square(size double precision, cell_i integer, cell_j integer, origin incendies.geometry DEFAULT '010100000000000000000000000000000000000000'::incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_Square$function$
;

-- DROP FUNCTION incendies.st_squaregrid(in float8, in incendies.geometry, out incendies.geometry, out int4, out int4);

CREATE OR REPLACE FUNCTION incendies.st_squaregrid(size double precision, bounds incendies.geometry, OUT geom incendies.geometry, OUT i integer, OUT j integer)
 RETURNS SETOF record
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$ST_ShapeGrid$function$
;

-- DROP FUNCTION incendies.st_srid(incendies.geography);

CREATE OR REPLACE FUNCTION incendies.st_srid(geog incendies.geography)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_get_srid$function$
;

-- DROP FUNCTION incendies.st_srid(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_srid(geom incendies.geometry)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_get_srid$function$
;

-- DROP FUNCTION incendies.st_startpoint(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_startpoint(incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_startpoint_linestring$function$
;

-- DROP FUNCTION incendies.st_subdivide(incendies.geometry, int4, float8);

CREATE OR REPLACE FUNCTION incendies.st_subdivide(geom incendies.geometry, maxvertices integer DEFAULT 256, gridsize double precision DEFAULT '-1.0'::numeric)
 RETURNS SETOF incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_Subdivide$function$
;

-- DROP FUNCTION incendies.st_summary(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_summary(incendies.geometry)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_summary$function$
;

-- DROP FUNCTION incendies.st_summary(incendies.geography);

CREATE OR REPLACE FUNCTION incendies.st_summary(incendies.geography)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_summary$function$
;

-- DROP FUNCTION incendies.st_swapordinates(incendies.geometry, cstring);

CREATE OR REPLACE FUNCTION incendies.st_swapordinates(geom incendies.geometry, ords cstring)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_SwapOrdinates$function$
;

-- DROP FUNCTION incendies.st_symdifference(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_symdifference(geom1 incendies.geometry, geom2 incendies.geometry, gridsize double precision DEFAULT '-1.0'::numeric)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_SymDifference$function$
;

-- DROP FUNCTION incendies.st_symmetricdifference(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_symmetricdifference(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE sql
AS $function$SELECT incendies.ST_SymDifference(geom1, geom2, -1.0);$function$
;

-- DROP FUNCTION incendies.st_tileenvelope(int4, int4, int4, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_tileenvelope(zoom integer, x integer, y integer, bounds incendies.geometry DEFAULT '0102000020110F00000200000093107C45F81B73C193107C45F81B73C193107C45F81B734193107C45F81B7341'::incendies.geometry, margin double precision DEFAULT 0.0)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_TileEnvelope$function$
;

-- DROP FUNCTION incendies.st_touches(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_touches(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$touches$function$
;

-- DROP FUNCTION incendies.st_transform(incendies.geometry, int4);

CREATE OR REPLACE FUNCTION incendies.st_transform(incendies.geometry, integer)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$transform$function$
;

-- DROP FUNCTION incendies.st_transform(incendies.geometry, text, text);

CREATE OR REPLACE FUNCTION incendies.st_transform(geom incendies.geometry, from_proj text, to_proj text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS $function$SELECT incendies.postgis_transform_geometry($1, $2, $3, 0)$function$
;

-- DROP FUNCTION incendies.st_transform(incendies.geometry, text);

CREATE OR REPLACE FUNCTION incendies.st_transform(geom incendies.geometry, to_proj text)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS $function$SELECT incendies.postgis_transform_geometry($1, proj4text, $2, 0)
	FROM incendies.spatial_ref_sys WHERE srid=incendies.ST_SRID($1);$function$
;

-- DROP FUNCTION incendies.st_transform(incendies.geometry, text, int4);

CREATE OR REPLACE FUNCTION incendies.st_transform(geom incendies.geometry, from_proj text, to_srid integer)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS $function$SELECT incendies.postgis_transform_geometry($1, $2, proj4text, $3)
	FROM incendies.spatial_ref_sys WHERE srid=$3;$function$
;

-- DROP FUNCTION incendies.st_transformpipeline(incendies.geometry, text, int4);

CREATE OR REPLACE FUNCTION incendies.st_transformpipeline(geom incendies.geometry, pipeline text, to_srid integer DEFAULT 0)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS $function$SELECT incendies.postgis_transform_pipeline_geometry($1, $2, TRUE, $3)$function$
;

-- DROP FUNCTION incendies.st_translate(incendies.geometry, float8, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_translate(incendies.geometry, double precision, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_Affine($1, 1, 0, 0, 0, 1, 0, 0, 0, 1, $2, $3, $4)$function$
;

-- DROP FUNCTION incendies.st_translate(incendies.geometry, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_translate(incendies.geometry, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_Translate($1, $2, $3, 0)$function$
;

-- DROP FUNCTION incendies.st_transscale(incendies.geometry, float8, float8, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_transscale(incendies.geometry, double precision, double precision, double precision, double precision)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS $function$SELECT incendies.ST_Affine($1,  $4, 0, 0,  0, $5, 0,
		0, 0, 1,  $2 * $4, $3 * $5, 0)$function$
;

-- DROP FUNCTION incendies.st_triangulatepolygon(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_triangulatepolygon(g1 incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_TriangulatePolygon$function$
;

-- DROP FUNCTION incendies.st_unaryunion(incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_unaryunion(incendies.geometry, gridsize double precision DEFAULT '-1.0'::numeric)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_UnaryUnion$function$
;

-- DROP AGGREGATE incendies.st_union(incendies.geometry, float8);

-- Aggregate function incendies.st_union(incendies.geometry, float8)
-- ERROR: more than one function named "incendies.st_union";

-- DROP FUNCTION incendies.st_union(incendies._geometry);

CREATE OR REPLACE FUNCTION incendies.st_union(incendies.geometry[])
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$pgis_union_geometry_array$function$
;

-- DROP AGGREGATE incendies.st_union(incendies.geometry);

-- Aggregate function incendies.st_union(incendies.geometry)
-- ERROR: more than one function named "incendies.st_union";

-- DROP FUNCTION incendies.st_union(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_union(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_Union$function$
;

-- DROP FUNCTION incendies.st_union(incendies.geometry, incendies.geometry, float8);

CREATE OR REPLACE FUNCTION incendies.st_union(geom1 incendies.geometry, geom2 incendies.geometry, gridsize double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000
AS '$libdir/postgis-3', $function$ST_Union$function$
;

-- DROP FUNCTION incendies.st_voronoilines(incendies.geometry, float8, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_voronoilines(g1 incendies.geometry, tolerance double precision DEFAULT 0.0, extend_to incendies.geometry DEFAULT NULL::incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE
AS $function$ SELECT incendies._ST_Voronoi(g1, extend_to, tolerance, false) $function$
;

-- DROP FUNCTION incendies.st_voronoipolygons(incendies.geometry, float8, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_voronoipolygons(g1 incendies.geometry, tolerance double precision DEFAULT 0.0, extend_to incendies.geometry DEFAULT NULL::incendies.geometry)
 RETURNS incendies.geometry
 LANGUAGE sql
 IMMUTABLE PARALLEL SAFE
AS $function$ SELECT incendies._ST_Voronoi(g1, extend_to, tolerance, true) $function$
;

-- DROP FUNCTION incendies.st_within(incendies.geometry, incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_within(geom1 incendies.geometry, geom2 incendies.geometry)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 5000 SUPPORT incendies.postgis_index_supportfn
AS '$libdir/postgis-3', $function$within$function$
;

-- DROP FUNCTION incendies.st_wkbtosql(bytea);

CREATE OR REPLACE FUNCTION incendies.st_wkbtosql(wkb bytea)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_from_WKB$function$
;

-- DROP FUNCTION incendies.st_wkttosql(text);

CREATE OR REPLACE FUNCTION incendies.st_wkttosql(text)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 250
AS '$libdir/postgis-3', $function$LWGEOM_from_text$function$
;

-- DROP FUNCTION incendies.st_wrapx(incendies.geometry, float8, float8);

CREATE OR REPLACE FUNCTION incendies.st_wrapx(geom incendies.geometry, wrap double precision, move double precision)
 RETURNS incendies.geometry
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$ST_WrapX$function$
;

-- DROP FUNCTION incendies.st_x(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_x(incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_x_point$function$
;

-- DROP FUNCTION incendies.st_xmax(incendies.box3d);

CREATE OR REPLACE FUNCTION incendies.st_xmax(incendies.box3d)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$BOX3D_xmax$function$
;

-- DROP FUNCTION incendies.st_xmin(incendies.box3d);

CREATE OR REPLACE FUNCTION incendies.st_xmin(incendies.box3d)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$BOX3D_xmin$function$
;

-- DROP FUNCTION incendies.st_y(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_y(incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_y_point$function$
;

-- DROP FUNCTION incendies.st_ymax(incendies.box3d);

CREATE OR REPLACE FUNCTION incendies.st_ymax(incendies.box3d)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$BOX3D_ymax$function$
;

-- DROP FUNCTION incendies.st_ymin(incendies.box3d);

CREATE OR REPLACE FUNCTION incendies.st_ymin(incendies.box3d)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$BOX3D_ymin$function$
;

-- DROP FUNCTION incendies.st_z(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_z(incendies.geometry)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_z_point$function$
;

-- DROP FUNCTION incendies.st_zmax(incendies.box3d);

CREATE OR REPLACE FUNCTION incendies.st_zmax(incendies.box3d)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$BOX3D_zmax$function$
;

-- DROP FUNCTION incendies.st_zmflag(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.st_zmflag(incendies.geometry)
 RETURNS smallint
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$LWGEOM_zmflag$function$
;

-- DROP FUNCTION incendies.st_zmin(incendies.box3d);

CREATE OR REPLACE FUNCTION incendies.st_zmin(incendies.box3d)
 RETURNS double precision
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/postgis-3', $function$BOX3D_zmin$function$
;

-- DROP FUNCTION incendies."text"(incendies.geometry);

CREATE OR REPLACE FUNCTION incendies.text(incendies.geometry)
 RETURNS text
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT COST 50
AS '$libdir/postgis-3', $function$LWGEOM_to_text$function$
;

-- DROP FUNCTION incendies.updategeometrysrid(varchar, varchar, varchar, varchar, int4);

CREATE OR REPLACE FUNCTION incendies.updategeometrysrid(catalogn_name character varying, schema_name character varying, table_name character varying, column_name character varying, new_srid_in integer)
 RETURNS text
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
	myrec RECORD;
	okay boolean;
	cname varchar;
	real_schema name;
	unknown_srid integer;
	new_srid integer := new_srid_in;

BEGIN

	-- Find, check or fix schema_name
	IF ( schema_name != '' ) THEN
		okay = false;

		FOR myrec IN SELECT nspname FROM pg_namespace WHERE text(nspname) = schema_name LOOP
			okay := true;
		END LOOP;

		IF ( okay <> true ) THEN
			RAISE EXCEPTION 'Invalid schema name';
		ELSE
			real_schema = schema_name;
		END IF;
	ELSE
		SELECT INTO real_schema current_schema()::text;
	END IF;

	-- Ensure that column_name is in geometry_columns
	okay = false;
	FOR myrec IN SELECT type, coord_dimension FROM incendies.geometry_columns WHERE f_table_schema = text(real_schema) and f_table_name = table_name and f_geometry_column = column_name LOOP
		okay := true;
	END LOOP;
	IF (NOT okay) THEN
		RAISE EXCEPTION 'column not found in geometry_columns table';
		RETURN false;
	END IF;

	-- Ensure that new_srid is valid
	IF ( new_srid > 0 ) THEN
		IF ( SELECT count(*) = 0 from incendies.spatial_ref_sys where srid = new_srid ) THEN
			RAISE EXCEPTION 'invalid SRID: % not found in spatial_ref_sys', new_srid;
			RETURN false;
		END IF;
	ELSE
		unknown_srid := incendies.ST_SRID('POINT EMPTY'::incendies.geometry);
		IF ( new_srid != unknown_srid ) THEN
			new_srid := unknown_srid;
			RAISE NOTICE 'SRID value % converted to the officially unknown SRID value %', new_srid_in, new_srid;
		END IF;
	END IF;

	IF postgis_constraint_srid(real_schema, table_name, column_name) IS NOT NULL THEN
	-- srid was enforced with constraints before, keep it that way.
		-- Make up constraint name
		cname = 'enforce_srid_'  || column_name;

		-- Drop enforce_srid constraint
		EXECUTE 'ALTER TABLE ' || quote_ident(real_schema) ||
			'.' || quote_ident(table_name) ||
			' DROP constraint ' || quote_ident(cname);

		-- Update geometries SRID
		EXECUTE 'UPDATE ' || quote_ident(real_schema) ||
			'.' || quote_ident(table_name) ||
			' SET ' || quote_ident(column_name) ||
			' = incendies.ST_SetSRID(' || quote_ident(column_name) ||
			', ' || new_srid::text || ')';

		-- Reset enforce_srid constraint
		EXECUTE 'ALTER TABLE ' || quote_ident(real_schema) ||
			'.' || quote_ident(table_name) ||
			' ADD constraint ' || quote_ident(cname) ||
			' CHECK (st_srid(' || quote_ident(column_name) ||
			') = ' || new_srid::text || ')';
	ELSE
		-- We will use typmod to enforce if no srid constraints
		-- We are using postgis_type_name to lookup the new name
		-- (in case Paul changes his mind and flips geometry_columns to return old upper case name)
		EXECUTE 'ALTER TABLE ' || quote_ident(real_schema) || '.' || quote_ident(table_name) ||
		' ALTER COLUMN ' || quote_ident(column_name) || ' TYPE  geometry(' || incendies.postgis_type_name(myrec.type, myrec.coord_dimension, true) || ', ' || new_srid::text || ') USING incendies.ST_SetSRID(' || quote_ident(column_name) || ',' || new_srid::text || ');' ;
	END IF;

	RETURN real_schema || '.' || table_name || '.' || column_name ||' SRID changed to ' || new_srid::text;

END;
$function$
;

-- DROP FUNCTION incendies.updategeometrysrid(varchar, varchar, int4);

CREATE OR REPLACE FUNCTION incendies.updategeometrysrid(character varying, character varying, integer)
 RETURNS text
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
	ret  text;
BEGIN
	SELECT incendies.UpdateGeometrySRID('','',$1,$2,$3) into ret;
	RETURN ret;
END;
$function$
;

-- DROP FUNCTION incendies.updategeometrysrid(varchar, varchar, varchar, int4);

CREATE OR REPLACE FUNCTION incendies.updategeometrysrid(character varying, character varying, character varying, integer)
 RETURNS text
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
	ret  text;
BEGIN
	SELECT incendies.UpdateGeometrySRID('',$1,$2,$3,$4) into ret;
	RETURN ret;
END;
$function$
;
