#!/bin/bash

CHART=$(terraform state list helm_release.webapp)

if [[ $CHART == 'helm_release.webapp' ]]
then
 TF="terraform apply -replace="helm_release.webapp" -auto-approve -input=false"
 echo $TF
else
 TF="terraform apply -auto-approve -input=false"
 echo $TF
fi