# Code Naming Convention Patterns

This document provides detailed code naming patterns for variables, functions, classes, and modules.

## Variable Naming Conventions

### Local Variables
**Format**: Language-dependent (camelCase or snake_case)

**JavaScript/TypeScript (camelCase)**:
```typescript
const userName = "John Doe";
const isValid = true;
const totalAmount = 100.50;
const itemCount = 5;
```

**Python (snake_case)**:
```python
user_name = "John Doe"
is_valid = True
total_amount = 100.50
item_count = 5
```

**Java (camelCase)**:
```java
String userName = "John Doe";
boolean isValid = true;
double totalAmount = 100.50;
int itemCount = 5;
```

### Constants
**Format**: SCREAMING_SNAKE_CASE (all languages)

```typescript
const MAX_RETRIES = 3;
const API_BASE_URL = "https://api.example.com";
const DEFAULT_TIMEOUT = 5000;
const PAGE_SIZE = 20;
```

```python
MAX_RETRIES = 3
API_BASE_URL = "https://api.example.com"
DEFAULT_TIMEOUT = 5000
PAGE_SIZE = 20
```

### Class/Instance Variables
**Format**: Language-specific conventions

**JavaScript/TypeScript**:
```typescript
class User {
  private _id: string;           // Private with underscore
  public name: string;            // Public, no prefix
  protected email: string;        // Protected, no prefix
  
  constructor(name: string) {
    this.name = name;
  }
}
```

**Python**:
```python
class User:
    def __init__(self, name):
        self._id = None          # Protected (single underscore)
        self.name = name         # Public
        self.__private = None    # Private (double underscore)
```

**Java**:
```java
public class User {
    private String id;
    public String name;
    protected String email;
}
```

## Function/Method Naming Conventions

### General Functions
**Format**: Verb-based, descriptive, camelCase or snake_case

**JavaScript/TypeScript**:
```typescript
function getUserData(userId: string) { }
function calculateTotal(items: Item[]) { }
function validateEmail(email: string): boolean { }
function formatDate(date: Date): string { }
```

**Python**:
```python
def get_user_data(user_id: str): pass
def calculate_total(items: list): pass
def validate_email(email: str) -> bool: pass
def format_date(date: datetime) -> str: pass
```

### Getter/Setter Methods
**JavaScript/TypeScript**:
```typescript
class User {
  private _name: string;
  
  getName(): string {
    return this._name;
  }
  
  setName(name: string): void {
    this._name = name;
  }
  
  // Or use properties
  get name(): string {
    return this._name;
  }
  
  set name(value: string) {
    this._name = value;
  }
}
```

**Python**:
```python
class User:
    @property
    def name(self):
        return self._name
    
    @name.setter
    def name(self, value):
        self._name = value
```

**Java**:
```java
public class User {
    private String name;
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
}
```

### Boolean Functions
**Prefixes**: `is`, `has`, `should`, `can`, `will`

```typescript
function isValid(input: string): boolean { }
function hasPermission(user: User, resource: string): boolean { }
function shouldRetry(attempt: number): boolean { }
function canEdit(user: User, document: Document): boolean { }
function willExpire(date: Date): boolean { }
```

```python
def is_valid(input_str: str) -> bool: pass
def has_permission(user: User, resource: str) -> bool: pass
def should_retry(attempt: int) -> bool: pass
def can_edit(user: User, document: Document) -> bool: pass
def will_expire(date: datetime) -> bool: pass
```

### Constructor Naming
**Format**: Matches class name (language-dependent)

```typescript
class UserProfile {
  constructor(name: string, email: string) { }
}
```

```python
class UserProfile:
    def __init__(self, name: str, email: str):
        pass
```

```java
public class UserProfile {
    public UserProfile(String name, String email) {
    }
}
```

## Class/Type Naming Conventions

### Class Names
**Format**: PascalCase, noun-based

```typescript
class UserProfile { }
class PaymentProcessor { }
class DataValidator { }
class OrderManager { }
class EmailService { }
```

```python
class UserProfile:
    pass

class PaymentProcessor:
    pass

class DataValidator:
    pass
```

```java
public class UserProfile { }
public class PaymentProcessor { }
public class DataValidator { }
```

### Interface Names
**Format**: PascalCase, with or without 'I' prefix

**TypeScript (no prefix)**:
```typescript
interface UserRepository {
  getUser(id: string): Promise<User>;
  saveUser(user: User): Promise<void>;
}

interface Drawable {
  draw(): void;
}
```

**C# (with 'I' prefix)**:
```csharp
interface IUserRepository {
  Task<User> GetUser(string id);
  Task SaveUser(User user);
}

interface IDrawable {
  void Draw();
}
```

### Enum Names
**Format**: PascalCase, singular or plural

```typescript
enum UserRole {
  Admin,
  User,
  Guest
}

enum HttpMethod {
  GET,
  POST,
  PUT,
  DELETE
}

enum OrderStatus {
  Pending,
  Processing,
  Shipped,
  Delivered,
  Cancelled
}
```

```python
from enum import Enum

class UserRole(Enum):
    ADMIN = "admin"
    USER = "user"
    GUEST = "guest"

class HttpMethod(Enum):
    GET = "GET"
    POST = "POST"
    PUT = "PUT"
    DELETE = "DELETE"
```

