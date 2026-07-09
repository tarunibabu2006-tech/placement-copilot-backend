import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../api/api_client.dart';
import '../widgets/glass_card.dart';

class ResumeAnalyzerScreen extends StatefulWidget {
  const ResumeAnalyzerScreen({Key? key}) : super(key: key);

  @override
  State<ResumeAnalyzerScreen> createState() => _ResumeAnalyzerScreenState();
}

class _ResumeAnalyzerScreenState extends State<ResumeAnalyzerScreen> {
  final ApiClient _apiClient = ApiClient();
  
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _analysisResult;
  String? _selectedFileName;

  Future<void> _pickAndUploadResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
        _isLoading = true;
        _errorMessage = null;
        _analysisResult = null;
      });

      try {
        final response = await _apiClient.uploadFile(
          '/resume/analyze',
          result.files.single.path!,
          'file', // Field name expected by backend
        );

        if (response.statusCode == 200) {
          setState(() {
            _analysisResult = jsonDecode(response.body);
            _isLoading = false;
          });
        } else {
          final err = jsonDecode(response.body);
          setState(() {
            _errorMessage = err['detail'] ?? 'Failed to analyze resume';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Connection error. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E15),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Resume Analyzer',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          // Background ambient glow
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withOpacity(0.12),
                blurRadius: 100,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassCard(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          size: 64,
                          color: Color(0xFF6366F1),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Upload your Resume',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Get instant AI feedback and ATS scoring (PDF only)',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (_selectedFileName != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              'Selected: $_selectedFileName',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF10B981),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _isLoading ? null : _pickAndUploadResume,
                            icon: _isLoading 
                                ? const SpinKitRing(color: Colors.white, size: 20, lineWidth: 2)
                                : const Icon(Icons.upload_file),
                            label: Text(
                              _isLoading ? 'Analyzing with AI...' : 'Select PDF',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.redAccent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: GoogleFonts.inter(color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (_analysisResult != null) ...[
                    const SizedBox(height: 32),
                    Text(
                      'Analysis Results',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildResultContent(),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultContent() {
    final score = _analysisResult!['score'] ?? 0;
    final strengths = List<String>.from(_analysisResult!['strengths'] ?? []);
    final weaknesses = List<String>.from(_analysisResult!['weaknesses'] ?? []);
    final tips = List<String>.from(_analysisResult!['tips'] ?? []);

    Color scoreColor = Colors.redAccent;
    if (score >= 80) scoreColor = const Color(0xFF10B981); // Green
    else if (score >= 60) scoreColor = const Color(0xFFF59E0B); // Orange

    return Column(
      children: [
        // Score Circle
        GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            children: [
              Text(
                'ATS Match Score',
                style: GoogleFonts.inter(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              CircularPercentIndicator(
                radius: 70.0,
                lineWidth: 12.0,
                animation: true,
                percent: score / 100,
                center: Text(
                  "$score%",
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0,
                    color: Colors.white,
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.white10,
                progressColor: scoreColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Strengths
        _buildListSection('Strengths', Icons.check_circle_outline, const Color(0xFF10B981), strengths),
        const SizedBox(height: 16),
        // Weaknesses
        _buildListSection('Areas to Improve', Icons.warning_amber_rounded, const Color(0xFFF59E0B), weaknesses),
        const SizedBox(height: 16),
        // Actionable Tips
        _buildListSection('Actionable Tips', Icons.lightbulb_outline, const Color(0xFF6366F1), tips),
      ],
    );
  }

  Widget _buildListSection(String title, IconData icon, Color color, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 28.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: Colors.white54, fontSize: 16)),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.inter(color: Colors.white70, height: 1.4),
                      ),
                    ),
                  ],
                ),
              )).toList(),
        ],
      ),
    );
  }
}
