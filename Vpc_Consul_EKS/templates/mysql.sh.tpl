#!/usr/bin/env bash
set -e

tee /etc/consul.d/mysql-3306.json > /dev/null <<"EOF"
{
  "service": {
    "id": "mysql-3306",
    "name": "mysql",
    "tags": ["mysql"],
    "port": 3306,
    "checks": [

         {
        "id": "service",
        "name": "mysql service",
        "args": ["systemctl", "status", "mysql"],
        "interval": "60s"
      }

    ]
  }
}
EOF

consul reload
