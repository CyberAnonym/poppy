#!/bin/bash

v_WorkDIR=`cd $(dirname $0) && cd .. && pwd`
v_ConfDIR=$v_WorkDIR/config
. $v_ConfDIR/alarm.properties
. $v_ConfDIR/monitor.properties
v_TotalMemoryKB=`grep -i MemTotal $v_GetMemOfFile|awk -F ' ' '{print $2}'`
v_TotalMemoryMB=$((v_TotalMemoryKB/1024))

v_FreeMemoryKB=`grep -i MemFree $v_GetMemOfFile|awk -F ' ' '{print $2}'`
v_FreeMemoryMB=$((v_FreeMemoryKB/1024))

v_UsedMemKB=$((v_TotalMemoryKB-v_FreeMemoryKB))
v_UsedMemMB=$((v_TotalMemoryKB/1024))

v_BuffersKB=`grep -i ^Buffers $v_GetMemOfFile|awk -F ' ' '{print $2}'`
v_BuffersMB=$((v_BuffersKB/1024))

v_CachedKB=`grep -i ^Cached $v_GetMemOfFile|awk -F ' ' '{print $2}'`
v_CachedMB=$((v_CachedKB/1024))

#RealFreeMem is available mem. include buffers and cached.
v_RealFreeMemKB=$((v_FreeMemoryKB+v_BuffersKB+v_CachedKB))
v_RealFreeMemPercent=$((v_RealFreeMemKB*100/v_TotalMemoryKB))

#RealUsedMem not include buffer and cached.
v_RealUsedMemKB=$((v_TotalMemoryKB-v_RealFreeMemKB))
v_RealUsedMemPercent=$((v_RealUsedMemKB*100/v_TotalMemoryKB))

v_AlarmFreeMemKB=$((v_TotalMemoryKB*v_AlarmFreeMemPercent/100))
v_AlarmUsedMemKB=$((v_TotalMemoryKB*v_AlarmUsedMemPercent/100))
#echo $v_RealUsedMemKB
#echo $v_TotalMemoryKB
#echo $v_RealUsedMemPercent
#echo $v_AlarmFreeMemKB
#echo "Total memory is $v_TotalMemoryKB KB"
#echo "Now free memory is  $v_FreeMemoryKB KB  $v_FreeMemoryMB MB"
