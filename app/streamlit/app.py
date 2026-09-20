import streamlit as st

pg = st.navigation([
    st.Page("accueil.py", title="Accueil", default=True),
    # st.Page("pages/commune.py", title="Détail commune"),
])
pg.run()