# Agent Skill Examples

This document provides complete, real-world examples of different types of agent skills.

## Example 1: PDF Processing Skill (Document Processing)

### Directory Structure

```
pdf-processor/
├── SKILL.md
├── scripts/
│   ├── extract-text.py
│   └── merge-pdfs.py
└── references/
    └── pdf-library-guide.md
```

### SKILL.md

```markdown
---
name: pdf-processor
description: Extracts text and tables from PDF files, fills PDF forms, and merges multiple PDFs. Use when working with PDF documents or when user mentions PDFs, forms, or document extraction.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0.0"
  category: document-processing
---

# PDF Processor

## When to Use

- Extracting text from PDF documents
- Parsing tables and structured data from PDFs
- Filling out PDF forms programmatically
- Merging multiple PDF files
- Converting PDFs to other formats

## Prerequisites

- Python 3.8 or higher
- PyPDF2 library: `pip install PyPDF2`
- pdfplumber library: `pip install pdfplumber`

## Instructions

### Step 1: Extract Text from PDF

For simple text extraction:

```bash
python scripts/extract-text.py input.pdf --output output.txt
```

The script will:

1. Read the PDF file
2. Extract text from all pages
3. Save to output file or print to console

### Step 2: Extract Tables

For structured data extraction:

```bash
python scripts/extract-text.py input.pdf --tables --output data.json
```

Options:

- `--tables`: Extract tables as structured data
- `--pages 1-5`: Extract specific page range
- `--format json|txt|csv`: Output format

### Step 3: Merge PDFs

To combine multiple PDF files:

```bash
python scripts/merge-pdfs.py file1.pdf file2.pdf file3.pdf --output merged.pdf
```

## Examples

### Example 1: Extract Invoice Data

**Input:** invoice_2024-01-15.pdf

**Command:**

```bash
python scripts/extract-text.py invoice_2024-01-15.pdf --tables --format json
```

**Output:**

```json
{
  "invoice_number": "INV-2024-001",
  "date": "2024-01-15",
  "total": 1234.56,
  "items": [
    {"description": "Service A", "amount": 500.00},
    {"description": "Service B", "amount": 734.56}
  ]
}
```

### Example 2: Merge Multiple Reports

**Input:** report_q1.pdf, report_q2.pdf, report_q3.pdf

**Command:**

```bash
python scripts/merge-pdfs.py report_q1.pdf report_q2.pdf report_q3.pdf --output annual_report.pdf
```

**Result:** Single PDF file containing all quarterly reports

## Edge Cases

### Case 1: Password-Protected PDFs

**Description:** PDF requires password to open

**Handling:**

- Prompt user for password
- Pass password to script: `--password <password>`
- Script will attempt to decrypt before processing

### Case 2: Scanned PDFs (No Text Layer)

**Description:** PDF contains only images of text

**Handling:**

- Use OCR (Optical Character Recognition)
- Install tesseract: `brew install tesseract` (macOS) or `apt-get install tesseract-ocr` (Linux)
- Script will automatically detect and apply OCR if needed

### Case 3: Large PDF Files (>50MB)

**Description:** PDF file is very large and may cause memory issues

**Handling:**

- Process in chunks using `--chunk-size 10` option
- Script will process 10 pages at a time
- Output will be written incrementally

## Error Handling

### Error: "File not found"

**Cause:** Input PDF file doesn't exist or path is incorrect

**Resolution:**

1. Check file path is correct
2. Use absolute path if relative path fails
3. Verify file extension is .pdf

### Error: "Module not found: PyPDF2"

**Cause:** Required Python library not installed

**Resolution:**

```bash
pip install PyPDF2 pdfplumber
```

### Error: "Corrupted PDF"

**Cause:** PDF file is damaged or not a valid PDF

**Resolution:**

1. Try opening in PDF reader to verify
2. Use `--repair` option to attempt repair
3. Re-download or obtain new copy of file

## Scripts

All scripts are Python-based for cross-platform compatibility.

### extract-text.py

Extracts text and tables from PDF files.

**Usage:**

```bash
python scripts/extract-text.py <input.pdf> [OPTIONS]

Options:
  --output FILE         Output file (default: stdout)
  --tables              Extract tables as structured data
  --pages START-END     Extract specific page range
  --format FORMAT       Output format: txt, json, csv (default: txt)
  --password PASSWORD   Password for encrypted PDFs
```

### merge-pdfs.py

Merges multiple PDF files into one.

**Usage:**

```bash
python scripts/merge-pdfs.py <input1.pdf> <input2.pdf> ... --output <output.pdf>

Options:
  --output FILE         Output PDF file (required)
  --compress            Compress output file
```

## Additional Resources

See [references/pdf-library-guide.md](references/pdf-library-guide.md) for detailed information about PyPDF2 and pdfplumber libraries.

```

---

## Example 2: Code Security Analyzer (Analysis Skill)

### Directory Structure
```

code-security-analyzer/
├── SKILL.md
├── scripts/
│   └── analyze-security.py
└── references/
    ├── vulnerability-checklist.md
    └── remediation-guide.md

```

