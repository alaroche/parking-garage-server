from typing import Optional

from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/parking_spots")
def read_item(q: Optional[str] = None):
    return {"item_id": item_id, "q": q}
