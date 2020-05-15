#!/bin/bash

iterations=$1


for i in $(eval echo "{1..$iterations}")
do
  echo $i;
done
