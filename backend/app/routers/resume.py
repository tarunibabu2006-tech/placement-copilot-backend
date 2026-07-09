import json
from fastapi import APIRouter, Depends, UploadFile, File, HTTPException, status
from sqlalchemy.orm import Session
from .. import database, models, schemas
from ..routers.auth import get_current_user
from ..services.gemini_service import GeminiService

router = APIRouter(
    prefix="/resume",
    tags=["Resume Analyzer"]
)

gemini_service = GeminiService()

@router.post("/analyze")
async def analyze_resume(
    file: UploadFile = File(...),
    current_user: models.User = Depends(get_current_user),
    db: Session = Depends(database.get_db)
):
    if not file.filename.lower().endswith('.pdf'):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Only PDF files are supported"
        )
    
    try:
        # Read file contents
        content = await file.read()
        
        # Extract text using PyMuPDF
        resume_text = gemini_service.extract_text_from_pdf(content)
        
        if not resume_text.strip():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Could not extract text from the PDF. It might be a scanned image or empty."
            )
        
        # Send text to Gemini for analysis
        json_result = gemini_service.analyze_resume(resume_text)
        
        # Parse result to dict to ensure it's valid JSON
        result = json.loads(json_result)
        
        return result
    
    except json.JSONDecodeError:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to parse AI response. Please try again."
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Analysis failed: {str(e)}"
        )
