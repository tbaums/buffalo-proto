#!/bin/bash
dcos security org service-accounts keypair private-key.pem public-key.pem
sleep 1
dcos security org service-accounts create -p public-key.pem -d "Edge-LB service account" edge-lb-principal
sleep 1
dcos security secrets create-sa-secret private-key.pem edge-lb-principal dcos-edgelb/edge-lb-secret
sleep 1
dcos security org groups add_user superusers edge-lb-principal
