#!/usr/bin/env bats

consul_service="consul"

@test "Check consul is up and running" {
  test $(bc <<< "$VERSION >= 3.5") -eq 0 && skip "Consul not installed in this version"

  # Check Consul is reachable
  run curl http://${consul_service}:8500/v1/catalog/service/consul
  [ "$status" -eq 0 ]
}

@test "Check consul agent service has joined consul server container" {
   test $(bc <<< "$VERSION >= 3.5") -eq 0 && skip "Consul not installed in this version"

   # Sleep to prevent race conditions
   sleep 2

   # Check consul service has joined consul server container
   status="$(cat /var/log/s6-uncaught-logs/current  | grep 'adding server' 2>&1 > /dev/null; echo $?)"
   [ "$status" -eq 0 ]
}
