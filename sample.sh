#!/bin/bash
# this script is to provide the list of modified files to deploy 
#Line 7 and line 13 curently set for only threee columns in csv file
target_folder=$1
input_csv=$2

#read header
header_arr=($(head -1 ${input_csv} | awk -F ',' '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10}'))

#parse csv
while IFS=',' read -r -a arr
do
        #parse all cols in csv
        for i in {0..9}
        do
                if [[ -n ${arr[i]} ]]
                then
                        cp_cmd[i]="${cp_cmd[i]}${header_arr[i]}/${arr[i]}  "    # create cp command string for all folders
                fi
        done
done < <(tail -n +2 ${input_csv})

#make final command and execute, sample command  mkdir -p target/folder1 && cp folder1/test1.xml folder1/file1.xml target/folder1/
for i in "${!cp_cmd[@]}"
do
        cp_cmd_to_run="mkdir -p ${target_folder}/${header_arr[$i]} && cp -r ${cp_cmd[$i]} ${target_folder}/${header_arr[$i]}/"
        echo "${cp_cmd_to_run}"
        eval ${cp_cmd_to_run}
done