### SKILL.md
```markdown
---
name: code-security-analyzer
description: Analyzes code for security vulnerabilities, including SQL injection, XSS, and authentication issues. Use when reviewing code security, conducting security audits, or when user mentions vulnerabilities or security concerns.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0.0"
  category: security
---

# Code Security Analyzer

## When to Use

- Security code reviews before deployment
- Regular security audits
- Investigating security incidents
- Compliance requirements (SOC 2, HIPAA, etc.)
- Pre-commit security checks

## Prerequisites

- Python 3.8 or higher
- bandit library: `pip install bandit`
- Safety library: `pip install safety`
- Access to source code repository

## Instructions

### Step 1: Run Security Scan

Scan codebase for vulnerabilities:

```bash
python scripts/analyze-security.py /path/to/code --output report.json
```

The analyzer will check for:

- SQL injection vulnerabilities
- Cross-site scripting (XSS)
- Hardcoded credentials
- Insecure dependencies
- Authentication/authorization flaws
- Cryptographic issues

### Step 2: Review Findings

The script generates a report with:

- **Critical**: Immediate security risks requiring urgent fixes
- **High**: Significant vulnerabilities to address soon
- **Medium**: Security improvements recommended
- **Low**: Best practice suggestions

### Step 3: Prioritize Remediation

Focus on:

1. Critical vulnerabilities first
2. High-risk items in production code
3. Medium/low issues during regular maintenance

### Step 4: Verify Fixes

After remediation:

```bash
python scripts/analyze-security.py /path/to/code --verify --baseline report.json
```

## Examples

### Example 1: Full Repository Scan

**Input:** Python web application

**Command:**

```bash
python scripts/analyze-security.py ./my-app --output security-report.json
```

**Output:**

```json
{
  "summary": {
    "critical": 2,
    "high": 5,
    "medium": 12,
    "low": 8
  },
  "findings": [
    {
      "severity": "CRITICAL",
      "type": "SQL_INJECTION",
      "file": "app/database.py",
      "line": 45,
      "description": "SQL query uses string formatting instead of parameterized queries",
      "recommendation": "Use parameterized queries or ORM to prevent SQL injection"
    },
    {
      "severity": "HIGH",
      "type": "HARDCODED_PASSWORD",
      "file": "config/settings.py",
      "line": 12,
      "description": "Database password hardcoded in source code",
      "recommendation": "Move credentials to environment variables or secret management system"
    }
  ]
}
```

### Example 2: Pre-Commit Check

**Input:** Modified files in git staging area

**Command:**

```bash
python scripts/analyze-security.py --git-staged --fail-on critical,high
```

**Result:**

- Exits with code 0 if no critical/high vulnerabilities found
- Exits with code 1 if critical/high vulnerabilities found, blocking commit

## Edge Cases

### Case 1: False Positives

**Description:** Scanner flags secure code as vulnerable

**Handling:**

- Review finding carefully
- Add exception with justification: `--ignore CVE-2024-12345 "Reason: ..."`
- Document in `.security-ignore` file

### Case 2: Third-Party Dependencies

**Description:** Vulnerability in external library

**Handling:**

1. Check if update available: `pip list --outdated`
2. Review changelog for breaking changes
3. Update dependency: `pip install --upgrade <package>`
4. Test application thoroughly

### Case 3: Legacy Code with Many Issues

**Description:** Old codebase with numerous vulnerabilities

**Handling:**

- Create remediation plan prioritizing critical/high issues
- Use `--baseline` to track progress over time
- Address issues incrementally

## Error Handling

### Error: "Permission denied"

**Cause:** Script cannot read source files

**Resolution:**

- Check file permissions
- Run with appropriate user privileges
- Verify path is correct

### Error: "Unsupported language"

**Cause:** Codebase uses language not supported by analyzer

**Resolution:**

- Check supported languages in documentation
- Use language-specific security tools
- Combine multiple tools for comprehensive analysis

## Scripts

### analyze-security.py

Scans codebase for security vulnerabilities.

**Usage:**

```bash
python scripts/analyze-security.py <path> [OPTIONS]

Options:
  --output FILE           Output report file (JSON format)
  --format FORMAT         Report format: json, html, sarif
  --severity LEVEL        Minimum severity to report (critical, high, medium, low)
  --fail-on LEVELS        Exit with error if these severity levels found
  --baseline FILE         Compare against baseline report
  --git-staged            Only scan git staged files
  --ignore CODES          Ignore specific vulnerability codes
```

## Additional Resources

- [references/vulnerability-checklist.md](references/vulnerability-checklist.md) - Complete security checklist
- [references/remediation-guide.md](references/remediation-guide.md) - Step-by-step remediation instructions

```

---

## Example 3: API Documentation Generator (Generation Skill)

### Directory Structure
```

api-documentation-generator/
├── SKILL.md
├── scripts/
│   └── generate-docs.py
├── templates/
│   ├── api-template.md
│   └── endpoint-template.md
└── references/
    └── openapi-guide.md

```

