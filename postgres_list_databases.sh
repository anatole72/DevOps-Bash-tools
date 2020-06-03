#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2020-03-12 16:40:27 +0000 (Thu, 12 Mar 2020)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

# Lists all PostgreSQL databases using adjacent psql.sh script
#
# FILTER environment variable will restrict to matching databases (if giving <db>.<table>, matches up to the first dot)
#
# Tested on AWS RDS PostgreSQL 9.5.15

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(dirname "$0")"

"$srcdir/psql.sh" -q -t -c 'SELECT DISTINCT(table_catalog) FROM information_schema.tables ORDER BY table_catalog;' "$@" |
sed 's/^[[:space:]]*//; s/[[:space:]]*$//; /^[[:space:]]*$/d' |
while read -r db; do
    if [ -n "${FILTER:-}" ] &&
       ! [[ "$db" =~ ${FILTER%%.*} ]]; then
        continue
    fi
    printf '%s\n' "$db"
done
