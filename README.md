# mercedev
Developers' ultimate work environment 

#### Terraform 

Objectives

* Deploy new environment 
* creating new instances 

$ terraform plan
$ terraform destroy

$ echo $USER 
this is the user name will be used for all the env instances launched

#### Kubernetes

kubectl config get-clusters

kubectl cluster-info (returns dns)

kubectl config view (returns user & password for environment)

create remote dashboard 
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard-no-rbac.yaml

