import hashlib
import pwd
import sqlite3

connection = sqlite3.connect('jupyterhub.sqlite')
results = connection.execute('SELECT name FROM users')
names = [x[0] for x in results]
uids = {}

for name in names:
    try:
        uid = pwd.getpwnam(name).pw_uid
    except KeyError:
        uid = int(hashlib.sha1(name.encode()).hexdigest(), 16) % (10 ** 8)
    uids[name] = uid
