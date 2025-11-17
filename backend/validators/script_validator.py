from typing import Optional

# conservative Unicode range map for AI4I 22 languages (Scheduled Languages)
SCRIPT_RANGES = {
    # Bengali/Assamese scripts
    "as": [(0x0980, 0x09FF)],   # Assamese (Bengali script block)
    "bn": [(0x0980, 0x09FF)],   # Bengali

    # Devanagari (many languages)
    "brx": [(0x0900, 0x097F)],  # Bodo (Devanagari)
    "doi": [(0x0900, 0x097F)],  # Dogri (Devanagari)
    "hi":  [(0x0900, 0x097F)],  # Hindi
    "mai": [(0x0900, 0x097F)],  # Maithili
    "mr":  [(0x0900, 0x097F)],  # Marathi
    "ne":  [(0x0900, 0x097F)],  # Nepali
    "sa":  [(0x0900, 0x097F)],  # Sanskrit
    "kok": [(0x0900, 0x097F)],  # Konkani (commonly Devanagari)

    # Gujarati
    "gu": [(0x0A80, 0x0AFF)],   # Gujarati

    # Gurmukhi (Punjabi)
    "pa": [(0x0A00, 0x0A7F)],   # Gurmukhi

    # Oriya / Odia
    "or": [(0x0B00, 0x0B7F)],   # Odia

    # Tamil
    "ta": [(0x0B80, 0x0BFF)],   # Tamil

    # Telugu
    "te": [(0x0C00, 0x0C7F)],   # Telugu

    # Kannada
    "kn": [(0x0C80, 0x0CFF)],   # Kannada

    # Malayalam
    "ml": [(0x0D00, 0x0D7F)],   # Malayalam

    # Meitei Mayek (Manipuri / mni)
    "mni": [(0xABC0, 0xABFF)],  # Meitei Mayek block

    # Santali (Ol Chiki)
    "sat": [(0x1C50, 0x1C7F)],  # Ol Chiki

    # Arabic-script languages (use Arabic Unicode block)
    "ks": [(0x0600, 0x06FF)],   # Kashmiri (Arabic script chosen)
    "sd": [(0x0600, 0x06FF)],   # Sindhi (Arabic script chosen)
    "ur": [(0x0600, 0x06FF)],   # Urdu

    # English (Latin script)
    "en": [(0x0041, 0x007A)],   # Latin letters (basic A-Z,a-z) — conservative

    # Fallbacks / shortcodes already in repo
    # (If other codes exist, add them with appropriate ranges)
}

def _char_in_ranges(ch: str, ranges) -> bool:
    cp = ord(ch)
    for start, end in ranges:
        if start <= cp <= end:
            return True
    return False

def text_matches_script(text: Optional[str], language_code: Optional[str]) -> bool:
    """
    Return True if text contains at least one character from the script range of language_code.
    If language_code is unknown or empty, return True (do not block unknown languages).
    If text is empty or None, return False (presence should be enforced separately).
    """
    if not text or not language_code:
        return False
    code = language_code.lower()
    if code not in SCRIPT_RANGES:
        # Unknown language: do not strictly enforce here (avoid false negatives)
        return True
    ranges = SCRIPT_RANGES[code]
    for ch in text:
        if _char_in_ranges(ch, ranges):
            return True
    return False
