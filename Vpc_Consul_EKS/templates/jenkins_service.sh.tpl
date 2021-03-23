#!/usr/bin/env bash
set -xe

tee /etc/consul.d/jenkins-8080.json > /dev/null <<"EOF"
{
  "service": {
    "id": "jenkins-8080",
    "name": "jenkins",
    "tags": ["jenkins"],
    "port": 8080,
    "checks": [
      {
        "id": "tcp",
        "name": "TCP on port 8080",
        "tcp": "localhost:8080",
        "interval": "10s",
        "timeout": "1s"
      },
      {
        "id": "http",
        "name": "HTTP on port 8080",
        "http": "http://localhost:8080/",
        "interval": "30s",
        "timeout": "1s"
      },
      {
        "id": "service",
        "name": "jenkins service",
        "args": ["systemctl", "status", "jenkins"],
        "interval": "60s"
      }
    ]
  }
}
EOF

consul reload