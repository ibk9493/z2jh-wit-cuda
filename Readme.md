Create a k8s cluster 
Run the following command on all nodes:
mkdir -p /u/bin/jupyter_notebooks && chmod 777 -R /u/bin/jupyter_notebooks
Create a namespace in k8s:
kubectl create namespace ai-jupyter
Create a secret key in jupyter namespace to auto-pull images from repository:
kubectl -n jupyter create secret generic <key> --from-file=.dockerconfigjson=/root/.docker/config.json --type=kubernetes.io/dockerconfigjson
Create a TLS secret jupyter-tls-secret in jupyter namespace to enable HTTPS.
Copy jupyter_pv_pvc.yaml from SVN and run this command:
kubectl apply -f jupyter_pv_pvc.yaml

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
helm upgrade --cleanup-on-fail \
  --install jupyter jupyterhub/jupyterhub \
  --namespace ai-jupyter \
  --create-namespace \
  --version=2.0.0 \
  --values config.yaml


Verify that everything is ready and running
kubectl --namespace=jupyter get all -o wide
kubectl --namespace=jupyter get ingress

A base image is inherited from jupyter/all-spark-notebook:spark-3.1.1 and 
the packages from old jupyterhub is installed to create a new image jupyter:latest

Applying configuration changes
The general method to modify your Kubernetes deployment is to:
1.	Make a change to your config.yaml.
2.	Run a helm upgrade:
helm upgrade --cleanup-on-fail \
   jupyter jupyterhub/jupyterhub \
  --namespace ai-jupyter \
  --version=2.0.0 \
  --values config.yaml
3.	Verify that everything is ready and running
kubectl -n jupyter get all -o wide
kubectl -n jupyter get ingress
