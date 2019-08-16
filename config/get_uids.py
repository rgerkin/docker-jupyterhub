import json
import os
import pwd
import sqlite3

HERE = os.path.dirname(os.path.realpath(__file__))
everyone = pwd.getpwall()
uids = {}

# Only get UIDs for users with a UID >= 1000
uids = {person.pw_name: person.pw_uid for person in everyone if person.pw_uid >= 1000}

# Write this to the settings file
SETTINGS_PATH = os.path.join(HERE, 'jupyterhub_config_private.json')
with open(SETTINGS_PATH, 'r+') as f:
    s = json.load(f)
    s['uids'] = uids
    f.seek(0)
    json.dump(s, f)
    f.truncate()
