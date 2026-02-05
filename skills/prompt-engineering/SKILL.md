---
name: prompt-engineering
description: Provides guidelines, best practices, and templates for effective AI prompting in software development. Use when creating prompts for requirement analysis, code generation, testing, documentation, or deployment tasks, or when user mentions prompt engineering, AI prompting, or software development prompting.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0"
  last_updated: "2026-02-05"
---

# Prompt Engineering

## Overview

This skill provides comprehensive guidelines, best practices, and templates for effective AI prompting in software development contexts. It helps developers craft prompts that elicit better responses from AI models for the entire software development lifecycle, from requirement gathering and analysis to code generation, testing, documentation, and deployment. The skill covers various prompt types optimized for software development tasks, optimization strategies, and common pitfalls specific to development workflows.

## When to Use

- Creating prompts for requirement analysis and specification writing
- Generating code, tests, and documentation
- Designing system architecture and API specifications
- Writing deployment scripts and infrastructure as code
- Creating technical documentation and user guides
- Debugging code issues and performance optimization
- Code review and refactoring suggestions
- When user mentions prompt engineering, AI prompting, or software development prompting

## Prerequisites

- Basic understanding of AI language models
- Access to an AI model (OpenAI, Claude, etc.)

## Instructions

### Step 1: Understand Your Development Context

Before crafting a prompt, clearly define:

1. **Development Phase**: Which stage of the SDLC? (requirements, design, implementation, testing, deployment)
2. **Technology Stack**: Programming languages, frameworks, tools, and platforms involved
3. **Constraints**: Performance requirements, security needs, scalability considerations
4. **Stakeholders**: Who will use or review the output?

### Step 2: Choose Development-Focused Prompt Type

Select the appropriate prompt template based on your development task:

- **Requirement Analysis Prompts**: For gathering and refining requirements
- **Architecture Design Prompts**: For system design and component specification
- **Code Generation Prompts**: For implementing features and functions
- **Testing Prompts**: For creating test cases and validation strategies
- **Documentation Prompts**: For technical writing and API documentation
- **Deployment Prompts**: For infrastructure and deployment automation

### Step 3: Apply Software Development Best Practices

Follow these core principles for development-focused prompting:

1. **Specify Technical Context**: Include programming languages, frameworks, and versions
2. **Define Code Standards**: Reference coding conventions, patterns, and best practices
3. **Include Error Handling**: Request comprehensive error handling and edge cases
4. **Consider Scalability**: Address performance, security, and maintainability
5. **Provide Examples**: Use real-world software development scenarios

### Step 4: Use Development Templates

Choose from the proven templates in the templates/ directory based on your needs:

- `role-prompt.md` - For expert-level development guidance
- `instruction-prompt.md` - For code generation and implementation
- `few-shot-prompt.md` - For consistent code review feedback
- `chain-of-thought-prompt.md` - For complex architecture design

```bash
# Copy a development-focused template
cp templates/[template-name].md my-prompt.md
```

### Step 5: Validate and Iterate

Test your prompt with your AI model and iterate based on code quality and completeness. Use the guidelines in the references to improve your prompts.

## Examples

### Example 1: Code Review Request

**Input Prompt:**

```
You are a senior software engineer conducting a code review. Review the following Python function for a user authentication system:

1. Security vulnerabilities and best practices
2. Code quality, readability, and maintainability
3. Error handling and edge cases
4. Performance considerations
5. Testing recommendations

Provide specific, actionable feedback with code examples for improvements.

Function to review:
```python
def authenticate_user(username, password):
    user = database.find_user(username)
    if user and user.password == password:
        return create_session_token(user)
    return None
```

```

**Why it works:**
- Clear development context (authentication system)
- Specific technical criteria for review
- Requests concrete improvements with examples
- Considers security, performance, and testing

### Example 2: API Design Specification

**Input Prompt:**
```

Design a REST API for an e-commerce product catalog system. Follow these requirements:

Requirements:

- CRUD operations for products, categories, and inventory
- Pagination and filtering capabilities
- Proper HTTP status codes and error responses
- JWT authentication for admin operations
- Rate limiting and caching considerations

Technical Stack:

- Node.js with Express.js
- MongoDB for data storage
- Input validation with Joi
- API documentation with OpenAPI 3.0

Provide:

1. Complete endpoint specifications with methods, paths, and parameters
2. Request/response schemas in JSON
3. Error response formats
4. Authentication requirements
5. Sample API calls with curl commands

```

**Why it works:**
- Comprehensive technical specifications
- Clear technology stack definition
- Structured output requirements
- Includes practical examples and documentation needs

## Edge Cases

### Case 1: Missing Technical Context

**Problem**: "Write a function to sort data" without specifying language, data types, or constraints

**Solution**: Always include technology stack, performance requirements, and use case context

### Case 2: Incomplete Requirements

**Problem**: Requesting a "user management system" without specifying features, security requirements, or scale

**Solution**: Break down into specific components and provide detailed specifications for each

### Case 3: Technology Stack Mismatch

**Problem**: Asking for React component patterns in a Vue.js project context

**Solution**: Clearly specify the technology stack and version requirements upfront

## Error Handling

### Development-Specific Issues

#### Incomplete Code Generation
**Solutions:**
- Specify all imports and dependencies
- Include error handling patterns
- Request unit tests with the code
- Define input validation requirements

#### Architecture Design Issues
**Solutions:**
- Provide system constraints and scale requirements
- Include technology stack preferences
- Request trade-off analysis for design decisions
- Ask for deployment and maintenance considerations

#### Documentation Gaps
**Solutions:**
- Specify documentation format (Markdown, JSDoc, etc.)
- Include code examples and usage scenarios
- Request API specifications and error codes
- Ask for setup and deployment instructions

### AI Prompting Issues

#### Poor Response Quality
**Solutions:**
- Add more specific examples
- Break complex tasks into steps
- Provide clearer success criteria
- Use chain-of-thought prompting

#### Inconsistent Results
**Solutions:**
- Add system prompts for consistency
- Include more context and constraints
- Use temperature settings appropriately
- Provide reference examples

#### Hallucinations or Factual Errors
**Solutions:**
- Include source verification instructions
- Add "cite your sources" requirements
- Use fact-checking prompts
- Provide reference materials

## References

- [references/best-practices.md](references/best-practices.md) - Comprehensive software development prompting guidelines
- [references/prompt-types.md](references/prompt-types.md) - Development-focused prompt types and templates
- [references/common-mistakes.md](references/common-mistakes.md) - Common pitfalls in software development prompting
