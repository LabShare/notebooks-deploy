# Configuration file for Jupyter Hub

c = get_config()

c.JupyterHub.log_level = 10

import os
from oauthenticator.generic import LocalGenericOAuthenticator

OAUTH_CLIENT_ID = os.getenv('OAUTH_CLIENT_ID')
OAUTH_CLIENT_SECRET = os.getenv('OAUTH_CLIENT_SECRET')
AUTH_URL = os.getenv('AUTH_URL')
ADMIN_USERS = os.getenv('ADMIN_USERS')

c.JupyterHub.authenticator_class = LocalGenericOAuthenticator

c.Authenticator.admin_users = set(ADMIN_USERS.split(';'))

c.LocalGenericOAuthenticator.client_id = OAUTH_CLIENT_ID
c.LocalGenericOAuthenticator.client_secret = OAUTH_CLIENT_SECRET
c.LocalGenericOAuthenticator.userdata_url = "{0}/auth/me".format(AUTH_URL)
c.LocalGenericOAuthenticator.username_key = "email"
c.LocalGenericOAuthenticator.userdata_method = "GET"
c.LocalGenericOAuthenticator.extra_params = dict(client_id=OAUTH_CLIENT_ID, client_secret=OAUTH_CLIENT_SECRET)
c.LocalGenericOAuthenticator.basic_auth = False
c.LocalGenericOAuthenticator.create_system_users = True
c.LocalGenericOAuthenticator.add_user_cmd = ['adduser', '-q', '--gecos', '""', '--disabled-password', '--force-badname']

# Add SSL key and cert
c.JupyterHub.ssl_key = '/srv/oauthenticator/ssl/ssl.key'
c.JupyterHub.ssl_cert = '/srv/oauthenticator/ssl/ssl.cert'

# For local testing
c.LocalGenericOAuthenticator.tls_verify = False