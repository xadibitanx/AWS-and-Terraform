#!/usr/bin/env bash
set -xe

tee /etc/consul.d/jenkins-node-22.json > /dev/null <<"EOF"
{
  "service": {
    "id": "jenkins-node-22",
    "name": "jenkins-slaves",
    "tags": ["jenkins-slaves"],
    "port": 22,
    "checks": [
      {
        "id": "tcp",
        "name": "TCP on port 22",
        "tcp": "localhost:22",
        "interval": "10s",
        "timeout": "1s"
      }
    ]
  }
}
EOF

consul reload