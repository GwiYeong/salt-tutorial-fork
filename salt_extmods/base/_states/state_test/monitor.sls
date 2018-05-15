write_to_file:
    schedule.present:
      - function: cmd.run_all
      - seconds: 5
      - job_args:
          - echo "{{grains['id']}}" >> /tmp/scheduled_writing; whoami >> /tmp/scheduled_writing
      - job_kwargs:
          runas: test
          shell: /bin/bash
