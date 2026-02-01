# PowerShell script to run MLflow with SQLite

Write-Host "🛑 停止現有的 MLflow 容器..." -ForegroundColor Yellow
docker-compose --profile postgresql down 2>$null
docker-compose --profile sqlite down 2>$null

# 啟動 SQLite 版本的 MLflow
Write-Host "🚀 啟動 MLflow Server (SQLite 版本)..." -ForegroundColor Green
docker-compose --profile sqlite up -d

# 等待服務啟動
Start-Sleep -Seconds 2

# 檢查服務狀態
$containerRunning = docker ps | Select-String -Pattern "mlflow_server_sqlite"
if ($containerRunning) {
    Write-Host "✅ MLflow Server (SQLite) 已成功啟動！" -ForegroundColor Green
    Write-Host "👉 請打開瀏覽器查看: http://localhost:5000" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📊 查看日誌: docker-compose --profile sqlite logs -f" -ForegroundColor Yellow
    Write-Host "🛑 停止服務: docker-compose --profile sqlite down" -ForegroundColor Yellow
} else {
    Write-Host "❌ MLflow Server 啟動失敗，請檢查日誌:" -ForegroundColor Red
    docker-compose --profile sqlite logs
}
