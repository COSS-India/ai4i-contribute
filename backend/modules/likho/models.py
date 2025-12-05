from pydantic import BaseModel, Field, model_validator
from typing import Optional, List, Dict, Any, Self

from validators.script_validator import text_matches_script


# ================================================================
#                     LIKHO (TRANSLATION)
#                     DPG-BALANCED MODELS
# ================================================================

# --------------------
# Queue (Contribution)
# --------------------

class LikhoQueueRequest(BaseModel):
    src_language: str = Field(..., example="en")  # ISO code only
    tgt_language: str = Field(..., example="hi")  # ISO code only
    batch_size: Optional[int] = Field(
        5, description="Requested batch size (default 5)"
    )
    userId: Optional[str] = None


class LikhoQueueItem(BaseModel):
    item_id: str
    src_language: str
    tgt_language: str
    text: str
    metadata: Optional[Dict[str, Any]] = None


class LikhoQueueResponse(BaseModel):
    sessionId: str
    src_language: str
    tgt_language: str
    items: List[LikhoQueueItem]
    totalCount: int


# --------------------
# Submit Translation (Contribution)
# --------------------

class LikhoSubmitRequest(BaseModel):
    item_id: str
    src_language: str  # ISO code only
    tgt_language: str  # ISO code only
    translation: str
    sequenceNumber: Optional[int] = None  # BOLO-aligned
    metadata: Optional[Dict[str, Any]] = None
    userId: Optional[str] = None

    @model_validator(mode="after")
    def _validate_translation(self) -> Self:
        if not text_matches_script(self.translation, self.tgt_language):
            raise ValueError("Please type in the target language only")
        return self


class LikhoSubmitResponse(BaseModel):
    item_id: str
    status: str
    sequenceNumber: int
    totalInSession: int
    remainingInSession: int
    progressPercentage: int


# --------------------
# Skip / Report (Contribution)
# --------------------

class LikhoSkipRequest(BaseModel):
    item_id: str
    reason: Optional[str] = None
    userId: Optional[str] = None


class LikhoReportRequest(BaseModel):
    item_id: str
    report_type: str
    description: Optional[str] = None
    userId: Optional[str] = None


# --------------------
# Session Complete (Contribution)
# --------------------

class LikhoSessionCompleteResponse(BaseModel):
    summary: Dict[str, int]


# ================================================================
#                     LIKHO VALIDATION
# ================================================================

# --------------------
# Validation Queue
# --------------------

class LikhoValidationQueueRequest(BaseModel):
    src_language: str = Field(..., example="en")  # ISO code only
    tgt_language: str = Field(..., example="hi")  # ISO code only
    batch_size: Optional[int] = Field(
        5, description="Requested batch size (default 5)"
    )
    userId: Optional[str] = None


class LikhoValidationItem(BaseModel):
    item_id: str
    src_language: str
    tgt_language: str
    text: str
    translation: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None


class LikhoValidationQueueResponse(BaseModel):
    sessionId: str
    src_language: str
    tgt_language: str
    items: List[LikhoValidationItem]
    totalCount: int


# --------------------
# Validation: Correct
# --------------------

class LikhoValidationAcceptRequest(BaseModel):
    item_id: str
    sequenceNumber: Optional[int] = None
    userId: Optional[str] = None


class LikhoValidationProgressResponse(BaseModel):
    validated_item: Optional[str] = None
    corrected_item: Optional[str] = None

    sequenceNumber: int
    totalInSession: int
    remainingInSession: int
    progressPercentage: int


# --------------------
# Validation: Needs Change (Correction)
# --------------------

class LikhoValidationCorrectionRequest(BaseModel):
    item_id: str
    src_language: str  # ISO code only
    tgt_language: str  # ISO code only
    corrected_translation: str
    sequenceNumber: Optional[int] = None
    userId: Optional[str] = None

    @model_validator(mode="after")
    def _validate_corrected_translation(self) -> Self:
        if not text_matches_script(self.corrected_translation, self.tgt_language):
            raise ValueError("Please type the corrected translation in the target language only")
        return self


# --------------------
# Validation: Skip / Report
# --------------------

class LikhoValidationSkipRequest(BaseModel):
    item_id: str
    reason: Optional[str] = None
    userId: Optional[str] = None


class LikhoValidationReportRequest(BaseModel):
    item_id: str
    report_type: str
    description: Optional[str] = None
    userId: Optional[str] = None


# --------------------
# Validation Session Complete
# --------------------

class LikhoValidationSessionCompleteResponse(BaseModel):
    summary: Dict[str, int]
