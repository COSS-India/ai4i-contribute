from main import app
from fastapi.testclient import TestClient

client = TestClient(app)

def test_session_complete_basics():
    resp = client.post(
        "/suno/session-complete",
        json={
            "module": "suno",
            "language": "hi",
            "session_id": "abc",
            "items_submitted": [
                {"item_id": "1"},
                {"item_id": "2"}
            ]
        }
    )
    assert resp.status_code == 200

    js = resp.json()
    assert "data" in js
    assert "summary" in js["data"]
    assert js["data"]["summary"]["completed_count"] == 2
