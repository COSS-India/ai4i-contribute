from typing import Optional, List, Tuple
import unicodedata
import re

# =============================================================
#  STRICT SCRIPT VALIDATION
# =============================================================

SCRIPT_RANGES = {
    # Bengali/Assamese
    "as": [(0x0980, 0x09FF)],
    "bn": [(0x0980, 0x09FF)],

    # Devanagari group
    "brx": [(0x0900, 0x097F)],
    "doi": [(0x0900, 0x097F)],
    "hi":  [(0x0900, 0x097F)],
    "mai": [(0x0900, 0x097F)],
    "mr":  [(0x0900, 0x097F)],
    "ne":  [(0x0900, 0x097F)],
    "sa":  [(0x0900, 0x097F)],
    "kok": [(0x0900, 0x097F)],

    # Gujarati
    "gu": [(0x0A80, 0x0AFF)],

    # Gurmukhi
    "pa": [(0x0A00, 0x0A7F)],

    # Odia
    "or": [(0x0B00, 0x0B7F)],

    # Tamil
    "ta": [(0x0B80, 0x0BFF)],

    # Telugu
    "te": [(0x0C00, 0x0C7F)],

    # Kannada
    "kn": [(0x0C80, 0x0CFF)],

    # Malayalam
    "ml": [(0x0D00, 0x0D7F)],

    # Meitei Mayek
    "mni": [(0xABC0, 0xABFF)],

    # Santali
    "sat": [(0x1C50, 0x1C7F)],

    # Arabic script languages
    "ks": [(0x0600, 0x06FF)],
    "sd": [(0x0600, 0x06FF)],
    "ur": [(0x0600, 0x06FF)],

    # English (conservative)
    "en": [(0x0041, 0x007A)],
}

# -------------------------------------------------------------
#  EMOJI DETECTION
# -------------------------------------------------------------

_EMOJI_RE = re.compile(
    "[" 
    "\U0001F300-\U0001F5FF"
    "\U0001F600-\U0001F64F"
    "\U0001F680-\U0001F6FF"
    "\U0001F700-\U0001F77F"
    "\U0001F780-\U0001F7FF"
    "\U0001F800-\U0001F8FF"
    "\U0001F900-\U0001F9FF"
    "\U0001FA00-\U0001FA6F"
    "\U0001FA70-\U0001FAFF"
    "]+", 
    flags=re.UNICODE,
)

def contains_emoji(text: str) -> bool:
    return bool(_EMOJI_RE.search(text))


# -------------------------------------------------------------
#  CHARACTER CLASS HELPERS
# -------------------------------------------------------------

def _char_in_ranges(ch: str, ranges: List[Tuple[int, int]]) -> bool:
    cp = ord(ch)
    for start, end in ranges:
        if start <= cp <= end:
            return True
    return False


def _is_punc_space_symbol_digit(ch: str) -> bool:
    """
    Allowed noise:
    - whitespace (any)
    - punctuation (Unicode P*)
    - symbols     (Unicode S*)
    - digits 0-9
    """
    if ch.isdigit():
        return True

    if ch.isspace():
        return True

    cat = unicodedata.category(ch)
    if cat.startswith("P"):
        return True
    if cat.startswith("S"):
        return True

    return False


# -------------------------------------------------------------
#  STRICT VALIDATION
# -------------------------------------------------------------

def validate_script_exclusive(text: Optional[str], language_code: Optional[str]) -> bool:
    """
    STRICT validator:
      ✔ must contain ≥1 target-script character
      ✔ punctuation/symbols/digits/whitespace allowed
      ✔ emoji rejected
      ✔ ANY foreign-script letter => reject
      ✔ unknown language codes => reject
    """
    if not text or not language_code:
        return False

    if contains_emoji(text):
        return False

    code = language_code.lower()

    # unknown languages are NOT allowed
    if code not in SCRIPT_RANGES:
        return False

    ranges = SCRIPT_RANGES[code]

    seen_native = False

    for ch in text:
        if _is_punc_space_symbol_digit(ch):
            continue

        if _char_in_ranges(ch, ranges):
            seen_native = True
            continue

        # non-punctuation + outside target script => reject
        return False

    return seen_native


# -------------------------------------------------------------
#  BACKWARD COMPATIBILITY WRAPPER
# -------------------------------------------------------------

def text_matches_script(text: Optional[str], language_code: Optional[str]) -> bool:
    return validate_script_exclusive(text, language_code)
