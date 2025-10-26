#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Converted from Jupyter Notebook: notebook.ipynb
Conversion Date: 2025-10-26T11:46:10.578Z
"""

### 📦 Step 1: Import Libraries & Upload Dataset
import pandas as pd
import numpy as np
import os
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LogisticRegression
from sklearn.calibration import CalibratedClassifierCV
from sklearn.metrics import classification_report, roc_auc_score, roc_curve
import joblib
from google.colab import files

# STEP 2: Upload dataset (CSV file)
print("📤 Please upload your e-commerce dataset CSV file...")
uploaded = files.upload()

# Get filename dynamically
for filename in uploaded.keys():
    DATA_PATH = filename

print(f"✅ File uploaded: {DATA_PATH}")

### 🧹 Step 2: Data Cleaning & Feature Engineering
# Create output directory
OUTPUT_DIR = "output"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# Load data
df = pd.read_csv(DATA_PATH)
print("Loaded data shape:", df.shape)
print("Columns:", df.columns.tolist())

# Ensure Return_Flag column exists and is numeric
if 'Return_Flag' not in df.columns:
    raise ValueError("Dataset must contain a 'Return_Flag' column (0 = not returned, 1 = returned)")
df['Return_Flag'] = df['Return_Flag'].astype(int)

# Drop duplicates
df.drop_duplicates(inplace=True)

# Handle missing important fields
critical_cols = ['Order_ID', 'Product_ID', 'Price', 'Return_Flag']
df = df.dropna(subset=[c for c in critical_cols if c in df.columns])

# Convert Order_Date to datetime
if 'Order_Date' in df.columns:
    df['Order_Date'] = pd.to_datetime(df['Order_Date'], errors='coerce')
    df['Order_Month'] = df['Order_Date'].dt.month
    df['Order_DayOfWeek'] = df['Order_Date'].dt.dayofweek

# Example derived features
if 'Price' in df.columns:
    df['Price'] = pd.to_numeric(df['Price'], errors='coerce').fillna(df['Price'].median())
    df['High_Price_Flag'] = (df['Price'] > df['Price'].quantile(0.75)).astype(int)

if 'Delivery_Issue' in df.columns:
    df['Delivery_Issue_Flag'] = (df['Delivery_Issue'].astype(str).str.lower() == 'yes').astype(int)

print("✅ Data cleaned and new features created.")
df.head()

### ⚙️ Step 3: Define Feature Columns
# Define categorical and numerical columns
possible_cats = ['Product_Category', 'Vendor', 'Region', 'Customer_Segment', 'Payment_Method', 'Product_ID']
possible_nums = ['Price', 'Quantity', 'Order_Month', 'Order_DayOfWeek', 'High_Price_Flag', 'Delivery_Issue_Flag']

categorical_cols = [c for c in possible_cats if c in df.columns]
numerical_cols = [c for c in possible_nums if c in df.columns]

feature_cols = numerical_cols + categorical_cols
print("📊 Using features:")
print("Categorical:", categorical_cols)
print("Numerical:", numerical_cols)


### 🤖 Step 4: Train Logistic Regression Model
# Prepare X and y
X = df[feature_cols].copy()
y = df['Return_Flag'].copy()

# Train-test split (stratified)
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, stratify=y, random_state=42
)

# Preprocessing: OneHot + Scaling
cat_transformer = OneHotEncoder(handle_unknown='ignore')
num_transformer = Pipeline(steps=[('scaler', StandardScaler())])

preprocessor = ColumnTransformer(
    transformers=[
        ('num', num_transformer, numerical_cols),
        ('cat', cat_transformer, categorical_cols)
    ]
)

# Logistic Regression with calibration
base_clf = LogisticRegression(max_iter=200, class_weight='balanced', random_state=42)
model = Pipeline([
    ('preproc', preprocessor),
    ('clf', CalibratedClassifierCV(base_clf, cv=3, method='isotonic'))
])

# Train model
model.fit(X_train, y_train)

print("✅ Model training complete!")

# Evaluate model
y_pred = model.predict(X_test)
y_proba = model.predict_proba(X_test)[:, 1]

print("🔍 Classification Report:")
print(classification_report(y_test, y_pred))
print("ROC-AUC Score:", roc_auc_score(y_test, y_proba))

### 📈 Step 5: Save Predictions & Identify High-Risk Products
# Predict probabilities for full dataset
df['pred_prob'] = model.predict_proba(X)[:, 1]

# Define threshold for high-risk (tuneable)
RISK_THRESHOLD = 0.25
df['High_Risk_Label'] = (df['pred_prob'] >= RISK_THRESHOLD).astype(int)

# Export results
high_risk = df[df['High_Risk_Label'] == 1].copy()
high_risk.sort_values('pred_prob', ascending=False, inplace=True)

# Save output files
high_risk_file = os.path.join(OUTPUT_DIR, "high_risk_products.csv")
scored_file = os.path.join(OUTPUT_DIR, "scored_orders.csv")

high_risk.to_csv(high_risk_file, index=False)
df.to_csv(scored_file, index=False)

print("✅ Files saved:")
print("•", high_risk_file)
print("•", scored_file)

# Download files in Colab
files.download(high_risk_file)
files.download(scored_file)


### 💾 Step 6: Save Model for Future Use
# Save model pipeline for reuse
model_path = os.path.join(OUTPUT_DIR, "return_risk_model.joblib")
joblib.dump(model, model_path)
print(f"✅ Model saved to {model_path}")

# Download model file
files.download(model_path)