# API Contract: [Endpoint Name]

**Version**: 1.0  
**Date**: [YYYY-MM-DD]  
**Author**: [Name]  
**Related Design**: [Link to design.md]

---

## Endpoint Overview

**Path**: `/api/v1/[resource]/[action]`  
**Method**: GET | POST | PUT | PATCH | DELETE  
**Description**: [Brief description of what this endpoint does]

**Use Case**: [When and why this endpoint would be called]

---

## Authentication & Authorization

### Authentication Required

- **Required**: Yes / No
- **Method**: Bearer Token (JWT) / API Key / OAuth 2.0 / Basic Auth
- **Token Location**: Header `Authorization: Bearer <token>`

### Authorization Rules

- **Required Permissions**: `[permission.resource.action]` (e.g., `users.profile.read`)
- **Required Roles**: `[role1, role2]` (e.g., `admin`, `user`)
- **Resource Ownership**: User must own the resource / Admin can access all
- **Additional Checks**: [Any other authorization logic]

**Example Authorization Header**:

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## Request Specification

### URL Parameters

| Parameter | Type | Required | Description | Example |
|-----------|------|----------|-------------|---------|
| `[param1]` | String | Yes | [Description] | `abc123` |
| `[param2]` | Integer | No | [Description] | `42` |

**Example URL**:

```
/api/v1/[resource]/[abc123]
```

### Query Parameters

| Parameter | Type | Required | Default | Constraints | Description |
|-----------|------|----------|---------|-------------|-------------|
| `page` | Integer | No | 1 | Min: 1 | Page number for pagination |
| `limit` | Integer | No | 20 | Min: 1, Max: 100 | Items per page |
| `sort` | String | No | `created_at` | Enum: [field1, field2] | Sort field |
| `order` | String | No | `desc` | Enum: [asc, desc] | Sort order |
| `filter` | String | No | - | - | Filter expression |
| `search` | String | No | - | - | Search query |

**Example Query String**:

```
?page=2&limit=50&sort=name&order=asc&filter=status:active
```

### Request Headers

| Header | Required | Description | Example |
|--------|----------|-------------|---------|
| `Content-Type` | Yes | Request content type | `application/json` |
| `Accept` | No | Accepted response type | `application/json` |
| `X-Request-ID` | No | Request tracking ID | `req-uuid-12345` |
| `X-API-Version` | No | API version override | `v2` |

### Request Body

**Content-Type**: `application/json`

#### Schema

```json
{
  "[field1]": "string (required)",
  "[field2]": "integer (optional)",
  "[field3]": {
    "[nested_field1]": "string",
    "[nested_field2]": "boolean"
  },
  "[field4]": ["array", "of", "strings"]
}
```

#### Fields

| Field | Type | Required | Constraints | Description |
|-------|------|----------|-------------|-------------|
| `[field1]` | String | Yes | Max: 255 chars | [Description] |
| `[field2]` | Integer | No | Min: 0, Max: 100 | [Description] |
| `[field3]` | Object | No | - | [Description] |
| `[field3].[nested_field1]` | String | Conditional | Required if field3 present | [Description] |
| `[field3].[nested_field2]` | Boolean | No | - | [Description] |
| `[field4]` | Array[String] | No | Max: 10 items | [Description] |

#### Validation Rules

1. **Field-Level**:
   - `[field1]`: Must match regex pattern `^[a-zA-Z0-9_-]+$`
   - `[field2]`: Must be between 0 and 100 inclusive
   - `[field4]`: Each item must be unique

2. **Entity-Level**:
   - If `[field2]` > 50, then `[field3]` is required
   - At least one of `[field1]` or `[field4]` must be provided

3. **Business Logic**:
   - [Business validation rule 1]
   - [Business validation rule 2]

#### Example Request Body

```json
{
  "[field1]": "example-value",
  "[field2]": 42,
  "[field3]": {
    "[nested_field1]": "nested-value",
    "[nested_field2]": true
  },
  "[field4]": ["item1", "item2", "item3"]
}
```

---

## Response Specification

