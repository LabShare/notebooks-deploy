# Designed to be run as
#
# docker run -it -p 8000:8000 jupyterhub/oauthenticator

FROM jupyterhub/jupyterhub

# Install oauthenticator from git
RUN python3 -m pip install jupyter git+https://github.com/labshare/oauthenticator.git

# Create oauthenticator directory and put necessary files in it
RUN mkdir /srv/oauthenticator
WORKDIR /srv/oauthenticator
ENV OAUTHENTICATOR_DIR /srv/oauthenticator

ADD jupyterhub_config.py jupyterhub_config.py

ADD ssl /srv/oauthenticator/ssl
RUN chmod 700 /srv/oauthenticator
