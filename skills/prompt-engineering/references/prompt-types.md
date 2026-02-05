# Software Development Prompt Types and Templates

## Overview

Different software development tasks require different prompt structures. This guide covers prompt types specifically optimized for the software development lifecycle, from requirements to deployment.

## 1. Requirements Analysis Prompts

**Purpose**: Transform business requirements into technical specifications
**When to use**: Converting user stories, business needs, or feature requests into actionable development tasks

### Template

```
Analyze these [type of requirements] and create detailed technical specifications:

[Requirements to analyze]

For each requirement, provide:
1. Functional requirements and acceptance criteria
2. Technical implementation approach
3. Data models and API endpoints needed
4. UI/UX considerations
5. Testing scenarios and edge cases
6. Dependencies and integration points

Technical constraints:
- [Technology stack]
- [Performance requirements]
- [Security requirements]
- [Scalability needs]
```

### Example

```
Analyze these user stories for an e-commerce product catalog and create technical specifications:

User Stories:
- As a customer, I want to browse products by category
- As an admin, I need to manage product inventory and pricing
- As a customer, I want to search products with filters

For each story, provide:
1. API endpoint specifications
2. Database schema changes
3. Frontend component requirements
4. Search and filtering logic
5. Caching strategy
6. Testing approach

Technical constraints:
- React frontend with TypeScript
- Node.js/Express backend
- PostgreSQL database
- Elasticsearch for search
- Response time < 200ms for category browsing
```

## 2. System Architecture Prompts

**Purpose**: Design high-level system architecture and component interactions
**When to use**: Planning system design, technology selection, and architectural decisions

### Template

```
Design the system architecture for [application/system description]:

Requirements:
- [Functional requirements]
- [Non-functional requirements]
- [Scale and performance targets]
- [Security and compliance needs]

Technical context:
- [Technology preferences/constraints]
- [Existing systems to integrate with]
- [Deployment environment]

Provide:
1. High-level component diagram
2. Data flow and integration patterns
3. Technology stack recommendations with justification
4. Scaling and fault tolerance strategy
5. Security architecture overview
6. Deployment and operational considerations
```

### Example

```
Design the system architecture for a real-time collaborative document editor:

Requirements:
- Support 1000+ concurrent users per document
- Real-time synchronization with < 100ms latency
- Offline editing with conflict resolution
- Version history and rollback capabilities
- Multi-device synchronization

Technical context:
- Web-based application
- Cloud-native deployment on AWS
- Must integrate with existing user management system

Provide:
1. Microservices architecture diagram
2. Real-time communication strategy (WebSockets, Operational Transforms)
3. Database design for document storage and versioning
4. Caching and CDN strategy
5. Authentication and authorization approach
6. Monitoring and logging architecture
```

## 3. Code Generation Prompts

**Purpose**: Generate production-ready code with proper structure and best practices
**When to use**: Implementing features, creating boilerplate, or generating utility functions

### Template

```
Implement [feature/component] with the following specifications:

Functionality:
- [Core features and behaviors]
- [Input/output specifications]
- [Error handling requirements]

Technical requirements:
- [Programming language and framework]
- [Design patterns to follow]
- [Performance and security constraints]
- [Testing requirements]

Code quality standards:
- [Coding conventions]
- [Documentation requirements]
- [Dependency management]

Include:
- Complete implementation with error handling
- Unit tests with edge cases
- API documentation or docstrings
- Usage examples
```

### Example

```
Implement a user authentication service in Node.js with the following specifications:

Functionality:
- User registration with email verification
- Login with JWT token generation
- Password reset workflow
- Account lockout after failed attempts
- Session management and refresh tokens

Technical requirements:
- Express.js framework with TypeScript
- PostgreSQL with Prisma ORM
- bcrypt for password hashing
- JWT for token management
- Rate limiting and security headers

Code quality standards:
- ESLint configuration following Airbnb style guide
- Comprehensive error handling with custom error classes
- Input validation with Joi schemas
- Unit tests with Jest (minimum 80% coverage)

Include:
- Complete service implementation
- Database migrations
- API route handlers
- Middleware for authentication
- Test files with mocking
```

## 4. Code Review Prompts

**Purpose**: Conduct thorough code reviews focusing on quality, security, and best practices
**When to use**: Reviewing pull requests, assessing code quality, or providing feedback on implementations

### Template

