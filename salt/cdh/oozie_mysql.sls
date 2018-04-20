{% set mysql_root_password = salt['pillar.get']('mysql:root_pw', 'mysqldefault') %}

{% set oozie_user = salt['pillar.get']('hadoop:oozie:user', 'oozie') %}
{% set oozie_database = salt['pillar.get']('hadoop:oozie:database', 'oozie') %}
{% set oozie_password = salt['pillar.get']('hadoop:oozie:passwprd', 'oozie') %}

{% set hive_user = salt['pillar.get']('hadoop:hive:user', 'hive') %}
{% set hive_database = salt['pillar.get']('hadoop:hive:database', 'hive') %}
{% set hive_password = salt['pillar.get']('hadoop:hive:password', 'hive') %}

{% set hue_user = salt['pillar.get']('hadoop:hue:user', 'hue') %}
{% set hue_database = salt['pillar.get']('hadoop:hue:database', 'hue') %}
{% set hue_password = salt['pillar.get']('hadoop:hue:password', 'hue') %}

# mysql_user module is broken with the version of salt used here for mysql 5.7
# this automation will be handled in a separate step by Ansible
{% if pillar['mysql-server']['package-name'] not in ('mysql-server-5.7') %}
include:
  - mysql

cdh-Create oozie MySQL user:
  mysql_user.present:
    - name: {{ oozie_user }}
    - host: localhost
    - password: {{ oozie_password }}
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}

cdh-Create oozie MySQL user remote:
  mysql_user.present:
    - name: {{ oozie_user }}
    - host: '%'
    - password: {{ oozie_password }}
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    
cdh-Create oozie MySQL user from host:
  mysql_user.present:
    - name: {{ oozie_user }}
    - host: '%'
    - password: {{ oozie_password }}
    - host: '{{ grains['nodename'] }}'
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    
cdh-Create oozie database:
  mysql_database.present:
    - name: {{ oozie_database }}
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}

cdh-Grant privileges to oozie user connecting from localhost:
   mysql_grants.present:
    - grant: all privileges
    - database: {{ oozie_database }}.*
    - user: {{ oozie_user }}
    - host: localhost
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}

cdh-Grant privileges to oozie user from outside:
   mysql_grants.present:
    - grant: all privileges
    - database: {{ oozie_database }}.*
    - user: {{ oozie_user }}
    - host: '%'
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}

cdh-Grant privileges to oozie user from host:
   mysql_grants.present:
    - grant: all privileges
    - database: {{ oozie_database }}.*
    - user: {{ oozie_user }}
    - host: '{{ grains['nodename'] }}'
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}

cdh-Create hive MySQL user:
  mysql_user.present:
    - name: {{ hive_user }}
    - host: localhost
    - password: {{ hive_password }}
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}

cdh-Create hive MySQL user remote:
  mysql_user.present:
    - name: {{ hive_user }}
    - host: '%'
    - password: {{ hive_password }}
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}    
    
cdh-Create hive database:
  mysql_database.present:
    - name: {{ hive_database }}
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}

cdh-Grant privileges to hive user connecting from localhost:
   mysql_grants.present:
    - grant: all privileges
    - database: {{ hive_database }}.*
    - user: {{ hive_user }}
    - host: localhost
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}

cdh-Grant privileges to hive user from outside:
   mysql_grants.present:
    - grant: all privileges
    - database: {{ hive_database }}.*
    - user: {{ hive_user }}
    - host: '%'
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}

cdh-Create hue MySQL user:
  mysql_user.present:
    - name: {{ hue_user }}
    - host: localhost
    - password: {{ hue_password }}
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}

cdh-Create hue MySQL user remote:
  mysql_user.present:
    - name: {{ hue_user }}
    - host: '%'
    - password: {{ hue_password }}
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}

cdh-Create hue database:
  mysql_database.present:
    - name: {{ hue_database }}
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}

cdh-Grant privileges to hue user connecting from localhost:
   mysql_grants.present:
    - grant: all privileges
    - database: {{ hue_database }}.*
    - user: {{ hue_user }}
    - host: localhost
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}

cdh-Grant privileges to hue user from outside:
   mysql_grants.present:
    - grant: all privileges
    - database: {{ hue_database }}.*
    - user: {{ hue_user }}
    - host: '%'
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}

cdh-Create root user remote:
  mysql_user.present:
    - name: root
    - host: '%'
    - password: {{ mysql_root_password }}
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}

cdh-Grant privileges to root user from outside:
   mysql_grants.present:
    - grant: all privileges
    - grant_option: True
    - database: '*.*'
    - user: root
    - host: '%'
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
{% endif %}
