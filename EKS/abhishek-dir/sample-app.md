# Sample App deployment

## Copy the deploy.yml to your local and save it with name deploy.yml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: todo-deploy
  labels:
    app: todo-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: todo-app
  template:
    metadata:
      labels:
        app: todo-app
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/arch
                operator: In
                values:
                - amd64
                - arm64
      containers:
      - name: Django-todo-App
        image: uj5ghare/django-todo-app
        ports:
        - name: http
          containerPort: 8000
        imagePullPolicy: IfNotPresent
      nodeSelector:
        kubernetes.io/os: linux
```

## Deploy the app

```
kubectl apply -f deploy.yaml
```


## Copy the below file as service.yml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: todo-svc
  labels:
    app: todo-app
spec:
  selector:
    app: todo-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8000
```

## Deploy the service

```
kubectl apply -f service.yaml
```