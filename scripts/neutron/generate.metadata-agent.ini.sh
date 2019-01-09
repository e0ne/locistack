#!/bin/bash
set -x
cat > /etc/neutron/metadata_agent.ini <<- EOF
[DEFAULT]
#
# From neutron.metadata.agent
#
# Location for Metadata Proxy UNIX domain socket. (string value)
#metadata_proxy_socket = $state_path/metadata_proxy
# User (uid or name) running metadata proxy after its initialization (if empty:
# agent effective user). (string value)
#metadata_proxy_user =
# Group (gid or name) running metadata proxy after its initialization (if
# empty: agent effective group). (string value)
#metadata_proxy_group =
# Certificate Authority public key (CA cert) file for ssl (string value)
#auth_ca_cert = <None>
# IP address or DNS name of Nova metadata server. (unknown value)
# Deprecated group/name - [DEFAULT]/nova_metadata_ip
nova_metadata_host = ${CONTROL_HOST_IP}
# TCP Port used by Nova metadata server. (port value)
# Minimum value: 0
# Maximum value: 65535
#nova_metadata_port = 8775
# When proxying metadata requests, Neutron signs the Instance-ID header with a
# shared secret to prevent spoofing. You may select any string for a secret,
# but it must match here and in the configuration used by the Nova Metadata
# Server. NOTE: Nova uses the same config key, but in [neutron] section.
# (string value)
metadata_proxy_shared_secret = ${METADATA_SECRET}
# Protocol to access nova metadata, http or https (string value)
# Allowed values: http, https
#nova_metadata_protocol = http
# Allow to perform insecure SSL (https) requests to nova metadata (boolean
# value)
#nova_metadata_insecure = false
# Client certificate for nova metadata api server. (string value)
#nova_client_cert =
# Private key of client certificate. (string value)
#nova_client_priv_key =
# Metadata Proxy UNIX domain socket mode, 4 values allowed: 'deduce': deduce
# mode from metadata_proxy_user/group values, 'user': set metadata proxy socket
# mode to 0o644, to use when metadata_proxy_user is agent effective user or
# root, 'group': set metadata proxy socket mode to 0o664, to use when
# metadata_proxy_group is agent effective group or root, 'all': set metadata
# proxy socket mode to 0o666, to use otherwise. (string value)
# Allowed values: deduce, user, group, all
#metadata_proxy_socket_mode = deduce
# Number of separate worker processes for metadata server (defaults to half of
# the number of CPUs) (integer value)
metadata_workers = 1
# Number of backlog requests to configure the metadata server socket with
# (integer value)
#metadata_backlog = 4096
# DEPRECATED: URL to connect to the cache back end. This option is deprecated
# in the Newton release and will be removed. Please add a [cache] group for
# oslo.cache in your neutron.conf and add "enable" and "backend" options in
# this section. (string value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
#cache_url =
#
# From oslo.log
#
# If set to true, the logging level will be set to DEBUG instead of the default
# INFO level. (boolean value)
# Note: This option can be changed without restarting.
#debug = false
# The name of a logging configuration file. This file is appended to any
# existing logging configuration files. For details about logging configuration
# files, see the Python logging module documentation. Note that when logging
# configuration files are used then all logging configuration is set in the
# configuration file and other logging configuration options are ignored (for
# example, logging_context_format_string). (string value)
# Note: This option can be changed without restarting.
# Deprecated group/name - [DEFAULT]/log_config
#log_config_append = <None>
# Defines the format string for %%(asctime)s in log records. Default:
# %(default)s . This option is ignored if log_config_append is set. (string
# value)
#log_date_format = %Y-%m-%d %H:%M:%S
# (Optional) Name of log file to send logging output to. If no default is set,
# logging will go to stderr as defined by use_stderr. This option is ignored if
# log_config_append is set. (string value)
# Deprecated group/name - [DEFAULT]/logfile
#log_file = <None>
# (Optional) The base directory used for relative log_file  paths. This option
# is ignored if log_config_append is set. (string value)
# Deprecated group/name - [DEFAULT]/logdir
#log_dir = <None>
# Uses logging handler designed to watch file system. When log file is moved or
# removed this handler will open a new log file with specified path
# instantaneously. It makes sense only if log_file option is specified and
# Linux platform is used. This option is ignored if log_config_append is set.
# (boolean value)
#watch_log_file = false
# Use syslog for logging. Existing syslog format is DEPRECATED and will be
# changed later to honor RFC5424. This option is ignored if log_config_append
# is set. (boolean value)
#use_syslog = false
# Enable journald for logging. If running in a systemd environment you may wish
# to enable journal support. Doing so will use the journal native protocol
# which includes structured metadata in addition to log messages.This option is
# ignored if log_config_append is set. (boolean value)
#use_journal = false
# Syslog facility to receive log lines. This option is ignored if
# log_config_append is set. (string value)
#syslog_log_facility = LOG_USER
# Log output to standard error. This option is ignored if log_config_append is
# set. (boolean value)
#use_stderr = false
# Format string to use for log messages with context. (string value)
#logging_context_format_string = %(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s
# Format string to use for log messages when context is undefined. (string
# value)
#logging_default_format_string = %(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s
# Additional data to append to log message when logging level for the message
# is DEBUG. (string value)
#logging_debug_format_suffix = %(funcName)s %(pathname)s:%(lineno)d
# Prefix each line of exception output with this format. (string value)
#logging_exception_prefix = %(asctime)s.%(msecs)03d %(process)d ERROR %(name)s %(instance)s
# Defines the format string for %(user_identity)s that is used in
# logging_context_format_string. (string value)
#logging_user_identity_format = %(user)s %(tenant)s %(domain)s %(user_domain)s %(project_domain)s
# List of package logging levels in logger=LEVEL pairs. This option is ignored
# if log_config_append is set. (list value)
#default_log_levels = amqp=WARN,amqplib=WARN,boto=WARN,qpid=WARN,sqlalchemy=WARN,suds=INFO,oslo.messaging=INFO,oslo_messaging=INFO,iso8601=WARN,requests.packages.urllib3.connectionpool=WARN,urllib3.connectionpool=WARN,websocket=WARN,requests.packages.urllib3.util.retry=WARN,urllib3.util.retry=WARN,keystonemiddleware=WARN,routes.middleware=WARN,stevedore=WARN,taskflow=WARN,keystoneauth=WARN,oslo.cache=INFO,dogpile.core.dogpile=INFO
# Enables or disables publication of error events. (boolean value)
#publish_errors = false
# The format for an instance that is passed with the log message. (string
# value)
#instance_format = "[instance: %(uuid)s] "
# The format for an instance UUID that is passed with the log message. (string
# value)
#instance_uuid_format = "[instance: %(uuid)s] "
# Interval, number of seconds, of log rate limiting. (integer value)
#rate_limit_interval = 0
# Maximum number of logged messages per rate_limit_interval. (integer value)
#rate_limit_burst = 0
# Log level name used by rate limiting: CRITICAL, ERROR, INFO, WARNING, DEBUG
# or empty string. Logs with level greater or equal to rate_limit_except_level
# are not filtered. An empty string means that all levels are filtered. (string
# value)
#rate_limit_except_level = CRITICAL
# Enables or disables fatal status of deprecations. (boolean value)
#fatal_deprecations = false
[agent]
#
# From neutron.metadata.agent
#
# Seconds between nodes reporting state to server; should be less than
# agent_down_time, best if it is half or less than agent_down_time. (floating
# point value)
#report_interval = 30
# Log agent heartbeats (boolean value)
#log_agent_heartbeats = false
[cache]
#
# From oslo.cache
#
# Prefix for building the configuration dictionary for the cache region. This
# should not need to be changed unless there is another dogpile.cache region
# with the same configuration name. (string value)
#config_prefix = cache.oslo
# Default TTL, in seconds, for any cached item in the dogpile.cache region.
# This applies to any cached method that doesn't have an explicit cache
# expiration time defined for it. (integer value)
#expiration_time = 600
# Cache backend module. For eventlet-based or environments with hundreds of
# threaded servers, Memcache with pooling (oslo_cache.memcache_pool) is
# recommended. For environments with less than 100 threaded servers, Memcached
# (dogpile.cache.memcached) or Redis (dogpile.cache.redis) is recommended. Test
# environments with a single instance of the server can use the
# dogpile.cache.memory backend. (string value)
# Allowed values: oslo_cache.memcache_pool, oslo_cache.dict, dogpile.cache.memcached, dogpile.cache.redis, dogpile.cache.memory, dogpile.cache.null
#backend = dogpile.cache.null
# Arguments supplied to the backend module. Specify this option once per
# argument to be passed to the dogpile.cache backend. Example format:
# "<argname>:<value>". (multi valued)
#backend_argument =
# Proxy classes to import that will affect the way the dogpile.cache backend
# functions. See the dogpile.cache documentation on changing-backend-behavior.
# (list value)
#proxies =
# Global toggle for caching. (boolean value)
#enabled = false
# Extra debugging from the cache backend (cache keys, get/set/delete/etc
# calls). This is only really useful if you need to see the specific cache-
# backend get/set/delete calls with the keys/values.  Typically this should be
# left set to false. (boolean value)
#debug_cache_backend = false
# Memcache servers in the format of "host:port". (dogpile.cache.memcache and
# oslo_cache.memcache_pool backends only). (list value)
#memcache_servers = localhost:11211
# Number of seconds memcached server is considered dead before it is tried
# again. (dogpile.cache.memcache and oslo_cache.memcache_pool backends only).
# (integer value)
#memcache_dead_retry = 300
# Timeout in seconds for every call to a server. (dogpile.cache.memcache and
# oslo_cache.memcache_pool backends only). (integer value)
#memcache_socket_timeout = 3
# Max total number of open connections to every memcached server.
# (oslo_cache.memcache_pool backend only). (integer value)
#memcache_pool_maxsize = 10
# Number of seconds a connection to memcached is held unused in the pool before
# it is closed. (oslo_cache.memcache_pool backend only). (integer value)
#memcache_pool_unused_timeout = 60
# Number of seconds that an operation will wait to get a memcache client
# connection. (integer value)
#memcache_pool_connection_get_timeout = 10
EOF
