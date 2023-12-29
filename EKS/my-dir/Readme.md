# Django Todo App Deployment 

### This guide will help you deploy the Django Todo App using Docker and AWS EKS.

## Prerequisites

#### You can install following tools from tools directory.

- Helm3 installed 
- Docker installed
- AWS CLI installed
- Eksctl installed
- Kubectl installed
- Git installed

## Steps

1. **Clone the repository:**
    ```bash
    git clone https://github.com/LondheShubham153/django-todo-cicd.git  
    cd django-todo-cicd/
    ```

2. **Build the Docker image:**
    ```bash
    docker build -t uj5ghare/django-todo-app .
    ```

3. **Run the Docker image:**
    ```bash
    docker run -d -p 8000:8000 uj5ghare/django-todo-app
    ```

4. **Login to Docker:**
    Replace `<username>` and `<password>` with your Docker credentials.
    ```bash
    DOCKER_USERNAME=<username>
    DOCKER_PASSWORD=<password> 
    echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin
    ```

5. **Push the Docker image:**
    ```bash
    docker push uj5ghare/django-todo-app
    ```
<br><br>

# Creating & Configuring EKS Cluster

1. **Create an EKS cluster:**
    ```bash
    eksctl create cluster --name cluster1 --region ap-south-1 --fargate 
    ```

2. **Update kubeconfig:**
    ```bash
    aws eks update-kubeconfig --name cluster1 
    ```

3. **Check the nodes:**
    ```bash
    kubectl get nodes
    ```

4. **Create a Fargate profile:**
    ```bash
    eksctl create fargateprofile --name profile1 --cluster cluster1 --region ap-south-1 --namespace ns1
    ```

5. **Clone the repository again:**
    ```bash
    git clone https://github.com/Uj5Ghare/django-todo-cicd.git 
    cd django-todo-cicd/EKS/
    ```

6. **Apply the Kubernetes configuration:**
    ```bash
    kubectl apply -f . 
    ```

7. **Check all the resources in the namespace:**
    ```bash
    kubectl get all -n ns1
    ```
<br><br>


# AWS Load Balancer Controller Setup
Follow the steps below to set up the AWS Load Balancer Controller on your EKS cluster.

1. Export your cluster name:
    ```bash
    export cluster_name=cluster1
    ```

2. Get the OIDC ID:
    ```bash
    oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
    ```

3. Associate the IAM OIDC provider:
    ```bash
    eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve
    ```

4. Create the IAM policy:
    ```bash
    aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json
    ```

5. Create the IAM service account:
    ```bash
    eksctl create iamserviceaccount --cluster=cluster1 --namespace=kube-system --name=aws-load-balancer-controller --role-name AmazonEKSLoadBalancerControllerRole --attach-policy-arn=arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy --approve
    ```

6. Add the EKS helm repo:
    ```bash
    helm repo add eks https://aws.github.io/eks-charts
    ```

7. Install the AWS Load Balancer Controller:
    ```bash
    helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=cluster1 --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller --set region=ap-south-1 --set vpcId=<your-vpc-id>
    ```

8. Verify the deployment:
    ```bash
    kubectl get deployment -n kube-system aws-load-balancer-controller
    ```