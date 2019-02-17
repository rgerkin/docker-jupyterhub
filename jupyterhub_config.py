# jupyterhub_config.py
c = get_config()

import os
pjoin = os.path.join

runtime_dir = os.path.join('/etc/jupyterhub')

# Change from Jupyter Notebook to JupyterLab
c.Spawner.default_url = '/lab'
c.Spawner.debug = True

# Redirect HTTP requests on port 80 to the server on HTTPS
c.ConfigurableHTTPProxy.command = ['configurable-http-proxy', '--redirect-port', '8000']

c.JupyterHub.ssl_key = pjoin(runtime_dir,'my.key')
c.JupyterHub.ssl_cert = pjoin(runtime_dir,'my.cert')
c.JupyterHub.cookie_secret_file = pjoin(runtime_dir, 'cookie_secret')
c.JupyterHub.db_url = pjoin(runtime_dir, 'jupyterhub.sqlite')
c.JupyterHub.extra_log_file = pjoin(runtime_dir, 'jupyterhub.log')

# Administrators - set of users who can administer the Hub itself
from oauthenticator.github import LocalGitHubOAuthenticator
c.JupyterHub.authenticator_class = LocalGitHubOAuthenticator
a = c.LocalGitHubOAuthenticator

import json
dirname = os.path.dirname(__file__)
settings_path = pjoin(dirname, 'jupyterhub_config_private.json')
with open(settings_path, 'r') as f:
  s = json.load(f)
a.oauth_callback_url = '%s:%d/hub/oauth_callback' % (s['url'], s['port'])
a.client_id = s['client_id']
a.client_secret = s['client_secret']
a.create_system_users = True
a.admin_users = s['admin_users']
a.whitelist = s['white_list']
