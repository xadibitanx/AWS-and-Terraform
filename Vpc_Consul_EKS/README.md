## Steps for EKS after apply 
- aws eks --region=us-east-1 update-kubeconfig --name
- kubectl get nodes -o wide

## For register kuberneties to consul service: 
- Install helm : https://helm.sh/docs/intro/install/
- Download consul chart :  helm repo add hashicorp https://helm.releases.hashicorp.com
- kubectl create secret generic consul-gossip-encryption-key --from-literal=key="the same secret as the consul service has in the script consul.sh.tpl"
(for creating a new one for consul service before apply all terraform env : consul keygen)
helm install consul hashicorp/consul -f values.yaml
(take the conf from here: https://github.com/ops-school/kubernetes/blob/main/coredns/coredns-kubernetes/consul-helm/values.yaml)
- take the clusterip : kubectl get svc
- kubectl edit configmap coredns -n kube-system
 add the block:
 consul {
	errors
	cache 30
	forward . <consul-dns-service-cluster-ip 172.20.101.209>
}

right after this block:
    .:53 {
        errors
        health
        kubernetes cluster.local in-addr.arpa ip6.arpa {
          pods insecure
          fallthrough in-addr.arpa ip6.arpa
        }
