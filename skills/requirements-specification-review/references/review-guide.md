# Requirements Specification Review Guide

## Coverage Taxonomy Detailed

### 1. Functional Scope & Behavior

**What to Check:**
- Are the core user goals clearly stated?
- Is success criteria measurable and testable?
- Is there an explicit "Out of Scope" section?
- Are user roles and personas differentiated?

**Examples of Clear:**
- "Users can reset password via email link"
- "Admin users can view all user accounts"
- "Success: 95% of users complete task in under 60 seconds"

**Examples of Unclear:**
- "System handles user management" (too vague)
- "Good user experience" (not measurable)
- No out-of-scope section when feature has natural boundaries

### 2. Domain & Data Model

**What to Check:**
- Are entities, attributes, and relationships documented?
- Are identity and uniqueness rules specified?
- Are lifecycle/state transitions defined?
- Are data volume and scale assumptions stated?

**Examples of Clear:**
- "User entity: id (UUID), email (unique), created_at"
- "Order states: DRAFT → SUBMITTED → PAID → SHIPPED"
- "Expected 100K users, 1M orders per year"

**Examples of Unclear:**
- "Store user data" (what data?)
- "Handle orders" (what states? lifecycle?)
- No data volume assumptions

### 3. Interaction & UX Flow

**What to Check:**
- Are critical user journeys documented step-by-step?
- Are error/empty/loading states specified?
- Are accessibility or localization notes included?

**Examples of Clear:**
- "User clicks 'Login' → enters credentials → sees dashboard"
- "Show spinner during API calls, error message on failure"
- "Support screen readers, keyboard navigation"

**Examples of Unclear:**
- "User logs in" (no steps)
- No mention of error states
- No accessibility considerations

### 4. Non-Functional Quality Attributes

**What to Check:**
- Performance targets (latency, throughput)
- Scalability expectations (horizontal/vertical, limits)
- Reliability & availability (uptime, recovery)
- Observability needs (logging, metrics, tracing)
- Security & privacy (authN/Z, data protection)
- Compliance / regulatory constraints

**Examples of Clear:**
- "API response time: p95 < 200ms, p99 < 500ms"
- "Support 10,000 concurrent users"
- "99.9% uptime SLA"
- "Log all authentication attempts"
- "Encrypt data at rest and in transit"
- "GDPR compliant data retention (2 years)"

**Examples of Unclear:**
- "Fast performance" (not measurable)
- "Scalable system" (no limits)
- "Secure" (no specifics)

### 5. Integration & External Dependencies

**What to Check:**
- External services/APIs and their failure modes
- Data import/export formats
- Protocol/versioning assumptions

**Examples of Clear:**
- "Integrate with Stripe API v2023-10-16"
- "On Stripe timeout (>30s), retry 3 times then fail order"
- "Export user data as JSON or CSV"

**Examples of Unclear:**
- "Integrate with payment provider" (which one?)
- No failure mode handling
- "Support data export" (what format?)

### 6. Edge Cases & Failure Handling

**What to Check:**
- Negative scenarios documented
- Rate limiting / throttling behavior
- Conflict resolution (concurrent edits)

**Examples of Clear:**
- "If email already exists, return 409 Conflict"
- "Rate limit: 100 requests per minute per user"
- "Last write wins for concurrent profile updates"

**Examples of Unclear:**
- No mention of error scenarios
- No rate limiting strategy
- No conflict resolution policy

### 7. Constraints & Tradeoffs

**What to Check:**
- Technical constraints documented
- Explicit tradeoffs or rejected alternatives noted

**Examples of Clear:**
- "Must work on mobile devices (iOS 14+, Android 10+)"
- "Trade-off: Eventual consistency for better performance"
- "Alternative considered: Real-time sync (rejected: too expensive)"

**Examples of Unclear:**
- No constraints mentioned
- No tradeoffs documented
- No alternatives discussed

### 8. Architecture Alignment (if architecture.md exists)

**What to Check:**
- Does spec align with architectural patterns?
- Is it consistent with technology stack?
- Does it adhere to quality attribute requirements?

**Examples of Clear:**
- Spec uses REST API (matches architecture)
- Mentions PostgreSQL (matches architecture database choice)
- Performance targets align with architecture SLAs

**Examples of Unclear:**
- Spec proposes different technology than architecture
- Contradicts architectural patterns
- Performance targets conflict with architecture

### 9. Standards Compliance (if standards.md exists)

**What to Check:**
- Naming convention requirements
- File structure alignment
- Coding standard adherence

**Examples of Clear:**
- Component names follow standards: `UserProfileComponent`
- File structure matches: `src/components/user/profile.tsx`
- Uses standard error handling patterns

**Examples of Unclear:**
- Naming conventions not followed
- File structure deviates from standards
- Custom patterns conflict with standards

### 10. Terminology & Consistency

**What to Check:**
- Canonical glossary terms used consistently
- No conflicting synonyms or deprecated terms

