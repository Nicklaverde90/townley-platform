Townley Platform

Townley Platform is an internal, full-stack manufacturing operations system built to support Townley Engineering & Manufacturing’s production execution, operational tracking, and compliance requirements.

The platform centralizes critical manufacturing data—including work orders, production stages, audits, and user roles—into a single, secure system with strong access control, full traceability, and a design that supports future extensibility.

This repository contains the complete application stack along with all supporting infrastructure and tooling.

Core Capabilities
Operations

End-to-end work order lifecycle management

Multi-stage manufacturing workflow tracking

CSV import and export for operational data

Security & Governance

Role-based access control (viewer / editor / admin)

Permission enforcement at both UI and API layers

Comprehensive audit trail for all operational actions

Observability & Audit

Filterable audit log interface

CSV export for compliance and review

Live audit event streaming via Server-Sent Events (SSE)

Architecture

Frontend: React, Vite, Tailwind CSS

Backend: FastAPI, SQLAlchemy

Database: Microsoft SQL Server (ODBC)

Reverse Proxy: Nginx

Infrastructure: Docker Compose

CI: GitHub Actions (linting, testing, builds)

Development Standards: Conventional commits, pre-commit hooks

Repository Structure
/frontend        React frontend application
/backend         FastAPI backend application
/docker          Docker and Nginx configuration
/docs            Platform documentation
docker-compose.yml

Local Development
Prerequisites

Docker Desktop

Node.js (for frontend development)

Python (for backend tooling and scripts)

Start the Stack
docker compose up --build

Local URLs

Frontend: http://localhost

API Health Check: http://localhost/api/health

API Documentation: http://localhost/api/docs

Administration
Create or Promote an Admin User
docker compose exec api python -m app.scripts.create_admin admin@example.com


This command will create the user if it does not exist, or promote an existing user by setting:

role = admin

is_admin = 1

Documentation

Detailed technical documentation is located in the /docs directory.

Start here:
👉 docs/README.md

Status

The platform is under active internal development and is designed to evolve incrementally as operational requirements expand.

Portfolio

🔗 https://nicklavede90.github.io