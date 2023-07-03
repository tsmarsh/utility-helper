# Deployment

This is a simple app, but we're still dealing with a few quirks of kubernetes.

## Ingress

Whilst the ingress is defined, the implementation isn't. Thats because I couldn't figure out how to do without helm.

Run these commands to add nginx ingress to your cluster:


```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

helm install nginx-ingress ingress-nginx/ingress-nginx
```

## Secrets

### Mongo

Place the connection string for the environment in the kustomization.yaml for the overlay you're using. It needs to be base64 encode. Easier way I've found to get that is:

```kubectl create secret generic mongo-connection-string --from-literal=MONGO_CONNECTION_STRING="<connection string from atlas with creds>```

## Deployment

To deploy the app, run the following command:

```kubectl apply -k overlays/<overlay>```

Where <overlay> is the overlay you want to deploy. I'd recommend starting with dev and configuring it for a DNS you control.
