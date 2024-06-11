variable "project" {
  description = "GCP project"
  type        = string
}

variable "region" {
  description = "Region to deploy resources"
  type        = string
}

variable "zone" {
  description = "Zone to deploy resources"
  type        = string
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
}

variable "network" {
  description = "VPC network name"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the node pool"
  type        = number
}

variable "machine_type" {
  description = "Machine type for nodes"
  type        = string
}

variable "preemptibility" {
  description = "Whether to use preemptible VMs"
  type        = bool
}