**Examples of Clear:**
- Consistently uses "account" throughout (not "account" and "profile")
- Terms defined in glossary section
- No conflicting terminology

**Examples of Unclear:**
- Uses "user", "account", "profile" interchangeably
- Terms not defined
- Conflicting usage across sections

### 11. Completion Signals

**What to Check:**
- Acceptance criteria are testable
- Measurable Definition of Done indicators

**Examples of Clear:**
- "User can complete registration in under 60 seconds"
- "All functional requirements have acceptance tests"
- "API endpoints return in under 200ms"

**Examples of Unclear:**
- "Feature is done when complete" (not testable)
- No acceptance criteria
- Vague completion indicators

### 12. Placeholders & Ambiguities

**What to Check:**
- No TODO markers remain
- Ambiguous adjectives quantified

**Examples of Clear:**
- All sections complete (no TODOs)
- "Fast" replaced with "< 2 seconds"
- "Scalable" replaced with "supports 10K concurrent users"

**Examples of Unclear:**
- Contains TODO markers
- Uses vague terms: "robust", "intuitive", "fast"
- Sections marked [TBD]

## Question Formulation Guidelines

### Multiple-Choice Questions

**Good Questions:**
- Have 2-5 clear options
- Each option is implementable
- Options are mutually exclusive
- Cover the reasonable solution space

**Example:**
```markdown
## Question 1: Session Expiration

**Context**: Spec doesn't specify session timeout policy.

**Recommended:** Option B - Balances security with user convenience

| Option | Description |
|--------|-------------|
| A | 30 minutes idle timeout (high security) |
| B | 24 hours idle timeout (standard) |
| C | 7 days idle timeout (low security, high convenience) |
| Short | Provide different timeout value |
```

**Bad Questions:**
- Too many options (>5)
- Options overlap or are vague
- Missing "Short" option for custom answers

### Short-Answer Questions

**Good Questions:**
- Can be answered in ≤5 words
- Have a clear suggested answer
- Are not open-ended

**Example:**
```markdown
## Question 2: Data Retention

**Context**: No retention policy specified for user activity logs.

**Suggested:** 90 days - Standard for analytics

Format: Short answer (≤5 words)
```

**Bad Questions:**
- Require long explanations
- No suggested answer
- Too open-ended

## Integration Strategies

### Where to Integrate Answers

| Answer About | Primary Section | Secondary Section |
|--------------|-----------------|-------------------|
| User action/flow | User Scenarios | Functional Requirements |
| Data structure | Key Entities / Data Model | Technical Details |
| Performance target | Success Criteria | Non-Functional Requirements |
| Error handling | Edge Cases | Error Handling |
| Security policy | Security / Privacy | Non-Functional Requirements |
| Integration behavior | Integration / Dependencies | Functional Requirements |
| Terminology | Throughout spec + Glossary | All mentions |

### Integration Patterns

**Pattern 1: Add New Requirement**
- Answer adds new functionality
- Create new bullet in Functional Requirements
- Update related sections (User Scenarios, Success Criteria)

**Pattern 2: Clarify Existing**
- Answer refines existing requirement
- Replace vague statement with specific one
- Update terminology throughout

**Pattern 3: Add Constraint**
- Answer specifies limits or boundaries
- Add to Constraints or Non-Functional Requirements
- Update Success Criteria if needed

**Pattern 4: Define Data**
- Answer specifies data structure
- Update Key Entities or Data Model section
- Add relationships if relevant

**Pattern 5: Specify Behavior**
- Answer describes system behavior
- Update appropriate functional requirement
- Add to Edge Cases if error scenario

## Prioritization Decision Matrix

### Impact Assessment

**High Impact:**
- Affects architecture decisions
- Changes data model significantly
- Impacts multiple user scenarios
- Has security/compliance implications
- Affects scalability or performance targets

**Medium Impact:**
- Affects single feature implementation
- Clarifies UX flow
- Specifies error handling
- Defines non-critical constraints

**Low Impact:**
- Stylistic preferences
- Minor UX tweaks
- Optional features
- Nice-to-have clarifications

### Uncertainty Assessment

**High Uncertainty:**
- Multiple reasonable interpretations exist
- No industry standard applies
- Answer depends on business decision
- Spec is completely silent

**Medium Uncertainty:**
- Vague but inferable
- Industry standards exist but not specified
- Some context clues in spec

**Low Uncertainty:**
- Minor ambiguity
- Answer easily inferable from context
- Low risk if assumption made

### Priority Matrix

| Impact | Uncertainty | Priority | Ask Question? |
|--------|-------------|----------|---------------|
| High | High | **Critical** | ✅ Yes (1st) |
| High | Medium | Important | ✅ Yes (2nd) |
| Medium | High | Important | ✅ Yes (3rd) |
| High | Low | Low | ❌ Make assumption |
| Medium | Medium | Low | ⚠️ If quota allows |
| Low | High | Low | ❌ Defer to planning |
| Medium | Low | Very Low | ❌ Make assumption |
| Low | Medium | Very Low | ❌ Defer |
| Low | Low | Very Low | ❌ Skip |

