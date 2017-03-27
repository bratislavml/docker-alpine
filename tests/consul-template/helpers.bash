#!/usr/bin/env bash

function require_env {
    if [[ -z ${!1} ]]; then
        errecho "This test requires the $1 environment variable to be set in order to run."
        exit 1
    fi
}

function register_service {
    require_env CONSUL_ADDRESS
    service=$1
    tag=$2
    local payload=$(curl -s http://${CONSUL_ADDRESS}/v1/catalog/service/consul | jq -r '.[] | {  address: .Address, port:.ServicePort}')
    address=$(echo ${payload} | jq -r '.address')

body=$(cat << EOF
{
  "Datacenter": "dc1",
  "Node": "node-$service",
  "Address": "$address",
  "Service": {
    "ID": "$service",
    "Service": "$service",
    "Address": "$address",
    "Port": 8500,
    "Tags": ["$tag"]
  },
  "Check": {
    "Node": "node-$service",
    "CheckID": "service:$service",
    "Name": "Health check for service $service",
    "Notes": "Script based health check",
    "Status": "passing",
    "ServiceID": "$service"
  }
}
EOF
)
    echo "Registering service '$service' (Address : $address, Port: 8500, Tag: $tag)"
    curl -H 'Content-Type: application/json' -XPUT -d "${body}" http://${CONSUL_ADDRESS}/v1/catalog/register
}

function register_key {
    require_env CONSUL_ADDRESS

    key=$1
    value=$2

    echo "Registering key '$key'"
    curl -s -H 'Content-Type: application/json' -XPUT -d "${value}" "http://${CONSUL_ADDRESS}/v1/kv/$key"  > /dev/null
}

function random_ip {
    echo $(dd if=/dev/urandom bs=4 count=1 2>/dev/null | od -An -tu1 | sed -e 's/^ *//' -e 's/  */./g')
}

function random_port {
    echo $(shuf -i30000-50000 -n1)
}
