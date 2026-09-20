import folium

def site_popup(nom, valeur, unite=""):
    html = f"""
    <div style="
        font-family: 'Segoe UI', system-ui, sans-serif;
        min-width: 180px;
        padding: 10px 12px;
    ">
      <div style="
          font-size: 11px;
          letter-spacing: .08em;
          text-transform: uppercase;
          color: #8a8a8a;
          margin-bottom: 4px;
      ">Site</div>
      <div style="
          font-size: 10px;
          font-weight: 650;
          margin-bottom: 8px;
      ">{nom}</div>
      <div style="
          border-top: 1px solid #eee;
          padding-top: 8px;
          display: flex;
          align-items: baseline;
          gap: 8px;
      ">
        <span style="font-size: 12px; font-weight: 700; color: #c1121f;">
          {valeur}
        </span>
        <span style="font-size: 12px; color: #666;">{unite}</span>
      </div>
    </div>
    """
    return folium.Popup(html, max_width=260)
