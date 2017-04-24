@test "environment variable 'NPROC' is set" {
  run test -n "${NPROC}"
  [ $status -eq 0 ]
}

@test "environment variable 'CONSUL_ADDRESS' is set" {
  run test -n "${CONSUL_ADDRESS}"
  [ $status -eq 0 ]
}

@test "environment variable 'CONSUL_SERF_ADDRESS' is set" {
  run test -n "${CONSUL_SERF_ADDRESS}"
  [ $status -eq 0 ]
}
