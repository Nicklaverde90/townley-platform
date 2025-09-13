from fastapi import FastAPI
app = FastAPI(title="Townley API")
@app.get("/api/health")
def health(): return {"status":"ok"}
