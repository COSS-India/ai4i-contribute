from fastapi import APIRouter
from pathlib import Path
import json
import os
import uuid

from fastapi.staticfiles import StaticFiles

from models import (
    GetSentencesRequest,
    RecordContributionRequest,
    SkipSentenceRequest,
    ReportSentenceRequest,
    ValidationQueueResponse,
    BoloValidationCorrectRequest,
    BoloValidationCorrectionRequest,
    BoloValidationSkipRequest,
    BoloValidationReportRequest,

    APIResponse,
)

try:
    from config import config
except Exception:
    config = None


router = APIRouter(tags=["bolo"])

# ----------------------------------------------------------------------
# STATIC DIRECTORY
# ----------------------------------------------------------------------
BOLO_STATIC_DIR = os.path.join(os.path.dirname(__file__), "static")

# ----------------------------------------------------------------------
# DATA DIRECTORY FOR MOCK JSON BATCHES
# ----------------------------------------------------------------------
BASE_PATH = Path(__file__).resolve().parents[2] / "data" / "bolo"


def load_json(path: Path):
    if not path.exists():
        return []
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


# ================================================================
#                         INSTRUCTIONS + HELP
# ================================================================

@router.get("/instructions")
def instructions():
    data = {
        "title": "Bolo: Speak the sentence",
        "description": "Read the sentence aloud and record your voice. Replay and re-record as needed.",
        "steps": [
            "Select your language.",
            "Read the sentence shown.",
            "Tap record and speak clearly.",
            "Replay your audio to check quality.",
            "Submit the audio or Skip if you cannot read the sentence.",
        ],
    }
    return APIResponse(success=True, data=data)


@router.get("/help")
def help_page():
    data = {
        "faqs": [
            {
                "q": "What if I misread the sentence?",
                "a": "Just re-record before submitting."
            },
            {
                "q": "What if the sentence is unclear?",
                "a": "Use Skip or Report."
            },
        ]
    }
    return APIResponse(success=True, data=data)


# ================================================================
#                           CONTRIBUTION
# ================================================================

@router.post("/queue")
def queue(req: GetSentencesRequest):
    """
    Load a batch of sentences for recording.
    """

    batch = load_json(BASE_PATH / "queue" / "sample_batch.json")
    count = min(req.count, len(batch))

    return APIResponse(
        success=True,
        data={
            "sessionId": str(uuid.uuid4()),
            "language": req.language,
            "sentences": batch[:count],
            "totalCount": len(batch),
        },
    )


@router.post("/submit")
def submit(req: RecordContributionRequest):
    """
    Accept the user's spoken audio for a sentence.
    Returns mock contributionId + progress fields.
    """

    contribution_id = str(uuid.uuid4())
    fake_audio_url = f"/bolo/static/{contribution_id}.mp3"

    total = getattr(config, "session_contributions_limit", 5) if config else 5
    seq = getattr(req, "sequenceNumber", 1)
    remaining = max(total - seq, 0)
    progress = int((seq / total) * 100) if total else 0

    return APIResponse(
        success=True,
        data={
            "contributionId": contribution_id,
            "audioUrl": fake_audio_url,
            "duration": getattr(req, "duration", 0),
            "status": "pending",
            "sequenceNumber": seq,
            "totalInSession": total,
            "remainingInSession": remaining,
            "progressPercentage": progress,
        },
    )


@router.post("/skip")
def skip(req: SkipSentenceRequest):
    return APIResponse(
        success=True,
        data={
            "skippedSentenceId": req.sentenceId,
            "reason": req.reason,
        },
    )


@router.post("/report")
def report(req: ReportSentenceRequest):
    return APIResponse(
        success=True,
        data={
            "reportedSentenceId": req.sentenceId,
            "reportType": req.reportType,
        },
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
    """
    Returns a demo static audio file.
    """
    return APIResponse(
        success=True,
        data={"sample_audio": "/bolo/static/sample1.mp3"},
    )


# ================================================================
#                           VALIDATION
# ================================================================

@router.get("/validation")
def validation_queue(batch_size: int = 5):
    """
    Load a batch of items for validation.
    """

    batch = load_json(BASE_PATH / "validation" / "sample_batch.json")

    return APIResponse(
        success=True,
        data={
            "sessionId": str(uuid.uuid4()),
            "language": "unknown",
            "validationItems": batch[:batch_size],
            "totalCount": len(batch),
        },
    )


@router.post("/validation/correct")
def validation_correct(req: BoloValidationCorrectRequest):
    total = getattr(config, "session_validations_limit", 25) if config else 25
    seq = req.sequenceNumber or 1
    remaining = max(total - seq, 0)
    progress = int((seq / total) * 100) if total else 0

    return APIResponse(
        success=True,
        data={
            "validated_item": req.contributionId,
            "sequenceNumber": seq,
            "totalInSession": total,
            "remainingInSession": remaining,
            "progressPercentage": progress,
        },
    )


@router.post("/validation/submit-correction")
def validation_submit_correction(req: BoloValidationCorrectionRequest):
    total = getattr(config, "session_validations_limit", 25) if config else 25
    seq = req.sequenceNumber or 1
    remaining = max(total - seq, 0)
    progress = int((seq / total) * 100) if total else 0

    return APIResponse(
        success=True,
        data={
            "corrected_item": req.contributionId,
            "correctedAudioUrl": req.correctedAudioUrl,
            "sequenceNumber": seq,
            "totalInSession": total,
            "remainingInSession": remaining,
            "progressPercentage": progress,
        },
    )


@router.post("/validation/skip")
def validation_skip(req: BoloValidationSkipRequest):
    return APIResponse(
        success=True,
        data={"skipped_item": req.contributionId},
    )


@router.post("/validation/report")
def validation_report(req: BoloValidationReportRequest):
    return APIResponse(
        success=True,
        data={
            "reported_item": req.contributionId,
            "reportType": req.reportType,
        },
    )


@router.post("/validation/session-complete")
def validation_session_complete(payload: dict):
    items = payload.get("items", [])
    return APIResponse(
        success=True,
        data={"summary": {"validated_count": len(items)}},
    )
