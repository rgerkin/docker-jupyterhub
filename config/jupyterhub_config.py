# jupyterhub_config.py
import json
import os
from oauthenticator.github import LocalGitHubOAuthenticator

HERE = os.path.dirname(__file__)
pjoin = os.path.join
runtime_dir = os.path.join('/etc/jupyterhub')

# Current configuration
c = get_config()

# Change from Jupyter Notebook to JupyterLab
c.Spawner.default_url = '/lab'

# Debug
c.Spawner.debug = True

# How often to cull idle servers
c.Spawner.args = ['--MappingKernelManager.cull_idle_timeout=604800', '--MappingKernelManager.cull_interval=300']

# Get security info
c.JupyterHub.ssl_key = pjoin(runtime_dir,'my.key')
c.JupyterHub.ssl_cert = pjoin(runtime_dir,'my.cert')
c.JupyterHub.cookie_secret_file = pjoin(runtime_dir, 'cookie_secret')

# Location of the JupyterHub database (containing users)
c.JupyterHub.db_url = pjoin(runtime_dir, 'jupyterhub.sqlite')

# Location of the log file
c.JupyterHub.extra_log_file = pjoin(runtime_dir, 'jupyterhub.log')

# Administrators - set of users who can administer the Hub itself
c.JupyterHub.authenticator_class = LocalGitHubOAuthenticator
a = c.LocalGitHubOAuthenticator

# Locate and open the (private) settings file
settings_path = pjoin(HERE, 'jupyterhub_config_private.json')
with open(settings_path, 'r') as f:
  s = json.load(f)

a.oauth_callback_url = '%s:%d/hub/oauth_callback' % (s['url'], s['port'])
a.client_id = s['client_id']
a.client_secret = s['client_secret']
a.create_system_users = True
a.admin_users = s['admin_users']
a.whitelist = s['white_list']
a.uids = s['uids']
