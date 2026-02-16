# Terraform Azure Infrastructure – Modular, Production-Ready Deployment

This repository contains a fully modular, production-grade Terraform configuration for deploying a complete Microsoft Azure environment.

The design focuses on:

- Scalability  
- Reusability  
- Security  
- Clean architecture  

It follows patterns commonly used by senior cloud engineers in enterprise environments.

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

The architecture can easily be extended to support multi-environment deployments (dev / staging / prod).

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

---

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
│   ├── vm/
│   ├── keyvault/
│   ├── monitoring/
│   └── loadbalancing/
│
└── README.md
```

---

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
````
No secrets are stored in Terraform code
SSH keys are loaded from local files
Managed identities are used instead of service principals
Tags are applied consistently for cost management and governance
