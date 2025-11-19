
import os, json

MODULES=["suno","likho","dekho"]

def test_data_directories_exist():
    for m in MODULES:
        assert os.path.exists(f"data/{m}/queue")
        assert os.path.exists(f"data/{m}/validation")

def test_sample_batch_json_validity():
    for m in MODULES:
        for t in ["queue","validation"]:
            path=f"data/{m}/{t}/sample_batch.json"
            assert os.path.exists(path)
            with open(path,"r",encoding="utf8") as f:
                obj=json.load(f)
                assert isinstance(obj,list)

def test_routes_exist(client):
    for e in ["/suno/instructions","/likho/instructions","/dekho/instructions"]:
        assert client.get(e).status_code!=404

def test_apiresponse_structure(client):
    body=client.get("/suno/help").json()
    assert "success" in body and "data" in body and "error" in body
