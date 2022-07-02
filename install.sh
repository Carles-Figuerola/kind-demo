#!/bin/bash

## Install metal-lb to have a pool of IPs for the load balancer / ingress controller
kubectl create ns metallb-system 
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 172.17.255.1-172.17.255.250
EOF
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml

## Install traefik and setup the dashboard
helm repo add traefik https://helm.traefik.io/traefik 2>&1 | grep skipping || helm repo update
helm upgrade -i traefik traefik/traefik
kubectl wait pod -l app.kubernetes.io/instance=traefik --for condition=Ready --timeout=300s
#kubectl apply -f - <<EOF
#apiVersion: traefik.containo.us/v1alpha1
#kind: IngressRoute
#metadata:
#  name: dashboard
#spec:
#  entryPoints:
#    - web
#  routes:
#    - match: (PathPrefix(``/dashboard``) || PathPrefix(``/api``))
#      kind: Rule
#      services:
#        - name: api@internal
#          kind: TraefikService
#EOF

## Open a port to traefik 
nohup kubectl port-forward  service/traefik 8888:80
