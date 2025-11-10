"""
Likho Module (Phase 1)
Placeholder routes for module setup.
Translation workflow will be added in Phase 3.
"""

from fastapi import APIRouter, HTTPException
from pathlib import Path
import json

# Module router
router = APIRouter(prefix="/likho", tags=["Likho"])

@router.get("/status")
def likho_status():
    """Basic health check for Likho module."""
    return {"module": "likho", "status": "ok"}

@router.get("/sample")
def likho_sample():
    """Return mock sample data for Likho (Phase 1 only)."""
    # backend/modules/likho/routes.py → go up 3 levels → backend/
    data_path = Path(__file__).resolve().parents[3] / "data" / "likho" / "sample.json"

    if not data_path.exists():
        raise HTTPException(status_code=500, detail="likho sample.json missing")

    with open(data_path, "r", encoding="utf-8") as f:
        return json.load(f)
