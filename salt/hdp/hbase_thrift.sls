{% set thrift_port = pillar['hbase-thrift']['port'] %}
{% set info_port = pillar['hbase-thrift']['info-port'] %}

{% if grains['os'] == 'Ubuntu' and grains['osrelease_info'][0] <= 14 %}
/etc/init/hbase-thrift.conf:
  file.managed:
    - source: salt://hdp/templates/hbase-daemon.conf.tpl
{% elif grains['os'] in ('RedHat', 'CentOS') or grains['oscodename'] in ('xenial') %}
/usr/lib/systemd/system/hbase-thrift.service:
  file.managed:
    - source: salt://hdp/templates/hbase-daemon.service.tpl
{% endif %}
    - mode: 644
    - template: jinja
    - context:
      daemon_service: 'thrift'
      daemon_port: {{ thrift_port }}
      info_port: {{ info_port }}

{% if grains['os'] in ('RedHat', 'CentOS') or grains['oscodename'] in ('xenial') %}
hdp-systemctl_reload_hbase_thrift:
  cmd.run:
    - name: /bin/systemctl daemon-reload; /bin/systemctl enable hbase-thrift
{% endif %}

hdp-start_hbase_thrift:
  cmd.run:
    - name: 'service hbase-thrift stop || echo already stopped; service hbase-thrift start'
