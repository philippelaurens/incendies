
--
-- localisation
--

SET search_path TO incendies, public;

CREATE TABLE localisation (
    id_localisation SERIAL PRIMARY KEY,
    longitude DECIMAL(9,6),
    latitude DECIMAL(9,6)
);

CREATE INDEX idx_localisation_longitude ON localisation (longitude);
CREATE INDEX idx_localisation_latitude ON localisation (latitude);

CREATE TABLE type_cluster (
    id SMALLSERIAL PRIMARY KEY,
    nom VARCHAR(32)
);

CREATE TABLE cluster (
    id_localisation INT NOT NULL,
    date_experiment TIMESTAMP NOT NULL,
    cluster_id INT NOT NULL,
    type_cluster SMALLINT NOT NULL,
    PRIMARY KEY (id_localisation, date_experiment),
    CONSTRAINT fk_cluster_id_localisation FOREIGN KEY (id_localisation) REFERENCES localisation (id_localisation),
    CONSTRAINT fk_cluster_type_cluster FOREIGN KEY (type_cluster) REFERENCES type_cluster (id)
);

CREATE INDEX fk_cluster_type_cluster ON cluster (type_cluster);


--
-- commune
--

CREATE TABLE departement (
    code VARCHAR(10) NOT NULL,
    nom VARCHAR(100),
    PRIMARY KEY (code)
);

CREATE TABLE region (
    id SMALLSERIAL PRIMARY KEY,
    code SMALLINT,
    nom VARCHAR(32)
);

CREATE TABLE commune (
    id_commune SERIAL PRIMARY KEY,
    code_insee VARCHAR(10),
    localisation INT NOT NULL,
    nom_standard VARCHAR(100),
    region SMALLINT,
    departement VARCHAR(10),
    population INT,
    superficie_hectare INT,
    densite DECIMAL(10,2),
    altitude_moyenne SMALLINT,
    altitude_minimale SMALLINT,
    altitude_maximale SMALLINT,
    CONSTRAINT fk_commune_departement FOREIGN KEY (departement) REFERENCES departement (code),
    CONSTRAINT fk_commune_localisation FOREIGN KEY (localisation) REFERENCES localisation (id_localisation),
    CONSTRAINT fk_commune_region FOREIGN KEY (region) REFERENCES region (id)
);

CREATE INDEX fk_commune_localisation ON commune (localisation);
CREATE INDEX fk_commune_region ON commune (region);
CREATE INDEX fk_commune_departement ON commune (departement);


--
-- incendie
--

CREATE TABLE precision_surface (
    id SMALLSERIAL PRIMARY KEY,
    nom VARCHAR(32)
);

CREATE TABLE type_peuplement (
    id SMALLSERIAL PRIMARY KEY,
    nom VARCHAR(32)
);

CREATE TABLE nature (
    id SMALLSERIAL PRIMARY KEY,
    nom VARCHAR(32)
);

CREATE TABLE incendie (
    id_incendie SERIAL PRIMARY KEY,
    localisation INT NOT NULL,
    code_insee VARCHAR(10) NOT NULL,
    date_premiere_alerte TIMESTAMP NOT NULL,
    annee INT NOT NULL,
    surface_parcourue INT NOT NULL,
    surface_foret INT,
    surface_maquis_garrigues INT,
    autres_surfaces_naturelles INT,
    surfaces_agricoles INT,
    autres_surfaces INT,
    surface_autres_terres_boisees INT,
    surfaces_non_boisees_naturelles INT,
    surfaces_non_boisees_artificialisees INT,
    surfaces_non_boisees INT,
    precision_surface SMALLINT NOT NULL,
    type_peuplement SMALLINT NOT NULL,
    nature SMALLINT NOT NULL,
    CONSTRAINT fk_incendie_localisation FOREIGN KEY (localisation) REFERENCES localisation (id_localisation),
    CONSTRAINT fk_incendie_nature FOREIGN KEY (nature) REFERENCES nature (id),
    CONSTRAINT fk_incendie_precision_surface FOREIGN KEY (precision_surface) REFERENCES precision_surface (id),
    CONSTRAINT fk_incendie_type_peuplement FOREIGN KEY (type_peuplement) REFERENCES type_peuplement (id)
);

CREATE INDEX fk_incendie_localisation ON incendie (localisation);
CREATE INDEX fk_incendie_precision_surface ON incendie (precision_surface);
CREATE INDEX fk_incendie_type_peuplement ON incendie (type_peuplement);
CREATE INDEX fk_incendie_nature ON incendie (nature);


--
-- affecte
--

