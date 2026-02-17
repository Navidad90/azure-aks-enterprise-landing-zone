Azure Enterprise AKS Landing Zone (Hub-Spoke Architecture)

Overview

This project implements an enterprise-grade Azure AKS landing zone using Terraform, based on Microsoft’s hub-and-spoke reference architecture.

The objective is to demonstrate real-world Azure platform engineering practices, focusing on secure networking, modular infrastructure design, and production-ready deployment patterns.

Engineering Goals
This implementation demonstrates:

Hub-spoke networking design
Centralized outbound traffic inspection using Azure Firewall
Private AKS cluster deployment
Private DNS integration
Network security segmentation
Monitoring integration with Log Analytics
Infrastructure modularization using Terraform

Architecture Overview
Hub (Shared Services)

The hub virtual network hosts centralized and shared services.

Virtual Network (10.0.0.0/16)
Azure Firewall
Azure Bastion
Gateway Subnet (reserved for future connectivity)
Log Analytics Workspace
Private DNS Zone for AKS
VNet Peering configuration
The hub enforces centralized governance, security, and observability.

Spoke (Workload Landing Zone)
The spoke virtual network hosts workload-specific resources.

Virtual Network (10.1.0.0/16)
AKS Nodes Subnet
Ingress Subnet
Private Endpoint Subnet
API Server Subnet
Network Security Group
Route Table enforcing forced egress to Azure Firewall
Private AKS Cluster

This separation aligns with enterprise landing zone principles and workload isolation strategies.

Connectivity Model
The networking configuration includes:

Bidirectional VNet peering
Centralized outbound routing through Azure Firewall
Private DNS zone linked to both Hub and Spoke

Networking Design
Traffic Flow
Outbound traffic follows this path:

AKS Subnet
→ Route Table
→ Azure Firewall (Hub)
→ Internet

This ensures centralized inspection and aligns with enterprise network governance standards.

Terraform Design Approach
This project follows a layered Terraform structure to reflect enterprise infrastructure patterns.

Root Layer

Backend configuration
Provider configuration
Environment orchestration

Environment Layer

Development environment configuration

Module Layer

hub-network module
spoke-network module

Modules communicate using:

Input variables
Output values
Cross-module references

All infrastructure is defined as code. No manual Azure Portal configuration is required.

Project Structure
root/
│
├── environments/
│   └── dev/
│
├── modules/
│   ├── hub-network/
│   └── spoke-network/

Technologies Used

Terraform
AzureRM Provider
Azure Virtual Networks
Azure Firewall
Azure Bastion
Azure Kubernetes Service (Private Cluster)
Azure Private DNS
Azure Log Analytics

Key Engineering Concepts Demonstrated

Hub-spoke architecture implementation
Private AKS cluster networking
Centralized outbound control
Modular Terraform design
Cross-module dependency handling
Enterprise naming conventions
Infrastructure validation using terraform plan

Deployment Status

The full architecture is defined and validated using Terraform plan.
No resources are deployed by default in order to avoid unnecessary cloud costs.

Author

Azure Solutions Architect specializing in:
Enterprise Azure networking
AKS platform architecture
Terraform-based infrastructure automation

![AKS Enterprise Baseline](./images/aks-baseline-architecture.svg)