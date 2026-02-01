# mlflow-docker-simple

一個使用 Docker 和 Poetry 的 MLflow 簡單範例專案，展示如何使用 MLflow 追蹤 XGBoost 機器學習實驗。

## 📋 專案簡介

這個專案提供了一個完整的 MLflow 實驗追蹤環境，包含：
- Docker Compose 啟動的 MLflow 伺服器
- Poetry 管理的 Python 依賴
- XGBoost 模型訓練範例
- 自動化的實驗追蹤和模型記錄

## ✨ 功能特色

- 🐳 **Docker 化部署**：使用 Docker Compose 快速啟動 MLflow 伺服器
- 📦 **Poetry 依賴管理**：使用 Poetry 管理 Python 套件
- 🤖 **XGBoost 整合**：展示 XGBoost 模型訓練與 MLflow 自動記錄
- 📊 **實驗追蹤**：自動記錄模型參數、指標和 artifacts
- 💾 **雙資料庫支援**：支援 SQLite（開發）和 PostgreSQL（生產）兩種模式
- 🔧 **完全自包含**：包含 PostgreSQL 資料庫，無需外部依賴

## 🛠️ 技術棧

- **MLflow**: 3.9.0
- **XGBoost**: >=3.1.3
- **scikit-learn**: >=1.8.0
- **Python**: >=3.12
- **Poetry**: 依賴管理工具

## 📁 專案結構

```
mlflow-docker-simple/
├── mlflow_server/          # MLflow Server Dockerfile
│   └── Dockerfile          # 包含 PostgreSQL 驅動的 MLflow 映像檔
├── docker-compose.yml      # MLflow 伺服器配置（支援 SQLite/PostgreSQL）
├── pyproject.toml          # Poetry 依賴配置
├── poetry.lock             # 鎖定的依賴版本
├── train.py                # XGBoost 訓練腳本
├── main.py                 # 主程式（範例）
├── run_sqlite.sh           # 啟動 SQLite 版本的腳本（Linux/Mac）
├── run_postgresql.sh       # 啟動 PostgreSQL 版本的腳本（Linux/Mac）
├── run_sqlite.ps1          # 啟動 SQLite 版本的腳本（Windows）
├── run_postgresql.ps1      # 啟動 PostgreSQL 版本的腳本（Windows）
├── mlflow_data/            # MLflow 資料目錄
│   ├── artifacts/          # 模型 artifacts
│   └── mlflow.db           # SQLite 資料庫（SQLite 模式使用）
├── .gitignore              # Git 忽略檔案
└── README.md               # 專案說明文件
```

## 🚀 快速開始

### 前置需求

- Docker 和 Docker Compose
- Poetry（Python 套件管理工具）
- Python >= 3.12

### 安裝步驟

1. **安裝 Poetry**（如果尚未安裝）：
   ```bash
   # Windows (PowerShell)
   (Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -
   ```

2. **安裝專案依賴**：
   ```bash
   poetry install
   ```

3. **啟動 MLflow 伺服器**（選擇一種模式）：

   **SQLite 模式（適合開發測試）**：
   ```bash
   # Windows
   .\run_sqlite.ps1
   
   # Linux/Mac
   chmod +x run_sqlite.sh
   ./run_sqlite.sh
   ```

   **PostgreSQL 模式（適合生產環境）**：
   ```bash
   # Windows
   .\run_postgresql.ps1
   
   # Linux/Mac
   chmod +x run_postgresql.sh
   ./run_postgresql.sh
   ```

4. **執行訓練腳本**：
   ```bash
   poetry run python train.py
   ```

5. **查看 MLflow UI**：
   打開瀏覽器訪問 http://localhost:5000

## 📖 使用說明

### 選擇資料庫模式

本專案支援兩種資料庫模式：

- **SQLite 模式**：適合開發和測試，無需額外資料庫服務，啟動快速
- **PostgreSQL 模式**：適合生產環境，提供更好的並發性能和資料持久化

### 啟動 MLflow 伺服器

#### 方式一：使用腳本（推薦）

**SQLite 模式**：
```bash
# Windows
.\run_sqlite.ps1

# Linux/Mac
./run_sqlite.sh
```

**PostgreSQL 模式**：
```bash
# Windows
.\run_postgresql.ps1

# Linux/Mac
./run_postgresql.sh
```

#### 方式二：手動使用 docker-compose

**SQLite 模式**：
```bash
# 啟動服務（背景執行）
docker-compose --profile sqlite up -d

# 查看日誌
docker-compose --profile sqlite logs -f

# 停止服務
docker-compose --profile sqlite down
```

