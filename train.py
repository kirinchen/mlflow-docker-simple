import mlflow
import mlflow.xgboost
import xgboost as xgb
from sklearn.datasets import load_diabetes
from sklearn.model_selection import train_test_split
from sklearn.metrics import r2_score

# ==========================================
# 1. 設定 MLflow 連線
# ==========================================
# 指向 Docker 啟動的 Server
mlflow.set_tracking_uri("http://localhost:5000")
mlflow.set_experiment("Poetry_XGBoost_Demo")


def train():
    # ==========================================
    # 2. 準備資料
    # ==========================================
    X, y = load_diabetes(return_X_y=True, as_frame=True)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # ==========================================
    # 3. 啟動 MLflow Run
    # ==========================================
    with mlflow.start_run():
        print("🚀 [Poetry Env] 開始訓練...")

        # 開啟 XGBoost 自動紀錄
        mlflow.xgboost.autolog()

        # ==========================================
        # 4. 訓練 XGBoost 模型
        # ==========================================
        params = {
            "n_estimators": 100,
            "max_depth": 3,
            "learning_rate": 0.1,
            "subsample": 0.8,
            "early_stopping_rounds": 10
        }

        model = xgb.XGBRegressor(**params)

        model.fit(
            X_train, y_train,
            eval_set=[(X_test, y_test)],
            verbose=False
        )

        # ==========================================
        # 5. 手動補紀錄 Metric
        # ==========================================
        predictions = model.predict(X_test)
        r2 = r2_score(y_test, predictions)
        mlflow.log_metric("test_r2_score", r2)

        print(f"✅ 訓練完成！ R2 Score: {r2:.4f}")
        print("👉 請打開瀏覽器查看: http://localhost:5000")


if __name__ == "__main__":
    train()