"""
Pydantic models for AgriDaan API
All request/response models based on the API documentation
"""
from pydantic import BaseModel, Field, EmailStr
from typing import List, Optional, Dict, Any
from datetime import datetime
from enum import Enum

# ==================== Authentication Models ====================

class SendOTPRequest(BaseModel):
    mobileNo: str = Field(..., pattern="^[6-9]\\d{9}$", example="9177454678")
    countryCode: str = Field(default="+91", example="+91")

class SendOTPResponse(BaseModel):
    success: bool = True
    message: str = "OTP sent successfully"
    data: Dict[str, Any] = Field(example={
        "sessionId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
        "expiresIn": 300,
        "expiresAt": "2025-09-29T10:35:00Z",
        "isNewUser": False
    })

class ResendOTPRequest(BaseModel):
    sessionId: str = Field(..., format="uuid")

class VerifyOTPRequest(BaseModel):
    sessionId: str = Field(..., format="uuid")
    otp: str = Field(..., pattern="^\\d{6}$", example="536247")

class VerifyOTPResponse(BaseModel):
    success: bool = True
    message: str = "Login successful"
    data: Dict[str, Any] = Field(example={
        "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
        "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
        "tokenType": "Bearer",
        "expiresIn": 86400,
        "user": {},
        "requiresConsent": True,
        "requiresProfile": False
    })

class ConsentRequest(BaseModel):
    termsAccepted: bool
    privacyAccepted: bool
    copyrightAccepted: bool
    consentText: Optional[Dict[str, str]] = None

class ConsentResponse(BaseModel):
    success: bool = True
    message: str = "Consent recorded successfully"
    data: Dict[str, Any] = Field(example={
        "consentId": "consent-123-abc",
        "consentTimestamp": "2025-01-17T10:30:00Z",
        "ipAddress": "192.168.1.1"
    })

# ==================== User Profile Models ====================

class AgeGroup(str, Enum):
    UNDER_18 = "Under 18"
    AGE_18_25 = "18-25 years"
    AGE_26_30 = "26-30 years"
    AGE_31_40 = "31-40 years"
    AGE_41_50 = "41-50 years"
    AGE_51_60 = "51-60 years"
    ABOVE_60 = "Above 60"

class Gender(str, Enum):
    MALE = "Male"
    FEMALE = "Female"
    OTHER = "Other"
    PREFER_NOT_SAY = "Prefer not to say"

class UserRegistrationRequest(BaseModel):
    firstName: str = Field(..., min_length=2, max_length=50, example="Ragani")
    lastName: str = Field(..., min_length=2, max_length=50, example="Shukla")
    ageGroup: AgeGroup = Field(..., example="26-30 years")
    gender: Gender = Field(..., example="Female")
    mobileNo: Optional[str] = Field(None, example="9177454678")
    email: Optional[EmailStr] = Field(None, example="user@example.com")
    country: str = Field(..., example="India")
    state: str = Field(..., example="Maharashtra")
    district: str = Field(..., example="Amravati")
    preferredLanguage: str = Field(..., example="Marathi")

class UserProfile(BaseModel):
    userId: str = Field(..., format="uuid")
    firstName: str = Field(..., example="Ragani")
    lastName: str = Field(..., example="Shukla")
    mobileNo: str = Field(..., example="+919177454678")
    email: Optional[str] = Field(None, example="user@example.com")
    ageGroup: str = Field(..., example="26-30 years")
    gender: str = Field(..., example="Female")
    country: str = Field(..., example="India")
    state: str = Field(..., example="Maharashtra")
    district: str = Field(..., example="Amravati")
    preferredLanguage: str = Field(..., example="Marathi")
    contributionCount: int = Field(default=0, example=5)
    validationCount: int = Field(default=0, example=25)
    certificateEarned: bool = Field(default=False)
    certificateId: Optional[str] = Field(None)
    consentGiven: bool = Field(default=False)
    consentTimestamp: Optional[datetime] = Field(None)
    createdAt: datetime = Field(default_factory=datetime.utcnow)
    updatedAt: datetime = Field(default_factory=datetime.utcnow)

class UserStatsResponse(BaseModel):
    success: bool = True
    data: Dict[str, Any] = Field(example={
        "contributionCount": 5,
        "validationCount": 25,
        "certificateEligible": True,
        "certificateIssued": False,
        "certificateId": "CERT-2025-001",
        "lastContributionDate": "2025-01-17T10:30:00Z",
        "lastValidationDate": "2025-01-17T10:30:00Z"
    })

# ==================== Location Models ====================

