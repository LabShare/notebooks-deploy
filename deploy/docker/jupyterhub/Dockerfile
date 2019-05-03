FROM jupyterhub/jupyterhub:0.9.4

# Track semantic versioning
COPY VERSION /

# Install dockerspawner, oauth, postgres
RUN /opt/conda/bin/conda install -yq psycopg2=2.7 && \
    /opt/conda/bin/conda clean -tipsy && \
    /opt/conda/bin/pip install --no-cache-dir \
        oauthenticator==0.7.* \
        jupyterhub-dummyauthenticator==0.3.* \
        dockerspawner==0.9.* \
        jupyterhub-kubespawner==0.10.*

CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]
