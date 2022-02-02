from fastapi import FastAPI
from fastapi import File, UploadFile
from utils import get_squares, get_fen
from tensorflow.keras.models import load_model
import numpy as np
import os

app = FastAPI()

model = load_model(
    os.path.join(os.path.dirname(__file__), "..", "models", "V10_100x100_Grayscale_v1")
)


def classify(sq):
    predictions = model.predict(sq)
    y_classes = [np.argmax(element) for element in predictions]
    return y_classes


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.post("/api/nextbestmove")
async def predict_api(file: UploadFile = File(...)):
    extension = file.filename.split(".")[-1] in ("jpg", "jpeg", "png")
    if not extension:
        return "Image must be jpg or png format!"
    content = await file.read()
    squares = get_squares(content)
    prediction = classify(squares)
    fen = get_fen(prediction)
    return fen
