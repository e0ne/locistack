#!/bin/bash

/scripts/common/wait-for-it.sh --host=mariadb --port=3306 -t 60

# because we can't actually trust MariaDB to be ready
sleep 5

cat > /tmp/create_database.sql <<-EOF
CREATE DATABASE IF NOT EXISTS neutron CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
  IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
  IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
EOF

mysql -u root -p$MYSQL_ROOT_PASSWORD -h ${CONTROL_HOST_IP} < /tmp/create_database.sql

neutron-db-manage --config-file /etc/neutron/neutron.conf \
                  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini \
                  --config-file /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
                  --config-file /etc/neutron/dhcp_agent.ini \
                  --config-file /etc/neutron/l3_agent.ini \
                  upgrade head
