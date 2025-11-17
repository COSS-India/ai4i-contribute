from main import app
from fastapi.testclient import TestClient

client = TestClient(app)

VALID_SUNO = {"module":"suno","item_id":"s1","language":"mr","payload":{"transcript":"राम"}}
INVALID_LANG = {"module":"suno","item_id":"s1","language":"xx","payload":{"transcript":"राम"}}
INVALID_SCRIPT = {"module":"suno","item_id":"s1","language":"mr","payload":{"transcript":"hello"}}
MISSING_FIELD = {"module":"suno","item_id":"s1","language":"mr","payload":{"text":"something"}}

def test_valid_submit():
    r = client.post("/suno/submit", json=VALID_SUNO)
    assert r.status_code in (200, 201, 202)

def test_invalid_language():
    r = client.post("/suno/submit", json=INVALID_LANG)
    assert r.status_code == 400
    assert "INVALID_REQUEST" in r.text

def test_invalid_script():
    r = client.post("/suno/submit", json=INVALID_SCRIPT)
    assert r.status_code in (400, 422)
    assert ("INVALID_SCRIPT" in r.text) or ("INVALID_REQUEST" in r.text)

def test_missing_field():
    r = client.post("/suno/submit", json=MISSING_FIELD)
    assert r.status_code in (400, 422)
    assert ("MISSING_FIELD_IN_PAYLOAD" in r.text) or ("INVALID_REQUEST" in r.text)
