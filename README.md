# GCP Infrastructure as Code

Infraestrutura completa e production-ready para Google Cloud Platform implementada com Terraform. Este projeto demonstra boas práticas de Infrastructure as Code (IaC) para ambientes de produção no GCP.

## Objetivo

Este projeto fornece uma infraestrutura completa e modular que inclui:
- VPC multi-region com subnets privadas e públicas
- Cluster GKE (Google Kubernetes Engine) com node pools configuráveis
- Cloud SQL (PostgreSQL) com backups automáticos e alta disponibilidade
- Cloud Load Balancing global com Cloud CDN
- Cloud Storage buckets para armazenamento
- Cloud IAM com roles e service accounts seguindo princípio de menor privilégio
- Cloud Armor para proteção contra ataques DDoS e WAF
- Configurações separadas para múltiplos ambientes (dev, staging, production)

## Arquitetura

A infraestrutura é organizada em módulos reutilizáveis:

- **VPC Module**: Rede virtual com subnets, NAT Gateway, Cloud Router
- **GKE Module**: Cluster Kubernetes com node pools, auto-scaling
- **Cloud SQL Module**: Banco de dados gerenciado com backups e replicação
- **Load Balancer Module**: Load balancer global com health checks e CDN
- **Storage Module**: Buckets Cloud Storage com versionamento e lifecycle policies
- **IAM Module**: Service accounts e roles customizadas

## Pré-requisitos

- Conta Google Cloud Platform ativa com billing habilitado
- Google Cloud SDK (gcloud) instalado e configurado
- Terraform >= 1.0 instalado
- Permissões necessárias no GCP:
  - Owner ou Editor + Security Admin
  - Service Usage Admin
  - Kubernetes Engine Admin
  - Cloud SQL Admin

## Estrutura do Projeto

```
gcp-iac-terraform/
├── README.md
├── LICENSE
├── .gitignore
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── backend.tf.example
│   ├── modules/
│   │   ├── vpc/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── gke/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── cloud-sql/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── load-balancer/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── storage/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   └── iam/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   └── environments/
│       ├── dev/
│       │   ├── main.tf
│       │   └── terraform.tfvars
│       ├── staging/
│       │   ├── main.tf
│       │   └── terraform.tfvars
│       └── prod/
│           ├── main.tf
│           └── terraform.tfvars
├── .github/
│   └── workflows/
│       └── terraform-ci.yml
└── docs/
    └── architecture.md
```

## Instalação Rápida

### 1. Configurar Backend do Terraform

Crie um bucket Cloud Storage para armazenar o state do Terraform:

```bash
gsutil mb -p seu-project-id -l us-central1 gs://terraform-state-bucket
gsutil versioning set on gs://terraform-state-bucket
```

Copie e configure o backend:
```bash
cd terraform
cp backend.tf.example backend.tf
# Edite backend.tf com seu bucket
```

### 2. Configurar Variáveis

Escolha um ambiente e configure as variáveis:
```bash
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com seus valores
```

### 3. Aplicar Infraestrutura

```bash
terraform init
terraform plan
terraform apply
```

## Uso por Ambiente

### Desenvolvimento
```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

### Staging
```bash
cd terraform/environments/staging
terraform init
terraform plan
terraform apply
```

### Produção
```bash
cd terraform/environments/prod
terraform init
terraform plan  # Sempre revise cuidadosamente!
terraform apply
```

## Módulos Disponíveis

### VPC Module

Cria uma VPC com subnets, NAT Gateway e Cloud Router:

```hcl
module "vpc" {
  source = "../../modules/vpc"
  
  project_id   = var.project_id
  region       = var.region
  network_name = "production-vpc"
  
  subnets = [
    {
      name          = "subnet-1"
      ip_cidr_range = "10.0.1.0/24"
      region        = "us-central1"
    }
  ]
}
```

### GKE Module

Provisiona um cluster Kubernetes:

```hcl
module "gke" {
  source = "../../modules/gke"
  
  project_id   = var.project_id
  region       = var.region
  cluster_name = "production-cluster"
  network      = module.vpc.network_name
  subnetwork   = module.vpc.subnet_names[0]
  
  node_pools = [
    {
      name         = "default-pool"
      machine_type = "e2-medium"
      min_count    = 1
      max_count    = 5
    }
  ]
}
```

### Cloud SQL Module

Cria instância de banco de dados:

```hcl
module "cloud_sql" {
  source = "../../modules/cloud-sql"
  
  project_id       = var.project_id
  region           = var.region
  instance_name    = "production-db"
  database_version = "POSTGRES_14"
  tier             = "db-n1-standard-2"
  
  backup_enabled   = true
  backup_start_time = "03:00"
}
```

## Segurança

### IAM

- Service accounts com permissões mínimas necessárias
- Roles customizadas seguindo princípio de menor privilégio
- Separação de permissões por ambiente

### Rede

- Subnets privadas para recursos internos
- NAT Gateway para acesso à internet sem IPs públicos
- Cloud Armor configurado para proteção

### Secrets

- Uso do Secret Manager para credenciais sensíveis
- Rotação automática de chaves quando possível

## CI/CD

O projeto inclui GitHub Actions para:
- Validação de sintaxe Terraform
- Formatação automática
- Plan em pull requests
- Aplicação automática em merge para dev (opcional)

## Custos Estimados

Custos mensais aproximados (varia por uso e região):
- VPC: Gratuito
- GKE: ~$73/mês (cluster mínimo com 3 nodes e2-medium)
- Cloud SQL: ~$100/mês (db-n1-standard-2)
- Load Balancer: ~$18/mês (base) + tráfego
- Cloud Storage: ~$0.02/GB/mês

## Troubleshooting

### Erro de permissões
Verifique se a conta tem as permissões necessárias:
```bash
gcloud projects get-iam-policy seu-project-id
```

### Erro ao criar GKE
Certifique-se de que a API do Kubernetes Engine está habilitada:
```bash
gcloud services enable container.googleapis.com
```

### State lock
Se o state estiver travado:
```bash
terraform force-unlock LOCK_ID
```

## Documentação Adicional

Consulte `docs/architecture.md` para:
- Diagramas de arquitetura
- Decisões de design
- Guias de troubleshooting detalhados

## Boas Práticas Implementadas

1. **Módulos reutilizáveis**: Código DRY e reutilizável
2. **Separação de ambientes**: Configurações isoladas por ambiente
3. **State remoto**: State armazenado no Cloud Storage
4. **Versionamento**: Controle de versão de toda infraestrutura
5. **Documentação**: README e arquitetura documentados
6. **Validação**: CI/CD com validação automática

## Contribuindo

Contribuições são bem-vindas. Por favor:
1. Faça fork do projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Abra um Pull Request

## Licença

MIT License - veja o arquivo LICENSE para detalhes.

## Autor

Criado como exemplo de implementação de Infrastructure as Code no GCP para fins educacionais e de referência.

