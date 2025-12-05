from pydantic import BaseModel, Field, model_validator
from typing import Optional, List, Dict, Any, Self

from validators.script_validator import text_matches_script

# ================================================================
#                     SUNO (TRANSCRIPTION)
#                     DPG-BALANCED MODELS
# ================================================================

# --------------------
# Queue (Contribution)
# --------------------

class SunoQueueRequest(BaseModel):
    language: str = Field(..., example="hi")  # ISO code only
    batch_size: Optional[int] = Field(5, description="Requested batch size (default 5)")
    userId: Optional[str] = None


class SunoQueueItem(BaseModel):
    item_id: str
    language: str
    audio_url: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None


class SunoQueueResponse(BaseModel):
    sessionId: str
    language: str
    items: List[SunoQueueItem]
    totalCount: int


# --------------------
# Submit Transcription (Contribution)
# --------------------

class SunoSubmitRequest(BaseModel):
    item_id: str
    language: str  # ISO code only
    transcript: str
    sequenceNumber: Optional[int] = None  # ✅ aligned with BOLO
    metadata: Optional[Dict[str, Any]] = None
    userId: Optional[str] = None

    @model_validator(mode="after")
    def _validate_transcript(self) -> Self:
        if not text_matches_script(self.transcript, self.language):
            raise ValueError("Please type in your chosen language only")
        return self


class SunoSubmitResponse(BaseModel):
    item_id: str
    status: str
    sequenceNumber: int
    totalInSession: int
    remainingInSession: int
    progressPercentage: int


# --------------------
# Skip / Report (Contribution)
# --------------------

class SunoSkipRequest(BaseModel):
    item_id: str
    reason: Optional[str] = None
    userId: Optional[str] = None


class SunoReportRequest(BaseModel):
    item_id: str
    report_type: str
    description: Optional[str] = None
    userId: Optional[str] = None


# --------------------
# Session Complete (Contribution)
# --------------------

class SunoSessionCompleteResponse(BaseModel):
    summary: Dict[str, int]


# ================================================================
#                     SUNO VALIDATION
# ================================================================

# --------------------
# Validation Queue
# --------------------

class SunoValidationQueueRequest(BaseModel):
    language: str = Field(..., example="hi")  # ISO code only
    batch_size: Optional[int] = Field(5, description="Requested batch size (default 5)")
    userId: Optional[str] = None


class SunoValidationItem(BaseModel):
    item_id: str
    language: str
    audio_url: Optional[str] = None
    transcript: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None


class SunoValidationQueueResponse(BaseModel):
    sessionId: str
    language: str
    items: List[SunoValidationItem]
    totalCount: int


# --------------------
# Validation: Correct
# --------------------

class SunoValidationAcceptRequest(BaseModel):
    item_id: str
    sequenceNumber: Optional[int] = None
    userId: Optional[str] = None


class SunoValidationProgressResponse(BaseModel):
    validated_item: Optional[str] = None
    corrected_item: Optional[str] = None

    sequenceNumber: int
    totalInSession: int
    remainingInSession: int
    progressPercentage: int


# --------------------
# Validation: Needs Change (Correction)
# --------------------

class SunoValidationCorrectionRequest(BaseModel):
    item_id: str
    language: str  # ISO code only
    corrected_transcript: str
    sequenceNumber: Optional[int] = None
    userId: Optional[str] = None

    @model_validator(mode="after")
    def _validate_corrected_transcript(self) -> Self:
        if not text_matches_script(self.corrected_transcript, self.language):
            raise ValueError("Please type the corrected transcription in the chosen language only")
        return self


# --------------------
# Validation: Skip / Report
# --------------------

class SunoValidationSkipRequest(BaseModel):
    item_id: str
    reason: Optional[str] = None
    userId: Optional[str] = None


class SunoValidationReportRequest(BaseModel):
    item_id: str
    report_type: str
    description: Optional[str] = None
    userId: Optional[str] = None


# --------------------
# Validation Session Complete
# --------------------

class SunoValidationSessionCompleteResponse(BaseModel):
    summary: Dict[str, int]
