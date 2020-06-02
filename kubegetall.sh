#!/bin/bash
#
# Get all Kubernetes resources in a namespace or the default namespace if omitted.
#
# Usage: kubegetall [namespace]
#

namespace=${1:-"default"}

for resourceType in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v event); do
        resources=$(kubectl -n ${namespace} get --ignore-not-found $resourceType)
        j=0
        while read -r line; do
                j=$((j+1))
                if [ $j -eq 1 ] ; then
                        header=$line;
                elif [ $j -eq 2 ] ; then
                        space=$(echo $resourceType | sed -r 's/./-/g')
                        echo -e "\n$space $header"
                        echo -e "$resourceType/$line"
                else
                        echo -e "$resourceType/$line"
                fi
        done <<< "$resources"
done
