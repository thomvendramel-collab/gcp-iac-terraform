# Arquitetura do GCP Infrastructure as Code

## Visão Geral

Este documento descreve a arquitetura e decisões de design da infraestrutura implementada no Google Cloud Platform.

## Componentes Principais

### VPC (Virtual Private Cloud)

Rede virtual isolada com:
- Subnets privadas e públicas
- NAT Gateway para acesso à internet
- Cloud Router para roteamento

### GKE (Google Kubernetes Engine)

Cluster Kubernetes gerenciado com:
- Node pools configuráveis
- Auto-scaling
- Network policies habilitadas
- Private nodes (opcional)

### Cloud SQL

Banco de dados gerenciado com:
- Backups automáticos
- Alta disponibilidade (opcional)
- Point-in-time recovery
- Query insights

### Load Balancer

Load balancer global com:
- Health checks
- CDN (opcional)
- SSL/TLS (opcional)

### Cloud Storage

Buckets de armazenamento com:
- Versionamento
- Lifecycle policies
- Uniform bucket-level access

### IAM

Service accounts e roles com:
- Princípio de menor privilégio
- Roles customizadas
- Separação por ambiente

## Decisões de Design

### Por que módulos?

- Reutilização de código
- Manutenção facilitada
- Testes isolados
- Versionamento independente

### Separação de ambientes

- Configurações isoladas
- State separado
- Permissões diferentes
- Custos otimizados

## Segurança

- Private nodes no GKE
- Subnets privadas
- IAM com menor privilégio
- Secrets no Secret Manager

## Custos

- Recursos escaláveis
- Auto-scaling
- Lifecycle policies
- Otimização por ambiente

