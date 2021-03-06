#!/bin/bash
set -x

# Wait for neutron and glance so we can create the network
until $(curl --output /dev/null --silent http://${CONTROL_HOST_IP}:9696); do
    printf 'waiting on neutron'
    sleep 5
done

source /scripts/common/adminrc
export CLEANING_NETWORK=`openstack network show provider | grep '| id' | cut -d '|' -f 3`
export PROVISIONING_NETWORK=$CLEANING_NETWORK

# Wait for glance so we can create the image connection
until $(curl --output /dev/null --silent http://${CONTROL_HOST_IP}:9292); do
    printf 'waiting on glance'
    sleep 5
done

source /scripts/ironic/glancerc
export SWIFT_GLANCE_ACCOUNT=`openstack object store account show | grep AUTH | cut -d '|' -f 3 | xargs`

cat > /etc/ironic/ironic.conf <<-EOF
[DEFAULT]
enabled_hardware_types = ipmi
enabled_network_interfaces = flat,neutron
#enabled_drivers = agent_ipmitool,pxe_ipmitool

enabled_boot_interfaces = pxe
enabled_deploy_interfaces = iscsi,direct

auth_strategy = keystone
transport_url = rabbit://guest:${RABBITMQ_DEFAULT_PASS}@${CONTROL_HOST}
tempdir = /imagedata/tmp

[api]
api_workers = 1

[keystone_authtoken]

auth_type=password
auth_uri=http://${CONTROL_HOST_IP}:5000
auth_url=http://${CONTROL_HOST_IP}:35357
username=ironic
password=${SERVICE_PASSWORD}
project_name=service
project_domain_name=Default
user_domain_name=Default

[pxe]
pxe_append_params = systemd.journald.forward_to_console=yes
tftp_server=${IMAGE_HOST_IP}
tftp_root=/imagedata/tftpboot
tftp_master_path=/imagedata/tftpboot/master_images
pxe_bootfile_name=undionly.kpxe
ipxe_enabled=true
ipxe_boot_script = /etc/ironic/boot.ipxe
instance_master_path = /imagedata/httpboot/master_images
images_path = /imagedata/cache
ipxe_use_swift = false 

uefi_pxe_bootfile_name=ipxe.efi

pxe_config_template=\$pybasedir/drivers/modules/ipxe_config.template
uefi_pxe_config_template=\$pybasedir/drivers/modules/ipxe_config.template

[deploy]
http_url = http://${IMAGE_HOST_IP}:8080
http_root = /imagedata/httpboot

[conductor]
api_url = http://${IMAGE_HOST_IP}:6385/
clean_nodes = false
automated_clean = false

[database]
connection = mysql+pymysql://ironic:${MYSQL_ROOT_PASSWORD}@${CONTROL_HOST_IP}/ironic
max_pool_size=200
max_overflow=300

[dhcp]
dhcp_provider = neutron

[ilo]
use_web_server_for_images = true

[inspector]
enabled = false

[neutron]
auth_type = password
auth_url=http://${CONTROL_HOST_IP}:35357
username=ironic
password=${SERVICE_PASSWORD}
project_name=service
project_domain_name=Default
user_domain_name=Default

cleaning_network=${CLEANING_NETWORK}
provisioning_network=${PROVISIONING_NETWORK}

[glance]
auth_type = password
auth_url=http://${CONTROL_HOST_IP}:35357
username=ironic
password=${SERVICE_PASSWORD}
project_name=service
project_domain_name=Default
user_domain_name=Default

temp_url_endpoint_type = swift
swift_endpoint_url = http://${CONTROL_HOST_PRIVATE_IP}:8888
swift_account = ${SWIFT_GLANCE_ACCOUNT}
swift_container = glance
swift_temp_url_key = ${SWIFT_TEMP_URL_KEY}

[swift]
auth_type = password
auth_url=http://${CONTROL_HOST_IP}:35357
username=ironic
password=${SERVICE_PASSWORD}
project_name=service
project_domain_name=Default
user_domain_name=Default

[service_catalog]
auth_type = password
auth_url=http://${CONTROL_HOST_IP}:35357
username=ironic
password=${SERVICE_PASSWORD}
project_name=service
project_domain_name=Default
user_domain_name=Default

[disk_utils]
iscsi_verify_attempts = 60

EOF
