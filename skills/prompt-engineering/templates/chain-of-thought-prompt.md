# Architecture Design Prompt Template

Use this template for complex software design problems that require step-by-step reasoning and analysis.

## Template Structure

```
Design [system/component/architecture] for [specific use case] with the following requirements:

Problem Statement:
- [Clear description of the problem to solve]
- [Current challenges or pain points]
- [Success criteria and constraints]

Requirements Analysis:
- Functional requirements: [What the system must do]
- Non-functional requirements: [Performance, scalability, security, etc.]
- Technical constraints: [Technology stack, legacy systems, etc.]
- Business constraints: [Budget, timeline, team skills, etc.]

Current State Assessment:
- Existing systems and their limitations
- Available resources and infrastructure
- Team capabilities and expertise

Solution Exploration:
Step 1: [First consideration - e.g., technology options]
- Option A: [Description, pros/cons]
- Option B: [Description, pros/cons]
- Recommendation: [Rationale]

Step 2: [Next consideration - e.g., architecture patterns]
- Pattern A: [Description, trade-offs]
- Pattern B: [Description, trade-offs]
- Recommendation: [Rationale]

Step 3: [Continue with additional considerations]

Proposed Solution:
- High-level architecture: [System overview]
- Component breakdown: [Key components and responsibilities]
- Data flow: [How data moves through the system]
- Technology choices: [Justification for each choice]

Implementation Plan:
- Phase 1: [MVP features and timeline]
- Phase 2: [Additional features and scaling]
- Risk mitigation: [Potential issues and solutions]
- Success metrics: [How to measure success]

Migration Strategy (if applicable):
- Transition plan from current system
- Data migration approach
- Rollback procedures
- Go-live checklist
```

## Example Usage

```
Design a microservices architecture for an e-commerce platform handling 10,000+ concurrent users.

Problem Statement:
- Current monolithic application experiencing performance issues during peak hours
- Difficulty scaling individual features independently
- Long deployment cycles and high risk of outages
- Need to support mobile apps and third-party integrations

Requirements Analysis:
- Functional: User management, product catalog, shopping cart, payment processing, order management
- Non-functional: 99.9% uptime, <500ms response time, horizontal scalability
- Technical: Must integrate with existing PostgreSQL database, support REST and GraphQL APIs
- Business: 6-month migration timeline, team of 8 developers with mixed experience

Current State Assessment:
- Ruby on Rails monolith with 500k+ lines of code
- Single PostgreSQL database with performance issues
- Team experienced in Rails but new to microservices
- AWS infrastructure with load balancers and RDS

Solution Exploration:
Step 1: Service decomposition strategy
- Domain-driven design: Break down by business capabilities (user, product, order, payment)
- Database-per-service: Each service owns its data with eventual consistency
- API composition: GraphQL gateway for client requests
- Recommendation: Hybrid approach with shared database initially, migrate to database-per-service

Step 2: Communication patterns
- Synchronous: REST APIs for real-time operations (payments, inventory checks)
- Asynchronous: Event-driven for order processing and notifications
- CQRS: Separate read/write models for complex queries
- Recommendation: Event-driven with REST fallback for critical paths

Step 3: Technology stack evaluation
- Languages: Node.js for API services, Python for data processing, Go for high-performance services
- Infrastructure: Kubernetes for orchestration, Istio for service mesh
- Monitoring: ELK stack for logging, Prometheus/Grafana for metrics
- Recommendation: Polyglot approach based on service requirements

Proposed Solution:
- API Gateway: GraphQL federation layer
- User Service: Authentication, profiles (Node.js)
- Product Service: Catalog, inventory (Python with async)
- Order Service: Cart, checkout, fulfillment (Go)
- Payment Service: Stripe integration (Node.js)
- Event Bus: Apache Kafka for inter-service communication
- Database: PostgreSQL with read replicas, Redis for caching

Implementation Plan:
- Phase 1 (2 months): Extract user and product services, establish event infrastructure
- Phase 2 (2 months): Add order and payment services, implement CQRS
- Phase 3 (2 months): Performance optimization, monitoring, testing
- Risk mitigation: Feature flags, canary deployments, comprehensive testing
- Success metrics: Response time <300ms, 99.95% uptime, deployment frequency 10x increase

Migration Strategy:
- Strangler pattern: Gradually replace monolith features
- Data migration: Online migration with fallback to old system
- Rollback: Feature flags to disable new services
- Go-live: Blue-green deployment with traffic shifting
```

## Tips for Success

- Break down complex problems into manageable steps
- Consider multiple options with pros/cons analysis
- Include specific metrics and success criteria
- Address risks and mitigation strategies
- Provide implementation timeline and phases
- Consider team capabilities and organizational constraints
