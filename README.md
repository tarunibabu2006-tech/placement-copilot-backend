# 🚀 AI Placement Copilot

A premium, full-stack, AI-powered placement preparation platform designed specifically for Indian students. The platform guides students from resume building with real-time ATS analysis to interactive mock interviews using state-of-the-art Generative AI.

---

## 🔗 Live Deployments

*   **Interactive API Documentation (Swagger):** [https://placement-copilot-backend-production.up.railway.app/docs](https://placement-copilot-backend-production.up.railway.app/docs)

---

## 🛠 Tech Stack

### Backend
*   **FastAPI** – High-performance asynchronous Python web framework.
*   **PostgreSQL** – Robust relational database deployed in production.
*   **SQLAlchemy ORM & Alembic** – Database models management and migrations.
*   **Google Gemini 1.5 Flash** – Advanced AI model driving resume parsing and ATS analysis.
*   **PyMuPDF** – High-accuracy PDF text extraction.
*   **Docker & Railway** – Modern containerized deployment infrastructure.

### Frontend
*   **Flutter** – Premium cross-platform mobile and web client interface.
*   **Provider** – Structured and robust application state management.
*   **Flutter Secure Storage** – Safely stores user JWT tokens for persistent sessions.
*   **Glassmorphism Design** – Elegant, modern dark mode visuals with ambient glows.

---

## 📂 Project Structure

```
AI_Placement_Copilot/
├── backend/                  # FastAPI Application
│   ├── app/
│   │   ├── database.py       # SQLAlchemy Database configuration
│   │   ├── models.py         # SQLAlchemy Database models (User, etc.)
│   │   ├── schemas.py        # Pydantic validation schemas
│   │   ├── utils.py          # JWT, hashing, and password utilities
│   │   ├── routers/          # API Routers (auth, resume, etc.)
│   │   └── services/         # Services (Gemini AI service)
│   ├── main.py               # Main application entry point
│   ├── requirements.txt      # Python package dependencies
│   └── Dockerfile            # Container configuration
├── frontend/                 # Flutter Application
│   ├── lib/
│   │   ├── api/              # API Client (headers & secure tokens)
│   │   ├── providers/        # State Management (AuthProvider)
│   │   ├── widgets/          # Custom reusable UI widgets (GlassCard)
│   │   ├── screens/          # Application views (Login, Register, Dashboard, ResumeAnalyzer)
│   │   └── main.dart         # Flutter entry point
│   └── pubspec.yaml          # Flutter package dependencies
├── railway.json              # Railway deployment config
└── README.md                 # Project documentation
```

---

## 🚀 Local Setup Guide

### 1. Backend Setup (FastAPI)

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Create and activate a Python virtual environment:
   ```bash
   python -m venv venv
   # On Windows:
   .\venv\Scripts\activate
   # On macOS/Linux:
   source venv/bin/activate
   ```
3. Install required dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Set up environment variables (create a `.env` file):
   ```env
   DATABASE_URL=postgresql://user:password@localhost:5400/dbname
   GEMINI_API_KEY=your_gemini_api_key_here
   ```
5. Run the development server:
   ```bash
   uvicorn main:app --reload
   ```
   Open [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs) in your browser.

### 2. Frontend Setup (Flutter)

1. Ensure you have the Flutter SDK installed on your machine.
2. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
3. Fetch dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app on your emulator or web browser:
   ```bash
   flutter run
   ```

---

## 📈 Roadmaps & Next Phases
- [x] **Phase 1:** Environment setup & structure setup.
- [x] **Phase 2:** Authentication system (FastAPI API and Flutter integration).
- [x] **Phase 3:** AI Resume Analyzer (PDF parsing, Gemini Integration, circular scoring UI).
- [ ] **Phase 4:** AI-driven interactive Mock Interviews (Chat & Speech feedback).
- [ ] **Phase 5:** Aptitude Practice & auto-graded questions module.
- [ ] **Phase 6:** Analytics dashboard & roadmap visualizers.
