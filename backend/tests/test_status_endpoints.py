from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_status_all_modules():
    for module in ["suno", "likho", "dekho"]:
        resp = client.get(f"/{module}/status")
        assert resp.status_code == 200
        data = resp.json()
        assert "status" in data
