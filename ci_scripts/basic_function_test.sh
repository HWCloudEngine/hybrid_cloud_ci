#!/bin/bash
HOST_CASCADING=162.3.130.50

if [ ! -d /var/lib/jenkins/hybrid_test_case ]; then
    mkdir -p /var/lib/jenkins/hybrid_test_case
fi

if [ -d /var/lib/jenkins/hybrid_test_case/high_level_test ]; then
    echo "delete test case dir( /var/lib/jenkins/hybrid_test_case/high_level_test )"
	rm -rf /var/lib/jenkins/hybrid_test_case/high_level_test
fi

if [ -f /var/lib/jenkins/hybrid_test_case/high_level_test.tar ]; then
    echo "delete test case file( /var/lib/jenkins/hybrid_test_case/test_case.tar )"
	rm /var/lib/jenkins/hybrid_test_case/high_level_test.tar
fi

TEST_CASE_SCRIPTS_DIR="/var/lib/jenkins/jobs/badam/workspace/high_level_test"

mkdir -p /var/lib/jenkins/hybrid_test_case/high_level_test
cp -rf /var/lib/jenkins/jobs/badam/workspace/high_level_test/* /var/lib/jenkins/hybrid_test_case/high_level_test/
cd /var/lib/jenkins/hybrid_test_case
tar -cf high_level_test.tar high_level_test
cd ..

FILE_COPY_USER=fsp
RUN_USER=root
DES_DIR="/home/"${FILE_COPY_USER}"/hybrid_test/"

echo "copy test_case.tar to HOST_CASCADING(${HOST_CASCADING}) ..."
ssh root@${HOST_CASCADING} rm -rf /home/fsp/hybrid_test_case/
ssh fsp@${HOST_CASCADING} mkdir -p /home/fsp/hybrid_test_case/

scp /var/lib/jenkins/hybrid_test_case/high_level_test.tar fsp@${HOST_CASCADING}:/home/fsp/hybrid_test_case
ssh fsp@${HOST_CASCADING} tar -xf /home/fsp/hybrid_test_case/high_level_test.tar -C /home/fsp/hybrid_test_case
scp /var/lib/jenkins/scripts/basic_function_test_on_cascading.sh fsp@${HOST_CASCADING}:/home/fsp/hybrid_test_case

ssh fsp@${HOST_CASCADING} /usr/bin/sh /home/fsp/hybrid_test_case/basic_function_test_on_cascading.sh

if [ $?=0 ]; then
    echo "Run Test Case Finished!"
	scp fsp@${HOST_CASCADING}:/home/fsp/hybrid_test_case/basic_function_test_log.tar /var/lib/jenkins/hybrid_test_case
	tar -xf /var/lib/jenkins/hybrid_test_case/basic_function_test_log.tar -C /var/lib/jenkins/hybrid_test_case
	cp /var/lib/jenkins/hybrid_test_case/basic_function_test_log.tar /var/lib/jenkins/hybrid_test_case/basic_function_test_log_`date +%Y_%m_%d_%H_%M_%S`.tar
fi