#!/bin/bash
# fake edit
set -ev
if [ "${TRAVIS_OS_NAME}" = "linux" ]; then
	sh -e /etc/init.d/xvfb start
fi 
