variable "project" {
  description = "GCP project"
  type        = string
  default     = "burner-kumshatr"
}

variable "region" {
  description = "Region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone to deploy resources"
  type        = string
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "private-gke-cluster"
}

variable "vpc_network_id" {
  description = "VPC network name"
  type        = string
  default     = vpc_network
}

variable "subnetwork" {
  description = "subnetwork network name"
  type        = string
  default     = gke-private-subnet
}
variable "node_count" {
  description = "Number of nodes in the node pool"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "Machine type for nodes"
  type        = string
  default     = e2-small
}

variable "preemptibility" {
  description = "Whether to use preemptible VMs"
  type        = bool
}
