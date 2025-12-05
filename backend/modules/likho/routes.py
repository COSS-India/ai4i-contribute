from fastapi import APIRouter
from pathlib import Path
import json
import uuid

from models import APIResponse
from modules.likho.models import (
    LikhoQueueRequest,
    LikhoSubmitRequest,
    LikhoSkipRequest,
    LikhoReportRequest,
    LikhoValidationQueueRequest,
    LikhoValidationAcceptRequest,
    LikhoValidationCorrectionRequest,
    LikhoValidationSkipRequest,
    LikhoValidationReportRequest,
)

# Load configuration (safe if missing)
try:
    from config import config
except Exception:
    config = None

router = APIRouter(tags=["likho"])

BASE_PATH = Path(__file__).resolve().parents[2] / "data" / "likho"


def load_json(path: Path):
    if not path.exists():
        return []
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


# ---------------------------------------------------------
# Instructions + Help (kept as-is)
# ---------------------------------------------------------

@router.get("/instructions")
def instructions():
    return APIResponse(
        success=True,
        data={
            "title": "Likho: Translation Instructions",
            "description": "Translate the given text into the target language.",
            "steps": [
                "Read the source text carefully.",
                "Translate into the target language only.",
                "Ensure grammar and meaning are correct.",
                "Submit after review.",
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
                    "q": "Which language should I translate to?",
                    "a": "Use the target language indicated on screen.",
                },
                {
                    "q": "What if the text is offensive?",
                    "a": "Use Report to flag the content.",
                },
            ]
        },
    )


# ---------------------------------------------------------
# Contribution
# ---------------------------------------------------------

@router.post("/queue")
def queue(req: LikhoQueueRequest):
    """
    Load a batch of translation items for a given language pair.
    """
    batch = load_json(BASE_PATH / "queue" / "sample_batch.json")
    requested = req.batch_size or 5
    actual_count = min(requested, len(batch))

    return APIResponse(
        success=True,
        data={
            "sessionId": str(uuid.uuid4()),
            "src_language": req.src_language,
            "tgt_language": req.tgt_language,
            "items": batch[:actual_count],
            "totalCount": actual_count,
        },
    )


@router.post("/submit")
def submit(req: LikhoSubmitRequest):
    """
    Accept a user translation and return mandatory progress fields.
    BOLO/Suno-aligned sequenceNumber handling.
    """
    total = getattr(config, "session_translations_limit", 5) if config else 5
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
def skip(req: LikhoSkipRequest):
    return APIResponse(
        success=True,
        data={
            "skipped_item": req.item_id,
            "reason": req.reason,
        },
    )


@router.post("/report")
def report(req: LikhoReportRequest):
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
    required = getattr(config, "cert_translations_required", 5) if config else 5

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
def validation_queue(req: LikhoValidationQueueRequest):
    """
    Load a batch of items for validation for a given language pair.
    """
    batch = load_json(BASE_PATH / "validation" / "sample_batch.json")
    requested = req.batch_size or 5
    actual_count = min(requested, len(batch))

    return APIResponse(
        success=True,
        data={
            "sessionId": str(uuid.uuid4()),
            "src_language": req.src_language,
            "tgt_language": req.tgt_language,
            "items": batch[:actual_count],
            "totalCount": actual_count,
        },
    )


@router.post("/validation/correct")
def validation_correct(req: LikhoValidationAcceptRequest):
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
def validation_correction(req: LikhoValidationCorrectionRequest):
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
def validation_skip(req: LikhoValidationSkipRequest):
    return APIResponse(
        success=True,
        data={
            "skipped_item": req.item_id,
            "reason": req.reason,
        },
    )


@router.post("/validation/report")
def validation_report(req: LikhoValidationReportRequest):
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
