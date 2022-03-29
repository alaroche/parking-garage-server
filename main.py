from api import garage, auth
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

SECRET_TOKEN = '7c3a4e52502438e4f4596861c6040542a8632a688ffef1ea88c85f19626e71b2'

app = FastAPI()

app.include_router(garage.router)
app.include_router(auth.router)

app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_headers=['*'],
    allow_methods=['*'],
    allow_origins=[
        'http://aaronhost:3000',
        'http://localhost:3000'
    ]
)