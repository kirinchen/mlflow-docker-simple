#!/bin/bash

# 停止所有相關的容器
echo "🛑 停止現有的 MLflow 容器..."
docker-compose --profile postgresql down 2>/dev/null || true
docker-compose --profile sqlite down 2>/dev/null || true

# 啟動 SQLite 版本的 MLflow
echo "🚀 啟動 MLflow Server (SQLite 版本)..."
docker-compose --profile sqlite up -d

# 等待服務啟動
sleep 2

# 檢查服務狀態
if docker ps | grep -q mlflow_server_sqlite; then
    echo "✅ MLflow Server (SQLite) 已成功啟動！"
    echo "👉 請打開瀏覽器查看: http://localhost:5000"
    echo ""
    echo "📊 查看日誌: docker-compose --profile sqlite logs -f"
    echo "🛑 停止服務: docker-compose --profile sqlite down"
else
    echo "❌ MLflow Server 啟動失敗，請檢查日誌:"
    docker-compose --profile sqlite logs
fi
