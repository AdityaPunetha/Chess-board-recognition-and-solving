from fastapi import FastAPI
from fastapi import File, UploadFile
from predict import pred

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/api/predict")
def predict(text: str):
    return text


@app.post("/predict/image")
async def predict_api(file: UploadFile = File(...)):
    extension = file.filename.split(".")[-1] in ("jpg", "jpeg", "png")
    if not extension:
        return "Image must be jpg or png format!"
    content = await file.read()
    predictions = pred(content)
    # prediction = convert_image(content)
    return predictions
