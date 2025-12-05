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

class APIResponse(BaseModel):
    success: bool
    data: Any | None = None
    error: Optional[str] = None
