# Configuration file for Jupyter Hub

c = get_config()

c.JupyterHub.log_level = 10

import os
from oauthenticator.generic import GenericOAuthenticator

OAUTH_CLIENT_ID = os.getenv('OAUTH_CLIENT_ID')
OAUTH_CLIENT_SECRET = os.getenv('OAUTH_CLIENT_SECRET')
OAUTH_CALLBACK_URL = os.getenv('OAUTH_CALLBACK_URL')

ORGANIZATION = os.getenv('ORGANIZATION')  # LabShare Auth tenant
AUTH_URL = os.getenv('AUTH_URL')          # URL of the LabShare Auth instance

# Add SSL key and cert
#c.JupyterHub.ssl_key = '/srv/oauthenticator/ssl/ssl.key'
#c.JupyterHub.ssl_cert = '/srv/oauthenticator/ssl/ssl.cert'

c.JupyterHub.authenticator_class = GenericOAuthenticator

c.GenericOAuthenticator.oauth_callback_url=OAUTH_CALLBACK_URL
c.GenericOAuthenticator.client_id = OAUTH_CLIENT_ID
c.GenericOAuthenticator.client_secret = OAUTH_CLIENT_SECRET
c.GenericOAuthenticator.userdata_url = "{0}/auth/me".format(AUTH_URL)
c.GenericOAuthenticator.username_key = "email"
c.GenericOAuthenticator.username_method = "GET"
c.GenericOAuthenticator.extra_params = dict(client_id=OAUTH_CLIENT_ID, client_secret=OAUTH_CLIENT_SECRET)
c.GenericOAuthenticator.basic_auth = False

# For local testing
#c.GenericOAuthenticator.tls_verify = False