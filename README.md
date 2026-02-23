# Terraform Azure Infrastructure – Modular, Production-Ready Deployment

This repository contains a fully modular, production-grade Terraform configuration for deploying a complete Microsoft Azure environment.

The design focuses on:

- Scalability  
- Reusability  
- Security  
- Clean architecture  


The project is structured around independent Terraform modules, each responsible for a specific Azure component. The root configuration orchestrates these modules into a cohesive, maintainable infrastructure stack.

---

# High-Level Architecture

This deployment provisions a complete Azure environment consisting of:

- Virtual Network (VNet)
  - Frontend subnet
  - Backend subnet
- Network Security Groups (NSGs) with inbound and outbound rules
- Linux Virtual Machines with system-assigned managed identities
- Azure Load Balancer (Standard SKU)
  - Frontend Public IP
  - Backend pool
  - Health probe
  - HTTP load-balancing rule
  - SSH NAT rule
- Azure Key Vault with access policies for VM identities
- Log Analytics Workspace
- Diagnostic Settings for:
  - VMs
  - NSGs
  - VNet
  - Key Vault
- Remote Terraform state stored in Azure Storage  
  (`backend.tf` excluded from repository)
-Azure Container Registry (ACR)
-Azure Container Instances (ACI) with MSI-only authentication

The architecture can easily be extended to support multi-environment deployments (dev / staging / prod).

Frontend VM Configuration (Nginx + Secure Access via Load Balancer)
The frontend virtual machine is configured using a Custom Script Extension (CSE) to automatically install and configure an Nginx web server at deployment time. This ensures that the VM is fully provisioned and ready to serve HTTP traffic without requiring any manual post‑deployment steps.

Key characteristics of the frontend VM:
No public IP address  
The VM is deployed without a public IP, following Azure security best practices.
It is not directly reachable from the internet.

Inbound access only through the Load Balancer  
All external traffic flows through the Azure Standard Load Balancer, which:

exposes a public IP

forwards HTTP traffic (port 80) to the VM

performs health checks using a TCP probe

provides a secure NAT rule for SSH access (50001 → 22)

Nginx installed via Custom Script Extension  
The VM module uses a CSE to:

install Nginx

enable and start the service

ensure the server is reachable through the load balancer

This approach demonstrates a production‑ready pattern where compute resources remain private, and all ingress traffic is routed through controlled, observable, and secure entry points.

Azure Container Registry (ACR) & Azure Container Instances (ACI)
This project also includes a secure, cloud‑native container deployment using Azure Container Registry (ACR) and Azure Container Instances (ACI).
The design follows Azure best practices and uses Managed Identity (MSI) for passwordless authentication.

Overview
ACR stores Docker images for containerized workloads

ACI runs containers without managing VMs or Kubernetes

MSI allows ACI to pull images securely from ACR without passwords

This pattern integrates seamlessly with the VM-based infrastructure and demonstrates a modern, serverless compute option.


## Architecture diagram

<img width="2048" height="1056" alt="image" src="https://github.com/user-attachments/assets/c6b99b3b-002e-4348-9d23-028dd93a6bf1" />


---

# Why This Project Uses Terraform Modules

This project intentionally follows a modular Terraform design, which provides:

## Reusability

Each module is self-contained and reusable across environments or even different projects.

## Separation of Concerns

Networking, compute, security, monitoring, and load balancing are isolated into independent modules.

## Scalability

Adding new VMs, subnets, or entire environments requires minimal changes.

## Maintainability

Modules reduce duplication and improve readability and maintainability of the codebase.

## Testability

Each module can be validated and tested independently.

## GitHub-Ready Structure

The layout mirrors structures used in professional Terraform registries and open-source projects.

# Project Structure

```
.
├── env/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars (ignored)
│       ├── backend.tf (ignored)
│       └── outputs.tf
│
├── modules/
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── vm/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── keyvault/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── monitoring/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── loadbalancing/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
└── README.md
```


# Why This Structure?

