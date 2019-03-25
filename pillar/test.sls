test_stage_fork:
  env_test: {{ saltenv }}
  tttt: ttt

include:
  - nhnent:
      defaults:
        de: default
        nhnent: default_nhnent
      key: de