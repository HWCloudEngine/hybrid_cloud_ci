#!/bin/sh

if [ ! -d /var/lib/jenkins/jobs/badam/hybrid_Integration_testing ]; then
    mkdir -p /var/lib/jenkins/jobs/badam/hybrid_Integration_testing
fi

rm -rf /var/lib/jenkins/jobs/badam/hybrid_Integration_testing/*

cd /var/lib/jenkins/scripts

/bin/sh patch_deploy_extend.sh

/bin/sh basic_function_test.sh

cd /var/lib/jenkins/jobs/badam/hybrid_Integration_testing
cp /var/lib/jenkins/hybrid_test_case/basic_function_test_log.tar ./
cp /var/lib/jenkins/hybrid_test_case/basic_function_test_log/basic_function_test_result.log ./

if [ "$(basic_function_test_result.log | grep "failed test:")" = "failed test: 0" ]; then
   exit 0
else
   exit 127
fi
