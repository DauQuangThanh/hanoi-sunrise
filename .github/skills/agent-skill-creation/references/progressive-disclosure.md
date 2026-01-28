# Progressive Disclosure in Agent Skills

## What is Progressive Disclosure?

Progressive disclosure is a loading strategy that helps agents manage their limited context window by loading only what's needed, when it's needed.

## Why It Matters

### Context Window Limitations

All LLMs have a limited context window (token budget) for processing inputs. When an agent has access to hundreds of skills, loading all skill content at once would overflow this context window.

**Example Impact:**

```
Scenario: Agent with 200 available skills

WITHOUT Progressive Disclosure:
- Load all 200 skills fully: 200 × 5,000 tokens = 1,000,000 tokens
- Result: CONTEXT OVERFLOW - Agent cannot function

WITH Progressive Disclosure:
- Load metadata only: 200 × 100 tokens = 20,000 tokens
- Then load 1 activated skill: 20,000 + 5,000 = 25,000 tokens
- Result: EFFICIENT - Agent has room for actual work
```

## Three-Tier Loading Strategy

### Tier 1: Metadata (Always Loaded)

**What loads:**

- Skill `name` field
- Skill `description` field
- Basic frontmatter only

**Token cost:** ~100 tokens per skill

**When:** Agent startup (ALL skills loaded at this tier)

**Purpose:** Skill discovery and selection

**Critical insight:** This is why the `description` field is so important - it's the ONLY information agents have when deciding which skill to activate.

### Tier 2: Instructions (Load on Activation)

**What loads:**

- Complete SKILL.md body content
- All instructions, examples, and guidance
- Everything after the frontmatter

**Token cost:** <5,000 tokens recommended per skill

**When:** Only when skill is activated based on task match

**Purpose:** Detailed execution instructions for the selected skill

**Best practice:** Keep SKILL.md under 500 lines (~5,000 tokens) to maintain efficiency

### Tier 3: Resources (Load on Demand)

**What loads:**

- Files in `scripts/` directory
- Files in `references/` directory
- Files in `assets/` directory
- Files in `templates/` directory

**Token cost:** Variable (can be very large)

**When:** Only when explicitly required by instructions

**Purpose:** Specialized tools, detailed reference documentation, and assets

**Best practice:** Move detailed content to references/ to avoid loading it unless needed

## Impact on Skill Design

### 1. Optimize Description Field

Since Tier 1 is the only thing loaded during discovery:

**Do:**

- Include specific capabilities
- List use cases and scenarios
- Add keywords users might mention
- Use full 1-1024 character limit if needed

**Don't:**

- Be vague ("helps with data")
- Skip keywords
- Assume agents will "figure it out"
- Be too brief (minimum context hurts matching)

### 2. Keep SKILL.md Concise

Since Tier 2 loads into active context:

**Do:**

- Keep under 500 lines (~5,000 tokens)
- Focus on essential instructions
- Reference detailed docs in references/
- Use clear, concise language

**Don't:**

- Include entire API references in SKILL.md
- Duplicate content from external docs
- Add lengthy examples inline
- Include appendices in main file

### 3. Structure References Efficiently

Since Tier 3 loads on demand:

**Do:**

- Break content into focused files
- Use clear, descriptive filenames
- Reference specific files from SKILL.md
- Keep reference files independent

**Don't:**

- Create reference chains (file → file → file)
- Make agents navigate multiple hops
- Bury important info deep in references
- Create circular dependencies

## Example: Well-Structured Skill

```
pdf-processor/
├── SKILL.md                    # 450 lines - Core instructions only
├── scripts/
│   ├── extract.py             # Load only when needed
│   └── merge.py               # Load only when needed
├── references/
│   ├── api-reference.md       # Detailed API docs - load on demand
│   ├── troubleshooting.md     # Error handling details - load on demand
│   └── advanced-features.md   # Advanced usage - load on demand
└── assets/
    └── config-template.json   # Load only when user needs it
```

**Loading sequence:**

1. **Startup:** Load `name` + `description` (100 tokens)
2. **User asks to process PDF:** Agent activates skill, loads SKILL.md body (4,500 tokens)
3. **User encounters error:** Agent loads `references/troubleshooting.md` (2,000 tokens)
4. **User needs advanced feature:** Agent loads `references/advanced-features.md` (3,000 tokens)

**Total tokens used:** 9,600 (vs 50,000+ if everything loaded upfront)

## Common Mistakes

### Mistake 1: Description Too Short

```yaml
❌ description: "PDF tool"
```

**Problem:** Agent doesn't have enough context to match user's intent

**Fix:**

```yaml
✅ description: "Extracts text and tables from PDF files, fills PDF forms, and merges multiple PDFs. Use when working with PDF documents or when user mentions PDFs, forms, or document extraction."
```

### Mistake 2: SKILL.md Too Long

```markdown
❌ SKILL.md with 1,200 lines including:
   - Complete API reference
   - 50 detailed examples
   - Troubleshooting guide
   - Historical context
   - Alternative approaches
```

**Problem:** Loads 15,000+ tokens just to read instructions, leaving little room for actual work

**Fix:**

```markdown
✅ SKILL.md with 480 lines:
   - Core instructions
   - 3-5 key examples
   - References to detailed docs

✅ references/api-reference.md - Load only when needed
✅ references/examples.md - Load only when needed
✅ references/troubleshooting.md - Load only when needed
```

### Mistake 3: Deep Reference Chains

```markdown
❌ SKILL.md → references/overview.md → references/details/section1.md → references/details/subsection.md
```

**Problem:** Multiple file reads waste context and time

**Fix:**

```markdown
✅ SKILL.md → references/feature-guide.md (self-contained)
✅ SKILL.md → references/api-reference.md (self-contained)
```

## Testing Progressive Disclosure

### Test 1: Discovery Test

Can the agent find your skill with just the description?

```bash
# Test with various user phrases
"I need to process a PDF file"          # Should match
"Extract text from this document"       # Should match  
"Merge these PDFs together"             # Should match
"Parse this JSON file"                  # Should NOT match
```

### Test 2: Size Test

Check that SKILL.md stays under recommended size:

```bash
# Count lines
wc -l SKILL.md
# Should be < 500 lines

# Estimate tokens (rough: 1 line ≈ 10 tokens)
# Should be < 5,000 tokens
```

### Test 3: Reference Load Test

Verify references load only when needed:

1. Activate skill with basic task
2. Observe: Only SKILL.md should load
3. Request advanced feature
4. Observe: Specific reference file loads
5. Verify: Other reference files not loaded

## Best Practices Summary

1. **Description:** Use full 1-1024 characters for better matching
2. **SKILL.md:** Keep under 500 lines (~5,000 tokens)
3. **References:** Move detailed content to references/
4. **Structure:** One level deep maximum (SKILL.md → reference.md)
5. **Testing:** Validate with realistic user queries
6. **Monitoring:** Track which skills activate most successfully