### SKILL.md
```markdown
---
name: api-documentation-generator
description: Generates API documentation from code with endpoints, parameters, and examples. Use when creating API docs, documenting REST APIs, or when user mentions API documentation or OpenAPI specifications.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0.0"
  category: documentation
---

# API Documentation Generator

## When to Use

- Documenting new REST APIs
- Updating existing API documentation
- Generating OpenAPI/Swagger specifications
- Creating developer-friendly API guides
- Maintaining API documentation in sync with code

## Prerequisites

- Python 3.8 or higher
- FastAPI, Flask, or Django application
- pydantic library (for FastAPI): `pip install pydantic`

## Instructions

### Step 1: Analyze API Code

Run documentation generator on your API code:

```bash
python scripts/generate-docs.py ./app --output docs/api.md
```

The generator will:

1. Scan source code for API endpoints
2. Extract route definitions, parameters, and responses
3. Generate formatted documentation

### Step 2: Review Generated Documentation

Check the generated docs for:

- Completeness of endpoint descriptions
- Accuracy of parameter definitions
- Example requests and responses
- Authentication requirements

### Step 3: Customize and Enhance

Edit generated documentation to add:

- Business logic explanations
- Usage examples
- Common error scenarios
- Best practices

### Step 4: Generate OpenAPI Specification

For OpenAPI/Swagger format:

```bash
python scripts/generate-docs.py ./app --format openapi --output api-spec.yaml
```

## Examples

### Example 1: FastAPI Application

**Input:** FastAPI application with 10 endpoints

**Command:**

```bash
python scripts/generate-docs.py ./app --format markdown --output docs/api.md
```

**Output:** `docs/api.md`

```markdown
# API Documentation

## Authentication

All endpoints require Bearer token authentication.

```http
Authorization: Bearer <your-token>
```

## Endpoints

### GET /api/users/{id}

**Description:** Retrieves user by ID

**Path Parameters:**

- `id` (integer, required): User ID

**Response:** 200 OK

```json
{
  "id": 123,
  "name": "John Doe",
  "email": "john@example.com"
}
```

**Errors:**

- 404: User not found
- 401: Unauthorized

---

### POST /api/users

**Description:** Creates a new user

**Request Body:**

```json
{
  "name": "Jane Smith",
  "email": "jane@example.com"
}
```

**Response:** 201 Created

```json
{
  "id": 124,
  "name": "Jane Smith",
  "email": "jane@example.com"
}
```

```

### Example 2: Generate OpenAPI Specification

**Command:**
```bash
python scripts/generate-docs.py ./app --format openapi --output openapi.yaml
```

**Output:** `openapi.yaml`

```yaml
openapi: 3.0.0
info:
  title: My API
  version: 1.0.0
paths:
  /api/users/{id}:
    get:
      summary: Get user by ID
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: integer
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
```

## Edge Cases

### Case 1: Undocumented Endpoints

**Description:** Endpoints lack docstrings or type hints

**Handling:**

- Generator creates basic documentation from route definition
- Add manual descriptions after generation
- Encourage developers to add docstrings

### Case 2: Complex Request/Response Models

**Description:** Nested objects or polymorphic types

**Handling:**

- Generator creates schema definitions
- Manual review recommended for accuracy
- Add examples for clarity

### Case 3: Deprecated Endpoints

**Description:** Old endpoints still in code but deprecated

**Handling:**

- Mark as deprecated in documentation
- Include migration instructions
- Set deprecation date

## Error Handling

### Error: "No endpoints found"

**Cause:** Generator cannot locate API routes

**Resolution:**

- Verify correct application path
- Check framework-specific route definitions
- Use `--pattern` option to specify route patterns

### Error: "Invalid type annotation"

**Cause:** Unsupported type hint in code

**Resolution:**

- Use standard Python type hints
- For custom types, add schema definitions
- Simplify complex type annotations

## Scripts

### generate-docs.py

Generates API documentation from source code.

**Usage:**

```bash
python scripts/generate-docs.py <app-path> [OPTIONS]

Options:
  --output FILE          Output documentation file
  --format FORMAT        Output format: markdown, openapi, html
  --title TITLE          API documentation title
  --version VERSION      API version
  --include-examples     Include code examples
  --auth-type TYPE       Authentication type: bearer, basic, oauth2
```

## Templates

Use provided templates to customize output:

- `templates/api-template.md` - Overall documentation structure
- `templates/endpoint-template.md` - Individual endpoint format

Edit these templates to match your documentation style.

## Additional Resources

See [references/openapi-guide.md](references/openapi-guide.md) for detailed OpenAPI specification information.

```

---

## Best Practices from Examples

### 1. Clear Structure
- Use consistent section ordering
- Provide multiple examples
- Include edge cases and error handling

### 2. Practical Examples
- Show real-world usage
- Include input and expected output
- Demonstrate different scenarios

### 3. Complete Prerequisites
- List all required tools and versions
- Include installation commands
- Mention system requirements

### 4. Error Handling
- Document common errors
- Provide clear resolution steps
- Include diagnostic commands

### 5. Script Documentation
- Clear usage instructions
- Document all options
- Provide examples for each option

### 6. Resource References
- Link to detailed guides in references/
- Keep main SKILL.md concise
- Provide additional context where needed
