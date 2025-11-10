"""
Suno Module (Phase 1)
Placeholder routes for module setup.
Do NOT add workflow logic here in Phase 1.
"""

from fastapi import APIRouter, HTTPException
from pathlib import Path
import json

# Module router
router = APIRouter(prefix="/suno", tags=["Suno"])

@router.get("/status")
def suno_status():
    """Basic health check for Suno module."""
    return {"module": "suno", "status": "ok"}

@router.get("/sample")
def suno_sample():
    """Return mock sample data for Suno (Phase 1 only)."""
    # backend/modules/suno/routes.py → go up 3 levels → backend/
    data_path = Path(__file__).resolve().parents[3] / "data" / "suno" / "sample.json"

    if not data_path.exists():
        raise HTTPException(status_code=500, detail="suno sample.json missing")

    with open(data_path, "r", encoding="utf-8") as f:
        return json.load(f)
