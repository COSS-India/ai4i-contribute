from models import SessionCompleteRequest

def test_session_complete_basic():
    req = SessionCompleteRequest(
        module="suno",
        language="hi",
        session_id="123",
        items_submitted=[
            {"item_id": "a"},
            {"item_id": "b"},
        ]
    )

    assert req.session_id == "123"
    assert isinstance(req.items_submitted, list)
    assert req.items_submitted[0]["item_id"] == "a"