```
Review this [language/framework] code for [context]:

Code to review:
```[language]
[code here]
```

Review criteria:

1. Code correctness and logic accuracy
2. Security vulnerabilities and best practices
3. Performance optimization opportunities
4. Code maintainability and readability
5. Testing coverage and quality
6. Adherence to coding standards and conventions

For each criterion, provide:

- Specific findings with line references
- Severity level (Critical/Major/Minor)
- Recommended fixes with code examples
- Rationale for recommendations

Additional considerations:

- [Specific domain requirements]
- [Performance benchmarks]
- [Security standards to follow]

```

### Example
```

Review this React component for a financial dashboard application:

```jsx
const TransactionList = ({ transactions, onSelect }) => {
  return (
    <div>
      {transactions.map(tx => (
        <div key={tx.id} onClick={() => onSelect(tx)}>
          <span>{tx.amount}</span>
          <span>{tx.date}</span>
        </div>
      ))}
    </div>
  );
};
```

Review criteria:

1. React best practices and hooks usage
2. Accessibility compliance (WCAG 2.1 AA)
3. Performance optimization for large transaction lists
4. TypeScript integration and type safety
5. Error handling and loading states
6. Security considerations for financial data

For each criterion, provide:

- Specific issues found
- Code improvement suggestions
- Testing recommendations
- Performance impact assessment

```

## 5. Testing Strategy Prompts

**Purpose**: Design comprehensive testing strategies for applications and features
**When to use**: Planning test coverage, creating test suites, or ensuring quality assurance

### Template
```

Create a comprehensive testing strategy for [application/feature]:

Application context:

- [Technology stack and architecture]
- [Core functionality and user workflows]
- [Integration points and external dependencies]
- [Performance and scalability requirements]

Testing scope:

- Unit testing for [components/modules]
- Integration testing for [APIs/services]
- End-to-end testing for [user journeys]
- Performance testing for [critical paths]
- Security testing for [vulnerability areas]

For each testing type, specify:

1. Testing tools and frameworks
2. Test case coverage requirements
3. Mocking and test data strategies
4. CI/CD integration approach
5. Success criteria and reporting

Include test scenarios for:

- Happy path functionality
- Error conditions and edge cases
- Performance under load
- Security vulnerabilities
- Data integrity and consistency

```

### Example
```

Create a comprehensive testing strategy for a microservices-based e-commerce platform:

Application context:

- 5 microservices (User, Product, Order, Payment, Notification)
- React frontend with Redux state management
- PostgreSQL and Redis for data storage
- Stripe payment integration
- AWS deployment with Kubernetes

Testing scope:

- Unit tests for business logic in each service
- Integration tests for service-to-service communication
- API contract tests with Pact
- End-to-end tests for complete user journeys
- Performance tests for checkout flow
- Security tests for payment processing

For each testing type, specify:

1. Tools: Jest for unit, Cypress for E2E, k6 for performance
2. Coverage: 85% minimum for unit tests, 100% API coverage
3. Test data: Factory pattern for consistent test data
4. CI/CD: GitHub Actions with parallel test execution
5. Reporting: Test results in JUnit format, coverage reports

Include test scenarios for:

- User registration and authentication flow
- Product search and filtering
- Shopping cart and checkout process
- Payment processing with success/failure cases
- Order status updates and notifications
- Inventory management and stock updates

```

## 6. API Design Prompts

**Purpose**: Design RESTful or GraphQL APIs with proper specifications and documentation
**When to use**: Creating new APIs, documenting existing ones, or planning API evolution

### Template
```

Design a [REST/GraphQL] API for [domain/purpose]:

Business requirements:

- [Core use cases and workflows]
- [Data entities and relationships]
- [Authentication and authorization needs]
- [Rate limiting and usage policies]

Technical specifications:

- [Response formats and status codes]
- [Error handling and validation]
- [Versioning strategy]
- [Documentation standards]

API endpoints to design:

1. [Resource 1] - CRUD operations
2. [Resource 2] - Business logic endpoints
3. [Resource 3] - Administrative functions

For each endpoint, provide:

- HTTP method and path
- Request/response schemas
- Authentication requirements
- Error responses
- Usage examples with curl
- OpenAPI/Swagger documentation

```

### Example
```

Design a REST API for a project management system:

Business requirements:

- Project creation and team assignment
- Task management with status tracking
- Time tracking and reporting
- File attachments and comments
- Role-based permissions (Admin, Manager, Developer)

Technical specifications:

- JSON API responses with consistent structure
- JWT authentication with refresh tokens
- Pagination for list endpoints
- API versioning with URL prefixes
- Comprehensive error messages

API endpoints to design:

1. Projects - CRUD with team management
2. Tasks - CRUD with assignment and status updates
3. Time entries - CRUD with reporting
4. Files - Upload/download with metadata
5. Comments - CRUD on tasks and projects

For each endpoint, provide:

- Complete OpenAPI 3.0 specification
- Request validation rules
- Response caching headers
- Rate limiting policies
- Integration test examples

```

