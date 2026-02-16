# Terraform Azure Infrastructure – Modular, Production‑Ready Deployment

This repository contains a fully modular, production‑grade Terraform configuration for deploying a complete Azure environment.
It is designed with scalability, reusability, security, and clean architecture in mind — following the same patterns used by senior cloud engineers in real‑world enterprise environments.

The project is structured around independent Terraform modules, each responsible for a separate Azure components.
The root configuration orchestrates these modules into a cohesive, maintainable infrastructure stack.

High‑Level Architecture

This deployment provisions a complete Azure environment consisting of:

Virtual Network (VNet) with frontend and backend subnets
Network Security Groups (NSGs) with inbound/outbound rules
Linux Virtual Machines with system‑assigned managed identities
Azure Load Balancer (Standard SKU)
Frontend Public IP
Backend pool
Health probe
HTTP load‑balancing rule
SSH NAT rule
Azure Key Vault with access policies for VM identities
Log Analytics Workspace

Diagnostic Settings for:

VMs
NSGs
VNet
Key Vault

Remote Terraform state stored in Azure Storage (backend.tf excluded from repo)

The architecture follows a hub‑and‑spoke‑ready pattern and can be extended to multi‑environment deployments (dev/staging/prod).

Why This Project Uses Terraform Modules
This project is intentionally built using modular Terraform design, which provides:

Reusability
Each module is self‑contained and can be reused across environments or even different projects.

Separation of concerns
Networking, compute, security, monitoring, and load balancing are isolated into their own modules.

Scalability
Adding new VMs, subnets, or environments requires minimal changes.

Maintainability
Modules reduce duplication and make the codebase easier to reason about.

Testability
Each module can be validated independently.

GitHub‑ready structure
This is the same structure used in open‑source Terraform registries.

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

Why this structure?

env/dev contains the environment‑specific configuration

modules/ contains reusable building blocks

The root module orchestrates the modules

This layout supports multi‑environment deployments (dev/staging/prod)

It mirrors the structure used in professional Terraform registries

Module Overview
Each module is designed to be stateless, parameterized, and environment‑agnostic.

Network Module
Creates:

Resource group
VNet
Frontend and backend subnets
NSGs with multiple rules

Outputs:
Subnet IDs
NSG IDs
VNet ID
Resource group name
Location

This module is the foundation for all other modules.

VM Module
Creates:

Linux VMs
NICs
System‑assigned managed identities

Outputs:
VM resource IDs
VM identity object IDs
NIC IDs

These outputs are consumed by the Key Vault and Load Balancer modules.

Key Vault Module
Creates:

Azure Key Vault
Access policies for VM identities (dynamic for_each)

Outputs:
Key Vault ID
Key Vault URI
This module demonstrates proper identity‑based access control.


Monitoring Module
Creates:

Log Analytics Workspace

Diagnostic settings for:
VMs
NSGs
VNet
Key Vault

Outputs:
Workspace ID
Workspace name

This module ensures full observability and auditability.


Load Balancing Module
Creates:

Public IP
Standard Load Balancer
Backend pool
Health probe
HTTP rule
SSH NAT rule
NIC associations

Outputs:
Public IP
Backend pool ID
Load Balancer ID

This module demonstrates proper LB configuration with NAT and backend pools.

Security Considerations
terraform.tfvars and backend.tf are intentionally excluded from version control
No secrets are stored in Terraform code
SSH keys are loaded from local files
Managed identities are used instead of service principals
Tags are applied consistently for cost management and governance