CREATE TABLE affecte (
    id_commune INT NOT NULL,
    id_incendie INT NOT NULL,
    date_impact TIMESTAMP NOT NULL,
    degre_impact VARCHAR(50),
    PRIMARY KEY (id_commune, id_incendie, date_impact),
    CONSTRAINT fk_affecte_id_commune FOREIGN KEY (id_commune) REFERENCES commune (id_commune),
    CONSTRAINT fk_affecte_id_incendie FOREIGN KEY (id_incendie) REFERENCES incendie (id_incendie)
);

CREATE INDEX fk_affecte_id_incendie ON affecte (id_incendie);


--
-- temporaire
--

CREATE TABLE tmp_commune (
    code_insee VARCHAR(10) NOT NULL,
    nom_standard VARCHAR(100) NOT NULL,
    nom_sans_pronom VARCHAR(100) NOT NULL,
    nom_a VARCHAR(100) NOT NULL,
    nom_de VARCHAR(100) NOT NULL,
    nom_sans_accent VARCHAR(100) NOT NULL,
    nom_standard_majuscule VARCHAR(100) NOT NULL,
    typecom VARCHAR(10) NOT NULL,
    typecom_texte VARCHAR(50) NOT NULL,
    reg_code SMALLINT NOT NULL,
    reg_nom VARCHAR(100) NOT NULL,
    dep_code VARCHAR(10) NOT NULL,
    dep_nom VARCHAR(100) NOT NULL,
    canton_code VARCHAR(10),
    canton_nom VARCHAR(100),
    epci_code VARCHAR(20),
    epci_nom VARCHAR(150),
    academie_code SMALLINT NOT NULL,
    academie_nom VARCHAR(100) NOT NULL,
    code_postal VARCHAR(10),
    codes_postaux VARCHAR(200),
    zone_emploi INT,
    code_insee_centre_zone_emploi VARCHAR(10),
    code_unite_urbaine VARCHAR(10),
    nom_unite_urbaine VARCHAR(100),
    taille_unite_urbaine SMALLINT,
    type_commune_unite_urbaine VARCHAR(50),
    statut_commune_unite_urbaine VARCHAR(50),
    population INT NOT NULL,
    superficie_hectare INT NOT NULL,
    superficie_km2 INT NOT NULL,
    densite DECIMAL(10,2),
    altitude_moyenne SMALLINT NOT NULL,
    altitude_minimale SMALLINT NOT NULL,
    altitude_maximale SMALLINT NOT NULL,
    latitude_mairie DECIMAL(9,6) NOT NULL,
    longitude_mairie DECIMAL(9,6) NOT NULL,
    latitude_centre DECIMAL(9,6),
    longitude_centre DECIMAL(9,6),
    grille_densite SMALLINT NOT NULL,
    grille_densite_texte VARCHAR(50) NOT NULL,
    niveau_equipements_services SMALLINT,
    niveau_equipements_services_texte VARCHAR(100),
    gentile VARCHAR(100),
    url_wikipedia VARCHAR(255),
    url_villedereve VARCHAR(255) NOT NULL
);

CREATE INDEX idx_tmp_commune_code_insee ON tmp_commune (code_insee);
CREATE INDEX idx_tmp_commune_longitude_mairie ON tmp_commune (longitude_mairie);
CREATE INDEX idx_tmp_commune_latitude_mairie ON tmp_commune (latitude_mairie);

CREATE TABLE tmp_incendie (
    annee INT NOT NULL,
    numero INT NOT NULL,
    departement VARCHAR(10) NOT NULL,
    insee VARCHAR(10) NOT NULL,
    nom_commune VARCHAR(150),
    date_premiere_alerte VARCHAR(30) NOT NULL,
    surface_parcourue BIGINT NOT NULL,
    surface_foret DECIMAL(15,2),
    surface_maquis_garrigues DECIMAL(15,2),
    autres_surfaces_naturelles DECIMAL(15,2),
    surfaces_agricoles DECIMAL(15,2),
    autres_surfaces DECIMAL(15,2),
    surface_autres_terres_boisees DECIMAL(15,2),
    surfaces_non_boisees_naturelles DECIMAL(15,2),
    surfaces_non_boisees_artificialisees DECIMAL(15,2),
    surfaces_non_boisees DECIMAL(15,2),
    precision_surfaces VARCHAR(100),
    type_peuplement REAL,
    nature VARCHAR(100),
    deces_batimentstouches VARCHAR(100),
    nombre_deces SMALLINT,
    nombre_batiments_totalement_detruits SMALLINT,
    nombre_batiments_partiellement_detruits SMALLINT,
    precision_donnee VARCHAR(200)
);

CREATE INDEX idx_tmp_incendie_insee ON tmp_incendie (insee);
CREATE INDEX idx_tmp_incendie_nature ON tmp_incendie (nature);
CREATE INDEX idx_tmp_incendie_type_peuplement ON tmp_incendie (type_peuplement);
CREATE INDEX idx_tmp_incendie_precision_surfaces ON tmp_incendie (precision_surfaces)



