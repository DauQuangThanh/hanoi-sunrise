# Data Model: [Feature Name]

**Date**: [YYYY-MM-DD]  
**Author**: [Name]  
**Related Design**: [Link to design.md]

---

## Overview

This document defines all data entities, their attributes, relationships, and validation rules for the [Feature Name] implementation.

---

## Entity Summary

Quick reference table of all entities in this feature:

| Entity | Description | Primary Key | Type |
|--------|-------------|-------------|------|
| [Entity1] | [Brief description] | [id field] | Persistent / Transient / External |
| [Entity2] | [Brief description] | [id field] | Persistent / Transient / External |
| [Entity3] | [Brief description] | [id field] | Persistent / Transient / External |

**Legend**:

- **Persistent**: Stored in database
- **Transient**: Temporary/in-memory only
- **External**: Managed by external system

---

## Entity Definitions

### Entity 1: [Entity Name]

**Description**: [Detailed description of what this entity represents]

**Type**: Persistent / Transient / External

**Table/Collection Name**: `[table_name]` (for persistent entities)

#### Fields

| Field Name | Type | Required | Default | Constraints | Description |
|------------|------|----------|---------|-------------|-------------|
| `id` | UUID | Yes | Auto-generated | Primary Key, Unique | Unique identifier |
| `[field1]` | String | Yes | - | Max 255 chars | [Description] |
| `[field2]` | Integer | No | 0 | Min: 0, Max: 100 | [Description] |
| `[field3]` | DateTime | Yes | NOW() | - | [Description] |
| `[field4]` | Boolean | No | false | - | [Description] |
| `[field5]` | Enum | Yes | - | Values: [A, B, C] | [Description] |
| `[field6]` | Array[String] | No | [] | - | [Description] |
| `[field7]` | JSON | No | {} | - | [Description] |
| `created_at` | DateTime | Yes | NOW() | Immutable | Record creation timestamp |
| `updated_at` | DateTime | Yes | NOW() | Auto-update | Record last update timestamp |
| `deleted_at` | DateTime | No | null | - | Soft delete timestamp |

#### Field Details

**`[field1]`**:

- **Purpose**: [Detailed purpose]
- **Format**: [Expected format, e.g., email, URL, etc.]
- **Example Values**:
  - Valid: `[example1]`, `[example2]`
  - Invalid: `[example3]` (reason)

**`[field2]`**:

- **Purpose**: [Detailed purpose]
- **Business Rules**: [Any business logic rules]
- **Example Values**: [Examples]

**`[field5]` (Enum)**:

- **Values**:
  - `A` - [Description of state A]
  - `B` - [Description of state B]
  - `C` - [Description of state C]
- **Default**: [Default value]
- **Transitions**: See State Machine section

#### Validation Rules

1. **Field-Level Validations**:
   - `[field1]`: Must be valid email format (regex: `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`)
   - `[field2]`: Must be between 0 and 100 inclusive
   - `[field3]`: Cannot be in the future
   - `[field5]`: Must be one of the defined enum values

2. **Entity-Level Validations**:
   - `[field1]` + `[field2]` combination must be unique
   - If `[field4]` is true, then `[field6]` cannot be empty
   - At least one of `[field7]` or `[field8]` must be provided

3. **Business Logic Validations**:
   - [Business rule 1]
   - [Business rule 2]

#### Indexes

For database performance optimization:

```sql
-- Primary index
CREATE INDEX idx_[entity]_id ON [table_name](id);

-- Secondary indexes
CREATE INDEX idx_[entity]_field1 ON [table_name]([field1]);
CREATE INDEX idx_[entity]_created ON [table_name](created_at);

-- Composite indexes
CREATE INDEX idx_[entity]_field1_field2 ON [table_name]([field1], [field2]);

-- Unique constraints
CREATE UNIQUE INDEX idx_[entity]_unique_field ON [table_name]([field1]);
```

#### Relationships

**One-to-Many**:

- **Has Many**: `[RelatedEntity]` via `[foreign_key]`
  - Description: [Relationship description]
  - Cascade: [Delete/Update behavior]
  - Example: One [Entity1] can have many [RelatedEntity]

**Many-to-One**:

- **Belongs To**: `[ParentEntity]` via `[foreign_key]`
  - Description: [Relationship description]
  - Required: Yes/No
  - Example: Each [Entity1] belongs to one [ParentEntity]