- `env/dev` contains environment-specific configuration
- `modules/` contains reusable infrastructure building blocks
- The root module orchestrates the modules
- The layout supports multi-environment deployments (dev / staging / prod)
- It mirrors the structure used in professional Terraform registries

---

# Module Overview

Each module is:

- Stateless  
- Fully parameterized  
- Environment-agnostic  

---

## Network Module

### Creates

- Resource Group
- Virtual Network (VNet)
- Frontend and backend subnets
- Network Security Groups with multiple rules

### Outputs

- Subnet IDs  
- NSG IDs  
- VNet ID  
- Resource Group name  
- Location  

This module serves as the foundation for all other modules.

---

## VM Module

### Creates

- Linux Virtual Machines
- Network Interfaces (NICs)
- System-assigned managed identities

### Outputs

- VM resource IDs  
- VM identity object IDs  
- NIC IDs  

These outputs are consumed by the Key Vault and Load Balancer modules.

---

## Key Vault Module

### Creates

- Azure Key Vault
- Access policies for VM identities (dynamic `for_each`)

### Outputs

- Key Vault ID  
- Key Vault URI  

This module demonstrates proper identity-based access control using managed identities.

---

## Monitoring Module

### Creates

- Log Analytics Workspace

### Configures Diagnostic Settings For

- Virtual Machines
- Network Security Groups
- Virtual Network
- Key Vault

### Outputs

- Workspace ID  
- Workspace name  

This module ensures full observability and auditability of the environment.

---

## Load Balancing Module

### Creates

- Public IP
- Standard Load Balancer
- Backend pool
- Health probe
- HTTP rule
- SSH NAT rule
- NIC associations

### Outputs

- Public IP  
- Backend pool ID  
- Load Balancer ID  

This module demonstrates proper LB configuration with NAT and backend pools.

---

# Security Considerations

- `terraform.tfvars` and `backend.tf` are intentionally excluded from version control
- No secrets are stored in Terraform code
- SSH keys are loaded from local files
- Managed identities are used instead of service principals
- Tags are applied consistently for cost management and governance

---

# Summary

This project demonstrates a production-grade, modular Terraform architecture for Azure infrastructure.

It follows best practices in:

- Infrastructure design  
- Security  
- Observability  
- Scalability  
- Code organization  

The structure is suitable for real-world enterprise deployments and can easily be extended to support additional environments, services, or advanced networking patterns.

No secrets are stored in Terraform code
SSH keys are loaded from local files
Managed identities are used instead of service principals
Tags are applied consistently for cost management and governance


# Future Enhancements Roadmap

This project forms a solid foundation for secure VM-based infrastructure. Below are potential future improvements that can evolve the environment toward a more scalable, secure, and cloud-native platform.

---

## 🔐 Security & Access

- Integrate Azure Bastion to remove public SSH exposure entirely  
- Enable Just-In-Time VM Access for time-bound administrative access  
- Replace Key Vault access policies with RBAC-based access control  
- Add Private Endpoints for Key Vault, Storage, and other services  

---

## 🌐 Networking & Traffic Management

- Introduce Application Gateway with WAF for Layer 7 routing and protection  
- Implement Hub-and-Spoke architecture for enterprise-grade network segmentation  
- Add Azure Firewall for outbound filtering and threat protection  

---

## 📊 Monitoring & Reliability

- Add Azure Monitor Alerts (CPU, disk, LB health, VM availability)  
- Enable VM Insights for deep performance analytics  
- Create Log Analytics dashboards for operational visibility  

---

## ⚙️ Automation & Scalability

- Replace standalone VMs with Virtual Machine Scale Sets (VMSS)  
- Add Autoscaling rules based on CPU or HTTP load  
- Introduce Packer for building hardened custom VM images  

---

## ☁️ Cloud-Native Evolution

- Add Azure Kubernetes Service (AKS) for containerized workloads  
- Deploy Azure Functions for serverless automation  
- Integrate Azure SQL or PostgreSQL Flexible Server for managed data services  

---

This roadmap outlines a natural progression from a secure VM-based baseline toward a fully cloud-native, enterprise-grade Azure architecture.
```

