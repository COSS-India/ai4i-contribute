"""
Dekho Module (Phase 1)
Placeholder routes for module setup.
Image-to-text workflow will be added in Phase 4.
"""

from fastapi import APIRouter, HTTPException
from pathlib import Path
import json

# Module router
router = APIRouter(prefix="/dekho", tags=["Dekho"])

@router.get("/status")
def dekho_status():
    """Basic health check for Dekho module."""
    return {"module": "dekho", "status": "ok"}

@router.get("/sample")
def dekho_sample():
    """Return mock sample data for Dekho (Phase 1 only)."""
    # backend/modules/dekho/routes.py → go up 3 levels → backend/
    data_path = Path(__file__).resolve().parents[3] / "data" / "dekho" / "sample.json"

    if not data_path.exists():
        raise HTTPException(status_code=500, detail="dekho sample.json missing")

    with open(data_path, "r", encoding="utf-8") as f:
        return json.load(f)
