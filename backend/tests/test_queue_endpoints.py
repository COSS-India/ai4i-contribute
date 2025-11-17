from main import app
from fastapi.testclient import TestClient

client = TestClient(app)

def test_queue_endpoints_return_mock_batches():
    for module in ["suno", "likho", "dekho"]:
        resp = client.get(f"/{module}/queue")
        assert resp.status_code == 200

        js = resp.json()
        assert "data" in js
        assert isinstance(js["data"], list)

        if js["data"]:
            first = js["data"][0]
            assert "item_id" in first
            assert "language" in first
