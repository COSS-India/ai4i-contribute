from pydantic import BaseModel, Field, model_validator
from typing import Optional, List, Dict, Any, Self

from validators.script_validator import text_matches_script


# ================================================================
#                     DEKHO (IMAGE TRANSCRIPTION)
#                     DPG-BALANCED MODELS
# ================================================================

# --------------------
# Queue (Contribution)
# --------------------

class DekhoQueueRequest(BaseModel):
    language: str = Field(..., example="hi")  # ISO code only
    batch_size: Optional[int] = Field(5, description="Requested batch size (default 5)")
    userId: Optional[str] = None


class DekhoQueueItem(BaseModel):
    item_id: str
    language: str
    image_url: str
    metadata: Optional[Dict[str, Any]] = None


class DekhoQueueResponse(BaseModel):
    sessionId: str
    language: str
    items: List[DekhoQueueItem]
    totalCount: int


# --------------------
# Submit Transcription (Contribution)
# --------------------

class DekhoSubmitRequest(BaseModel):
    item_id: str
    language: str  # ISO code only
    transcription: str
    sequenceNumber: Optional[int] = None  # BOLO/Suno/Likho aligned
    metadata: Optional[Dict[str, Any]] = None
    userId: Optional[str] = None

    @model_validator(mode="after")
    def _validate_transcription(self) -> Self:
        if not text_matches_script(self.transcription, self.language):
            raise ValueError("Please type in the chosen language only")
        return self


class DekhoSubmitResponse(BaseModel):
    item_id: str
    status: str
    sequenceNumber: int
    totalInSession: int
    remainingInSession: int
    progressPercentage: int


# --------------------
# Skip / Report (Contribution)
# --------------------

class DekhoSkipRequest(BaseModel):
    item_id: str
    reason: Optional[str] = None
    userId: Optional[str] = None


class DekhoReportRequest(BaseModel):
    item_id: str
    report_type: str
    description: Optional[str] = None
    userId: Optional[str] = None


# --------------------
# Session Complete (Contribution)
# --------------------

class DekhoSessionCompleteResponse(BaseModel):
    summary: Dict[str, int]


# ================================================================
#                     DEKHO VALIDATION
# ================================================================

# --------------------
# Validation Queue
# --------------------

class DekhoValidationQueueRequest(BaseModel):
    language: str = Field(..., example="hi")  # ISO code only
    batch_size: Optional[int] = Field(5, description="Requested batch size (default 5)")
    userId: Optional[str] = None


class DekhoValidationItem(BaseModel):
    item_id: str
    language: str
    image_url: str
    transcription: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None


class DekhoValidationQueueResponse(BaseModel):
    sessionId: str
    language: str
    items: List[DekhoValidationItem]
    totalCount: int


# --------------------
# Validation: Correct
# --------------------

class DekhoValidationAcceptRequest(BaseModel):
    item_id: str
    sequenceNumber: Optional[int] = None
    userId: Optional[str] = None


class DekhoValidationProgressResponse(BaseModel):
    validated_item: Optional[str] = None
    corrected_item: Optional[str] = None

    sequenceNumber: int
    totalInSession: int
    remainingInSession: int
    progressPercentage: int


# --------------------
# Validation: Needs Change (Correction)
# --------------------

class DekhoValidationCorrectionRequest(BaseModel):
    item_id: str
    language: str  # ISO code only
    corrected_transcription: str
    sequenceNumber: Optional[int] = None
    userId: Optional[str] = None

    @model_validator(mode="after")
    def _validate_corrected_transcription(self) -> Self:
        if not text_matches_script(self.corrected_transcription, self.language):
            raise ValueError("Please type the corrected transcription in the chosen language only")
        return self


# --------------------
# Validation: Skip / Report
# --------------------

class DekhoValidationSkipRequest(BaseModel):
    item_id: str
    reason: Optional[str] = None
    userId: Optional[str] = None


class DekhoValidationReportRequest(BaseModel):
    item_id: str
    report_type: str
    description: Optional[str] = None
    userId: Optional[str] = None


# --------------------
# Validation Session Complete
# --------------------

class DekhoValidationSessionCompleteResponse(BaseModel):
    summary: Dict[str, int]
