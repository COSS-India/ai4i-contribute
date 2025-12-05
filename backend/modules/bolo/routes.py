from fastapi import APIRouter
from pathlib import Path
import json
import os
import uuid

from models import APIResponse
from modules.bolo.models import (
    GetSentencesRequest,
    RecordContributionRequest,
    SkipSentenceRequest,
    ReportSentenceRequest,
    BoloValidationCorrectRequest,
    BoloValidationCorrectionRequest,
    BoloValidationSkipRequest,
    BoloValidationReportRequest,
)

# Load configuration (safe if missing)
try:
    from config import config
except Exception:
    config = None

router = APIRouter(tags=["Bolo"])

BOLO_STATIC_DIR = os.path.join(os.path.dirname(__file__), "static")
BASE_PATH = Path(__file__).resolve().parents[2] / "data" / "bolo"


def load_json(path: Path):
    if not path.exists():
        return []
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


# ================================================================
#                           INSTRUCTIONS + HELP
# ================================================================

@router.get("/instructions")
def instructions():
    return APIResponse(
        success=True,
        data={
            "title": "Bolo: Speak the sentence",
            "description": "Read the sentence aloud and record your voice.",
            "steps": [
                "Select your language.",
                "Read the sentence shown.",
                "Tap record and speak clearly.",
                "Replay your audio to check quality.",
                "Submit the audio or Skip the sentence.",
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
                    "q": "What if I misread the sentence?",
                    "a": "Re-record before submitting.",
                },
                {
                    "q": "What if the sentence is unclear?",
                    "a": "Use Skip or Report.",
                },
            ]
        },
    )


# ================================================================
#                           CONTRIBUTION (DPG BALANCED)
# ================================================================

@router.post("/queue")
def queue(req: GetSentencesRequest):
    """Load a batch of sentences for recording."""
    batch = load_json(BASE_PATH / "queue" / "sample_batch.json")
    requested = req.count or 5
    actual_count = min(requested, len(batch))

    return APIResponse(
        success=True,
        data={
            "sessionId": str(uuid.uuid4()),
            "language": req.language,
            "sentences": batch[:actual_count],
            "totalCount": actual_count,
        },
    )


@router.post("/submit")
def submit(req: RecordContributionRequest):
    """Accept a recorded contribution and return mandatory progress fields."""
    contribution_id = str(uuid.uuid4())
    fake_audio_url = f"/bolo/static/{contribution_id}.mp3"

    total = getattr(config, "session_contributions_limit", 5) if config else 5
    seq = req.sequenceNumber or 1
    remaining = max(total - seq, 0)
    progress = int((seq / total) * 100) if total else 0

    return APIResponse(
        success=True,
        data={
            "contributionId": contribution_id,
            "audioUrl": fake_audio_url,
            "duration": req.duration or 0,
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
    required = getattr(config, "cert_contributions_required", 5) if config else 5

    return APIResponse(
        success=True,
        data={
            "summary": {
                "completed_count": len(items),
                "required_for_certificate": required,
            }
        },
    )


@router.get("/test-speaker")
def test_speaker():
    return APIResponse(
        success=True,
        data={"sample_audio": "/bolo/static/sample1.mp3"},
    )


# ================================================================
#                           VALIDATION (DPG BALANCED)
# ================================================================

@router.post("/validation")
def validation_queue(req: GetSentencesRequest):
    # Language is REQUIRED via GetSentencesRequest
    """Load a batch of items for validation for a given language."""
    batch = load_json(BASE_PATH / "validation" / "sample_batch.json")
    requested = req.count or 5
    actual_count = min(requested, len(batch))

    return APIResponse(
        success=True,
        data={
            "sessionId": str(uuid.uuid4()),
            "language": req.language,
            "validationItems": batch[:actual_count],
            "totalCount": actual_count,
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
