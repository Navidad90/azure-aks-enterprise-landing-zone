Azure Enterprise AKS Landing Zone (Hub-Spoke Architecture):

This project implements an enterprise-grade Azure AKS landing zone using Terraform, based on Microsoft’s hub-and-spoke reference architecture.

The goal of this project is to demonstrate real-world Azure platform engineering practices including:

Hub-spoke networking

Centralized egress through Azure Firewall

Private AKS cluster deployment

Private DNS integration

Network security segmentation

Monitoring integration with Log Analytics

Infrastructure modularization using Terraform


Architecture Overview:
Hub (Shared Services)

Virtual Network (10.0.0.0/16)

Azure Firewall

Azure Bastion

Gateway Subnet (reserved)

Log Analytics Workspace

Private DNS Zone for AKS

VNet Peering

Spoke (Workload Landing Zone)

Virtual Network (10.1.0.0/16)

AKS Nodes Subnet

Ingress Subnet

Private Endpoint Subnet

API Server Subnet

Network Security Group

Route Table (forced egress to Firewall)

Private AKS Cluster

Connectivity

Bidirectional VNet peering

Centralized outbound routing

DNS zone linked to both Hub and Spoke

Networking Design

Traffic Flow:

AKS Subnet
→ Route Table
→ Azure Firewall (Hub)
→ Internet

This enforces centralized inspection and aligns with enterprise network governance patterns.

Terraform Design Approach

This project follows a layered Terraform structure:

Root Layer

Backend configuration

Provider configuration

Environment orchestration

Environment Layer

Dev environment configuration

Module Layer

hub-network module

spoke-network module

Modules communicate using:

Input variables

Output values

Cross-module references

No manual Azure Portal configuration is required.

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

Azure Kubernetes Service (Private)

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

This project is fully defined and validated using Terraform plan.

No resources are deployed by default in order to avoid unnecessary cloud cost.

Author

Azure Solutions Architect
Specializing in:

Enterprise Azure networking

AKS platform architecture

Terraform-based infrastructure automation

![AKS Enterprise Baseline](./images/aks-baseline-architecture.svg)