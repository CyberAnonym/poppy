#!/bin/bash

while getopts "a:b:c:d:e:f:g" OPT; do
        case $OPT in
        "a") echo "This is a message,the value is $OPTARG";;
        "b") echo "This is b message,the value is $OPTARG";;
        "c") echo "This is c message,the value is $OPTARG";;
        "d") echo "This is d message,the value is $OPTARG";;
        "e") echo "This is e message,the value is $OPTARG";;
        esac
done
