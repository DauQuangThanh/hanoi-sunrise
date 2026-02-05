# Software Development Prompt Engineering Best Practices

## Core Principles

### 1. Technical Context First

- Always specify programming languages, frameworks, and versions
- Include technology stack and architecture preferences
- Define development environment and deployment targets

### 2. Development Lifecycle Awareness

- Consider the SDLC phase (requirements, design, implementation, testing, deployment)
- Include relevant constraints for each phase
- Address scalability, security, and maintainability

### 3. Code Quality Standards

- Reference coding conventions and style guides
- Include testing requirements and documentation standards
- Specify performance and security requirements

### 4. Stakeholder Considerations

- Define target audience and use cases
- Include business requirements and constraints
- Consider maintenance and future extensibility

## Prompt Components

### System Context Prompts

Set the development environment and constraints:

```
You are developing a microservices application using:
- Backend: Node.js 18+ with Express.js
- Database: PostgreSQL with Prisma ORM
- Frontend: React 18 with TypeScript
- Deployment: Docker containers on AWS ECS
- Security: JWT authentication, input validation, rate limiting
```

### Technical Specification Prompts

Define detailed requirements:

```
Create a REST API endpoint for user registration with:
- Input validation using Joi schemas
- Password hashing with bcrypt
- Email verification workflow
- Error handling for duplicate emails
- Rate limiting (10 requests per minute)
- Comprehensive logging
```

### Code Generation Prompts

Request implementation with context:

```
Implement a React custom hook for data fetching with:
- TypeScript interfaces for API responses
- Error handling and loading states
- Automatic retries for failed requests
- Cache management with React Query
- Proper cleanup on component unmount
```

## Development Phase-Specific Patterns

### Requirements Analysis

For gathering and refining requirements:

```
Analyze these user stories and create detailed technical specifications:

User Stories:
- As a user, I want to search products by category
- As an admin, I need to manage product inventory

For each story, provide:
1. Acceptance criteria
2. API endpoint specifications
3. Database schema changes
4. UI component requirements
5. Testing scenarios
```

### System Architecture

For high-level design decisions:

```
Design the architecture for a real-time chat application handling 10,000 concurrent users:

Considerations:
- WebSocket connections for real-time messaging
- Message persistence and retrieval
- User authentication and authorization
- Scalability and fault tolerance
- Database choice and sharding strategy

Provide:
1. Component diagram
2. Data flow architecture
3. Technology stack recommendations
4. Scaling strategy
5. Security measures
```

### Code Implementation

For specific feature development:

```
Implement a payment processing service with the following requirements:

Features:
- Support for multiple payment providers (Stripe, PayPal)
- PCI compliance measures
- Transaction logging and audit trail
- Refund processing
- Webhook handling for payment status updates

Technical requirements:
- Use dependency injection pattern
- Implement comprehensive error handling
- Include unit and integration tests
- Follow SOLID principles
- Add detailed API documentation
```

### Testing Strategy

For comprehensive testing approaches:

```
Create a testing strategy for a user authentication system:

Components to test:
- Password hashing and verification
- JWT token generation and validation
- Session management
- Password reset workflow
- Account lockout after failed attempts

Testing types needed:
- Unit tests for business logic
- Integration tests for API endpoints
- End-to-end tests for user workflows
- Security testing for common vulnerabilities
- Performance testing under load

Provide test cases, mocking strategies, and CI/CD integration.
```

### Deployment and DevOps

For infrastructure and deployment:

```
Create deployment automation for a containerized web application:

Requirements:
- Docker containerization
- Kubernetes orchestration
- CI/CD pipeline with GitHub Actions
- Blue-green deployment strategy
- Database migrations
- Environment-specific configurations
- Monitoring and logging setup

Include:
1. Dockerfile and docker-compose.yml
2. Kubernetes manifests
3. CI/CD workflow files
4. Infrastructure as Code (Terraform)
5. Monitoring configuration
```

## Technology-Specific Tips

### Backend Development

