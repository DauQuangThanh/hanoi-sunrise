# Agent Skill Creation - Quick Start Guide

## 5-Minute Skill Creation

### Step 1: Choose Your Skill Name (30 seconds)

Valid names:

- `pdf-processor`
- `code-analyzer`
- `api-documentation-generator`

Invalid names:

- ❌ `PDF-Processor` (uppercase)
- ❌ `pdf_processor` (underscores)
- ❌ `-pdf-processor` (starts with hyphen)

### Step 2: Write Your Description (2 minutes)

Use this formula:

```
[What it does] + [When to use] + [Keywords]
```

**Example:**

```yaml
description: "Analyzes Python code for bugs, security issues, and style violations. Use when reviewing code, preparing for deployment, or when user mentions code quality, linting, or security audit."
```

### Step 3: Generate Skill Scaffold (1 minute)

```bash
cd /path/to/skills/directory

python3 scripts/generate-skill.py \
  --name code-analyzer \
  --description "Analyzes Python code for bugs, security issues, and style violations. Use when reviewing code or when user mentions code quality." \
  --author "Your Name"
```

### Step 4: Customize SKILL.md (1.5 minutes)

Edit the generated `SKILL.md`:

1. Fill in "When to Use" section with specific scenarios
2. Add Prerequisites (tools, packages needed)
3. Write step-by-step Instructions
4. Add at least one concrete Example

### Step 5: Validate (30 seconds)

```bash
python3 scripts/validate-skill.py ./code-analyzer
```

Fix any errors reported by the validator.

---

## Complete Example: JSON Validator Skill

### 1. Generate

```bash
python3 scripts/generate-skill.py \
  --name json-validator \
  --description "Validates JSON files against schemas, checks syntax, and reports errors. Use when working with JSON data or when user mentions JSON validation, schema checking." \
  --with-scripts
```

### 2. Customize SKILL.md

```markdown
---
name: json-validator
description: "Validates JSON files against schemas, checks syntax, and reports errors. Use when working with JSON data or when user mentions JSON validation, schema checking."
license: MIT
metadata:
  author: Your Name
  version: "1.0.0"
---

# JSON Validator

## When to Use

- Validating JSON file syntax
- Checking JSON against a schema
- Debugging malformed JSON
- Pre-deployment data validation

## Prerequisites

- Python 3.8+
- jsonschema library: `pip install jsonschema`

## Instructions

### Step 1: Load JSON File

Read and parse the JSON file:
```python
import json

with open('data.json', 'r') as f:
    data = json.load(f)
```

### Step 2: Validate Syntax

Check for valid JSON syntax. Handle errors:

```python
try:
    data = json.loads(json_string)
except json.JSONDecodeError as e:
    print(f"Invalid JSON: {e}")
```

### Step 3: Validate Against Schema (Optional)

If a schema is provided:

```python
from jsonschema import validate, ValidationError

try:
    validate(instance=data, schema=schema)
    print("Valid!")
except ValidationError as e:
    print(f"Validation error: {e.message}")
```

## Examples

### Example 1: Basic Validation

**Input:**

```json
{
  "name": "John Doe",
  "age": 30,
  "email": "john@example.com"
}
```

**Command:**

```bash
python3 scripts/json-validator.py --input data.json
```

**Output:**

```
✓ JSON syntax is valid
✓ All required fields present
```

### Example 2: Schema Validation

**Input:** data.json + schema.json

**Command:**

```bash
python3 scripts/json-validator.py --input data.json --schema schema.json
```

**Output:**

```
✓ JSON valid against schema
```

## Error Handling

### Error: Invalid JSON Syntax

**Symptoms:**

```
JSONDecodeError: Expecting ',' delimiter: line 5 column 3
```

**Resolution:**

1. Check for missing commas
2. Verify quotes are balanced
3. Ensure no trailing commas
4. Use a JSON formatter

### Error: Schema Validation Failed

**Resolution:**

1. Review schema requirements
2. Check field types match schema
3. Ensure required fields present

## Scripts

```bash
python3 scripts/json-validator.py --input data.json
python3 scripts/json-validator.py --input data.json --schema schema.json
```

```

