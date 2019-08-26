# Storage

## Prerequisites

To deploy Shared Filesystem on Rook/Ceph, at least 3 k8s nodes are required.

## Description

Rook/Ceph k8s configuration is condensed into single file `deploy/kubernetes/infrastructure/rook-ceph.yaml`. 
Configuration for `common` and `operator` are taken from https://github.com/rook/rook/blob/master/cluster/examples/kubernetes/ceph/ without changes. 
Configuration for `cluster` and `filesystem` are modified to run on a small AWS cluster

Original deploy instructions and reference are at 
https://rook.io/docs/rook/v1.0/ceph-quickstart.html
and
https://rook.io/docs/rook/v1.0/ceph-filesystem.html

## Usage

```
kubectl create -f deploy/kubernetes/infrastructure/rook-ceph.yaml
```

This will deploy Rook Operator, Ceph Cluster and Shared Filesystem available to all pods in cluster
