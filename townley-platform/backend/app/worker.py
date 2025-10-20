from rq import Worker
from app.jobs.queue import _redis

if __name__ == "__main__":
    Worker(["default"], connection=_redis).work(with_scheduler=True)
