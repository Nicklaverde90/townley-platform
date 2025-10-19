import asyncio
from typing import AsyncGenerator, Optional

from fastapi import APIRouter, Depends, Query
from fastapi.responses import StreamingResponse
from sqlalchemy import desc
from sqlalchemy.orm import Session

from app.core.db import get_db
from app.core.deps_role import user_from_query_token
from app.models.users import User
from app.models.workorder_audit import WorkOrderAudit

router = APIRouter(prefix="/api/audit", tags=["audit"])


async def sse_event_generator(db: Session, since_id: Optional[int], poll: float) -> AsyncGenerator[str, None]:
    last_id = since_id
    if last_id is None:
        latest = db.query(WorkOrderAudit).order_by(desc(WorkOrderAudit.id)).first()
        last_id = latest.id if latest else 0
    try:
        while True:
            rows = (
                db.query(WorkOrderAudit)
                    .filter(WorkOrderAudit.id > last_id)
                    .order_by(WorkOrderAudit.id.asc())
                    .limit(200)
                    .all()
            )
            for r in rows:
                last_id = r.id
                payload = {
                    "id": r.id,
                    "ts": r.occurred_at.isoformat() if r.occurred_at else None,
                    "record_no": r.record_no,
                    "action": r.action,
                    "user": r.user_email,
                    "details": r.after_json or r.before_json,
                }
                yield f"data: {payload}\n\n"
            await asyncio.sleep(poll)
    except asyncio.CancelledError:
        return


@router.get("/stream")
async def audit_stream(
    token_user: User = Depends(user_from_query_token),
    poll_interval: float = Query(1.0, ge=0.2, le=10.0),
    since_id: Optional[int] = Query(None, description="Start after this audit id"),
    db: Session = Depends(get_db),
):
    """Server-Sent Events stream of WorkOrderAudit rows."""
    generator = sse_event_generator(db, since_id, poll_interval)
    return StreamingResponse(generator, media_type="text/event-stream")
