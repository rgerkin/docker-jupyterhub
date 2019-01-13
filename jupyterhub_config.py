# jupyterhub_config.py
c = get_config()

# Change from JupyterHub to JupyterLab
c.Spawner.default_url = '/lab'
c.Spawner.debug = True

# Administrators - set of users who can administer the Hub itself
#
from oauthenticator.github import LocalGitHubOAuthenticator
c.JupyterHub.authenticator_class = LocalGitHubOAuthenticator
a = c.LocalGitHubOAuthenticator

from .jupyterhub_config_private import url, port, client_id, client_secret, admin_users, white_list
a.oauth_callback_url = '%s:%d/hub/oauth_callback' % (url, port)
a.client_id = client_id
a.client_secret = client_secret
a.create_system_users = True
a.admin_users = admin_users
a.whitelist = white_list
