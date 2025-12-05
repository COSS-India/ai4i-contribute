from fastapi import APIRouter
from pathlib import Path
import json
import os
import uuid

from models import APIResponse
from modules.dekho.models import (
    DekhoQueueRequest,
    DekhoSubmitRequest,
    DekhoSkipRequest,
    DekhoReportRequest,
    DekhoValidationQueueRequest,
    DekhoValidationAcceptRequest,
    DekhoValidationCorrectionRequest,
    DekhoValidationSkipRequest,
    DekhoValidationReportRequest,
)

# Load configuration (safe if missing)
try:
    from config import config
except Exception:
    config = None

router = APIRouter(tags=["dekho"])

# Static dir (for sample images, if you use them)
DEKHO_STATIC_DIR = os.path.join(os.path.dirname(__file__), "static")


BASE_PATH = Path(__file__).resolve().parents[2] / "data" / "dekho"


def load_json(path: Path):
    if not path.exists():
        return []
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


# ---------------------------------------------------------
# Instructions + Help (updated to transcription semantics)
# ---------------------------------------------------------

@router.get("/instructions")
def instructions():
    return APIResponse(
        success=True,
        data={
            "title": "Dekho: Image Transcription Instructions",
            "description": "Look at the image and type exactly the text you see.",
            "steps": [
                "Select your language.",
                "Observe the image closely.",
                "Type the text exactly as it appears in the chosen language.",
                "Check spelling before submitting.",
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
                    "a": "Use Skip to continue to the next item.",
                },
                {
                    "q": "Can I report inappropriate content?",
                    "a": "Yes, use Report to flag the item.",
                },
            ]
        },
    )


# ---------------------------------------------------------
# Contribution
# ---------------------------------------------------------

@router.post("/queue")
def queue(req: DekhoQueueRequest):
    """
    Load a batch of image transcription items for a given language.
    """
    batch = load_json(BASE_PATH / "queue" / "sample_batch.json")
    requested = req.batch_size or 5
    actual_count = min(requested, len(batch))

    return APIResponse(
        success=True,
        data={
            "sessionId": str(uuid.uuid4()),
            "language": req.language,
            "items": batch[:actual_count],
            "totalCount": actual_count,
        },
    )


@router.post("/submit")
def submit(req: DekhoSubmitRequest):
    """
    Accept a user transcription and return mandatory progress fields.
    """
    # Reuse transcription session limit like Suno
    total = getattr(config, "session_transcriptions_limit", 5) if config else 5
    seq = req.sequenceNumber or 1
    remaining = max(total - seq, 0)
    progress = int((seq / total) * 100) if total else 0

    return APIResponse(
        success=True,
        data={
            "item_id": req.item_id,
            "status": "submitted",
            "sequenceNumber": seq,
            "totalInSession": total,
            "remainingInSession": remaining,
            "progressPercentage": progress,
        },
    )


@router.post("/skip")
def skip(req: DekhoSkipRequest):
    return APIResponse(
        success=True,
        data={
            "skipped_item": req.item_id,
            "reason": req.reason,
        },
    )


@router.post("/report")
def report(req: DekhoReportRequest):
    return APIResponse(
        success=True,
        data={
            "reported_item": req.item_id,
            "reportType": req.report_type,
            "description": req.description,
        },
    )


@router.post("/session-complete")
def session_complete(payload: dict):
    items = payload.get("items", [])
    required = getattr(config, "cert_transcriptions_required", 5) if config else 5

    return APIResponse(
        success=True,
        data={
            "summary": {
                "completed_count": len(items),
                "required_for_certificate": required,
            }
        },
    )


# ---------------------------------------------------------
# Validation
# ---------------------------------------------------------

@router.post("/validation")
def validation_queue(req: DekhoValidationQueueRequest):
    """
    Load a batch of items for validation for a given language.
    """
    batch = load_json(BASE_PATH / "validation" / "sample_batch.json")
    requested = req.batch_size or 5
    actual_count = min(requested, len(batch))

    return APIResponse(
        success=True,
        data={
            "sessionId": str(uuid.uuid4()),
            "language": req.language,
            "items": batch[:actual_count],
            "totalCount": actual_count,
        },
    )


@router.post("/validation/correct")
def validation_correct(req: DekhoValidationAcceptRequest):
    total = getattr(config, "session_validations_limit", 25) if config else 25
    seq = req.sequenceNumber or 1
    remaining = max(total - seq, 0)
    progress = int((seq / total) * 100) if total else 0

    return APIResponse(
        success=True,
        data={
            "validated_item": req.item_id,
            "sequenceNumber": seq,
            "totalInSession": total,
            "remainingInSession": remaining,
            "progressPercentage": progress,
        },
    )


@router.post("/validation/submit-correction")
def validation_correction(req: DekhoValidationCorrectionRequest):
    total = getattr(config, "session_validations_limit", 25) if config else 25
    seq = req.sequenceNumber or 1
    remaining = max(total - seq, 0)
    progress = int((seq / total) * 100) if total else 0

    return APIResponse(
        success=True,
        data={
            "corrected_item": req.item_id,
            "sequenceNumber": seq,
            "totalInSession": total,
            "remainingInSession": remaining,
            "progressPercentage": progress,
        },
    )


@router.post("/validation/skip")
def validation_skip(req: DekhoValidationSkipRequest):
    return APIResponse(
        success=True,
        data={
            "skipped_item": req.item_id,
            "reason": req.reason,
        },
    )


@router.post("/validation/report")
def validation_report(req: DekhoValidationReportRequest):
    return APIResponse(
        success=True,
        data={
            "reported_item": req.item_id,
            "reportType": req.report_type,
            "description": req.description,
        },
    )


@router.post("/validation/session-complete")
def validation_session_complete(payload: dict):
    items = payload.get("items", [])
    required = getattr(config, "cert_validations_required", 25) if config else 25

    return APIResponse(
        success=True,
        data={
            "summary": {
                "validated_count": len(items),
                "required_for_certificate": required,
            }
        },
    )
