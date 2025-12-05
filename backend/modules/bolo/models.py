from pydantic import BaseModel, Field
from typing import Optional, List, Dict, Any

# ================================================================
#                     CONTRIBUTION (BOLO)
# ================================================================

class GetSentencesRequest(BaseModel):
    language: str = Field(..., example="hi")
    count: Optional[int] = Field(5, example=5)
    userId: Optional[str] = None


class SentenceItem(BaseModel):
    sentenceId: str
    text: str
    language: str
    sequenceNumber: int
    metadata: Optional[Dict[str, Any]] = None


class BoloQueueResponse(BaseModel):
    sessionId: str
    language: str
    sentences: List[SentenceItem]
    totalCount: int


class RecordContributionRequest(BaseModel):
    sentenceId: str
    audioUrl: str
    duration: Optional[float] = None
    sequenceNumber: Optional[int] = None
    userId: Optional[str] = None


class SubmitContributionResponse(BaseModel):
    contributionId: str
    audioUrl: str
    duration: Optional[float]
    status: str
    sequenceNumber: int
    totalInSession: int
    remainingInSession: int
    progressPercentage: int


class SkipSentenceRequest(BaseModel):
    sentenceId: str
    reason: Optional[str] = None
    userId: Optional[str] = None


class ReportSentenceRequest(BaseModel):
    sentenceId: str
    reportType: str
    userId: Optional[str] = None


class SessionCompleteResponse(BaseModel):
    summary: Dict[str, int]


class TestSpeakerResponse(BaseModel):
    sample_audio: str


# ================================================================
#                     VALIDATION (BOLO)
# ================================================================

class ValidationItem(BaseModel):
    contributionId: str
    sentenceId: str
    text: str
    audioUrl: str
    language: str
    sequenceNumber: int


class ValidationQueueResponse(BaseModel):
    sessionId: str
    language: str
    validationItems: List[ValidationItem]
    totalCount: int


class BoloValidationCorrectRequest(BaseModel):
    contributionId: str
    sequenceNumber: Optional[int] = None
    userId: Optional[str] = None


class BoloValidationCorrectionRequest(BaseModel):
    contributionId: str
    correctedAudioUrl: str
    sequenceNumber: Optional[int] = None
    userId: Optional[str] = None


class BoloValidationSkipRequest(BaseModel):
    contributionId: str
    reason: Optional[str] = None
    userId: Optional[str] = None


class BoloValidationReportRequest(BaseModel):
    contributionId: str
    reportType: str
    description: Optional[str] = None
    userId: Optional[str] = None


class ValidationProgressResponse(BaseModel):
    validated_item: Optional[str] = None
    corrected_item: Optional[str] = None
    correctedAudioUrl: Optional[str] = None
    sequenceNumber: int
    totalInSession: int
    remainingInSession: int
    progressPercentage: int


class ValidationSessionCompleteResponse(BaseModel):
    summary: Dict[str, int]
