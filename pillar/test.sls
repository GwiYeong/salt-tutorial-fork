test_stage_fork:
  env_test: {{ saltenv }}
  tttt: ttt

include:
  - nhnent:
      defaults:
        value: default
        nhnent: default_nhnent
      key: de
  - default:
      defaults:
        value: default
        nhnent: default_nhnent
      key: dete