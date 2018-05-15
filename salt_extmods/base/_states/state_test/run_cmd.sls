integration_with_pillar:
  cmd.run:
    - name: echo '{{ pillar['pkgs']['apache'] }}'
