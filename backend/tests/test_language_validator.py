import json
from pathlib import Path

def test_languages_json_structure():
    path = Path(__file__).resolve().parents[1] / "data" / "languages.json"
    assert path.exists(), "languages.json missing"

    data = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(data, list)

    for entry in data:
        assert "languageCode" in entry
        assert "languageName" in entry
        assert "nativeName" in entry
        assert "isActive" in entry
