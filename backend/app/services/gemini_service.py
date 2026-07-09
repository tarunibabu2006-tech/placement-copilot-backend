import os
import fitz  # PyMuPDF
import google.generativeai as genai

# Setup Gemini API (will read from GEMINI_API_KEY env var)
# We handle the initialization safely.
try:
    genai.configure(api_key=os.environ.get("GEMINI_API_KEY", ""))
except Exception as e:
    print(f"Failed to configure Gemini: {e}")

class GeminiService:
    def __init__(self):
        # We use gemini-1.5-flash as it's the recommended model for standard text tasks
        self.model = genai.GenerativeModel('gemini-1.5-flash')

    def extract_text_from_pdf(self, pdf_bytes: bytes) -> str:
        """Extract text content from uploaded PDF bytes."""
        try:
            doc = fitz.open(stream=pdf_bytes, filetype="pdf")
            text = ""
            for page in doc:
                text += page.get_text()
            return text
        except Exception as e:
            raise Exception(f"Failed to parse PDF: {str(e)}")

    def analyze_resume(self, resume_text: str) -> str:
        """Analyze the resume text using Gemini AI."""
        if not os.environ.get("GEMINI_API_KEY"):
            # Provide mock data if no API key is set for testing purposes
            return '''{
                "score": 75,
                "strengths": ["Good formatting", "Clear project descriptions"],
                "weaknesses": ["Missing quantifiable achievements", "Generic summary"],
                "tips": ["Add impact metrics (e.g. improved performance by X%)", "Include ATS-friendly keywords"]
            }'''

        prompt = f"""
        You are an expert HR recruiter and ATS (Applicant Tracking System) software.
        Analyze the following resume text and provide feedback in strict JSON format.
        Do not include markdown blocks like ```json, just output the raw JSON object.

        Required JSON structure:
        {{
            "score": <integer from 0 to 100 based on quality, ATS readability, and impact>,
            "strengths": [<list of 2-3 strong points>],
            "weaknesses": [<list of 2-3 weak points or missing elements>],
            "tips": [<list of 2-3 actionable tips for improvement>]
        }}

        Resume Text:
        {resume_text}
        """

        try:
            response = self.model.generate_content(prompt)
            # Clean up potential markdown formatting from the response
            result_text = response.text.strip()
            if result_text.startswith("```json"):
                result_text = result_text[7:]
            if result_text.endswith("```"):
                result_text = result_text[:-3]
            
            return result_text.strip()
        except Exception as e:
            raise Exception(f"Gemini AI analysis failed: {str(e)}")
