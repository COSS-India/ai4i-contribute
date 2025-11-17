from pathlib import Path
import json

def test_contract_frozen():
    readme = Path(__file__).resolve().parents[1] / "README.md"
    assert readme.exists()

    text = text = readme.read_text(encoding="utf-8")
    assert "AI4I API Contract (Frozen)" in text
