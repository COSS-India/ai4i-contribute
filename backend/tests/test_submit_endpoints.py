from main import app
from fastapi.testclient import TestClient

client = TestClient(app)

def test_submit_minimal():
    resp = client.post(
        "/suno/submit",
        json={
            "module": "suno",
            "item_id": "123",
            "language": "hi",
            "payload": {"transcript": "हेलो"}
        }
    )
    assert resp.status_code == 200
    js = resp.json()

    assert js["success"] is True
    assert "data" in js
    assert "submission_id" in js["data"]
