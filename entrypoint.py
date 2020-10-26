#!/usr/bin/python2

from entrypoint_helpers import env, gen_cfg, set_props

NIFI_HOME = env["NIFI_HOME"]

gen_cfg("nifi.properties.j2", "{}/conf/nifi.properties".format(NIFI_HOME))
gen_cfg("bootstrap.conf.j2", "{}/conf/bootstrap.conf".format(NIFI_HOME))