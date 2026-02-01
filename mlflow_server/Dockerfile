FROM ghcr.io/mlflow/mlflow:v3.9.0

# 安裝 PostgreSQL 驅動 (psycopg2-binary)
# 因為官方 Image 很精簡，這是連線 Postgres 必備的
RUN pip install psycopg2-binary

# 這裡不需設定 CMD，我們會由 docker-compose.yml 控制
