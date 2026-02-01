#!/bin/bash

# 停止所有相關的容器
echo "🛑 停止現有的 MLflow 容器..."
docker-compose --profile postgresql down 2>/dev/null || true
docker-compose --profile sqlite down 2>/dev/null || true

# 啟動 PostgreSQL 版本的 MLflow
echo "🚀 啟動 MLflow Server (PostgreSQL 版本)..."
echo "📦 啟動 PostgreSQL 資料庫..."
echo "🔨 建置 MLflow Server 映像檔（包含 PostgreSQL 驅動）..."
docker-compose --profile postgresql up -d --build

# 等待資料庫啟動
echo "⏳ 等待 PostgreSQL 資料庫啟動..."
sleep 5

# 檢查服務狀態
if docker ps | grep -q mlflow_db && docker ps | grep -q mlflow_server_postgres; then
    echo "✅ MLflow Server (PostgreSQL) 已成功啟動！"
    echo "👉 請打開瀏覽器查看: http://localhost:5000"
    echo ""
    echo "📊 查看日誌: docker-compose --profile postgresql logs -f"
    echo "🛑 停止服務: docker-compose --profile postgresql down"
    echo ""
    echo "💡 PostgreSQL 連線資訊:"
    echo "   Host: localhost"
    echo "   Port: 5432"
    echo "   Database: mlflow_db"
    echo "   User: mlflow_user"
    echo "   Password: mlflow_password"
else
    echo "❌ MLflow Server 啟動失敗，請檢查日誌:"
    docker-compose --profile postgresql logs
fi
