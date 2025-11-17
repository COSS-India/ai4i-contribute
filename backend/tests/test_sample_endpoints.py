from main import app
from fastapi.testclient import TestClient

client = TestClient(app)

def test_sample_endpoints():
    for module in ["suno", "likho", "dekho"]:
        resp = client.get(f"/{module}/sample")
        assert resp.status_code == 200

        js = resp.json()
        assert "sample_items" in js
        assert isinstance(js["sample_items"], list)
