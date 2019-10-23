FROM jupyterhub/jupyterhub:1.0.0

# Track semantic versioning
COPY VERSION /

# Install dockerspawner, oauth, postgres
RUN /opt/conda/bin/conda install -yq psycopg2=2.7 && \
    /opt/conda/bin/conda clean -tipsy && \
    /opt/conda/bin/pip install --no-cache-dir \
        git+https://github.com/labshare/oauthenticator.git \
        git+https://github.com/AnotherCodeArtist/kubespawner.git

CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]