**Many-to-Many**:

- **Has And Belongs To Many**: `[OtherEntity]` via join table `[join_table]`
  - Description: [Relationship description]
  - Join Table Fields: `[entity1_id]`, `[entity2_id]`, `[additional_field]`
  - Example: [Entity1] can be associated with multiple [OtherEntity] and vice versa

#### State Machine (if applicable)

**States**: [List all possible states]

**State Diagram**:

```
[State1] ──[Event1]──> [State2]
    │
    └──[Event2]──> [State3]
                      │
                      └──[Event3]──> [State4]
```

**State Transitions**:

| From State | Event | To State | Conditions | Side Effects |
|------------|-------|----------|------------|--------------|
| [State1] | [Event1] | [State2] | [Condition if any] | [What happens] |
| [State2] | [Event2] | [State3] | [Condition if any] | [What happens] |
| [State2] | [Event3] | [State1] | [Condition if any] | [What happens - rollback] |

**State Validation Rules**:

- From `[State1]`: Only `[Event1]` and `[Event2]` are valid
- From `[State2]`: Can transition to `[State3]` or back to `[State1]`
- `[State4]` is terminal (no transitions out)

**State-Specific Business Rules**:

- In `[State1]`: [Rule 1]
- In `[State2]`: [Rule 2]

#### Example Instance

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "[field1]": "example@domain.com",
  "[field2]": 42,
  "[field3]": "2026-01-24T10:30:00Z",
  "[field4]": true,
  "[field5]": "A",
  "[field6]": ["item1", "item2"],
  "[field7]": {
    "key1": "value1",
    "key2": "value2"
  },
  "created_at": "2026-01-20T09:00:00Z",
  "updated_at": "2026-01-24T10:30:00Z",
  "deleted_at": null
}
```

#### Database Schema

**PostgreSQL**:

```sql
CREATE TABLE [table_name] (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    [field1] VARCHAR(255) NOT NULL,
    [field2] INTEGER DEFAULT 0 CHECK ([field2] >= 0 AND [field2] <= 100),
    [field3] TIMESTAMP WITH TIME ZONE NOT NULL,
    [field4] BOOLEAN DEFAULT FALSE,
    [field5] VARCHAR(50) NOT NULL CHECK ([field5] IN ('A', 'B', 'C')),
    [field6] TEXT[],
    [field7] JSONB,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE,
    
    -- Constraints
    CONSTRAINT uq_[entity]_field1_field2 UNIQUE ([field1], [field2])
);

-- Indexes
CREATE INDEX idx_[entity]_field1 ON [table_name]([field1]);
CREATE INDEX idx_[entity]_created ON [table_name](created_at);

-- Trigger for updated_at
CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON [table_name]
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_updated_at();
```

**MongoDB**:

```javascript
db.createCollection("[collection_name]", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["[field1]", "[field3]", "[field5]", "created_at", "updated_at"],
      properties: {
        _id: { bsonType: "objectId" },
        [field1]: { 
          bsonType: "string",
          maxLength: 255,
          pattern: "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        },
        [field2]: { 
          bsonType: "int",
          minimum: 0,
          maximum: 100
        },
        [field3]: { bsonType: "date" },
        [field4]: { bsonType: "bool" },
        [field5]: { 
          bsonType: "string",
          enum: ["A", "B", "C"]
        },
        [field6]: { 
          bsonType: "array",
          items: { bsonType: "string" }
        },
        [field7]: { bsonType: "object" },
        created_at: { bsonType: "date" },
        updated_at: { bsonType: "date" },
        deleted_at: { bsonType: ["date", "null"] }
      }
    }
  }
});

// Indexes
db.[collection_name].createIndex({ "[field1]": 1 });
db.[collection_name].createIndex({ "created_at": -1 });
db.[collection_name].createIndex({ "[field1]": 1, "[field2]": 1 }, { unique: true });
```

---

### Entity 2: [Entity Name]

[Repeat the same structure as Entity 1]

**Description**: [Detailed description]

**Type**: Persistent / Transient / External

**Table/Collection Name**: `[table_name]`

#### Fields

[Same table structure as Entity 1]

#### Validation Rules

[Same structure as Entity 1]

#### Relationships

[Same structure as Entity 1]

#### Example Instance

```json
{
  // Example here
}
```

#### Database Schema

```sql
-- Schema here
```

---

### Entity 3: [Entity Name]

[Repeat the same structure]

---

## Entity Relationships Diagram

### ER Diagram

```
┌─────────────────┐           ┌─────────────────┐
│   [Entity1]     │           │   [Entity2]     │
├─────────────────┤           ├─────────────────┤
│ id (PK)         │           │ id (PK)         │
│ field1          │──────────<│ entity1_id (FK) │
│ field2          │    1:N    │ field1          │
│ ...             │           │ ...             │
└─────────────────┘           └─────────────────┘
                                       │
                                       │ N:M
                                       │
                                       ▼
                              ┌─────────────────┐
                              │   [Entity3]     │
                              ├─────────────────┤
                              │ id (PK)         │
                              │ field1          │
                              │ ...             │
                              └─────────────────┘
