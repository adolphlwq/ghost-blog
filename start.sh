#! /bin/sh
set -ex
cd versions/${GHOST_VERSION}
if [ ! -f "$GHOST_INSTALL/current/content/data/ghost.db" ];then
    knex-migrator init
else
    knex-migrator migrate
fi
node index.js
