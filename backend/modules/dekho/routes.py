from fastapi import APIRouter
from pathlib import Path
import json
from fastapi.staticfiles import StaticFiles
import os

from models import (
    DekhoQueueRequest,
    DekhoSubmitRequest,
    DekhoSkipRequest,
    DekhoReportRequest,
    DekhoValidationAcceptRequest,
    DekhoValidationRejectRequest,
    DekhoValidationCorrectionRequest,
    APIResponse,
)

router = APIRouter(prefix="/dekho", tags=["dekho"])

# ------------------------------------------------------------------
# Mount static directory for Dekho sample images
# Files will live inside: backend/modules/dekho/static/
# Accessible at: /dekho/static/<filename>
# ------------------------------------------------------------------
DEKHO_STATIC_DIR = os.path.join(os.path.dirname(__file__), "static")
router.mount("/static", StaticFiles(directory=DEKHO_STATIC_DIR), name="dekho_static")

BASE_PATH = Path(__file__).resolve().parents[2] / "data" / "dekho"


def load_json(path: Path):
    if not path.exists():
        return []
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


# ---------------------------------------------------------
# Instructions + Help
# ---------------------------------------------------------
@router.get("/instructions")
def instructions():
    return APIResponse(
        success=True,
        data={
            "title": "Dekho: Image Labeling Instructions",
            "description": "Look at the image and assign the correct label.",
            "steps": [
                "Observe the image closely.",
                "Enter one or more correct labels.",
                "Ensure spelling is correct.",
                "Submit after reviewing.",
            ],
        },
    )


@router.get("/help")
def help_page():
    return APIResponse(
        success=True,
        data={
            "faqs": [
                {
                    "q": "What if the image is unclear?",
                    "a": "Use Skip to continue."
                },
                {
                    "q": "Can I report inappropriate content?",
                    "a": "Yes, use Report to flag the item."
                }
            ]
        },
    )


# ---------------------------------------------------------
# Contribution
# ---------------------------------------------------------
@router.post("/queue")
def queue(req: DekhoQueueRequest):
    batch = load_json(BASE_PATH / "queue" / "sample_batch.json")
    return APIResponse(success=True, data=batch[: req.batch_size])


@router.post("/submit")
def submit(req: DekhoSubmitRequest):
    return APIResponse(
        success=True,
        data={"item_id": req.item_id, "message": "Label submitted"},
    )


@router.post("/skip")
def skip(req: DekhoSkipRequest):
    return APIResponse(success=True, data={"skipped_item": req.item_id})


@router.post("/report")
def report(req: DekhoReportRequest):
    return APIResponse(success=True, data={"reported_item": req.item_id})


@router.post("/session-complete")
def session_complete(payload: dict):
    items = payload.get("items", [])
    return APIResponse(
        success=True,
        data={"summary": {"completed_count": len(items)}},
    )


# ---------------------------------------------------------
# Validation
# ---------------------------------------------------------
@router.get("/validation")
def validation_queue(batch_size: int = 5):
    batch = load_json(BASE_PATH / "validation" / "sample_batch.json")
    return APIResponse(success=True, data=batch[: batch_size])


@router.post("/validation/correct")
def validation_correct(req: DekhoValidationAcceptRequest):
    return APIResponse(success=True, data={"validated_item": req.item_id})


@router.post("/validation/reject")
def validation_reject(req: DekhoValidationRejectRequest):
    return APIResponse(
        success=True,
        data={"rejected_item": req.item_id, "reason": req.reason},
    )


@router.post("/validation/submit-correction")
def validation_correction(req: DekhoValidationCorrectionRequest):
    return APIResponse(success=True, data={"corrected_item": req.item_id})


@router.post("/validation/skip")
def validation_skip(req: DekhoSkipRequest):
    return APIResponse(success=True, data={"skipped_item": req.item_id})


@router.post("/validation/report")
def validation_report(req: DekhoReportRequest):
    return APIResponse(success=True, data={"reported_item": req.item_id})
