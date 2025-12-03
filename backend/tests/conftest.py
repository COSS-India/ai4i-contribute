
import pytest, sys
from fastapi.testclient import TestClient
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from main import app

@pytest.fixture
def client():
    return TestClient(app)
