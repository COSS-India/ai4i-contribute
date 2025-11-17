"""
Dekho Module (Phase 1 → Phase 2)
Implements mock-compatible endpoints aligned with Bolo's image labeling APIs.
Phase 1 placeholder routes (/status, /sample) are retained.
"""

from fastapi import APIRouter, HTTPException, Body
from pathlib import Path
import json
from models import (
    QueueResponse,
    SubmitResponse,
    SessionCompleteResponse,
    SubmitRequest,
    SessionCompleteRequest,
)

# -------------------------------------------------------------------
# Module router
router = APIRouter(prefix="/dekho", tags=["Dekho"])

# -------------------------------------------------------------------
# Phase 1 Endpoints

@router.get("/status")
def dekho_status():
    """Basic health check for Dekho module."""
    return {"module": "dekho", "status": "ok"}

@router.get("/sample")
def dekho_sample():
    """Return mock sample data for dekho (Phase 1 only)."""
    data_path = Path(__file__).resolve().parents[2] / "data" / "dekho" / "sample.json"

    if not data_path.exists():
        raise HTTPException(status_code=500, detail="dekho sample.json missing")

    with open(data_path, "r", encoding="utf-8") as f:
        return json.load(f)

# -------------------------------------------------------------------
# Phase 2 Endpoints
# -------------------------------------------------------------------

def _load_mock_queue(module: str):
    """Helper to load mock queue data from backend/data/{module}/queue/sample_batch.json"""
    base = Path(__file__).resolve().parents[2] / "data" / module / "queue" / "sample_batch.json"
    if base.exists():
        with open(base, "r", encoding="utf-8") as f:
            return json.load(f)
    return []

@router.get("/queue")
async def get_queue():
    """Fetch a mock queue batch for Dekho module."""
    items = _load_mock_queue("dekho")
    return QueueResponse(success=True, data=items, error=None)

@router.post("/submit")
async def submit_contribution(request: SubmitRequest):
    """Mock submission handler for Dekho contributions."""
    return SubmitResponse(
        success=True,
        data={
            "message": "Label submission recorded",
            "submission_id": "sub_mock_0003",
            "received_item": request.item_id,
        },
        error=None,
    )

@router.post("/session-complete")
async def session_complete(request: SessionCompleteRequest = Body(...)):
    """Mark session as complete for Dekho mock module."""
    return SessionCompleteResponse(
        success=True,
        data={"summary": {"completed_count": len(request.items_submitted or [])}},
        error=None,
    )
