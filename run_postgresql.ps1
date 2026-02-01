# PowerShell script to run MLflow with PostgreSQL

Write-Host "🛑 停止現有的 MLflow 容器..." -ForegroundColor Yellow
docker-compose --profile postgresql down 2>$null
docker-compose --profile sqlite down 2>$null

# 啟動 PostgreSQL 版本的 MLflow
Write-Host "🚀 啟動 MLflow Server (PostgreSQL 版本)..." -ForegroundColor Green
Write-Host "📦 啟動 PostgreSQL 資料庫..." -ForegroundColor Cyan
Write-Host "🔨 建置 MLflow Server 映像檔（包含 PostgreSQL 驅動）..." -ForegroundColor Yellow
docker-compose --profile postgresql up -d --build

# 等待資料庫啟動
Write-Host "⏳ 等待 PostgreSQL 資料庫啟動..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# 檢查服務狀態
$dbRunning = docker ps | Select-String -Pattern "mlflow_db"
$mlflowRunning = docker ps | Select-String -Pattern "mlflow_server_postgres"
if ($dbRunning -and $mlflowRunning) {
    Write-Host "✅ MLflow Server (PostgreSQL) 已成功啟動！" -ForegroundColor Green
    Write-Host "👉 請打開瀏覽器查看: http://localhost:5000" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📊 查看日誌: docker-compose --profile postgresql logs -f" -ForegroundColor Yellow
    Write-Host "🛑 停止服務: docker-compose --profile postgresql down" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "💡 PostgreSQL 連線資訊:" -ForegroundColor Cyan
    Write-Host "   Host: localhost"
    Write-Host "   Port: 5432"
    Write-Host "   Database: mlflow_db"
    Write-Host "   User: mlflow_user"
    Write-Host "   Password: mlflow_password"
} else {
    Write-Host "❌ MLflow Server 啟動失敗，請檢查日誌:" -ForegroundColor Red
    docker-compose --profile postgresql logs
}
