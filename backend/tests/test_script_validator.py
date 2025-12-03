import pytest

from validators.script_validator import text_matches_script


# -------------------------------------------------------------------
# Positive samples per language
# -------------------------------------------------------------------
# NOTE: These samples are chosen to:
#  - contain at least one character in the language's script block
#  - optionally include spaces/punctuation/digits (allowed noise)
#
# They are not meant to be linguistically perfect, only script-correct.
# -------------------------------------------------------------------

POSITIVE_SAMPLES = {
    # Bengali/Assamese block
    "as": "অসমীয়া ভাষা",         # Assamese in Bengali script
    "bn": "বাংলা ভাষা",          # Bengali

    # Devanagari block
    "brx": "भारत",               # Bodo uses Devanagari
    "doi": "डोगरी भाषा",         # Dogri
    "hi":  "हिन्दी भाषा",        # Hindi
    "mai": "मैथिली भाषा",       # Maithili
    "mr":  "मराठी भाषा",        # Marathi
    "ne":  "नेपाली भाषा",        # Nepali
    "sa":  "संस्कृतम्",          # Sanskrit
    "kok": "कोंकणी भाषा",       # Konkani

    # Gujarati
    "gu": "ગુજરાતી ભાષા",

    # Gurmukhi (Punjabi)
    "pa": "ਪੰਜਾਬੀ ਭਾਸ਼ਾ",

    # Odia
    "or": "ଓଡ଼ିଆ ଭାଷା",

    # Tamil
    "ta": "தமிழ் மொழி",

    # Telugu
    "te": "తెలుగు భాష",

    # Kannada
    "kn": "ಕನ್ನಡ ಭಾಷೆ",

    # Malayalam
    "ml": "മലയാളം ഭാഷ",

    # Meitei Mayek (just use characters in range 0xABC0–0xABFF)
    "mni": "\uABC0\uABC1\uABC2",

    # Santali (Ol Chiki, 0x1C50–0x1C7F)
    "sat": "\u1C5A\u1C5B\u1C5C",

    # Arabic script (Kashmiri, Sindhi, Urdu)
    "ks": "سلام کشمیر",          # Kashmiri uses Arabic script
    "sd": "سلام سنڌي",           # Sindhi
    "ur": "یہ اردو زبان ہے",    # Urdu

    # English
    "en": "Hello World! 123",
}


@pytest.mark.parametrize("lang_code,text", POSITIVE_SAMPLES.items())
def test_text_matches_script_positive(lang_code: str, text: str):
    """
    Each supported language code should accept a sample string that
    contains at least one character in its script block.
    """
    assert text_matches_script(text, lang_code) is True


# -------------------------------------------------------------------
# Negative tests: foreign scripts, emoji, unknown language, empty input
# -------------------------------------------------------------------

@pytest.mark.parametrize(
    "lang_code,foreign_text",
    [
        ("hi", "Hello"),         # Latin letters in Devanagari language
        ("bn", "123 A"),         # Latin 'A' for Bengali
        ("ta", "தமிழ் A"),      # Mixed Tamil + Latin
        ("en", "हिन्दी"),       # Devanagari for English
        ("gu", "سلام"),         # Arabic for Gujarati
        ("ur", "বাংলা"),        # Bengali/Assamese for Urdu
    ],
)
def test_text_matches_script_rejects_foreign_script(lang_code: str, foreign_text: str):
    """
    Any non-punctuation character outside the target script range
    must cause validation to fail.
    """
    assert text_matches_script(foreign_text, lang_code) is False


def test_text_matches_script_rejects_emoji():
    text = "हिन्दी 🙂"
    assert text_matches_script(text, "hi") is False


def test_text_matches_script_rejects_unknown_language_code():
    # "xx" is not in SCRIPT_RANGES
    assert text_matches_script("Some text", "xx") is False


@pytest.mark.parametrize(
    "text,lang_code",
    [
        (None, "hi"),
        ("", "hi"),
        ("हिन्दी", None),
        ("", None),
    ],
)
def test_text_matches_script_rejects_empty_or_missing(text, lang_code):
    assert text_matches_script(text, lang_code) is False
