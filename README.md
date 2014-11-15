##Info
run and stop an specified service with a time limit
##Usage
1. Install tcl environment (just tested in centos)

	yum install tcl
2. Help info

	* -P(upper P):run a process througth timeout_plus.tcl script
	* -p(lowper p):the process id which you want to close at a time
	* -n:the name what you want to close at a time
	* -d:the date like 2014-01-01(only like this)
	* -t:the time like 08:11(only like this)
	* -r:stop the process after specified time like 1d(1day),10h(10 hours),10m(10minutes),5s(5 seconds)

3. Examples：
	1. start a service and stop that at an specified time
	
		nohup timeout_plus.tcl -P "watch date" -d 2015-01-12 -t 08:11 >/dev/null 2>&1 &
	2. stop a service with an know pid at an specified time
	
		nohup timeout_plus.tcl -p pid -d 2015-01-12 -t 08:11 >/dev/null 2>&1 &
	3. stop a service in today some times
	
		nohup timeout_plus.tcl -p pid -t 08:11 >/dev/null 2>&1 &
	4. stop a service with an know service name at an specified time
	
		nohup timeout_plus.tcl -n "watch date" -t 08:11 >/dev/null 2>&1 &
	5. stop a service after run 5minutes
		
		nohup timeout_plus.tcl -n "watch date" -r 5m >/dev/null 2>&1 &

[中文脚本说明](http://www.4linuxfun.com/timeout_plus-jiao-ben-shuo-ming/)
