from sqlalchemy import Column, Integer, String, Date, DateTime, Boolean
from sqlalchemy.sql import func
from app.core.db import Base


class WorkOrder(Base):
    __tablename__ = "WorkOrders"   # real SQL table name

    # Primary Key
    RecordNo = Column(Integer, primary_key=True, index=True)

    # Timestamps
    CreatedAt = Column(
        DateTime,
        server_default=func.now(),
        nullable=True,
        index=True,
    )

    # Core fields
    WorkOrderNo = Column(String)
    PartNo = Column(String)
    CustomerName = Column(String)
    AlloyCode = Column(String)
    QtyRequired = Column(Integer)
    RushDueDate = Column(Date)
    SerialNo = Column(String)
    StatusNotes = Column(String)

    # Process flags
    MoldingFinished = Column(Boolean)
    PouringFinished = Column(Boolean)
    HeatTreatFinished = Column(Boolean)
    MachiningFinished = Column(Boolean)
    AssemblyFinished = Column(Boolean)
    FinalInspComp = Column(Boolean)

    # Status
    Status = Column(String)