## 7. Database Design Prompts

**Purpose**: Design database schemas, relationships, and optimization strategies
**When to use**: Planning data models, database migrations, or performance optimization

### Template
```

Design the database schema for [application/system]:

Application requirements:

- [Core entities and relationships]
- [Data access patterns and queries]
- [Performance and scalability needs]
- [Data integrity and consistency requirements]

Technical context:

- [Database type and version]
- [ORM or query approach]
- [Migration strategy]
- [Backup and recovery needs]

Design components:

1. Entity-relationship diagram
2. Table definitions with constraints
3. Indexes for query optimization
4. Data types and sizing considerations
5. Relationship management (foreign keys, cascading)
6. Migration scripts and rollback plans

Include:

- Normalization analysis (3NF compliance)
- Denormalization for performance
- Partitioning strategy for large tables
- Audit logging for critical data
- Seed data for development

```

### Example
```

Design the database schema for a social media analytics platform:

Application requirements:

- User profiles with follower/following relationships
- Posts with likes, comments, and shares
- Hashtags and trending topic analysis
- Real-time analytics and reporting
- Content moderation and flagging system

Technical context:

- PostgreSQL 15 with PostGIS for location data
- Prisma ORM for type-safe queries
- Read replicas for analytics queries
- Point-in-time recovery requirements

Design components:

1. Users table with profile information
2. Posts table with content and metadata
3. Relationships table for follows/followers
4. Interactions table for likes/comments/shares
5. Hashtags table with post associations
6. Analytics tables for metrics aggregation

Include:

- JSONB columns for flexible metadata
- Full-text search indexes for content
- Time-series optimization for analytics
- Partitioning by date for large tables
- Replication setup for high availability

```

## 8. Deployment and DevOps Prompts

**Purpose**: Design deployment pipelines, infrastructure, and operational procedures
**When to use**: Setting up CI/CD, infrastructure as code, or operational runbooks

### Template
```

Design the deployment and operational strategy for [application/system]:

Application characteristics:

- [Technology stack and architecture]
- [Scalability and performance requirements]
- [Availability and uptime targets]
- [Security and compliance requirements]

Deployment requirements:

- [Environment types (dev/staging/prod)]
- [Deployment frequency and rollback strategy]
- [Infrastructure automation needs]
- [Monitoring and alerting requirements]

Design components:

1. CI/CD pipeline with stages and gates
2. Infrastructure as Code (Terraform/CloudFormation)
3. Container orchestration strategy
4. Monitoring and logging stack
5. Backup and disaster recovery
6. Security hardening and compliance

Include:

- Blue-green or canary deployment strategy
- Automated testing in pipeline
- Infrastructure cost optimization
- Incident response procedures
- Performance monitoring dashboards

```

### Example
```

Design the deployment and operational strategy for a containerized microservices application:

Application characteristics:

- 8 microservices in Node.js and Python
- Kubernetes orchestration on AWS EKS
- PostgreSQL and Redis for data storage
- External API integrations (payment, email)
- 99.9% uptime requirement

Deployment requirements:

- Multiple environments (dev, staging, production)
- Automated deployments with approval gates
- Zero-downtime updates with blue-green strategy
- Infrastructure security with VPC and security groups

Design components:

1. GitHub Actions CI/CD pipeline
2. Terraform infrastructure modules
3. Kubernetes manifests with Helm charts
4. Prometheus/Grafana monitoring stack
5. AWS Backup for data protection
6. AWS Config and Security Hub for compliance

Include:

- Multi-stage pipeline with security scanning
- Automated rollback procedures
- Cost allocation tags and budgets
- Incident response runbooks
- Performance and error budget tracking

```

## 9. Documentation Prompts

**Purpose**: Create comprehensive technical documentation for developers and stakeholders
**When to use**: Writing API docs, user guides, architectural documentation, or operational runbooks

