Work Orders CRUD, Sorting, and Role Enforcement

Patch README

1. Purpose of This Document

This README documents a platform patch that introduces create and update capabilities for work orders, server-side sorting, and administrative role enforcement. It provides a clear operational description, application steps, and validation guidance to support consistent deployment and audit readiness.

This patch is intended for platform maintainers and authorized administrators.

2. Patch Overview

This patch extends existing work order functionality by enabling controlled creation and modification of records, enforcing administrative permissions, and improving data retrieval through server-side sorting.

All changes are designed to integrate with the current platform architecture and security model.

3. Functional Scope
3.1 Backend Changes

The backend introduces the following capabilities:

Server-side sorting for work order listings via query parameters:

sort_by

sort_dir

Creation and update endpoints for work orders:

Creation via POST /api/workorders

Update via PUT /api/workorders/{record_no}

Administrative role enforcement:

Only users with Users.is_admin = 1 may create or update work orders

Database migration:

Adds Users.is_admin column with a default value of 0

All create and update operations are explicitly restricted to administrative users.

3.2 Frontend Changes

The frontend introduces controlled administrative interfaces:

An accessible modal form for creating and editing work orders

Form handling implemented with react-hook-form

Input validation implemented with zod

These interfaces are available only to users authorized to perform administrative actions.

4. Application Instructions

Apply this patch using the following standard procedure from the repository root.

Step 1: Extract Patch Files

Unzip the patch archive at the repository root

Preserve all directory paths during extraction

Step 2: Ensure Frontend Dependencies

Install required frontend dependencies:

docker compose exec web npm i react-hook-form zod


This step is required to support form handling and validation.

Step 3: Rebuild and Restart Services

Rebuild and restart all platform services:

docker compose up --build -d


This ensures all backend and frontend changes are applied.

Step 4: Apply Database Migration

Run the database migration:

docker compose exec api alembic upgrade head


This adds the is_admin column to the Users table when required.

Step 5: Assign Administrative Access

Mark an administrative user. Example SQL:

UPDATE Users
SET is_admin = 1
WHERE email = 'admin@example.com';


This step is required before testing create or update functionality.

Step 6: Validate in the User Interface

Log in using an administrative account

Use New Work Order to create a record

Click an existing work order row to edit it

Successful execution confirms correct role enforcement and UI integration.

5. API Endpoints

The following endpoints are affected or introduced:

GET /api/workorders

Query parameters:

q

page

page_size

sort_by = RecordNo | CreatedAt

sort_dir = asc | desc

POST /api/workorders

Creates a work order

Administrative access only

PUT /api/workorders/{record_no}

Updates a work order

Administrative access only

6. Operational and Compliance Notes

If the Users.is_admin column already exists, the migration will perform no action

Column presence should be verified if schema state is uncertain

Validation rules:

Description is required

Status is optional

CreatedAt defaults to server time on creation

These controls ensure predictable behavior, data integrity, and audit traceability.

7. Summary for Quick Reference

Enables controlled create and update operations for work orders

Adds server-side sorting for consistent data retrieval

Enforces administrative role checks at the API level

Introduces a documented database migration

Provides accessible, validated frontend forms for administrators

8. Review and Validation

This documentation should be reviewed as part of standard release governance. Operational and compliance stakeholders must validate accuracy, access controls, and migration behavior before production use.