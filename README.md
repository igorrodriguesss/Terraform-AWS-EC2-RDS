
# Terraform AWS EC2 + RDS

Projeto de estudo que provisiona uma infraestrutura completa na AWS — VPC, EC2 e RDS (MySQL) — usando **Terraform** para a infraestrutura e **Ansible** para configuração e deploy da aplicação. O objetivo central é validar a comunicação entre uma instância EC2 e um banco RDS dentro de uma rede segmentada (subnets públicas e privadas), com um pipeline de CI/CD automatizando todo o processo.

![Arquitetura do projeto](terraform/images/Projeto.png)

## Arquitetura

- **VPC** com subnet pública (EC2) e duas subnets privadas (RDS, multi-AZ)
- **Internet Gateway** + route table para saída da subnet pública
- **EC2** rodando uma aplicação Flask, em subnet pública, acessível via SSH e HTTP na porta 8080
- **RDS MySQL** em subnet privada, acessível apenas pela EC2
- **ECR** (Elastic Container Registry) para armazenar a imagem Docker da aplicação
- **GitHub Actions** orquestrando Terraform (infra) → build/push da imagem para o ECR → Ansible (deploy na EC2)

## Estrutura do repositório

```
.
├── .github/workflows/
│   └── pipeline.yml          # Pipeline de CI/CD (Terraform + Docker/ECR + Ansible)
├── ansible/
│   ├── deploy.yml            # Playbook principal (packages → db → app)
│   ├── hosts.ini             # Inventory da EC2
│   └── roles/
│       ├── packages/         # Instala dependências de sistema e libs Python
│       ├── db/                # Cria banco e tabela no RDS
│       └── app/               # Baixa, extrai e sobe a aplicação Flask (systemd)
├── app/
│   ├── app.py                 # Aplicação Flask (CRUD de usuários)
│   ├── requirements.txt
│   ├── dockerfile
│   ├── static/style.css
│   └── templates/              # index.html, add.html, edit.html
├── terraform/
│   ├── provider.tf             # Provider AWS + backend remoto (S3)
│   ├── variables.tf            # Variáveis do projeto
│   ├── modules.tf              # Chamada dos módulos (network, ec2_instance, database)
│   ├── ecr.tf                  # Repositório ECR
│   └── modules/
│       ├── network/            # VPC, subnets, route tables, IGW
│       ├── ec2_instance/       # EC2, key pair, security group
│       └── database/           # RDS, subnet group, security group
└── dockerfile
```

## Stack

- **Terraform** `6.54.0` (provider AWS)
- **Ansible** (playbooks + roles)
- **Python 3 / Flask 2.3.3** + **PyMySQL**
- **MySQL 8.0** (RDS)
- **Docker** + **Amazon ECR**
- **GitHub Actions** (CI/CD)

## Pré-requisitos

- Conta AWS com credenciais configuradas
- Terraform instalado (`>= 1.x`)
- Ansible instalado na máquina que vai orquestrar o deploy
- Par de chaves SSH gerado localmente (referenciado em `terraform/modules/ec2_instance/keypair.tf`)
- Bucket S3 já existente para o backend remoto do state (`igorrodriguesss-us-east-1-terraform-statefile`, configurável em `provider.tf`)

## Como rodar

### 1. Provisionar a infraestrutura

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Isso cria a VPC, subnets, EC2, RDS e o repositório ECR.

### 2. Configurar o inventory do Ansible

Edite `ansible/hosts.ini` com o IP público da EC2 recém-criada:

```ini
[ec2]
<IP_DA_EC2> ansible_user=ubuntu ansible_ssh_private_key_file=<caminho-da-sua-chave>
```

### 3. Rodar o playbook

```bash
ansible-playbook -i ansible/hosts.ini ansible/deploy.yml
```

O playbook executa, em ordem:
1. **packages** — instala dependências de sistema (build tools, driver MySQL) e libs Python
2. **db** — cria o banco `mydatabase` e a tabela `users` no RDS
3. **app** — baixa a aplicação, cria o virtualenv, instala dependências e sobe a Flask app via `systemd` (porta 8080)

## CI/CD

O workflow em `.github/workflows/pipeline.yml` roda a cada push na branch `main` e executa três jobs em sequência:

1. **terraform** — aplica a infraestrutura (`terraform apply -auto-approve`)
2. **build-and-push** — builda a imagem Docker da aplicação e sobe para o ECR
3. **deploy** — instala o Ansible no runner e executa o playbook de deploy na EC2

Secrets necessários no repositório (**Settings → Secrets and variables → Actions**):
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## Pontos de atenção / possíveis evoluções

Como é um projeto de estudo focado na comunicação EC2 ↔ RDS, alguns pontos ficaram simplificados de propósito e valem como próximos passos:

- **Credenciais do banco**: hoje estão hardcoded em `app/app.py` e nas tasks do Ansible. Em um cenário real, migrar para variáveis de ambiente e/ou **Ansible Vault** / **AWS Secrets Manager**.
- **Security Groups abertos**: as regras de entrada (SSH, 8080, 3306) liberam `0.0.0.0/0`. Vale restringir a IPs específicos.
- **RDS multi-AZ**: está habilitado (`multi_az = true`), o que é ótimo para alta disponibilidade, mas aumenta custo — considerar `false` para ambientes de estudo.
- **Deploy via systemd vs. Docker**: o job de CI já builda e sobe a imagem para o ECR, mas o playbook `app` ainda faz deploy via zip + venv + systemd. Unificar esse fluxo (Ansible puxando a imagem do ECR e rodando via Docker) deixaria o pipeline mais consistente ponta a ponta.

## Licença

Projeto pessoal de estudo, sem licença específica definida.
