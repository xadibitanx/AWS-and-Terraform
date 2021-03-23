#!/usr/bin/env bash
set -e

tee /etc/consul.d/Prometheus-9090.json > /dev/null <<"EOF"
{
  "service": {
    "id": "Prometheus-9090",
    "name": "Prometheus",
    "tags": ["Prometheus"],
    "port": 8080,
    "checks": [
      {
        "id": "tcp",
        "name": "TCP on port 9090",
        "tcp": "localhost:9090",
        "interval": "10s",
        "timeout": "1s"
      },
      {
        "id": "http",
        "name": "HTTP on port 9090",
        "http": "http://localhost:9090/",
        "interval": "30s",
        "timeout": "1s"
      }
    ]
  }
}
EOF

consul reload
