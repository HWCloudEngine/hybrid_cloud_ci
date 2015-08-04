#!/bin/bash
let "success = 0"
let "failed = 0"
let "skipped = 0"

if [ -d /home/fsp/hybrid_test_case/basic_function_test_log ]; then
    rm -rf /home/fsp/hybrid_test_case/basic_function_test_log
fi

mkdir -p /home/fsp/hybrid_test_case/basic_function_test_log

echo "Start Basic Function Test : `date`" > /home/fsp/hybrid_test_case/basic_function_test_log/basic_function_test_result.log
echo "=================================================================================================" >> /home/fsp/hybrid_test_case/basic_function_test_log/basic_function_test_result.log
for filename in `ls /home/fsp/hybrid_test_case/high_level_test/basic_function_test | grep 'test_.*.py'`
do
    test_case_name=${filename%%".py"}
    if [ ! -d /home/fsp/hybrid_test_case/basic_function_test_log/${test_case_name} ]; then
        echo "creat log dir ( /home/fsp/hybrid_test_case/basic_function_test_log/${test_case_name} )"
        mkdir -p /home/fsp/hybrid_test_case/basic_function_test_log/${test_case_name}
    fi
		
    python /home/fsp/hybrid_test_case/high_level_test/basic_function_test/${filename} > /home/fsp/hybrid_test_case/basic_function_test_log/${test_case_name}/test_result.log 2>&1
	
	test_result=`tail -1 /home/fsp/hybrid_test_case/basic_function_test_log/${test_case_name}/test_result.log`
	
	echo "-------------------------------------------------------------------------------------------------" >> /home/fsp/hybrid_test_case/basic_function_test_log/basic_function_test_result.log
	echo "${test_case_name}-------------------------------------------${test_result}" >> /home/fsp/hybrid_test_case/basic_function_test_log/basic_function_test_result.log
	
	let "success = success + `grep -c '^test_.*ok' /home/fsp/hybrid_test_case/basic_function_test_log/${test_case_name}/test_result.log`"
	let "failed = failed + `grep -c '^test_.*FAIL' /home/fsp/hybrid_test_case/basic_function_test_log/${test_case_name}/test_result.log`"
	let "skipped = skipped + `grep -c '^test_.*skipped' /home/fsp/hybrid_test_case/basic_function_test_log/${test_case_name}/test_result.log`"
	
	cat /home/fsp/hybrid_test_case/basic_function_test_log/${test_case_name}/test_result.log | grep '^test_.*ok' >> /home/fsp/hybrid_test_case/basic_function_test_log/basic_function_test_result.log
	cat /home/fsp/hybrid_test_case/basic_function_test_log/${test_case_name}/test_result.log | grep '^test_.*FAIL' >> /home/fsp/hybrid_test_case/basic_function_test_log/basic_function_test_result.log
	cat /home/fsp/hybrid_test_case/basic_function_test_log/${test_case_name}/test_result.log | grep '^test_.*skipped' >> /home/fsp/hybrid_test_case/basic_function_test_log/basic_function_test_result.log
	
	echo "" >> /home/fsp/hybrid_test_case/basic_function_test_log/basic_function_test_result.log
done
echo ""
echo "=================================================================================================" >> /home/fsp/hybrid_test_case/basic_function_test_log/basic_function_test_result.log
echo "success test: ${success}" >> /home/fsp/hybrid_test_case/basic_function_test_log/basic_function_test_result.log
echo "failed test: ${failed}" >> /home/fsp/hybrid_test_case/basic_function_test_log/basic_function_test_result.log
echo "skipped test: ${skipped}" >> /home/fsp/hybrid_test_case/basic_function_test_log/basic_function_test_result.log

echo "Finish Test Case"
cd /home/fsp/hybrid_test_case/
tar -cf basic_function_test_log.tar basic_function_test_log