### 3. Implement Script

Edit `scripts/json-validator.py`:

```python
#!/usr/bin/env python3
import json
import sys
import argparse
from pathlib import Path

def validate_json_file(file_path: Path, schema_path: Path = None):
    """Validate JSON file."""
    
    # Read and parse JSON
    try:
        with open(file_path, 'r') as f:
            data = json.load(f)
        print(f"✓ Valid JSON syntax: {file_path}")
    except json.JSONDecodeError as e:
        print(f"✗ Invalid JSON syntax: {e}")
        return False
    
    # Validate against schema if provided
    if schema_path:
        try:
            from jsonschema import validate, ValidationError
            
            with open(schema_path, 'r') as f:
                schema = json.load(f)
            
            validate(instance=data, schema=schema)
            print("✓ Valid against schema")
        except ValidationError as e:
            print(f"✗ Schema validation failed: {e.message}")
            return False
        except ImportError:
            print("Warning: jsonschema not installed. Run: pip install jsonschema")
    
    return True

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', required=True)
    parser.add_argument('--schema', required=False)
    args = parser.parse_args()
    
    input_path = Path(args.input)
    schema_path = Path(args.schema) if args.schema else None
    
    if not input_path.exists():
        print(f"Error: File not found: {input_path}")
        sys.exit(1)
    
    success = validate_json_file(input_path, schema_path)
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
```

### 4. Validate

```bash
python3 scripts/validate-skill.py ./json-validator
```

### 5. Test

```bash
# Create test JSON
echo '{"name": "test"}' > test.json

# Test the skill
python3 json-validator/scripts/json-validator.py --input test.json
```

---

## Common Patterns

### Pattern 1: Analysis Skill

**Structure:**

```
skill-name/
├── SKILL.md
└── scripts/
    └── analyze.py
```

**Focus:** Examining and reporting on existing content

### Pattern 2: Generation Skill

**Structure:**

```
skill-name/
├── SKILL.md
├── templates/
│   └── output-template.md
└── scripts/
    └── generate.py
```

**Focus:** Creating new content from inputs

### Pattern 3: Transformation Skill

**Structure:**

```
skill-name/
├── SKILL.md
└── scripts/
    └── transform.py
```

**Focus:** Converting from one format to another

### Pattern 4: Workflow Skill

**Structure:**

```
skill-name/
├── SKILL.md
└── references/
    └── workflow-steps.md
```

**Focus:** Multi-step processes with decision points

---

## Troubleshooting

### Validation Fails: "Invalid skill name"

**Cause:** Name doesn't follow rules

**Fix:** Use lowercase, hyphens only, no leading/trailing hyphens

### Validation Fails: "Description too short"

**Cause:** Description < 50 characters

**Fix:** Add what it does, when to use, and keywords

### Agent Doesn't Activate Skill

**Cause:** Poor description, missing keywords

**Fix:** Enhance description with specific use cases and keywords users would say

### Scripts Don't Run on Windows

**Cause:** Only Bash scripts provided

**Fix:** Add Python version (cross-platform) or .ps1 version

---

## Next Steps

1. **Deploy:** Copy skill to agent's skill directory
2. **Test:** Try activating with various prompts
3. **Iterate:** Gather feedback and improve
4. **Share:** Document and share with team
5. **Maintain:** Update as tools and practices evolve

## Resources

- Full specification: [agent-skills-creation-rules.md](../../rules/agent-skills-creation-rules.md)
- Platform locations: [agent-skills-folder-mapping.md](../../rules/agent-skills-folder-mapping.md)
- Template: [templates/skill-template.md](../templates/skill-template.md)
