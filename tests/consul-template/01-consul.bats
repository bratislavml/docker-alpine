#!/usr/bin/env bats

consul_service="consul"

@test "Check consul is up and running" {
  # Check Consul is reachable
  run curl http://${consul_service}:8500/v1/catalog/service/consul
  [ "$status" -eq 0 ]
}