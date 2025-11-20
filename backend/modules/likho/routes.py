from fastapi import APIRouter
from pathlib import Path
import json
from fastapi.staticfiles import StaticFiles
import os

from models import (
    LikhoQueueRequest,
    LikhoSubmitRequest,
    LikhoSkipRequest,
    LikhoReportRequest,
    LikhoValidationAcceptRequest,
    LikhoValidationRejectRequest,
    LikhoValidationCorrectionRequest,
    APIResponse,
)

router = APIRouter(tags=["likho"])

BASE_PATH = Path(__file__).resolve().parents[2] / "data" / "likho"


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
    batch = load_json(BASE_PATH / "queue" / "sample_batch.json")
    return APIResponse(success=True, data=batch[: req.batch_size])


@router.post("/submit")
def submit(req: LikhoSubmitRequest):
    return APIResponse(
        success=True,
        data={"item_id": req.item_id, "message": "Translation submitted"},
    )


@router.post("/skip")
def skip(req: LikhoSkipRequest):
    return APIResponse(success=True, data={"skipped_item": req.item_id})


@router.post("/report")
def report(req: LikhoReportRequest):
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
def validation_correct(req: LikhoValidationAcceptRequest):
    return APIResponse(success=True, data={"validated_item": req.item_id})


@router.post("/validation/reject")
def validation_reject(req: LikhoValidationRejectRequest):
    return APIResponse(
        success=True,
        data={"rejected_item": req.item_id, "reason": req.reason},
    )


@router.post("/validation/submit-correction")
def validation_correction(req: LikhoValidationCorrectionRequest):
    return APIResponse(success=True, data={"corrected_item": req.item_id})


@router.post("/validation/skip")
def validation_skip(req: LikhoSkipRequest):
    return APIResponse(success=True, data={"skipped_item": req.item_id})


@router.post("/validation/report")
def validation_report(req: LikhoReportRequest):
    return APIResponse(success=True, data={"reported_item": req.item_id})
