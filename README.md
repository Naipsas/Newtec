# Newtec - k8s demo

Content
--

* Main script
* k8s application deployment example

Features
--

* **Main Script** can:

1) Install `minikube` and all its dependencies (Virtualbox and so forth)
2) Run minikube
3) Run the example in `Example_01` folder in minikube
4) Remove `example-01` namespace app from minikube
5) Show key data of the example
6) Stop `minikube` if it's running

minikube example
--

A **wordpress** example using **bitnami images** (mariaDB + wordpress containers). It uses files to create secrets, services, configmaps, deployments and statefulsets.

Requirements / Tested in
--

* This demo has been tested in **CentOS 7 64b**