- Specify framework versions and middleware requirements
- Include database schema and migration scripts
- Request API documentation and error codes
- Consider caching strategies and performance optimization

### Frontend Development

- Define component architecture and state management
- Include responsive design requirements
- Specify accessibility standards (WCAG)
- Request cross-browser compatibility testing

### Full-Stack Applications

- Clearly separate frontend and backend requirements
- Define API contracts and data models
- Include authentication and authorization flows
- Consider real-time features and WebSocket implementation

### Mobile Development

- Specify platform (iOS, Android, or cross-platform)
- Include device-specific considerations
- Define offline functionality requirements
- Consider app store submission requirements

## Quality Assurance

### Code Review Standards

- Request adherence to coding standards
- Include security vulnerability checks
- Ask for performance optimization suggestions
- Request comprehensive documentation

### Testing Requirements

- Specify test coverage percentages
- Include different testing types (unit, integration, e2e)
- Request test data generation strategies
- Consider edge cases and error scenarios

### Documentation Standards

- Define documentation format and tools
- Include API documentation requirements
- Request user guide and deployment instructions
- Consider multiple audience types (developers, users, admins)

## Security Considerations

### Input Validation

- Request comprehensive input sanitization
- Include protection against common attacks (XSS, CSRF, SQL injection)
- Consider rate limiting and DDoS protection

### Authentication & Authorization

- Specify secure authentication mechanisms
- Include role-based access control
- Request secure session management
- Consider multi-factor authentication

### Data Protection

- Include encryption requirements
- Request GDPR/CCPA compliance measures
- Consider data retention policies
- Include audit logging requirements

## Performance Optimization

### Application Performance

- Request performance benchmarks and monitoring
- Include caching strategies and CDN usage
- Consider database optimization and indexing
- Request load testing recommendations

### Scalability Planning

- Include horizontal and vertical scaling strategies
- Request microservices decomposition guidance
- Consider cloud-native architecture patterns
- Include cost optimization recommendations

## Maintenance & Operations

### Monitoring & Logging

- Request comprehensive logging strategies
- Include health check endpoints
- Consider alerting and notification systems
- Request metrics collection and analysis

### Deployment Automation

- Include rollback strategies and procedures
- Request zero-downtime deployment approaches
- Consider feature flag implementations
- Include environment management strategies

## Common Patterns

### API Development

```
Design a RESTful API for [domain] with:
- CRUD operations for [resources]
- Proper HTTP methods and status codes
- Input validation and error handling
- Pagination and filtering
- API versioning strategy
- Documentation with OpenAPI/Swagger
```

### Database Design

```
Create database schema for [application] including:
- Entity-relationship diagram
- Table definitions with constraints
- Indexes for performance optimization
- Migration scripts
- Seed data for development
- Backup and recovery strategies
```

### Testing Implementation

```
Implement comprehensive tests for [feature] including:
- Unit tests for business logic
- Integration tests for API endpoints
- End-to-end tests for user workflows
- Mock data and test fixtures
- Test coverage reporting
- CI/CD integration
```

## Measuring Success

### Code Quality Metrics

- Test coverage percentage
- Code complexity analysis
- Security vulnerability scanning
- Performance benchmark results
- Documentation completeness

### Development Efficiency

- Implementation time vs estimates
- Bug detection and resolution rates
- Code review feedback incorporation
- Deployment success rates

### Business Value

- Feature completion and delivery
- User acceptance and satisfaction
- System reliability and uptime
- Scalability under real-world load

## Iteration and Improvement

### Feedback Integration

- Review AI-generated code in code reviews
- Track common issues and improvement patterns
- Update prompt templates based on successful outcomes
- Build a library of proven prompt patterns

### Continuous Learning

- Stay updated with new frameworks and tools
- Learn from community best practices
- Adapt prompts for new project requirements
- Share successful patterns with the team

### Quality Assurance

- Implement prompt validation checklists
- Test prompts across different AI models
- Measure output quality and consistency
- Refine prompts based on production usage
