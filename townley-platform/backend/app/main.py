from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.routes.auth import router as auth_router
from app.api.routes.workorders import router as workorders_router
from app.api.routes.workorders_admin import router as workorders_admin_router
from app.api.routes.jobs import router as jobs_router

app = FastAPI(title="Townley Platform API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost", "http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/api/health")
def health():
    return {"status": "ok"}

app.include_router(auth_router)
app.include_router(workorders_router)
app.include_router(workorders_admin_router)
app.include_router(jobs_router)