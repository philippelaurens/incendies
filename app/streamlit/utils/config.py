MAP_CENTER = [46.5, 2.5]
MAP_ZOOM = 6

SEASONS = {
    "Hiver": (12, 1, 2),
    "Printemps": (3, 4, 5),
    "Été": (6, 7, 8),
    "Automne": (9, 10, 11),
    }

VEGETATION_FILTERS = {
    "Forêt": "COALESCE(i.surface_foret, 0) > 0",
    "Maquis / garrigue": "COALESCE(i.surface_maquis_garrigues, 0) > 0",
    "Autres milieux naturels": "COALESCE(i.autres_surfaces_naturelles, 0) > 0",
}
ORIGIN_FILTERS = {
    "Naturelle": "n.nom ILIKE 'Naturelle%'",
    "Accidentelle": "(n.nom ILIKE 'Accidentelle%' OR n.nom ILIKE 'Involontaire%')",
    "Malveillante": "n.nom ILIKE 'Malveillance%'",
}

MONTH_NAMES = ["Jan","Fev","Mar","Avr","Mai","Juin","Juil","Aout","Sep","Oct","Nov","Dec"]
AVAILABLE_YEARS = [y for y in range(2006, 2026)]

# Paramétrage de l'affichage des cartes
FIRE_GRADIENT = {
    # Orange clair (faible densité)
    0.2: '#ffaa00',
    # Orange vif (densité moyenne)
    0.5: '#ff5500',
    # Violet / Pourpre (forte densité)
    0.8: '#9900cc',
    # Violet très foncé / Indigo (très forte densité)
    1.0: '#4b0082'
    }

HEATMAP_CONFIG = {
     'radius': 10,
     'blur': 5,
     # Conserve la visibilité des points au zoom
     'min_opacity': 0.85,
     # Maintient l'intensité jusqu'au zoom maximal
     'max_zoom': 18,
     'gradient': FIRE_GRADIENT
    }

TILES_SERVER = {
    "OpenStreetMap": {
        'tiles' : 'OpenStreetMap',
        'attr': None
    },
    'Esri Satellite': {
        'tiles' : 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
        'attr': 'Esri World imagery'
    },
    'CartDB Voyager': {
        'tiles' : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
        'attr': 'CARTO'
    },
    'OpenTopoMap': {
        'tiles' : 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
        'attr': 'OpenTopoMap'
    }
}

MAP_TITLE_TEMPLATE ="""
<div style="
    position: fixed;
    top: 12px;
    left: 60px;
    z-index: 9999;
    font-family: 'Helvetica Neue', Arial, sans-serif;
    font-size: 16px;
    font-weight: 700;
    color: darkorange;
    background-color: rgba(255, 255, 255, 0.85);
    padding: 8px 14px;
    border-radius: 6px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.2);
    border: 1px solid #cccccc;
">
    {title}
</div>
"""