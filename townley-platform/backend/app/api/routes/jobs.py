from fastapi import APIRouter, Depends, UploadFile, File, HTTPException
from app.core.admin_deps import require_admin
from app.jobs.queue import q
from app.jobs.importers import import_workorders_csv
from rq.job import Job
from redis.exceptions import RedisError
from app.core.deps import get_current_user

router = APIRouter(prefix="/api", tags=["jobs"])


@router.post("/workorders/import-async")
async def import_async(file: UploadFile = File(...), user=Depends(require_admin)):
    try:
        contents = await file.read()
        job = q.enqueue(
            import_workorders_csv, contents, user.email, job_timeout=60 * 15
        )
        return {"job_id": job.get_id()}
    except RedisError:
        raise HTTPException(status_code=500, detail="Queue unavailable")


@router.get("/jobs/{job_id}")
def job_status(job_id: str, _user=Depends(get_current_user)):
    try:
        job = Job.fetch(job_id, connection=q.connection)
    except Exception:
        raise HTTPException(status_code=404, detail="Job not found")
    resp = {
        "id": job.get_id(),
        "status": job.get_status(),
        "progress": int(job.meta.get("progress", 0)),
        "result": job.result if job.is_finished else None,
    }
    return resp
