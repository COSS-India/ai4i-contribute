from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_invalid_language_error():
    resp = client.post(
        "/suno/submit",
        json={
            "module":"suno",
            "item_id":"x",
            "language":"xx",   # invalid
            "payload":{"transcript":"hello"}
        }
    )
    assert resp.status_code == 400
    data = resp.json()
    assert "error" in data
    assert data["error"]["code"] == "INVALID_REQUEST"
