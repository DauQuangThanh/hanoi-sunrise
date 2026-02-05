# Code Generation Prompt Template

Use this template for generating production-ready code with proper structure, error handling, and best practices.

## Template Structure

```
Implement [feature/component/functionality] with the following specifications:

Functionality:
- [Core features and behaviors]
- [Input/output specifications]
- [Business logic requirements]

Technical requirements:
- [Programming language and version]
- [Framework and key dependencies]
- [Database/ORM if applicable]
- [Performance and scalability needs]

Code quality standards:
- [Error handling and validation]
- [Testing requirements]
- [Documentation and comments]
- [Code style and conventions]

Security considerations:
- [Input validation and sanitization]
- [Authentication/authorization if needed]
- [Security best practices]

Include:
- Complete implementation with imports
- Comprehensive error handling
- Unit tests with edge cases
- API documentation or docstrings
- Usage examples and integration notes
```

## Example Usage

```
Implement a user authentication service in Node.js with the following specifications:

Functionality:
- User registration with email verification
- JWT-based login with refresh tokens
- Password reset workflow with secure tokens
- Account lockout after failed attempts
- Role-based access control

Technical requirements:
- Node.js 18+ with Express.js framework
- PostgreSQL database with Prisma ORM
- bcrypt for password hashing
- JWT for token management
- Rate limiting and security headers

Code quality standards:
- ESLint with Airbnb style guide
- Comprehensive input validation with Joi
- Unit tests with Jest (minimum 85% coverage)
- JSDoc documentation for all functions
- Proper error handling with custom error classes

Security considerations:
- Password strength validation
- SQL injection prevention
- XSS protection in responses
- Secure token storage and transmission
- Audit logging for security events

Include:
- Complete service implementation
- Database schema and migrations
- API route handlers with middleware
- Test files with mocking
- README with setup and usage instructions
```

## Tips for Success

- Be specific about technology stack and versions
- Include all functional and non-functional requirements
- Specify error handling and edge cases
- Define testing and documentation expectations
- Consider security and performance requirements
- Provide context about how the code fits into the larger system
- Test and iterate on results
