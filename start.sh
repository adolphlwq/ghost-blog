#! /bin/sh
set -ex
cd versions/${GHOST_VERSION}
knex-migrator init
node index.js
