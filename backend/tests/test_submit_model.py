from models import SubmitRequest

def test_submit_likho_valid():
    req = SubmitRequest(
        module="likho",
        item_id="x",
        language="bn",
        payload={"translation": "বাংলা"}
    )
    assert req.payload["translation"] == "বাংলা"


def test_submit_dekho_valid():
    req = SubmitRequest(
        module="dekho",
        item_id="x",
        language="gu",
        payload={"label": "ગુજરાતી"}
    )
    assert req.payload["label"] == "ગુજરાતી"
