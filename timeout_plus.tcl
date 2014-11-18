#!/usr/bin/tclsh
#This is a script to termit pid at know time
#./timec.tcl -p pid -d 2014-01-03 -t 08:13
#./timec.tcl -n pidname -t 08:13
#./timec.tcl -p pid -d 2014-01-03 (-t 00:00)

#执行循环干掉某进程
proc killp {killpid closetime} {
	while {1} {
		set systemTime [clock seconds]
		if { $systemTime >= $closetime } {
			foreach kpid $killpid {
			exec kill -9 $kpid
			}
			exit
		}
	after 500
}
}


#定义为全局变量
set runp 	0
set killpid 	0
set closetime 	0 
set systemTime  0
set closedate 	0
set killname 	0
set runtime 	0
#判断参数个数，argc个数从1开始计数
if { $argc < 2 } {
puts "Error:arguments error!"
exit 1
} elseif { $argc < 7 } {

	if { [catch {dict keys $argv} keyinfo] != 0 } {
		puts "argument error"
		puts "./timec.tcl -p pid -d 2014-11-11 -t 08:11 "
		puts "./timec.tcl -p pid -t 08:11"
		puts "./timec.tcl -n pname -d 2014-01-02 -t 08:13"
		puts "./timec.tcl -n pname -t 08:13 "
		exit 1
	}
}
foreach key $keyinfo {
	switch $key {
		-P { set runp 	   [dict get $argv $key]}
		-p { set killpid   [dict get $argv $key]}
		-n { set killname  [dict get $argv $key]}
		-d { set closedate [dict get $argv $key]}
		-t { set closetime [dict get $argv $key]}
		-r { 
		     set runtime   [dict get $argv $key]
		     set time_unit [string index $runtime end]
		     set runtime   [string range $runtime 0 end-1]	
		     switch $time_unit {
			d { set closetime [expr {$runtime * 86400}] }
			h { set closetime [expr {$runtime * 3600}]  }
			m { set closetime [expr {$runtime * 60}]    }
			s { set closetime $runtime		  }
			default {
			        puts "time unit is : d/h/m/s" 
				exit 1
				}
			}
		}
	}
}

#确认关闭程序具体时间
if { $closedate == 0 } {
	if { $runtime == 0} {
		set closetime [clock scan [list [clock format [clock seconds] -format {%Y-%m-%d}] $closetime] -format {%Y-%m-%d %H:%M}] 
		} else {
		set closetime [expr [clock seconds] + $closetime]
		}
	} elseif { $closetime == 0} {
		set closetime [clock scan $closedate -format %Y-%m-%d] 
	} else {
		set closetime [clock scan [list $closedate $closetime] -format "%Y-%m-%d %H:%M"]
	}

if { $closetime < [clock seconds] } {
puts "closetime is less than now"
exit 1
}

if { $runp != 0 } {
	if {[catch {eval exec /usr/bin/nohup ${runp} >/dev/null 2>&1 &} killpid]} {
		puts "run process error."
		exit 1
	}		
}

#确认关闭程序的pid
if {$killpid == 0} {
	if { [catch {split [ exec ps -ax | grep -i "$killname" | grep -v "$::argv0" | awk {{print $1}}] "\n"} killpid]} {
		puts "There is no pid name you want to kill:$killpid"
		exit 1
	}
}


foreach kpid $killpid {
	if { [catch {exec ps -e | grep -v grep | grep -i $kpid} nopid]} {
		puts "there is no pid of $kpid"
		exit 1
	}
}

killp $killpid $closetime

