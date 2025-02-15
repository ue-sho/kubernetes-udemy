# Memo

## Kubernetes

コンテナオーケストレーションとは、コンテナを管理するための仕組み。

使えるリソースを一元管理することで、コンテナのスケーリングやロードバランシングを行う。

- master node: クラスタ全体を管理する
- worker node: コンテナを実行する

### リソース

- ワークロード
    - Pod: 1つ以上のコンテナをまとめたもの
    - ReplicaSet: Podの複製を管理する
    - Deployment: ReplicaSetを管理する
    - StatefulSet: データを持つアプリケーションを管理する
    - DaemonSet: 特定のノードでPodを実行する
    - Job: 一度だけ実行する
    - CronJob: 定期的に実行する
- サービス
    - Service: ネットワークを提供する
    - Ingress: サービスへのアクセスを制御する
- 設定
    - ConfigMap: 設定情報を管理する
    - Secret: 機密情報を管理する
- ストレージ
    - PersistentVolume: ストレージを管理する
    - PersistentVolumeClaim: ストレージを要求する
    - StorageClass: ストレージのクラスを管理する

### ネットワーク

Nodeは実サーバーに対応する。Podはコンテナに対応する。

クラスタネットワークは、Pod間の通信を可能にする。
外部ネットワークは、クラスタ外部との通信を可能にする。master nodeに対してのみアクセス可能。

### マニュフェスト

基本的にYAMLファイルで記述する。


## Kubectl

最初の `hello-world` は `Pod` 名で、`--restart=Never` は `Pod` が終了したら再起動しないようにする。

```bash
kubectl run hello-world --image=hello-world --restart=Never
```

`kubectl apply` でマニュフェストを適用する。

```bash
kubectl apply -f example/pod.yaml
```

`kubectl get` でリソースを取得する。

```bash
kubectl get pods -f example/pod.yaml
```

`kubectl create secret` でシークレットを作成する。

```bash
kubectl create secret generic my-secret --from-literal=username=admin --from-literal=password=password
```

`kubectl get secret` でシークレットを取得する。

```bash
kubectl get secret my-secret -o yaml
```

`kubectl describe` でリソースの詳細を取得する。

```bash
kubectl describe pod hello-world
```

`kubectl logs` でログを取得する。

```bash
kubectl logs hello-world
```

## Minikube

ローカル環境でKubernetesクラスタを構築する。

```bash
minikube start
```

SSHで接続する。

```bash
minikube ssh
```

IPアドレスを取得する。

```bash
minikube ip
```

MinikubeのDockerデーモンに接続する。

```bash
eval $(minikube docker-env)
```

## DB初期化

MongoDBのレプリカセットを初期化する。

```
use admin
db.auth("admin", "P@ssw0rd")
rs.initiate({
    _id: "rs0",
    members: [
        { _id: 0, host: "mongo-0.db-svc:27017" },
        { _id: 1, host: "mongo-1.db-svc:27017" },
        { _id: 2, host: "mongo-2.db-svc:27017" }
    ]
})
rs.status()
```

Debug PodからDBに初期データを投入する。

```bash
cd init
kubectl cp init/. debug:/root/init-db/
kubectl exec -it debug -- bash
cd /root/init-db
sh init.sh
```

データを確認してみる。

```sh
mongosh mongo-0.db-svc
```
```
use admin
db.auth("admin", "P@ssw0rd")
use weblog
show collections
db.posts.find().pretty()
```

## Appサーバー動作確認


```bash
cd apps/weblog-app
kubectl apply -f weblog-db-service.yml

# Hosts は minikube ip で取得したIPアドレス
docker run \
    -e MONGODB_USERNAME="user" \
    -e MONGODB_PASSWORD="welcome" \
    -e MONGODB_HOSTS="192.168.49.2:32717" \
    -e MONGODB_DATABASE="weblog" \
    -d \
    -p 8080:3000 \
    weblog-app:v1.0.0
```

WSL上で動かしているので、socatでポートフォワーディングする。

```bash
socat TCP-LISTEN:8080,fork TCP:192.168.49.2:8080
```

ブラウザで `http://localhost:8080` にアクセスすると確認できた。