```

### Relationship Cardinality

| Entity A | Relationship | Entity B | Cardinality | Description |
|----------|--------------|----------|-------------|-------------|
| [Entity1] | has many | [Entity2] | 1:N | [Description] |
| [Entity2] | belongs to | [Entity1] | N:1 | [Description] |
| [Entity2] | has and belongs to many | [Entity3] | N:M | [Description] |

---

## Data Flow

### Create Flow

```
User Input
    ↓
Validation (Field + Entity + Business Logic)
    ↓
[State1] (Initial State)
    ↓
Save to Database
    ↓
Create Related Entities (if any)
    ↓
Emit [Entity.Created] Event
    ↓
Return Created Entity
```

### Update Flow

```
Fetch Existing Entity
    ↓
Validate Changes
    ↓
Check State Transitions (if applicable)
    ↓
Apply Updates
    ↓
Update Related Entities (if needed)
    ↓
Set updated_at timestamp
    ↓
Save to Database
    ↓
Emit [Entity.Updated] Event
    ↓
Return Updated Entity
```

### Delete Flow

```
Fetch Existing Entity
    ↓
Check Delete Permissions
    ↓
Soft Delete: Set deleted_at timestamp
OR
Hard Delete: Remove from database
    ↓
Handle Related Entities (Cascade/Set Null/Restrict)
    ↓
Emit [Entity.Deleted] Event
    ↓
Return Success Response
```

---

## Aggregate Roots (Domain-Driven Design)

If using DDD principles:

### Aggregate 1: [Aggregate Name]

**Root Entity**: [Entity Name]

**Bounded Context**: [Context name]

**Entities in Aggregate**:

- [Root Entity]
- [Child Entity 1]
- [Child Entity 2]

**Value Objects**:

**Invariants** (rules that must always be true):

1. [Invariant 1]
2. [Invariant 2]

**Business Rules**:

1. [Rule 1]
2. [Rule 2]

---

## Data Migration Strategy

### Initial Schema Setup

**Migration File**: `001_create_[entity]_table.sql`

```sql
-- Migration SQL here
CREATE TABLE [table_name] (...);
```

### Adding New Fields

**Migration File**: `002_add_[field]_to_[entity].sql`

```sql
ALTER TABLE [table_name]
ADD COLUMN [new_field] [type] [constraints];
```

### Data Transformation

If migrating from existing data:

```sql
-- Example: Migrate old_field to new_field
UPDATE [table_name]
SET [new_field] = [transformation_logic]
WHERE [condition];
```

---

## Data Seeding

### Seed Data for Development/Testing

**[Entity1] Seed Data**:

```json
[
  {
    "id": "seed-uuid-1",
    "[field1]": "test1@example.com",
    "[field2]": 10,
    "[field5]": "A"
  },
  {
    "id": "seed-uuid-2",
    "[field1]": "test2@example.com",
    "[field2]": 20,
    "[field5]": "B"
  }
]
```

### Reference Data for Production

Data that should exist in production:

```json
[
  {
    "id": "ref-uuid-1",
    "name": "Reference Item 1",
    "type": "system"
  }
]
```

---

## Data Access Patterns

### Common Queries

1. **Get [Entity] by ID**:

   ```sql
   SELECT * FROM [table_name] WHERE id = ? AND deleted_at IS NULL;
   ```

2. **List all [Entity] with pagination**:

   ```sql
   SELECT * FROM [table_name]
   WHERE deleted_at IS NULL
   ORDER BY created_at DESC
   LIMIT ? OFFSET ?;
   ```

3. **Search [Entity] by [field1]**:

   ```sql
   SELECT * FROM [table_name]
   WHERE [field1] ILIKE ? AND deleted_at IS NULL
   ORDER BY [field2] DESC;
   ```

4. **Get [Entity] with related data**:

   ```sql
   SELECT e.*, r.*
   FROM [table_name] e
   LEFT JOIN [related_table] r ON r.entity_id = e.id
   WHERE e.id = ? AND e.deleted_at IS NULL;
   ```

### Indexes for Performance

- `[field1]`: For search queries
- `created_at`: For chronological sorting
- `[field1] + [field2]`: For unique constraint and compound queries
- `deleted_at`: For soft delete filtering

---

## Data Consistency Rules

### Consistency Requirements

1. **Atomicity**:
   - [Rule 1: e.g., User and Profile must be created together]
   - [Rule 2: e.g., Payment and Order status must update atomically]

2. **Eventual Consistency** (if using event-driven architecture):
   - [Rule 1: e.g., Search index updated asynchronously]
   - [Rule 2: e.g., Analytics data updated in batch]

### Transaction Boundaries

**Transaction 1: Create [Entity] with related data**

```
BEGIN TRANSACTION
  INSERT INTO [table_name] ...
  INSERT INTO [related_table] ...
  UPDATE [counter_table] ...