### Success Response

**Status Code**: `200 OK` | `201 Created` | `204 No Content`

**Content-Type**: `application/json`

#### Response Schema

```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "[field1]": "string",
    "[field2]": "integer",
    "[field3]": {
      "[nested_field1]": "string",
      "[nested_field2]": "boolean"
    },
    "[field4]": ["array", "of", "strings"],
    "created_at": "ISO8601 datetime",
    "updated_at": "ISO8601 datetime"
  },
  "meta": {
    "request_id": "string",
    "timestamp": "ISO8601 datetime",
    "version": "string"
  }
}
```

#### Fields

| Field | Type | Always Present | Description |
|-------|------|----------------|-------------|
| `success` | Boolean | Yes | Indicates successful operation |
| `data` | Object | Yes | Response payload |
| `data.id` | UUID | Yes | Resource identifier |
| `data.[field1]` | String | Yes | [Description] |
| `data.[field2]` | Integer | No | [Description] |
| `meta` | Object | Yes | Response metadata |
| `meta.request_id` | String | Yes | Request tracking ID |
| `meta.timestamp` | String | Yes | Response timestamp (ISO8601) |

#### Example Success Response

**Status**: `200 OK`

```json
{
  "success": true,
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "[field1]": "example-value",
    "[field2]": 42,
    "[field3]": {
      "[nested_field1]": "nested-value",
      "[nested_field2]": true
    },
    "[field4]": ["item1", "item2", "item3"],
    "created_at": "2026-01-24T10:30:00Z",
    "updated_at": "2026-01-24T10:30:00Z"
  },
  "meta": {
    "request_id": "req-uuid-12345",
    "timestamp": "2026-01-24T10:30:00Z",
    "version": "v1"
  }
}
```

### Pagination Response (for list endpoints)

**Status Code**: `200 OK`

```json
{
  "success": true,
  "data": [
    {
      "id": "uuid-1",
      "[field1]": "value1"
    },
    {
      "id": "uuid-2",
      "[field1]": "value2"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total_items": 100,
    "total_pages": 5,
    "has_next": true,
    "has_prev": false
  },
  "meta": {
    "request_id": "string",
    "timestamp": "ISO8601 datetime"
  }
}
```

### Error Response

**Status Codes**: See Error Codes section below

**Content-Type**: `application/json`

#### Error Response Schema

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": [
      {
        "field": "[field_name]",
        "message": "Field-specific error message",
        "code": "FIELD_ERROR_CODE"
      }
    ]
  },
  "meta": {
    "request_id": "string",
    "timestamp": "ISO8601 datetime"
  }
}
```

#### Example Error Response

**Status**: `400 Bad Request`

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "[field1]",
        "message": "[field1] must match pattern ^[a-zA-Z0-9_-]+$",
        "code": "INVALID_FORMAT"
      },
      {
        "field": "[field2]",
        "message": "[field2] must be between 0 and 100",
        "code": "OUT_OF_RANGE"
      }
    ]
  },
  "meta": {
    "request_id": "req-uuid-12345",
    "timestamp": "2026-01-24T10:30:00Z"
  }
}
```

---

## Error Codes

### Client Errors (4xx)

| Status Code | Error Code | Condition | Message | Resolution |
|-------------|------------|-----------|---------|------------|
| 400 | `VALIDATION_ERROR` | Request validation failed | "Request validation failed" | Fix validation errors in details |
| 400 | `INVALID_FORMAT` | Field format invalid | "[field] has invalid format" | Correct field format |
| 400 | `MISSING_REQUIRED_FIELD` | Required field missing | "[field] is required" | Provide required field |
| 401 | `UNAUTHORIZED` | Authentication failed | "Authentication required" | Provide valid credentials |
| 401 | `INVALID_TOKEN` | Token invalid or expired | "Invalid or expired token" | Refresh token |
| 403 | `FORBIDDEN` | Authorization failed | "Insufficient permissions" | Request appropriate permissions |
| 403 | `RESOURCE_FORBIDDEN` | User cannot access resource | "Access to resource denied" | Verify resource ownership |
| 404 | `NOT_FOUND` | Resource not found | "[Resource] not found" | Verify resource ID |
| 409 | `CONFLICT` | Resource conflict | "Resource already exists" | Use different identifier |
| 409 | `STATE_CONFLICT` | Invalid state transition | "Invalid state transition" | Check current resource state |
| 422 | `BUSINESS_LOGIC_ERROR` | Business rule violation | "[Business rule] violated" | Review business rules |
| 429 | `RATE_LIMIT_EXCEEDED` | Too many requests | "Rate limit exceeded" | Wait before retrying |

