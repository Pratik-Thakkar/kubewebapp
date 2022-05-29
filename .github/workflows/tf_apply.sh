#!/bin/bash

CHART=$(terraform state list helm_release.webapp)

if [[ $CHART == "helm_release.webapp" ]]
then
    terraform apply -replace="helm_release.webapp" -auto-approve -input=false
else
    terraform apply -auto-approve -input=false
fi