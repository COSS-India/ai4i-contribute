from validators.script_validator import text_matches_script

def test_script_ranges_smoke():
    assert text_matches_script("हेलो", "hi")
    assert text_matches_script("বাংলা", "bn")
    assert text_matches_script("ગુજરાતી", "gu")
    assert text_matches_script("ಕನ್ನಡ", "kn")
    assert text_matches_script("తెలుగు", "te")
    assert text_matches_script("தமிழ்", "ta")
    assert text_matches_script("കನ್ನಡ", "ml")

    # Arabic-script languages
    assert text_matches_script("کٲشُر", "ks")
    assert text_matches_script("سنڌي", "sd")
    assert text_matches_script("اردو", "ur")

    # Santali / Ol Chiki
    assert text_matches_script("ᱥᱟᱱᱛᱟᱲᱤ", "sat")