### Server Errors (5xx)

| Status Code | Error Code | Condition | Message | Resolution |
|-------------|------------|-----------|---------|------------|
| 500 | `INTERNAL_ERROR` | Unexpected server error | "Internal server error" | Retry or contact support |
| 502 | `BAD_GATEWAY` | Upstream service error | "Upstream service error" | Retry or contact support |
| 503 | `SERVICE_UNAVAILABLE` | Service temporarily unavailable | "Service unavailable" | Retry with backoff |
| 504 | `GATEWAY_TIMEOUT` | Upstream timeout | "Request timeout" | Retry with longer timeout |

---

## Rate Limiting

**Limit**: [X requests per Y time period] (e.g., 100 requests per minute)

**Scope**: Per user / Per IP / Per API key

**Headers**:

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1706097600
```

**When Exceeded**:

- **Status**: `429 Too Many Requests`
- **Retry-After Header**: Seconds until rate limit resets
- **Response**:

  ```json
  {
    "success": false,
    "error": {
      "code": "RATE_LIMIT_EXCEEDED",
      "message": "Rate limit exceeded. Try again in 60 seconds."
    }
  }
  ```

---

## Idempotency

**Idempotent**: Yes / No

**Idempotency Key** (for POST/PUT/PATCH):

- **Header**: `Idempotency-Key: <unique-key>`
- **Format**: UUID or client-generated unique string
- **Behavior**: Repeated requests with same key return same result
- **Retention**: Keys stored for [X hours/days]

**Example**:

```http
POST /api/v1/[resource]
Idempotency-Key: 550e8400-e29b-41d4-a716-446655440000
Content-Type: application/json

{...}
```

If the same request is sent again with the same key within retention period, the original response is returned without re-executing the operation.

---

## Caching

**Cacheable**: Yes / No

**Cache Control Headers**:

```http
Cache-Control: max-age=3600, public
ETag: "33a64df551425fcc55e4d42a148795d9"
Last-Modified: Wed, 24 Jan 2026 10:30:00 GMT
```

**Cache Invalidation**:

- Invalidated on: [Resource update / Delete / etc.]
- Cache key: `[pattern]`

**Conditional Requests**:

```http
GET /api/v1/[resource]/[id]
If-None-Match: "33a64df551425fcc55e4d42a148795d9"
```

Response if not modified:

```http
304 Not Modified
```

---

## Examples

### Example 1: Successful Request

**Request**:

```http
POST /api/v1/users HTTP/1.1
Host: api.example.com
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "email": "user@example.com",
  "name": "John Doe",
  "role": "user"
}
```

**Response**:

```http
HTTP/1.1 201 Created
Content-Type: application/json
Location: /api/v1/users/550e8400-e29b-41d4-a716-446655440000

{
  "success": true,
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "name": "John Doe",
    "role": "user",
    "created_at": "2026-01-24T10:30:00Z",
    "updated_at": "2026-01-24T10:30:00Z"
  },
  "meta": {
    "request_id": "req-uuid-12345",
    "timestamp": "2026-01-24T10:30:00Z",
    "version": "v1"
  }
}
```

### Example 2: Validation Error

**Request**:

```http
POST /api/v1/users HTTP/1.1
Host: api.example.com
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "email": "invalid-email",
  "name": ""
}
```

**Response**:

```http
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "email",
        "message": "Must be a valid email address",
        "code": "INVALID_FORMAT"
      },
      {
        "field": "name",
        "message": "Name is required",
        "code": "MISSING_REQUIRED_FIELD"
      }
    ]
  },
  "meta": {
    "request_id": "req-uuid-67890",
    "timestamp": "2026-01-24T10:31:00Z"
  }
}
```

### Example 3: Authorization Error

**Request**:

```http
GET /api/v1/users/550e8400-e29b-41d4-a716-446655440000 HTTP/1.1
Host: api.example.com
Authorization: Bearer invalid-token
```

**Response**:

```http
HTTP/1.1 401 Unauthorized
Content-Type: application/json
WWW-Authenticate: Bearer realm="api"