class Country(BaseModel):
    countryId: str = Field(..., example="IN")
    countryName: str = Field(..., example="India")
    countryCode: str = Field(..., example="+91")

class State(BaseModel):
    stateId: str = Field(..., example="MH")
    stateName: str = Field(..., example="Maharashtra")

class District(BaseModel):
    districtId: str = Field(..., example="MH-AMR")
    districtName: str = Field(..., example="Amravati")

class Language(BaseModel):
    languageCode: str = Field(..., example="mr")
    languageName: str = Field(..., example="Marathi")
    nativeName: str = Field(..., example="मराठी")
    isActive: bool = Field(default=True)

# ==================== Contribution Models ====================

class GetSentencesRequest(BaseModel):
    language: str = Field(..., example="Marathi")
    count: int = Field(default=5, maximum=5, example=5)

class Sentence(BaseModel):
    sentenceId: str = Field(..., example="sent-12345")
    text: str = Field(..., example="तुम्ही मला नेहमीच किल्ल्यांबाबत सांगता तशी त्या मार्गदर्शकाने आम्हांला किल्ल्याबाबत खूप छान माहिती पुरवली.")
    sequenceNumber: int = Field(..., minimum=1, maximum=5, example=1)
    metadata: Optional[Dict[str, Any]] = None

class GetSentencesResponse(BaseModel):
    success: bool = True
    data: Dict[str, Any] = Field(example={
        "sessionId": "session-123-abc",
        "language": "Marathi",
        "sentences": [],
        "totalCount": 5
    })

class RecordContributionRequest(BaseModel):
    sessionId: str = Field(..., format="uuid")
    sentenceId: str = Field(...)
    duration: float = Field(..., example=20.0)
    language: str = Field(..., example="Marathi")
    sequenceNumber: int = Field(..., example=1)
    metadata: Optional[str] = Field(None)

class RecordContributionResponse(BaseModel):
    success: bool = True
    message: str = "Recording submitted successfully"
    data: Dict[str, Any] = Field(example={
        "contributionId": "contrib-123-abc",
        "audioUrl": "https://storage.example.com/audio/123.mp3",
        "duration": 20.0,
        "status": "pending",
        "sequenceNumber": 1,
        "totalInSession": 5,
        "remainingInSession": 4,
        "progressPercentage": 20
    })

class SkipSentenceRequest(BaseModel):
    sessionId: str = Field(..., format="uuid")
    sentenceId: str = Field(...)
    reason: Optional[str] = Field(None, example="too_difficult")
    comment: Optional[str] = Field(None, max_length=200)

class ReportSentenceRequest(BaseModel):
    sentenceId: str = Field(...)
    reportType: str = Field(..., example="inappropriate")
    description: Optional[str] = Field(None, max_length=500)

# ==================== Validation Models ====================

class ValidationItem(BaseModel):
    contributionId: str = Field(..., format="uuid")
    sentenceId: str = Field(...)
    text: str = Field(..., example="तुम्ही मला नेहमीच किल्ल्यांबाबत सांगता तशी त्या मार्गदर्शकाने आम्हांला किल्ल्याबाबत खूप छान माहिती पुरवली.")
    audioUrl: str = Field(..., format="uri")
    duration: float = Field(..., example=20.0)
    sequenceNumber: int = Field(..., minimum=1, maximum=25, example=1)

class GetValidationQueueResponse(BaseModel):
    success: bool = True
    data: Dict[str, Any] = Field(example={
        "sessionId": "validation-session-123",
        "language": "Marathi",
        "validationItems": [],
        "totalCount": 25
    })

class SubmitValidationRequest(BaseModel):
    sessionId: str = Field(..., format="uuid")
    contributionId: str = Field(..., format="uuid")
    sentenceId: str = Field(...)
    decision: str = Field(..., example="correct")
    feedback: Optional[str] = Field(None, max_length=200)
    sequenceNumber: int = Field(..., example=1)

class SubmitValidationResponse(BaseModel):
    success: bool = True
    message: str = "Validation submitted successfully"
    data: Dict[str, Any] = Field(example={
        "validationId": "valid-123-abc",
        "sequenceNumber": 1,
        "totalInSession": 25,
        "remainingInSession": 24,
        "progressPercentage": 4
    })

# ==================== Certificate Models ====================

class CertificateEligibilityResponse(BaseModel):
    success: bool = True
    data: Dict[str, Any] = Field(example={
        "isEligible": True,
        "contributionsCompleted": 5,
        "contributionsRequired": 5,
        "validationsCompleted": 25,
        "validationsRequired": 25,
        "certificateIssued": False,
        "certificateId": "CERT-2025-001",
        "percentageComplete": 100
    })

