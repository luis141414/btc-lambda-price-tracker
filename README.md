# 🚀 BTC Lambda Price Tracker

Infraestructura **serverless** con AWS y Terraform para guardar el precio del Bitcoin **cada hora** en un bucket S3, usando:

- 🐍 Una Lambda escrita en Python  
- 🌐 La API de CoinGecko  
- ⏰ EventBridge para la programación (cron)  
- ☁️ S3 como almacenamiento  
- 🛠️ Terraform para desplegar todo en segundos

---

## 🧰 Tecnologías usadas

- **AWS Lambda**
- **Amazon S3**
- **Amazon EventBridge**
- **Terraform**
- **Python 3.9**
- **CoinGecko API**

---

## 📦 Estructura

```
btc-lambda-price-tracker/
├── price_checker.py      # Código de la Lambda
├── zip_lambda.sh         # Script para empaquetar en ZIP
├── lambda.zip            # Archivo generado (ignorado en .gitignore)
├── main.tf               # Infraestructura en Terraform
├── variables.tf          # Variables de configuración
└── outputs.tf            # Outputs útiles
```

---

## ⚙️ Despliegue

### 1. Prepara tu entorno

- Tener [Terraform](https://developer.hashicorp.com/terraform/downloads) instalado  
- Configura tu perfil de AWS con permisos suficientes (Lambda, S3, IAM, EventBridge)

```bash
aws configure --profile terraform-user
```

### 2. Empaqueta la Lambda

```bash
./zip_lambda.sh
```

### 3. Despliega con Terraform

```bash
AWS_PROFILE=terraform-user terraform init
AWS_PROFILE=terraform-user terraform apply
```

---

## 🧐 ¿Qué hace exactamente?

Cada hora:

1. EventBridge lanza automáticamente la función Lambda
2. La Lambda obtiene el precio actual del BTC desde CoinGecko
3. Guarda un JSON con el `timestamp` y el `price_usd` en un bucket S3

---

## 📂 Ejemplo de archivo en S3

```json
{
  "timestamp": "2025-04-15T22:03:07.357376",
  "price_usd": 84114
}
```