{
  "success": false,
  "error": {
    "code": "INVALID_TOKEN",
    "message": "Invalid or expired token"
  },
  "meta": {
    "request_id": "req-uuid-99999",
    "timestamp": "2026-01-24T10:32:00Z"
  }
}
```

---

## OpenAPI Specification

Complete OpenAPI 3.0 specification for this endpoint:

```yaml
openapi: 3.0.3
info:
  title: [API Title]
  version: 1.0.0
  description: [API Description]

servers:
  - url: https://api.example.com/v1
    description: Production
  - url: https://api-staging.example.com/v1
    description: Staging

paths:
  /[resource]:
    post:
      summary: [Endpoint summary]
      description: [Detailed description]
      operationId: [operationId]
      tags:
        - [Resource]
      security:
        - bearerAuth: []
      parameters:
        - name: X-Request-ID
          in: header
          schema:
            type: string
            format: uuid
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/[RequestSchema]'
      responses:
        '201':
          description: Created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/[ResponseSchema]'
        '400':
          description: Validation error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
      
  schemas:
    [RequestSchema]:
      type: object
      required:
        - [field1]
      properties:
        [field1]:
          type: string
          maxLength: 255
        [field2]:
          type: integer
          minimum: 0
          maximum: 100
          
    [ResponseSchema]:
      type: object
      properties:
        success:
          type: boolean
        data:
          type: object
          properties:
            id:
              type: string
              format: uuid
            [field1]:
              type: string
            created_at:
              type: string
              format: date-time
              
    ErrorResponse:
      type: object
      properties:
        success:
          type: boolean
          example: false
        error:
          type: object
          properties:
            code:
              type: string
            message:
              type: string
            details:
              type: array
              items:
                type: object
                properties:
                  field:
                    type: string
                  message:
                    type: string
                  code:
                    type: string
```

---

## Testing

### Unit Test Cases

1. **Request Validation**:
   - Test all required fields
   - Test field format validations
   - Test constraint violations
   - Test business logic validations

2. **Authentication/Authorization**:
   - Test missing token
   - Test invalid token
   - Test expired token
   - Test insufficient permissions

3. **Business Logic**:
   - Test successful operation
   - Test edge cases
   - Test error scenarios

### Integration Test Example

```javascript
describe('POST /api/v1/[resource]', () => {
  it('should create resource successfully', async () => {
    const response = await request(app)
      .post('/api/v1/[resource]')
      .set('Authorization', `Bearer ${validToken}`)
      .send({
        [field1]: 'test-value',
        [field2]: 42
      });
      
    expect(response.status).toBe(201);
    expect(response.body.success).toBe(true);
    expect(response.body.data).toHaveProperty('id');
    expect(response.body.data.[field1]).toBe('test-value');
  });
  
  it('should return 400 for invalid input', async () => {
    const response = await request(app)
      .post('/api/v1/[resource]')
      .set('Authorization', `Bearer ${validToken}`)
      .send({
        [field1]: '',  // Invalid: required field empty
      });
      
    expect(response.status).toBe(400);
    expect(response.body.success).toBe(false);
    expect(response.body.error.code).toBe('VALIDATION_ERROR');
  });
});
```

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | [Date] | Initial specification |
| 1.1 | [Date] | [Changes] |

---

## Related Contracts

---

## Notes

- [Any additional notes or considerations]
- [Performance considerations]
- [Known limitations]
