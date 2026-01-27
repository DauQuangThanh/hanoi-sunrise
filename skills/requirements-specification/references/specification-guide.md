# Requirements Specification Guide

## Detailed Section Requirements

### Mandatory vs Optional Sections

**Mandatory Sections** (must be completed for every feature):
- Feature Name
- Overview
- User Scenarios
- Functional Requirements
- Success Criteria

**Optional Sections** (include only when relevant):
- Key Entities (only if data/domain modeling is involved)
- Assumptions (document any assumptions made)
- Out of Scope (clarify what's explicitly excluded)
- Dependencies (external systems or prerequisite features)

**Section Handling Rule:**
- If a section doesn't apply to your feature, remove it entirely
- Never leave sections with just "N/A" or "Not applicable"
- Keep the specification clean and focused

## Detailed Validation Criteria

### Content Quality Checks

**No Implementation Details:**
- ❌ Bad: "Use bcrypt for password hashing"
- ❌ Bad: "Store sessions in Redis"
- ❌ Bad: "Implement with React hooks"
- ✅ Good: "Passwords must be securely hashed"
- ✅ Good: "User sessions persist across browser restarts"
- ✅ Good: "Interface responds to user interactions"

**Focus on User Value:**
- ❌ Bad: "Deploy using Docker containers"
- ❌ Bad: "Use PostgreSQL database"
- ✅ Good: "Users can access from multiple devices"
- ✅ Good: "Data persists reliably"

**Non-Technical Language:**
- ❌ Bad: "API returns JSON with status codes"
- ❌ Bad: "Frontend polls backend every 5 seconds"
- ✅ Good: "System provides status updates"
- ✅ Good: "Interface stays current with latest data"

### Requirement Completeness

**Testable Requirements:**
- Each requirement must be verifiable
- Must have clear acceptance criteria
- Must be measurable or observable
- Example: "User can reset password" ✅
- Example: "System is user-friendly" ❌ (not measurable)

**Unambiguous Requirements:**
- No vague terms: "fast", "easy", "intuitive"
- Use specific metrics: "within 2 seconds", "in 3 clicks"
- Avoid subjective terms without criteria

**Success Criteria Properties:**
- **Measurable**: Include specific metrics (time, percentage, count, rate)
  - ❌ "Search is fast"
  - ✅ "Search results appear in under 1 second"
- **Technology-agnostic**: No frameworks, languages, databases
  - ❌ "React components load quickly"
  - ✅ "Pages load in under 2 seconds"
- **User-focused**: Outcomes from user/business perspective
  - ❌ "Redis cache hit rate above 80%"
  - ✅ "90% of repeat queries return instantly"
- **Verifiable**: Can be tested without knowing implementation
  - ❌ "Code coverage above 80%"
  - ✅ "All user scenarios complete without errors"

## Clarification Management

### When to Use [NEEDS CLARIFICATION]

**Only use when:**
1. **Scope Impact**: Decision significantly changes feature scope
   - Example: "Should this support multiple languages?"
   - Impact: Internationalization affects entire feature
2. **Security/Privacy**: Legal or financial implications
   - Example: "How long should we retain user data?"
   - Impact: Compliance requirements vary by region
3. **Multiple Interpretations**: No clear reasonable default
   - Example: "Should 'active users' mean daily or monthly?"
   - Impact: Fundamentally different metrics
4. **User Experience**: Fundamentally different UX approaches
   - Example: "Should search be real-time or manual?"
   - Impact: Changes interaction model

**Don't use for:**
- Technical implementation (make reasonable assumptions)
- Standard industry practices (use common patterns)
- Minor UX details (use best practices)
- Performance targets (use industry standards)

### Reasonable Defaults (Make Assumptions)

**Data Retention:**
- User data: Industry-standard GDPR compliance (e.g., 2-7 years)
- Session data: 30 days
- Log data: 90 days
- Backup data: 30 days

**Performance Targets:**
- Page load: < 3 seconds (web), < 1 second (mobile)
- API response: < 500ms
- Search results: < 1 second
- Form submission: < 2 seconds

**Error Handling:**
- User-friendly error messages
- Graceful degradation
- Retry logic for transient failures
- Fallback to cached data when possible

**Authentication:**
- Session-based for web apps
- OAuth2 for third-party integrations
- Token expiration: 24 hours
- Refresh token: 30 days

**Integration Patterns:**
- RESTful APIs for web services
- Webhooks for event notifications
- Polling: Every 30-60 seconds for non-critical updates

### Clarification Question Format

When you must use [NEEDS CLARIFICATION], format questions as:

```markdown
## Question [N]: [Topic]

**Context**: [Quote relevant spec section]

**What we need to know**: [Specific question]

**Suggested Answers**:

| Option | Answer | Implications |
|--------|--------|--------------|
| A      | [First option] | [Impact on feature] |
| B      | [Second option] | [Impact on feature] |
| C      | [Third option] | [Impact on feature] |
| Custom | Your own answer | [How to provide it] |

**Your choice**: _[Wait for response]_
```

**Limit**: Maximum 3 clarification questions per feature

## Examples of Good vs Bad Specifications

### Example 1: User Authentication

**❌ Bad Specification:**
```markdown
## Overview
Implement user authentication using JWT tokens and bcrypt password hashing.
Store tokens in Redis cache with 24-hour expiration.

## Requirements
- Use Express.js middleware for auth
- Implement OAuth2 with Passport.js
- Store user data in PostgreSQL
- Deploy to AWS Lambda
```

**✅ Good Specification:**
```markdown
## Overview
Users can securely create accounts and log in to access personalized features.
The system maintains user sessions across browser restarts and devices.

## Functional Requirements
- Users can create accounts with email and password
- Users can log in with their credentials
- Users remain logged in across browser sessions
- Users can log out from any device
- Users can reset forgotten passwords via email

## Success Criteria
- 95% of users can complete registration in under 60 seconds
- Login response time under 2 seconds for 99% of requests
- Password reset emails delivered within 5 minutes
- Sessions persist for 30 days without re-authentication
```

### Example 2: Search Feature

**❌ Bad Specification:**
```markdown
## Overview
Build search using Elasticsearch with fuzzy matching and n-gram tokenization.
Index documents using Logstash pipeline.

## Requirements
- Configure Kibana dashboard
- Use React hooks for search UI
- Implement debouncing with Lodash
- Cache results in localStorage
```

**✅ Good Specification:**
```markdown
## Overview
Users can quickly find content by entering keywords or phrases.
Search understands common misspellings and partial matches.

## Functional Requirements
- Users can search by entering text in search box
- Results appear as user types (live search)
- System suggests corrections for misspelled words
- System handles partial word matches
- Results highlight matching terms

## Success Criteria
- Search results appear within 1 second of typing
- 90% of searches return relevant results in top 5
- System handles 100 concurrent searches without degradation
- Search works with 3+ character queries
```

## Validation Checklist Details

### Content Quality Validation

**Check: No Implementation Details**
- Scan entire spec for technology names
- Look for: language names, framework names, database names, cloud providers
- Verify: Focus is on behavior and outcomes, not tools

**Check: Focused on User Value**
- Each requirement should answer "What can users do?"
- Success criteria should measure user or business outcomes
- Technical metrics (cache hits, API calls) should be converted to user metrics

**Check: Written for Non-Technical Stakeholders**
- Avoid technical jargon
- Use domain language, not engineering language
- Should be understandable by product managers, designers, QA

**Check: All Mandatory Sections Completed**
- Feature Name: Present and descriptive
- Overview: 2-3 paragraphs explaining purpose
- User Scenarios: At least 1 primary flow
- Functional Requirements: At least 3 requirements
- Success Criteria: At least 3 measurable criteria

### Requirement Completeness Validation

**Check: No [NEEDS CLARIFICATION] Markers**
- Search for "[NEEDS CLARIFICATION"
- All must be resolved before validation passes
- If found, present questions to user

**Check: Requirements are Testable**
- Each requirement can be verified by QA
- Clear acceptance criteria exists
- Observable behavior is defined

**Check: Success Criteria are Measurable**
- Each criterion has a number (time, percentage, count)
- Each can be measured during testing
- No subjective terms without definition

**Check: All Acceptance Scenarios Defined**
- Primary user flow documented
- Happy path clearly described
- Expected outcomes specified

**Check: Edge Cases Identified**
- Error conditions documented
- Boundary conditions specified
- Unusual but valid scenarios considered

**Check: Scope Clearly Bounded**
- What's included is explicit
- Out of Scope section removes ambiguity
- Dependencies are identified

### Feature Readiness Validation

**Check: Functional Requirements Have Acceptance Criteria**
- Each requirement states what success looks like
- Criteria are observable and verifiable
- No ambiguous terms remain

**Check: User Scenarios Cover Primary Flows**
- Main use cases documented
- Step-by-step flows provided
- Expected outcomes clear

**Check: Feature Meets Success Criteria**
- Functional requirements align with success criteria
- All success criteria can be met by specified requirements
- No gaps between requirements and criteria

**Check: No Implementation Leakage**
- Final scan for any technical details
- Verify user-centric language throughout
- Ensure technology independence

## Common Validation Failures and Fixes

### Failure: "Requirements mention React, PostgreSQL, AWS"
**Fix**: Rewrite in terms of user capabilities:
- "React component" → "Interface element"
- "PostgreSQL query" → "Data retrieval"
- "AWS Lambda function" → "Background process"

### Failure: "Success criteria not measurable"
**Fix**: Add specific metrics:
- "Fast response" → "Response within 2 seconds"
- "High availability" → "99.9% uptime"
- "Many concurrent users" → "100 concurrent users"

### Failure: "Requirements not testable"
**Fix**: Add observable outcomes:
- "System is secure" → "Unauthorized users cannot access data"
- "Code is maintainable" → "Features can be modified without breaking tests"

### Failure: "[NEEDS CLARIFICATION] markers remain"
**Fix**: Present questions to user with format above, wait for responses, update spec

### Failure: "Missing acceptance scenarios"
**Fix**: Add user flow with:
1. User starts at [state]
2. User performs [action]
3. System responds with [outcome]
4. User sees [result]

## Iteration Strategy

### First Iteration
- Focus on removing implementation details
- Add metrics to success criteria
- Ensure all mandatory sections present

### Second Iteration
- Verify requirements are testable
- Check acceptance scenarios are complete
- Resolve any remaining [NEEDS CLARIFICATION]

### Third Iteration (Final)
- Final scan for technology leakage
- Verify all checklist items
- Document any remaining issues in notes

### After 3 Iterations
- If still failing, document specific issues
- Provide detailed explanation to user
- Suggest manual review areas
- Offer to proceed with warnings