COMMIT
```

**Transaction 2: Update with state transition**

```
BEGIN TRANSACTION
  SELECT ... FOR UPDATE  -- Lock row
  UPDATE [table_name] SET state = ...
  INSERT INTO [audit_log] ...
COMMIT
```

---

## Data Retention & Archival

### Retention Policy

- **Active Records**: Keep indefinitely while `deleted_at IS NULL`
- **Soft-Deleted Records**: Retain for [X days/months] before hard delete
- **Audit Logs**: Retain for [Y years] for compliance
- **Archived Data**: Move to cold storage after [Z months] of inactivity

### Archival Strategy

```sql
-- Move old data to archive table
INSERT INTO [table_name]_archive
SELECT * FROM [table_name]
WHERE updated_at < NOW() - INTERVAL '[X months]'
  AND deleted_at IS NOT NULL;

-- Delete archived data from main table
DELETE FROM [table_name]
WHERE id IN (SELECT id FROM [table_name]_archive);
```

---

## Privacy & Security Considerations

### Sensitive Data

**PII (Personally Identifiable Information)**:

- `[field1]`: Email address - encrypted at rest
- `[field2]`: Phone number - encrypted at rest
- `[field3]`: Address - encrypted at rest

**Encryption Strategy**:

- **At Rest**: AES-256 encryption for sensitive fields
- **In Transit**: TLS 1.3 for all data transfers
- **In Use**: Field-level encryption with application-managed keys

### Data Access Control

- **Read Access**: [Who can read]
- **Write Access**: [Who can write]
- **Delete Access**: [Who can delete]
- **Admin Access**: [Who has full access]

### Audit Trail

All operations tracked in audit log:

```json
{
  "entity_type": "[Entity]",
  "entity_id": "uuid",
  "operation": "CREATE|UPDATE|DELETE",
  "actor": "user_id",
  "timestamp": "ISO8601",
  "changes": {
    "field": {
      "old_value": "...",
      "new_value": "..."
    }
  }
}
```

---

## Testing Data Model

### Unit Test Cases

1. **Validation Tests**:
   - Test all field-level validations
   - Test entity-level validations
   - Test business logic validations

2. **State Transition Tests**:
   - Test all valid state transitions
   - Test invalid state transition rejections
   - Test state-specific business rules

3. **Relationship Tests**:
   - Test cascade deletes
   - Test referential integrity
   - Test orphaned record handling

### Integration Test Cases

1. **Database Operations**:
   - Test CRUD operations
   - Test transaction rollbacks
   - Test concurrent updates

2. **Data Migration Tests**:
   - Test schema migrations
   - Test data transformations
   - Test rollback procedures

---

## Appendix

### A. Terminology

| Term | Definition |
|------|------------|
| [Term 1] | [Definition] |
| [Term 2] | [Definition] |

### B. SQL Scripts

All complete SQL scripts for schema creation, indexes, and migrations.

### C. Sample Data Sets

Complete sample data for testing various scenarios.

---

## Revision History

| Date | Version | Author | Changes |
|------|---------|--------|---------|
| [Date] | 1.0 | [Name] | Initial data model |
| [Date] | 1.1 | [Name] | [Changes] |
