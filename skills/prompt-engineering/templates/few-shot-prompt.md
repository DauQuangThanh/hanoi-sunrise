# Code Review Prompt Template

Use this template for consistent code review feedback by providing examples of good and bad code patterns.

## Template Structure

```
Review the following code for [specific aspects: security, performance, maintainability, etc.]. Provide feedback in this format:

Examples:

Example 1 - Good Practice:
Code:
[sample good code]
Review: [positive feedback highlighting best practices]

Example 2 - Improvement Needed:
Code:
[sample code with issues]
Review: [constructive feedback with specific recommendations]

Example 3 - Security Concern:
Code:
[sample code with security issues]
Review: [security-focused feedback with severity level]

Now review this code:
[code to review]
```

## Example Usage

```
Review the following code for security vulnerabilities, performance issues, and maintainability concerns. Provide specific recommendations for improvements.

Examples:

Example 1 - Good Practice:
Code:
```python
import bcrypt
import jwt
from functools import wraps

def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()

def verify_token(token: str) -> dict:
    try:
        return jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
    except jwt.ExpiredSignatureError:
        raise ValueError("Token expired")
    except jwt.InvalidTokenError:
        raise ValueError("Invalid token")
```

Review: ✅ Excellent security practices. Uses bcrypt for password hashing with proper salt generation. JWT verification includes proper exception handling for expired and invalid tokens. Good separation of concerns.

Example 2 - Improvement Needed:
Code:

```javascript
app.get('/users/:id', (req, res) => {
  const userId = req.params.id;
  db.query('SELECT * FROM users WHERE id = ' + userId, (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});
```

Review: ⚠️ SQL injection vulnerability - using string concatenation for SQL queries. No input validation. Error handling throws exceptions instead of proper error responses. Add parameterized queries, input validation, and proper error handling.

Example 3 - Security Concern:
Code:

```python
def authenticate_user(username, password):
    user = User.query.filter_by(username=username).first()
    if user and user.password == password:
        return True
    return False
```

Review: 🚨 CRITICAL: Plain text password comparison. Never store or compare passwords in plain text. Use proper password hashing like bcrypt or argon2. This is a severe security vulnerability.

Now review this code:

```python
@app.route('/api/user/profile', methods=['GET'])
def get_user_profile():
    auth_header = request.headers.get('Authorization')
    if not auth_header:
        return jsonify({'error': 'No token provided'}), 401

    token = auth_header.split(' ')[1]
    try:
        payload = jwt.decode(token, app.config['SECRET_KEY'], algorithms=['HS256'])
        user_id = payload['user_id']

        user = User.query.get(user_id)
        return jsonify({
            'id': user.id,
            'username': user.username,
            'email': user.email
        })
    except Exception as e:
        return jsonify({'error': 'Invalid token'}), 401
```

```

## Tips for Success

- Provide 3-5 examples showing different scenarios
- Include both positive and negative examples
- Be specific about what aspects to review
- Use consistent feedback format across examples
- Include severity levels for issues (critical, warning, info)
- Focus on actionable recommendations

## Best Practices for Few-Shot Prompts

### Example Selection
- Choose 2-5 high-quality examples
- Ensure examples demonstrate the desired pattern clearly
- Use diverse but relevant examples
- Include edge cases when appropriate

### Example Quality
- Make inputs realistic and varied
- Ensure outputs are correct and well-formatted
- Use consistent style across examples
- Include comments or explanations if helpful

### Task Clarity
- Provide clear instructions before examples
- Specify what makes a good output
- Include any constraints or rules
- Define the scope of the task

## Common Use Cases

- Code generation with specific patterns
- Data transformation tasks
- Content formatting and styling
- Classification or categorization
- Translation with consistent terminology

## Tips for Success

- Start with simple examples and build complexity
- Test with examples not in your prompt to verify generalization
- Use examples that cover different scenarios
- Keep examples concise but complete
- Ensure examples follow the exact format you want

## Troubleshooting

### Inconsistent Results
- Add more examples
- Make examples more specific
- Clarify the task instructions
- Use lower temperature settings

### Not Following Pattern
- Review example quality
- Add more diverse examples
- Simplify the task if too complex
- Provide clearer formatting guidelines
