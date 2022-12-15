# apply kubernetes quark app
kubectl apply -f quark.yaml

# create cert-manager
kubectl create ns cert-manager
kubectl apply --validate=false -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.26.1/deploy/static/mandatory.yaml

# show pods running including certs as kobjects
kubectl -n cert-manager get all

# apply issuer yaml
kubectl apply -f issuer-certmanager-letsencrypt.yaml

# apply ingress yaml
kubectl apply -f ingress-nginx.yaml

# show certificates
kubectl get certificates

# apply grafana (port 3000:3000) (user admin:admin)
kubectl apply -f grafana.yaml

# check grafana
kubectl port-forward service/grafana 3000:3000
