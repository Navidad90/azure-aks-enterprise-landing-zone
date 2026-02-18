# Enterprise Azure AKS Landing Zone (Hub & Spoke) – Terraform

## Overview

This project implements a production-grade Azure enterprise landing zone using Terraform.  

It delivers a secure, scalable, governance-aligned Hub-and-Spoke architecture designed to host a private AKS platform with enterprise networking, monitoring, security controls, and policy enforcement.

This is not a lab setup.  
This reflects real-world enterprise Azure architecture patterns.

---

##  Architecture Summary

### Hub (Shared Services)

- Azure Virtual Network (10.0.0.0/16)
- Azure Firewall (Standard)
- Firewall Policy + Rule Collection Groups
- DDoS Protection Plan
- VPN Gateway (Route-based)
- Azure Bastion
- Private DNS Zones:
  - privatelink.westeurope.azmk8s.io
  - privatelink.azurecr.io
  - privatelink.vaultcore.azure.net
- Log Analytics Workspace
- Network Watcher
- NSG Flow Logs + Traffic Analytics
- Custom Azure Policy (Deny Public IP in Spoke)

---

### Spoke (AKS Platform)

- Virtual Network (10.1.0.0/16)
- Dedicated subnets:
  - AKS Nodes
  - AKS API (Private)
  - Ingress
  - Private Endpoints
  - Application Gateway
- Private AKS Cluster
- Azure Container Registry (Premium) + Private Endpoint
- Key Vault (RBAC enabled) + Private Endpoint
- Application Gateway (WAF_v2) integrated with Key Vault certificate
- Route tables forwarding traffic through Azure Firewall
- NSG with flow logging enabled

---

##  Security Design

- AKS deployed as **Private Cluster**
- No public exposure of control plane
- Azure Firewall as central egress control
- DDoS protection enabled at VNet level
- WAF (OWASP 3.2) in Prevention mode
- Private Endpoints for ACR and Key Vault
- NSG Flow Logs + Traffic Analytics enabled
- Subscription-level policy denying Public IP creation in Spoke resource group
- RBAC enabled for Key Vault
- Managed Identity for Application Gateway to access certificates

---

##  Network Topology

Hub ↔ Spoke peering with:

- Allow forwarded traffic
- Centralized firewall routing
- Private DNS resolution from Hub to Spoke

All internet-bound traffic from Spoke subnets routes through Azure Firewall.

---

##  Observability

- Log Analytics Workspace
- Firewall diagnostics enabled
- VPN Gateway diagnostics enabled
- Bastion diagnostics enabled
- NSG Flow Logs enabled
- Traffic Analytics configured

---

##  Repository Structure

weu-aks-enterprise-baseline/
│
├── modules/
│ ├── hub-network/
│ └── spoke-network/
│
├── environments/
│ └── dev/
│
└── README.md


Modules are fully reusable and environment-agnostic.

---

##  Deployment

### Prerequisites

- Azure CLI
- Terraform >= 1.5
- Contributor access to subscription

### Initialize

```bash
terraform init
Plan
terraform plan -out final.plan
Apply
terraform apply final.plan

Design Decisions
Hub-and-Spoke chosen for centralized security and scalability

Firewall-based egress control over NAT Gateway for policy enforcement

Private AKS for production security posture

Policy-as-Code integrated into Terraform

Flow logs and diagnostics enforced at baseline level

WAF integrated via Key Vault certificate for TLS termination

Key Competencies Demonstrated
Enterprise Azure Networking

Terraform modular design

Infrastructure as Code best practices

Secure AKS platform engineering

Azure Firewall & Policy design

Private Link & DNS architecture

Identity & RBAC integration

Observability implementation

Governance controls

Future Enhancements
Azure Firewall Premium (TLS inspection)

Azure Policy initiative bundles

Terraform remote backend with state locking

CI/CD pipeline integration

Workload Identity for AKS

Production / Staging environment separation

Author
Navid
Azure Solutions Architect
Enterprise Cloud & Security Architecture
