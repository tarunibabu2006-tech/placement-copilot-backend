# AI Placement Copilot

## Overview
A full‑stack AI‑powered platform to help Indian students prepare for placements.

## Phase 1 – Environment Setup
1. Install the following tools on your development machine:
   - **Visual Studio Code** – code editor.
   - **Python 3.12** – backend language.
   - **Git** – version control.
   - **Node.js (v20+)** – for the React frontend.
   - **MongoDB Compass** – GUI for MongoDB.
2. Clone the repository (once created) and open the project folder in VS Code.

## Project Structure
```
AI_Placement_Copilot/
├── backend/          # FastAPI server
├── frontend/         # React (Vite) app
├── database/         # DB scripts / seed data
├── docs/             # Architecture & design docs
├── tests/            # Automated tests
└── README.md         # This file
```

## Phase 2 – Backend Development (FastAPI)
```bash
# Navigate to backend folder
cd backend
# Install dependencies
pip install fastapi uvicorn
# Run the server
uvicorn main:app --reload
```

The `backend/main.py` file contains a minimal FastAPI app exposing a health‑check endpoint.

## Phase 3 – Database Design
MongoDB collections:
- **users** – user credentials.
- **resumes** – ATS score and suggestions.
- **aptitude_scores** – quantitative, logical, verbal scores.

## Subsequent Phases
- Resume Analyzer (PDF → Gemini → DB)
- Mock Interview (question/answer flow)
- Aptitude Practice (auto‑graded questions)
- Roadmap Generator
- Voice Assistant (Whisper → Gemini)
- Analytics Dashboard (Chart.js)
- Deployment (Render, Vercel, MongoDB Atlas)

---

*Feel free to modify this README as the project evolves.*
