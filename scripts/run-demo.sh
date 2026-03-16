#!/bin/bash
echo "======================================"
echo "      AI SECURITY SUITE DEMO"
echo "======================================"
echo ""

# Go to project root
cd ..

echo "Building Docker Images..."
echo "--------------------------------------"
docker build -t modelscan-container ./lightweight-tools/modelscan
docker build -t bandit-container ./lightweight-tools/bandit
docker build -t yara-container ./lightweight-tools/yara
docker build -t trivy-container ./lightweight-tools/trivy
echo ""

echo "======================================"
echo "         MODEL SCAN DEMO"
echo "======================================"
echo ""

echo "Running ModelScan - Safe Model"
docker run -it \
  -v $(pwd)/test-files/sample-models:/app \
  modelscan-container scan -p /app/safe_model.pkl

echo ""
echo "Running ModelScan - Malicious Model"
docker run -it \
  -v $(pwd)/test-files/sample-models:/app \
  modelscan-container scan -p /app/malicious_model.pkl

echo ""
echo "======================================"
echo "           BANDIT DEMO"
echo "======================================"
echo ""

echo "Running Bandit - Safe Code"
docker run -it \
  -v $(pwd)/test-files/python-code:/app \
  bandit-container /app/safe.py

echo ""
echo "Running Bandit - Vulnerable Code"
docker run -it \
  -v $(pwd)/test-files/python-code:/app \
  bandit-container /app/vulnerable.py

echo ""
echo "======================================"
echo "            YARA DEMO"
echo "======================================"
echo ""

echo "Running YARA - Safe File"
docker run -it \
  -v $(pwd)/test-files:/data \
  yara-container /data/yara-rules/malware_rule.yar /data/yara-test/safe.txt \
  | tee $(pwd)/test-files/outputs/yara_demo1_safe.txt

echo ""
echo "Running YARA - Malicious File"
docker run -it \
  -v $(pwd)/test-files:/data \
  yara-container /data/yara-rules/malware_rule.yar /data/yara-test/malicious.txt \
  | tee $(pwd)/test-files/outputs/yara_demo2_malicious.txt

echo ""
echo "======================================"
echo "            TRIVY DEMO"
echo "======================================"
echo ""

echo "Running Trivy - Safe File"
docker run -it \
  -v $(pwd)/test-files/trivy:/data \
  trivy-container fs /data/safe.txt \
  | tee $(pwd)/test-files/outputs/trivy_safe.txt

echo ""
echo "Running Trivy - Vulnerable requirements.txt"
docker run -it \
  -v $(pwd)/test-files/trivy:/data \
  trivy-container fs /data/requirements.txt \
  | tee $(pwd)/test-files/outputs/trivy_vulnerable.txt

echo ""
echo "======================================"
echo "            SEMGREP DEMO"
echo "======================================"
echo ""

# Semgrep - Safe File
docker run -it \
  -v $(pwd)/test-files/semgrep:/code \
  semgrep-container --config=p/ci /code/safe.py \
  | tee $(pwd)/test-files/outputs/semgrep_safe.txt

echo ""
# Semgrep - Vulnerable File
docker run -it \
  -v $(pwd)/test-files/semgrep:/code \
  semgrep-container --config=p/security-audit /code/vuln.py \
  | tee $(pwd)/test-files/outputs/semgrep_vulnerable.txt
echo ""
echo "======================================"
echo "            SYFT DEMO"
echo "======================================"
echo ""

# Syft scan
echo "Running Syft - Generate SBOM from requirements"

docker run -it \
  -v $(pwd)/test-files/syft:/scan \
  anchore/syft:latest dir:/scan \
  | tee $(pwd)/test-files/outputs/syft_report.txt
echo ""

echo "======================================"
echo "     DEMO COMPLETED SUCCESSFULLY"
echo "======================================"
