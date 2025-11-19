
from validators.script_validator import text_matches_script

def test_valid_hindi():
    assert text_matches_script("नमस्ते","hi")

def test_invalid_hindi_english():
    assert not text_matches_script("Hello नमस्ते","hi")

def test_emoji_rejected():
    assert not text_matches_script("नमस्ते 😊","hi")
