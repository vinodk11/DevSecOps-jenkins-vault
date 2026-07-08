# Trivy, SonarQube, and Nexus Kubernetes Manifests

# Folder Structure

```text
platform-tools/
│
├── trivy/
│   └── trivy-agent-pod.yaml
│
├── sonarqube/
│   ├── namespace.yaml
│   ├── postgres-secret.yaml
│   ├── postgres-pvc.yaml
│   ├── postgres-deployment.yaml
│   ├── postgres-service.yaml
│   ├── sonarqube-pvc.yaml
│   ├── sonarqube-deployment.yaml
│   ├── sonarqube-service.yaml
│   └── sonarqube-ingress.yaml
│
└── nexus/
    ├── namespace.yaml
    ├── nexus-pvc.yaml
    ├── nexus-deployment.yaml
    ├── nexus-service.yaml
    └── nexus-ingress.yaml
```

---

# TRIVY

## trivy/trivy-agent-pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: trivy-agent
  namespace: jenkins

spec:
  containers:

  - name: trivy
    image: aquasec/trivy:latest

    command:
    - cat

    tty: true
```

---

# SONARQUBE

## sonarqube/namespace.yaml

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: sonarqube
```

---

## sonarqube/postgres-secret.yaml

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
  namespace: sonarqube

type: Opaque

stringData:
  POSTGRES_DB: sonarqube
  POSTGRES_USER: sonar
  POSTGRES_PASSWORD: sonar123
```

---

## sonarqube/postgres-pvc.yaml

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
  namespace: sonarqube

spec:
  accessModes:
  - ReadWriteOnce

  resources:
    requests:
      storage: 10Gi
```

---

## sonarqube/postgres-deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
  namespace: sonarqube

spec:
  replicas: 1

  selector:
    matchLabels:
      app: postgres

  template:
    metadata:
      labels:
        app: postgres

    spec:
      containers:

      - name: postgres
        image: postgres:15

        ports:
        - containerPort: 5432

        env:
        - name: POSTGRES_DB
          valueFrom:
            secretKeyRef:
              name: postgres-secret
              key: POSTGRES_DB

        - name: POSTGRES_USER
          valueFrom:
            secretKeyRef:
              name: postgres-secret
              key: POSTGRES_USER

        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgres-secret
              key: POSTGRES_PASSWORD

        volumeMounts:
        - mountPath: /var/lib/postgresql/data
          name: postgres-storage

      volumes:
      - name: postgres-storage
        persistentVolumeClaim:
          claimName: postgres-pvc
```

---

## sonarqube/postgres-service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: postgres
  namespace: sonarqube

spec:
  selector:
    app: postgres

  ports:
  - port: 5432
    targetPort: 5432
```

---

## sonarqube/sonarqube-pvc.yaml

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: sonarqube-pvc
  namespace: sonarqube

spec:
  accessModes:
  - ReadWriteOnce

  resources:
    requests:
      storage: 20Gi
```

---

## sonarqube/sonarqube-deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sonarqube
  namespace: sonarqube

spec:
  replicas: 1

  selector:
    matchLabels:
      app: sonarqube

  template:
    metadata:
      labels:
        app: sonarqube

    spec:
      containers:

      - name: sonarqube
        image: sonarqube:lts-community

        ports:
        - containerPort: 9000

        env:
        - name: SONAR_JDBC_URL
          value: jdbc:postgresql://postgres:5432/sonarqube

        - name: SONAR_JDBC_USERNAME
          valueFrom:
            secretKeyRef:
              name: postgres-secret
              key: POSTGRES_USER

        - name: SONAR_JDBC_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgres-secret
              key: POSTGRES_PASSWORD

        resources:
          requests:
            memory: "2Gi"
            cpu: "1"

          limits:
            memory: "4Gi"
            cpu: "2"

        volumeMounts:
        - mountPath: /opt/sonarqube/data
          name: sonarqube-storage

      volumes:
      - name: sonarqube-storage
        persistentVolumeClaim:
          claimName: sonarqube-pvc
```

---

## sonarqube/sonarqube-service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: sonarqube
  namespace: sonarqube

spec:
  selector:
    app: sonarqube

  ports:
  - port: 9000
    targetPort: 9000

  type: ClusterIP
```

---

## sonarqube/sonarqube-ingress.yaml

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: sonarqube-ingress
  namespace: sonarqube

spec:
  ingressClassName: nginx

  rules:
  - host: sonarqube.local
    http:
      paths:
      - path: /
        pathType: Prefix

        backend:
          service:
            name: sonarqube
            port:
              number: 9000
```

---

# NEXUS

## nexus/namespace.yaml

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: nexus
```

---

## nexus/nexus-pvc.yaml

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nexus-pvc
  namespace: nexus

spec:
  accessModes:
  - ReadWriteOnce

  resources:
    requests:
      storage: 30Gi
```

---

## nexus/nexus-deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nexus
  namespace: nexus

spec:
  replicas: 1

  selector:
    matchLabels:
      app: nexus

  template:
    metadata:
      labels:
        app: nexus

    spec:
      containers:

      - name: nexus
        image: sonatype/nexus3:latest

        ports:
        - containerPort: 8081

        resources:
          requests:
            memory: "2Gi"
            cpu: "1"

          limits:
            memory: "4Gi"
            cpu: "2"

        volumeMounts:
        - mountPath: /nexus-data
          name: nexus-storage

      volumes:
      - name: nexus-storage
        persistentVolumeClaim:
          claimName: nexus-pvc
```

---

## nexus/nexus-service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nexus
  namespace: nexus

spec:
  selector:
    app: nexus

  ports:
  - port: 8081
    targetPort: 8081

  type: ClusterIP
```

---

## nexus/nexus-ingress.yaml

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nexus-ingress
  namespace: nexus

spec:
  ingressClassName: nginx

  rules:
  - host: nexus.local
    http:
      paths:
      - path: /
        pathType: Prefix

        backend:
          service:
            name: nexus
            port:
              number: 8081
```

---

# Deployment Commands

```bash
kubectl apply -f sonarqube/
kubectl apply -f nexus/
```

---

# Verification Commands

```bash
kubectl get pods -A
kubectl get svc -A
kubectl get ingress -A
```

---

# Initial Nexus Password

```bash
kubectl exec -it deployment/nexus -n nexus -- \
cat /nexus-data/admin.password
```

---

# SonarQube Default Credentials

```text
username: admin
password: admin
```

---

# Recommended Next Step

After these components are healthy:

1. Configure SonarQube token in Jenkins
2. Configure Nexus credentials in Jenkins
3. Add Trivy scan stage
4. Add Docker build stage
5. Add Docker push stage
6. Add Kubernetes deployment stage



kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml


kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml


http://sonarqube.sonarqube:9000

http://nexus.nexus:8081

http://vault.vault:8200

vault-k8s

enterprise DevOps concepts


Ag@sthy@123456


http://jenkins.jenkins.svc.cluster.local:8080


http://nexus.nexus:8081/repository/maven-releases
http://nexus.nexus:8081/repository/maven-sanpshots

<servers>

    <server>
        <id>maven-releases</id>
        <username>${NEXUS_USER}</username>
        <password>${NEXUS_PASS}</password>
    </server>

    <server>
        <id>maven-snapshots</id>
        <username>${NEXUS_USER}</username>
        <password>${NEXUS_PASS}</password>
    </server>

</servers>

kubectl logs jenkins-0 -n jenkins | grep -A 5 "Please use the following password"

kubectl get pod -n ingress-nginx -o wide

kubectl get svc -n ingress-nginx


squ_58d7b735fd929e6bc8f59b49541bce057f18190a


