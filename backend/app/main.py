from fastapi import FastAPI
from .routers import auth

app = FastAPI(title="AI Placement Copilot Backend", version="0.1.0")

# Include routers
app.include_router(auth.router, prefix="/auth", tags=["auth"])

@app.get("/health")
async def health_check():
    return {"status": "ok"}