**PostgreSQL 模式**：
```bash
# 啟動服務（包含建置 Dockerfile）
docker-compose --profile postgresql up -d --build

# 查看日誌
docker-compose --profile postgresql logs -f

# 停止服務
docker-compose --profile postgresql down
```

### 執行訓練

```bash
# 使用 Poetry 執行訓練腳本
poetry run python train.py
```

訓練腳本會：
- 載入糖尿病資料集（sklearn 內建）
- 訓練 XGBoost 回歸模型
- 自動記錄模型參數、指標和模型檔案到 MLflow
- 計算並記錄 R2 Score

### 查看實驗結果

1. 打開瀏覽器訪問 http://localhost:5000
2. 在 MLflow UI 中查看：
   - 實驗列表
   - 模型參數
   - 訓練指標
   - 模型 artifacts

## 🔧 配置說明

### Docker Compose 配置

MLflow 伺服器配置在 `docker-compose.yml` 中：

**SQLite 模式**：
- **Port**: 5000
- **Backend Store**: SQLite (`./mlflow_data/mlflow.db`)
- **Artifact Root**: `./mlflow_data/artifacts`
- **Image**: `ghcr.io/mlflow/mlflow:v3.9.0`

**PostgreSQL 模式**：
- **Port**: 5000
- **Backend Store**: PostgreSQL (`postgresql://mlflow_user:mlflow_password@db:5432/mlflow_db`)
- **Artifact Root**: `./mlflow_data/artifacts`
- **Image**: 自建 Dockerfile（包含 `psycopg2-binary` 驅動）
- **PostgreSQL Port**: 5432（可選，用於外部工具連線）

### MLflow Server Dockerfile

`mlflow_server/Dockerfile` 基於官方 MLflow 映像檔，額外安裝了 `psycopg2-binary` 以支援 PostgreSQL 連線。首次使用 PostgreSQL 模式時會自動建置此映像檔。

### MLflow 追蹤 URI

訓練腳本預設連接到 `http://localhost:5000`，可在 `train.py` 中修改：

```python
mlflow.set_tracking_uri("http://localhost:5000")
```

**注意**：無論使用 SQLite 還是 PostgreSQL 模式，Client 端都透過 HTTP 連接到 MLflow Server，因此 `train.py` 無需修改。

## 📝 範例程式碼

`train.py` 展示了基本的 MLflow 使用方式：

```python
# 設定 MLflow 連線
mlflow.set_tracking_uri("http://localhost:5000")
mlflow.set_experiment("Poetry_XGBoost_Demo")

# 啟動實驗追蹤
with mlflow.start_run():
    # 啟用 XGBoost 自動記錄
    mlflow.xgboost.autolog()
    
    # 訓練模型
    model = xgb.XGBRegressor(**params)
    model.fit(X_train, y_train, eval_set=[(X_test, y_test)])
    
    # 記錄自訂指標
    mlflow.log_metric("test_r2_score", r2)
```

## 🐛 疑難排解

### MLflow 伺服器無法連接

- 確認 Docker 容器正在運行：
  - SQLite: `docker-compose --profile sqlite ps`
  - PostgreSQL: `docker-compose --profile postgresql ps`
- 檢查端口 5000 是否被占用
- 查看容器日誌：
  - SQLite: `docker-compose --profile sqlite logs mlflow-sqlite`
  - PostgreSQL: `docker-compose --profile postgresql logs mlflow-postgres`

### PostgreSQL 連線問題

- 確認 PostgreSQL 容器已啟動：`docker ps | grep mlflow_db`
- 檢查 PostgreSQL 日誌：`docker-compose --profile postgresql logs db`
- 確認 MLflow Server 映像檔已正確建置（包含 psycopg2-binary）
- 首次使用需加上 `--build` 參數：`docker-compose --profile postgresql up -d --build`

### Poetry 安裝失敗

- 確認 Python 版本 >= 3.12
- 嘗試清除 Poetry 快取：`poetry cache clear pypi --all`

### 訓練腳本執行錯誤

- 確認已安裝所有依賴：`poetry install`
- 確認 MLflow 伺服器已啟動
- 檢查 `mlflow_data` 目錄權限

## 📄 授權

此專案為範例專案，可自由使用和修改。

## 👤 作者

kirin (kirin.chen1001@gmail.com)

## 🔗 相關資源

- [MLflow 官方文件](https://mlflow.org/docs/latest/index.html)
- [XGBoost 文件](https://xgboost.readthedocs.io/)
- [Poetry 文件](https://python-poetry.org/docs/)
