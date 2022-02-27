from fastapi import FastAPI
from fastapi import File, UploadFile
from .utils import get_squares, get_fen
from tensorflow.keras.models import load_model
import numpy as np
import os

app = FastAPI()

model = load_model(
    os.path.join(
        os.path.dirname(__file__),
        "..",
        "models",
        "model_custom_dataset_100x100_v2",
        "model_custom_dataset_100x100_v2",
    )
)


def classify(sq):
    predictions = model.predict(sq)
    y_classes = [np.argmax(element) for element in predictions]
    return y_classes


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/api/sample_fen")
def get_sample_fen():
    return {"fen": "3r1rk1/2p2ppp/4b3/2p1P3/p1p5/P1P2BP1/1PP1QP1P/2KR4"}


@app.post("/api/next_best_move")
async def predict_api(file: UploadFile = File(...), text: str = None):
    extension = file.filename.split(".")[-1] in ("jpg", "jpeg", "png")
    if not extension:
        return "Image must be jpg or png format!"
    content = await file.read()
    squares = get_squares(content)
    prediction = classify(squares)
    fen = get_fen(prediction, text)
    return fen


# uvicorn app:app --host 0.0.0.0 --port 12000 --reload
# uvicorn.run(app, host="0.0.0.0", port=12000, reload=True)
# uvicorn Backend.api.app:app --host 0.0.0.0 --port 12000 --reload