class GenerateCertificateResponse(BaseModel):
    success: bool = True
    message: str = "Congratulations!"
    data: Dict[str, Any] = Field(example={
        "certificateId": "CERT-2025-001",
        "recipientName": "Animesh Patil",
        "badgeName": "Agri Bhasha Samarthak",
        "issuedDate": "2025-09-17",
        "contributionsCount": 5,
        "validationsCount": 25,
        "certificateUrl": "https://storage.example.com/certificates/123.pdf",
        "thumbnailUrl": "https://storage.example.com/certificates/123.png",
        "shareUrl": "https://agridaan.gov.in/certificate/123"
    })

# ==================== System Models ====================

class SystemConfigResponse(BaseModel):
    success: bool = True
    data: Dict[str, Any]

class HealthResponse(BaseModel):
    success: bool = True
    message: str = "System is healthy"
    data: Dict[str, Any] = Field(example={
        "status": "healthy",
        "timestamp": "2025-01-17T10:30:00Z",
        "version": "1.0.0",
        "uptime": 86400,
        "services": {
            "database": "up",
            "storage": "up",
            "external_apis": "up"
        }
    })

class VersionResponse(BaseModel):
    success: bool = True
    data: Dict[str, Any] = Field(example={
        "apiVersion": "1.0.0",
        "buildVersion": "1.0.0-build.123",
        "buildDate": "2025-01-17T08:15:30Z",
        "environment": "production",
        "features": ["voice_contributions", "audio_validation", "certificate_generation"],
        "supportedLanguages": [],
        "limits": {
            "maxAudioSize": 10485760,
            "maxAudioDuration": 300,
            "sessionTimeout": 1800
        },
        "dependencies": {
            "database": "PostgreSQL 14.5",
            "cache": "Redis 6.2",
            "storage": "AWS S3"
        }
    })

# ==================== Error Models ====================

class ErrorResponse(BaseModel):
    success: bool = False
    error: Dict[str, Any] = Field(example={
        "code": "ERROR_CODE",
        "message": "Error message",
        "details": {},
        "timestamp": "2025-01-17T10:30:00Z"
    })

class ValidationError(BaseModel):
    success: bool = False
    error: Dict[str, Any] = Field(example={
        "code": "VALIDATION_ERROR",
        "message": "This field is required to continue.",
        "field": "district",
        "validationErrors": []
    })

# --- Phase 2 Models: AI4I Contribute ---
from enum import Enum
from pydantic import BaseModel, Field
from typing import Optional, List, Dict, Any

# --------------------------------------------------------------------
# Shared Models

class Module(str, Enum):
    SUNO = "suno"
    LIKHO = "likho"
    DEKHO = "dekho"

class APIError(BaseModel):
    code: int = Field(..., example=400)
    message: str = Field(..., example="Invalid language code")
    details: Optional[Dict[str, Any]] = None

class APIResponse(BaseModel):
    success: bool = True
    data: Optional[Any] = None
    error: Optional[APIError] = None

# --------------------------------------------------------------------
# /queue Request & Response Models

class QueueRequest(BaseModel):
    module: Module
    language: str = Field(..., description="ISO 639-1 code, e.g. 'hi'")
    batch_size: Optional[int] = Field(5, description="Requested batch size")

class QueueItem(BaseModel):
    item_id: str
    language: str
    data_url: Optional[str] = Field(None, description="URL or path to media (audio/image)")
    text_input: Optional[str] = Field(None, description="Input text for translation tasks")
    metadata: Optional[Dict[str, Any]] = None

class QueueResponse(APIResponse):
    data: Optional[List[QueueItem]] = None

# --------------------------------------------------------------------
# /submit Request & Response Models

class SubmitRequest(BaseModel):
    module: Module
    item_id: str
    language: str
    payload: Dict[str, Any] = Field(..., description="User response payload (transcript/translation/label)")
    metadata: Optional[Dict[str, Any]] = None
    client_timestamp: Optional[str] = None

class SubmitResponse(APIResponse):
    data: Optional[Dict[str, Any]] = None

# --------------------------------------------------------------------
# /session-complete Request & Response Models

class SessionCompleteRequest(BaseModel):
    module: Module
    language: str
    session_id: Optional[str] = None
    items_submitted: Optional[List[Dict[str, Any]]] = None
    session_start: Optional[str] = None
    session_end: Optional[str] = None

class SessionCompleteResponse(APIResponse):
    data: Optional[Dict[str, Any]] = None