## Example Coverage Scans

### Example 1: E-Commerce Checkout

**Scan Results:**

| Category | Status | Notes |
|----------|--------|-------|
| Functional Scope | Clear | User goals well defined |
| Data Model | **Partial** | Missing: Order.payment_method type |
| UX Flow | Clear | Checkout steps documented |
| Non-Functional | **Partial** | No performance targets |
| Integrations | **Missing** | Payment gateway failure mode undefined |
| Edge Cases | **Partial** | No concurrent payment handling |
| Constraints | Clear | Mobile support specified |
| Terminology | Clear | Consistent use of "order" vs "cart" |
| Completion | Clear | Acceptance criteria testable |
| Placeholders | Clear | No TODOs |

**Selected Questions (Top 5 by Impact × Uncertainty):**

1. Payment gateway timeout handling? (High × High = Critical)
2. Checkout performance target? (High × Medium = Important)
3. Payment method type (string/enum)? (Medium × Medium = Medium)
4. Concurrent payment handling? (Medium × High = Important)
5. Order confirmation email SLA? (Medium × Medium = Medium)

### Example 2: User Authentication

**Scan Results:**

| Category | Status | Notes |
|----------|--------|-------|
| Functional Scope | Clear | Login/logout/reset well defined |
| Data Model | **Missing** | No password policy specified |
| UX Flow | Clear | Login flow documented |
| Non-Functional | **Partial** | No session timeout specified |
| Security | **Partial** | Missing: MFA requirement |
| Edge Cases | **Missing** | No account lockout policy |
| Standards | Clear | Aligns with architecture OAuth2 |
| Terminology | Clear | Consistent |

**Selected Questions:**

1. Password policy (length, complexity)? (High × High = Critical)
2. Session timeout duration? (High × Medium = Important)
3. MFA requirement (all/admin/optional)? (High × High = Critical)
4. Account lockout after failed attempts? (Medium × High = Important)
5. Password reset link expiration? (Medium × Medium = Medium)

## Validation Checklist Details

### Per-Integration Validation

**Check: Single Bullet Per Answer**
- Clarifications section has exactly one entry per accepted answer
- No duplicate Q&A entries
- Each entry formatted: `- Q: [question] → A: [answer]`

**Check: No Vague Placeholders**
- Updated section contains specific, measurable statements
- No "TBD", "TODO", "[FILL IN]" markers remain in affected areas
- Concrete values replace vague terms

**Check: No Contradictions**
- Earlier conflicting statements removed or updated
- Consistent terminology across all updates
- No logical conflicts introduced

**Check: Valid Markdown**
- Heading hierarchy maintained
- List formatting correct
- No broken links or malformed syntax

**Check: Terminology Consistency**
- Same terms used across all updated sections
- Glossary updated if new terms introduced
- No synonyms introduced that conflict with existing usage

### Final Validation

**Check: Question Limit**
- Total questions asked ≤ 5 for this session
- Historical total across all sessions ≤ 10
- No excessive questioning

**Check: Heading Restrictions**
- Only allowed new headings: `## Clarifications`, `### Session YYYY-MM-DD`
- No other heading changes
- Section order preserved

**Check: Integration Complete**
- All accepted answers reflected in appropriate sections
- Clarifications section has all Q&A pairs
- No pending integrations

**Check: Internal Consistency**
- Functional requirements align with user scenarios
- Success criteria match functional requirements
- Data model matches entity references throughout
- Non-functional requirements consistent with constraints

## Error Recovery Strategies

### Recovery: Partial Integration Failure

**Issue**: Answer integrated into Clarifications but not into target section

**Strategy:**
1. Log the failure reason
2. Continue with next question (don't block)
3. Report at end: "Manual integration needed for Q[N] in [section]"
4. Provide guidance on where/how to integrate

### Recovery: Spec File Lock/Permission Issue

**Issue**: Can't write to spec file

**Strategy:**
1. Store all answers in memory
2. Complete questioning phase
3. Attempt final atomic write
4. If still fails: Output all answers to console/file for manual integration
5. Report: "Answers collected but file write failed"

### Recovery: Git Conflict

**Issue**: Spec file changed by another process during review

**Strategy:**
1. Spec file already saved with current changes
2. Attempt commit
3. If conflict: Report "Commit failed due to conflict, resolve manually"
4. Provide merge guidance
5. Continue with completion report

### Recovery: Invalid User Answer

**Issue**: User provides answer that doesn't fit format

**Strategy:**
1. Don't count as new question
2. Request clarification: "Please provide [specific format]"
3. Give example if helpful
4. Retry until valid answer or user explicitly skips

### Recovery: Markdown Parsing Failure

**Issue**: Spec has malformed markdown

**Strategy:**
1. Attempt best-effort parsing
2. Identify problematic section if possible
3. Skip that section in coverage scan
4. Report: "Skipped [section] due to parsing error"
5. Continue with remaining sections
6. Suggest manual markdown fix