### Template
```

Create [type of documentation] for [subject/application]:

Target audience:

- [Primary readers and their backgrounds]
- [Technical knowledge assumptions]
- [Use cases and goals]

Documentation scope:

1. [Section 1 - Overview and getting started]
2. [Section 2 - Core functionality and features]
3. [Section 3 - Configuration and customization]
4. [Section 4 - Troubleshooting and FAQ]
5. [Section 5 - API reference and examples]

Technical details to include:

- [Code examples and snippets]
- [Configuration files and options]
- [API specifications and schemas]
- [Architecture diagrams and data flows]
- [Best practices and recommendations]

Documentation standards:

- [Format and tooling (Markdown, Sphinx, etc.)]
- [Code highlighting and formatting]
- [Versioning and update procedures]
- [Accessibility and readability guidelines]

```

### Example
```

Create comprehensive API documentation for a payment processing service:

Target audience:

- Backend developers integrating payments
- Frontend developers implementing checkout flows
- DevOps engineers deploying and monitoring
- Product managers understanding capabilities

Documentation scope:

1. Getting started guide with authentication setup
2. Payment methods and supported currencies
3. Webhook configuration and event handling
4. Error handling and troubleshooting
5. Testing with sandbox environment
6. Production deployment checklist

Technical details to include:

- Complete OpenAPI 3.0 specification
- SDK examples in multiple languages
- Webhook payload schemas and signatures
- Rate limiting and quota information
- PCI compliance and security measures

Documentation standards:

- Hosted on GitBook with version control
- Interactive API explorer with Try It functionality
- Code samples with copy-to-clipboard
- Search functionality and table of contents
- Regular updates with changelog

```

## 10. Security Assessment Prompts

**Purpose**: Conduct security reviews and vulnerability assessments
**When to use**: Security code reviews, threat modeling, or compliance assessments

### Template
```

Conduct a comprehensive security assessment for [application/system/component]:

Assessment scope:

- [Components and functionality to review]
- [Security requirements and standards]
- [Compliance frameworks (OWASP, NIST, etc.)]
- [Threat models and attack vectors]

Security domains to evaluate:

1. Authentication and session management
2. Authorization and access controls
3. Input validation and sanitization
4. Data protection and encryption
5. Secure communication protocols
6. Security logging and monitoring
7. Configuration and secrets management

For each domain, provide:

- Current implementation assessment
- Identified vulnerabilities with severity levels
- Remediation recommendations with code examples
- Testing procedures for validation
- Compliance status and gaps

Risk assessment framework:

- [Likelihood vs impact matrix]
- [CVSS scoring for vulnerabilities]
- [Prioritization for remediation]
- [Timeline and resource requirements]

```

### Example
```

Conduct a comprehensive security assessment for a healthcare patient portal web application:

Assessment scope:

- User authentication and patient data access
- HIPAA compliance requirements
- OWASP Top 10 vulnerability prevention
- PHI (Protected Health Information) handling

Security domains to evaluate:

1. Multi-factor authentication implementation
2. Role-based access control for patient records
3. Input validation for medical data entry
4. Data encryption at rest and in transit
5. Secure API communication with EHR systems
6. Audit logging for all data access
7. Secure configuration management

For each domain, provide:

- Code review findings with specific examples
- Vulnerability severity (Critical/High/Medium/Low)
- Remediation code examples and best practices
- Penetration testing scenarios
- Compliance evidence and documentation

Risk assessment framework:

- CVSS v3.1 scoring for all findings
- Remediation priority based on patient safety impact
- Implementation timeline with quarterly milestones
- Security testing integration into CI/CD pipeline

```

## Choosing the Right Development Prompt Type

### SDLC Phase Guide

**Requirements Gathering** → Requirements Analysis Prompts
**System Design** → System Architecture Prompts
**Implementation** → Code Generation Prompts
**Code Review** → Code Review Prompts
**Testing** → Testing Strategy Prompts
**API Development** → API Design Prompts
**Data Modeling** → Database Design Prompts
**Deployment** → Deployment and DevOps Prompts
**Documentation** → Documentation Prompts
**Security Review** → Security Assessment Prompts

### Combining Development Prompt Types

Effective software development often requires combining multiple prompt types:

```

You are a senior full-stack architect (Role) designing a user management system (System Architecture).

Create detailed API specifications (API Design) for user CRUD operations with JWT authentication.

Include database schema design (Database Design) with proper indexing and relationships.

Provide code examples (Code Generation) in Node.js/Express with TypeScript.

Design comprehensive testing strategy (Testing Strategy) including unit, integration, and e2e tests.

Create deployment pipeline (Deployment and DevOps) with Docker and Kubernetes.

Include security assessment (Security Assessment) for authentication and data protection.

Generate API documentation (Documentation) with OpenAPI specification.

```

Experiment with combinations to create comprehensive development specifications that cover the entire software lifecycle.