### Type Alias Names
**Format**: PascalCase

```typescript
type UserId = string;
type Timestamp = number;
type Coordinates = [number, number];
type UserData = {
  id: string;
  name: string;
  email: string;
};
```

```python
from typing import TypeAlias

UserId: TypeAlias = str
Timestamp: TypeAlias = int
Coordinates: TypeAlias = tuple[float, float]
```

### Generic Type Parameters
**Format**: Single letter or descriptive PascalCase

```typescript
// Single letter
class List<T> { }
class Map<TKey, TValue> { }
class Result<TData, TError> { }

// Descriptive
class Repository<TEntity> { }
class Cache<TCacheKey, TCacheValue> { }
```

```java
// Single letter
public class List<T> { }
public class Map<K, V> { }

// Descriptive
public class Repository<TEntity> { }
```

```python
from typing import TypeVar, Generic

T = TypeVar('T')
TKey = TypeVar('TKey')
TValue = TypeVar('TValue')

class List(Generic[T]):
    pass

class Map(Generic[TKey, TValue]):
    pass
```

## Module/Package Naming Conventions

### Module Names
**Format**: Language-dependent

**JavaScript/TypeScript (kebab-case or camelCase)**:
```
user-service.ts
payment-processor.ts
dataValidator.ts
emailService.ts
```

**Python (snake_case)**:
```
user_service.py
payment_processor.py
data_validator.py
email_service.py
```

**Java (lowercase, no separators)**:
```
userservice
paymentprocessor
datavalidator
emailservice
```

### Package Names
**Java (reverse domain notation)**:
```
com.example.user
com.example.payment
com.example.data.validator
```

**Python (flat or hierarchical)**:
```
user/
  __init__.py
  service.py
  repository.py

payment/
  __init__.py
  processor.py
  gateway.py
```

**Node.js (npm package names)**:
```
@myorg/user-service
@myorg/payment-processor
@myorg/data-validator
```

### Import Alias Conventions
**Format**: Meaningful abbreviations

**Python**:
```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime as dt
```

**TypeScript**:
```typescript
import { UserService as US } from './user-service';
import * as UserUtils from './user-utils';
```

### Namespace Conventions
**TypeScript**:
```typescript
namespace UserManagement {
  export class UserService { }
  export class UserRepository { }
}
```

**C#**:
```csharp
namespace MyApp.UserManagement
{
    public class UserService { }
    public class UserRepository { }
}
```

## Do's and Don'ts

### ✅ DO
```typescript
// Clear, descriptive names
const userData = fetchUserData();
function calculateTotalPrice(items: Item[]): number { }
class PaymentProcessor { }

// Consistent casing
const firstName = "John";
const lastName = "Doe";
const isActive = true;

// Boolean prefixes
function isValid(input: string): boolean { }
function hasPermission(user: User): boolean { }

// Verb-based functions
function getUserById(id: string): User { }
function saveUserData(user: User): void { }
```

### ❌ DON'T
```typescript
// Cryptic abbreviations
const usr = fetchUsr();
function calcTotPrc(itms): number { }
class PmtProc { }

// Inconsistent casing
const FirstName = "John";
const last_name = "Doe";
const ISACTIVE = true;

// Missing boolean prefixes
function valid(input: string): boolean { }
function permission(user: User): boolean { }

// Noun-based functions
function user(id: string): User { }
function data(user: User): void { }
```

## Language-Specific Patterns

### JavaScript/TypeScript
```typescript
// Variables and functions: camelCase
const userName = "John";
function getUserData() { }

// Classes and types: PascalCase
class UserService { }
interface UserData { }
type UserId = string;

// Constants: SCREAMING_SNAKE_CASE
const MAX_RETRIES = 3;

// Private members: underscore prefix (convention)
class User {
  private _id: string;
}
```

### Python
```python
# Variables and functions: snake_case
user_name = "John"
def get_user_data(): pass

# Classes: PascalCase
class UserService:
    pass

# Constants: SCREAMING_SNAKE_CASE
MAX_RETRIES = 3

# Protected: single underscore
# Private: double underscore
class User:
    def __init__(self):
        self._protected = None
        self.__private = None
```

### Java
```java
// Variables and methods: camelCase
String userName = "John";
public void getUserData() { }

// Classes and interfaces: PascalCase
public class UserService { }
public interface UserRepository { }

// Constants: SCREAMING_SNAKE_CASE
public static final int MAX_RETRIES = 3;

// Packages: lowercase
package com.example.user;
```

### Go
```go
// Exported (public): PascalCase
type UserService struct { }
func GetUserData() { }

// Unexported (private): camelCase
type userRepository struct { }
func getUserFromDB() { }

// Constants: MixedCase or camelCase
const MaxRetries = 3
const defaultTimeout = 5000
```

### Rust
```rust
// Variables and functions: snake_case
let user_name = "John";
fn get_user_data() { }

// Types and traits: PascalCase
struct UserService;
trait UserRepository { }

// Constants: SCREAMING_SNAKE_CASE
const MAX_RETRIES: i32 = 3;

// Modules: snake_case
mod user_service;
```
