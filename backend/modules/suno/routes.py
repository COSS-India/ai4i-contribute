from fastapi import APIRouter
from pathlib import Path
import json
import uuid
import os

from models import APIResponse
from modules.suno.models import (
    SunoQueueRequest,
    SunoSubmitRequest,
    SunoSkipRequest,
    SunoReportRequest,
    SunoValidationQueueRequest,
    SunoValidationAcceptRequest,
    SunoValidationCorrectionRequest,
    SunoValidationSkipRequest,
    SunoValidationReportRequest,
)

# Load configuration (safe if missing)
try:
    from config import config
except Exception:
    config = None

router = APIRouter(tags=["Suno"])

SUNO_STATIC_DIR = os.path.join(os.path.dirname(__file__), "static")


BASE_PATH = Path(__file__).resolve().parents[2] / "data" / "suno"


def load_json(path: Path):
    if not path.exists():
        return []
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)

# ===============================================================
# Instructions + test-speaker + Help
# ===============================================================
@router.get("/instructions")
def instructions():
    data = {
        "title": "Suno: Transcription Instructions",
        "description": "Listen to the audio and type exactly what you hear.",
        "steps": [
            "Wear headphones.",
            "Listen carefully.",
            "Type the transcript in the same language.",
            "Submit after reviewing.",
        ],
    }
    return APIResponse(success=True, data=data)

@router.get("/test-speaker")
def test_speaker():
    return APIResponse(success=True, data={"sample_audio": "/suno/static/sample1.mp3"})

@router.get("/help")
def help_page():
    data = {
        "faqs": [
            {
                "q": "What if the audio is unclear?",
                "a": "Use Skip and continue to the next item."
            },
            {
                "q": "What language should I transcribe in?",
                "a": "Use the same language as the audio."
            }
        ]
    }
    return APIResponse(success=True, data=data)

# ================================================================
#                           CONTRIBUTION
# ================================================================

@router.post("/queue")
def queue(req: SunoQueueRequest):
    """
    Load a batch of audio items for transcription.
    Language is REQUIRED via SunoQueueRequest.
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
def submit(req: SunoSubmitRequest):
    """
    Accept a user transcription and return mandatory progress fields.
    BOLO-aligned sequenceNumber handling.
    """
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
def skip(req: SunoSkipRequest):
    return APIResponse(
        success=True,
        data={
            "skipped_item": req.item_id,
            "reason": req.reason,
        },
    )


@router.post("/report")
def report(req: SunoReportRequest):
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


# ================================================================
#                           VALIDATION
# ================================================================

@router.post("/validation")
def validation_queue(req: SunoValidationQueueRequest):
    """
    Load a batch of items for validation for a given language.
    Language is REQUIRED.
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
def validation_correct(req: SunoValidationAcceptRequest):
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
def validation_submit_correction(req: SunoValidationCorrectionRequest):
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
def validation_skip(req: SunoValidationSkipRequest):
    return APIResponse(
        success=True,
        data={
            "skipped_item": req.item_id,
            "reason": req.reason,
        },
    )


@router.post("/validation/report")
def validation_report(req: SunoValidationReportRequest):
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
