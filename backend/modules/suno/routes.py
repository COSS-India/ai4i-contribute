from fastapi import APIRouter
from pathlib import Path
import json
from fastapi.staticfiles import StaticFiles
import os


from models import (
    SunoQueueRequest,
    SunoSubmitRequest,
    SunoSkipRequest,
    SunoReportRequest,
    SunoValidationAcceptRequest,
    SunoValidationRejectRequest,
    SunoValidationCorrectionRequest,
    APIResponse,
)

router = APIRouter(tags=["suno"])

# ------------------------------------------------------------------
# Mount static directory for Suno sample audio files
# Files will live inside: backend/modules/suno/static/
# Accessible at: /suno/static/<filename>
# ------------------------------------------------------------------
SUNO_STATIC_DIR = os.path.join(os.path.dirname(__file__), "static")

BASE_PATH = Path(__file__).resolve().parents[2] / "data" / "suno"


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


# ---------------------------------------------------------
# Contribution
# ---------------------------------------------------------
@router.post("/queue")
def queue(req: SunoQueueRequest):
    batch = load_json(BASE_PATH / "queue" / "sample_batch.json")
    return APIResponse(success=True, data=batch[: req.batch_size])


@router.post("/submit")
def submit(req: SunoSubmitRequest):
    return APIResponse(
        success=True,
        data={"item_id": req.item_id, "message": "Transcription submitted"},
    )


@router.post("/skip")
def skip(req: SunoSkipRequest):
    return APIResponse(
        success=True,
        data={"skipped_item": req.item_id, "reason": req.reason},
    )


@router.post("/report")
def report(req: SunoReportRequest):
    return APIResponse(
        success=True,
        data={"reported_item": req.item_id, "type": req.report_type},
    )


@router.post("/session-complete")
def session_complete(payload: dict):
    items = payload.get("items", [])
    return APIResponse(
        success=True,
        data={"summary": {"completed_count": len(items)}},
    )


@router.get("/test-speaker")
def test_speaker():
    return APIResponse(success=True, data={"sample_audio": "/static/suno/sample1.mp3"})


# ---------------------------------------------------------
# Validation
# ---------------------------------------------------------
@router.get("/validation")
def validation_queue(batch_size: int = 5):
    batch = load_json(BASE_PATH / "validation" / "sample_batch.json")
    return APIResponse(success=True, data=batch[: batch_size])


@router.post("/validation/correct")
def validation_correct(req: SunoValidationAcceptRequest):
    return APIResponse(success=True, data={"validated_item": req.item_id})


@router.post("/validation/reject")
def validation_reject(req: SunoValidationRejectRequest):
    return APIResponse(
        success=True,
        data={"rejected_item": req.item_id, "reason": req.reason},
    )


@router.post("/validation/submit-correction")
def validation_correction(req: SunoValidationCorrectionRequest):
    return APIResponse(
        success=True,
        data={"corrected_item": req.item_id},
    )


@router.post("/validation/skip")
def validation_skip(req: SunoSkipRequest):
    return APIResponse(success=True, data={"skipped_item": req.item_id})


@router.post("/validation/report")
def validation_report(req: SunoReportRequest):
    return APIResponse(success=True, data={"reported_item": req.item_id})
