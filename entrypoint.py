#!/usr/bin/python3

from entrypoint_helpers import env, gen_cfg

NIFI_HOME = env["NIFI_HOME"]

gen_cfg("bootstrap.conf.j2", "{}/conf/bootstrap.conf".format(NIFI_HOME))
gen_cfg("bootstrap-notification-services.xml.j2", "{}/conf/bootstrap-notification-services.xml".format(NIFI_HOME))
gen_cfg("nifi.properties.j2", "{}/conf/nifi.properties".format(NIFI_HOME))
gen_cfg("authorizers.xml.j2", "{}/conf/authorizers.xml".format(NIFI_HOME))
gen_cfg("logback.xml.j2", "{}/conf/logback.xml".format(NIFI_HOME))
gen_cfg("login-identity-providers.xml.j2", "{}/conf/login-identity-providers.xml".format(NIFI_HOME))
gen_cfg("state-management.xml.j2", "{}/conf/state-management.xml".format(NIFI_HOME))