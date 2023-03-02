kind: Service
apiVersion: v1
metadata:
  name: java-hello
  labels:
    app: java-hello
spec:
  type: LoadBalancer
  externalTrafficPolicy: Cluster
  ports:
    - name: http
      port: 80
      targetPort: 3333
  selector:
    app: java-hello
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: java-hello
  labels:
    app: java-hello
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 1
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: java-hello
  template:
    metadata:
      labels:
        app: java-hello
      annotations:
        instrumentation.opentelemetry.io/inject-java: "true"  # newly added for auto instrumentatioin support
    spec:
      containers:
        - name: java-hello
          image: us-docker.pkg.dev/democs-378510/demo/prof5:COMMIT_SHA
          ports:
            - name: http
              containerPort: 3333
              protocol: TCP
          resources:
            limits:
              cpu: 800m
              memory: 2048Mi
            requests:
              cpu: 200m
              memory: 512Mi
          imagePullPolicy: Always
      restartPolicy: Always
      terminationGracePeriodSeconds: 30