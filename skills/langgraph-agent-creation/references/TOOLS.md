# LangGraph Tool Integration Guide

Comprehensive guide for integrating tools with LangGraph agents.

## Tool Basics

### What are Tools?

Tools are functions that agents can call to interact with external systems:

- **Search**: Web search, database queries
- **Computation**: Calculations, data processing
- **APIs**: External service integration
- **File Operations**: Read/write files, parse documents
- **Custom Logic**: Any Python function

### Tool Structure

```python
from langchain.tools import Tool

def my_function(input: str) -> str:
    """Function that will become a tool."""
    return f"Processed: {input}"

tool = Tool(
    name="my_tool",
    func=my_function,
    description="Clear description of what this tool does. Used by LLM to decide when to call it."
)
```

## Creating Tools

### Method 1: Simple Function Tool

```python
from langchain.tools import Tool

def calculator(expression: str) -> str:
    """Safely evaluate mathematical expressions."""
    try:
        # Use ast.literal_eval or a safe math parser
        import ast
        import operator
        
        ops = {
            ast.Add: operator.add,
            ast.Sub: operator.sub,
            ast.Mult: operator.mul,
            ast.Div: operator.truediv,
        }
        
        # Simple safe evaluation (limited operators)
        result = eval(expression, {"__builtins__": {}}, {})
        return str(result)
    except Exception as e:
        return f"Error: {e}"

calculator_tool = Tool(
    name="calculator",
    func=calculator,
    description="Evaluate mathematical expressions. Input: '2+2' or '10*5'. Output: the result."
)
```

### Method 2: Structured Tool with Pydantic

```python
from langchain.tools import StructuredTool
from pydantic import BaseModel, Field

class SearchInput(BaseModel):
    """Input for search tool."""
    query: str = Field(..., description="Search query")
    max_results: int = Field(default=10, description="Maximum results")

def search(query: str, max_results: int = 10) -> str:
    """Search the web and return results."""
    # Implementation
    results = perform_search(query, max_results)
    return format_results(results)

search_tool = StructuredTool.from_function(
    func=search,
    name="search",
    description="Search the web for information. Use when you need current information or facts.",
    args_schema=SearchInput
)
```

### Method 3: Class-Based Tool

```python
from langchain.tools import BaseTool
from pydantic import Field

class DatabaseQueryTool(BaseTool):
    """Tool for querying database."""
    
    name: str = "database_query"
    description: str = "Query the database for information. Input: SQL query string."
    
    db_connection: Any = Field(exclude=True)  # Runtime dependency
    
    def _run(self, query: str) -> str:
        """Execute synchronously."""
        try:
            results = self.db_connection.execute(query)
            return format_db_results(results)
        except Exception as e:
            return f"Database error: {e}"
    
    async def _arun(self, query: str) -> str:
        """Execute asynchronously."""
        try:
            results = await self.db_connection.execute_async(query)
            return format_db_results(results)
        except Exception as e:
            return f"Database error: {e}"

# Usage
db_tool = DatabaseQueryTool(db_connection=my_db)
```

## Common Tool Patterns

### Pattern 1: Search Tools

```python
from langchain_community.tools import DuckDuckGoSearchRun

# Web search
search = DuckDuckGoSearchRun()

# Or custom search
def custom_search(query: str) -> str:
    """Search custom data source."""
    results = my_search_engine.search(query)
    return "\n".join([r["title"] + ": " + r["snippet"] for r in results[:5]])

search_tool = Tool(
    name="search",
    func=custom_search,
    description="Search for information. Returns top 5 results."
)
```

### Pattern 2: API Integration

```python
import requests
from typing import Dict

def api_tool(endpoint: str, method: str = "GET", data: Dict = None) -> str:
    """Call external API."""
    base_url = "https://api.example.com"
    
    try:
        if method == "GET":
            response = requests.get(
                f"{base_url}/{endpoint}",
                timeout=10
            )
        elif method == "POST":
            response = requests.post(
                f"{base_url}/{endpoint}",
                json=data,
                timeout=10
            )
        
        response.raise_for_status()
        return response.json()
    
    except requests.RequestException as e:
        return {"error": str(e)}

api_caller = Tool(
    name="api_call",
    func=api_tool,
    description="Call external API. Specify endpoint and method."
)
```

### Pattern 3: File Operations

```python
from pathlib import Path

def read_file_tool(file_path: str) -> str:
    """Read file contents."""
    try:
        path = Path(file_path)
        if not path.exists():
            return f"Error: File not found: {file_path}"
        
        if path.stat().st_size > 1_000_000:  # 1MB limit
            return "Error: File too large"
        
        return path.read_text()
    except Exception as e:
        return f"Error reading file: {e}"

def write_file_tool(file_path: str, content: str) -> str:
    """Write content to file."""
    try:
        path = Path(file_path)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content)
        return f"Successfully wrote to {file_path}"
    except Exception as e:
        return f"Error writing file: {e}"

read_tool = Tool(name="read_file", func=read_file_tool, description="Read file contents")
write_tool = Tool(name="write_file", func=write_file_tool, description="Write to file")
```

### Pattern 4: Data Processing

```python
import pandas as pd

def analyze_csv_tool(file_path: str) -> str:
    """Analyze CSV file and return statistics."""
    try:
        df = pd.read_csv(file_path)
        
        stats = {
            "rows": len(df),
            "columns": len(df.columns),
            "column_names": df.columns.tolist(),
            "summary": df.describe().to_dict()
        }
        
        return str(stats)
    except Exception as e:
        return f"Error analyzing CSV: {e}"

csv_tool = Tool(
    name="analyze_csv",
    func=analyze_csv_tool,
    description="Analyze CSV file and return statistics"
)
```

## Integrating Tools with LangGraph

### Basic Integration

```python
from typing import TypedDict, Annotated, Sequence
from langchain_core.messages import BaseMessage
from langchain_openai import ChatOpenAI
from langgraph.graph import StateGraph, END
import operator

class AgentState(TypedDict):
    messages: Annotated[Sequence[BaseMessage], operator.add]
    tool_results: list[dict]

# Define tools
tools = [search_tool, calculator_tool, api_tool]

def tool_calling_node(state: AgentState) -> AgentState:
    """Node that uses tools."""
    llm = ChatOpenAI(model="gpt-4")
    llm_with_tools = llm.bind_tools(tools)
    
    response = llm_with_tools.invoke(state["messages"])
    
    # Check if LLM wants to call tools
    if response.tool_calls:
        results = []
        
        for tool_call in response.tool_calls:
            tool_name = tool_call["name"]
            tool_args = tool_call["args"]
            
            # Find and execute tool
            tool = next((t for t in tools if t.name == tool_name), None)
            
            if tool:
                try:
                    result = tool.invoke(tool_args)
                    results.append({
                        "tool": tool_name,
                        "args": tool_args,
                        "result": result
                    })
                except Exception as e:
                    results.append({
                        "tool": tool_name,
                        "error": str(e)
                    })
        
        return {**state, "tool_results": results}
    
    return state
```

### Advanced: Conditional Tool Selection

```python
def smart_tool_selector_node(state: AgentState) -> AgentState:
    """Intelligently select tools based on task."""
    llm = ChatOpenAI(model="gpt-4", temperature=0)
    
    # First, decide which tools are needed
    analysis_prompt = f"""Analyze this request and determine which tools are needed:
    
User request: {state['messages'][-1].content}

Available tools:
- search: Web search for current information
- calculator: Mathematical calculations
- database: Query structured data
- file_reader: Read file contents

Which tools are needed? List them.
"""
    
    response = llm.invoke([HumanMessage(content=analysis_prompt)])
    selected_tools_text = response.content.lower()
    
    # Select tools based on analysis
    selected_tools = []
    for tool in tools:
        if tool.name.lower() in selected_tools_text:
            selected_tools.append(tool)
    
    # Now use only selected tools
    if selected_tools:
        llm_with_tools = llm.bind_tools(selected_tools)
        response = llm_with_tools.invoke(state["messages"])
        
        # Execute tool calls
        # ... (same as before)
    
    return state
```

### Parallel Tool Execution

```python
import asyncio

async def parallel_tools_node(state: AgentState) -> AgentState:
    """Execute multiple tools in parallel."""
    llm = ChatOpenAI(model="gpt-4")
    llm_with_tools = llm.bind_tools(tools)
    
    response = llm_with_tools.invoke(state["messages"])
    
    if response.tool_calls:
        # Execute all tools in parallel
        async def execute_tool(tool_call):
            tool_name = tool_call["name"]
            tool_args = tool_call["args"]
            
            tool = next((t for t in tools if t.name == tool_name), None)
            
            if tool:
                try:
                    # Use async execution if available
                    if hasattr(tool, 'ainvoke'):
                        result = await tool.ainvoke(tool_args)
                    else:
                        # Fallback to sync in executor
                        loop = asyncio.get_event_loop()
                        result = await loop.run_in_executor(
                            None,
                            tool.invoke,
                            tool_args
                        )
                    
                    return {
                        "tool": tool_name,
                        "args": tool_args,
                        "result": result
                    }
                except Exception as e:
                    return {
                        "tool": tool_name,
                        "error": str(e)
                    }
        
        # Execute all tools in parallel
        results = await asyncio.gather(
            *[execute_tool(tc) for tc in response.tool_calls],
            return_exceptions=True
        )
        
        return {**state, "tool_results": results}
    
    return state
```

## Tool Error Handling

### Timeout Protection

```python
import asyncio
from functools import wraps

def with_timeout(seconds: int):
    """Decorator to add timeout to tool execution."""
    def decorator(func):
        @wraps(func)
        async def wrapper(*args, **kwargs):
            try:
                return await asyncio.wait_for(
                    func(*args, **kwargs),
                    timeout=seconds
                )
            except asyncio.TimeoutError:
                return f"Error: Tool execution timed out after {seconds}s"
        return wrapper
    return decorator

@with_timeout(30)
async def slow_api_tool(query: str) -> str:
    """API call that might be slow."""
    response = await slow_api.query(query)
    return response
```

### Retry Logic

```python
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10)
)
def unreliable_tool(input: str) -> str:
    """Tool that might fail transiently."""
    response = external_service.call(input)
    return response
```

### Validation

```python
from pydantic import BaseModel, Field, validator

class ValidatedToolInput(BaseModel):
    """Input with validation."""
    query: str = Field(..., min_length=1, max_length=1000)
    limit: int = Field(default=10, ge=1, le=100)
    
    @validator('query')
    def validate_query(cls, v):
        # Remove harmful characters
        if any(char in v for char in ['<', '>', ';', '&', '|']):
            raise ValueError("Invalid characters in query")
        return v

def validated_tool(input: ValidatedToolInput) -> str:
    """Tool with validated input."""
    # Input is guaranteed to be valid
    return process(input.query, input.limit)
```

## Tool Performance Optimization

### Caching Tool Results

```python
from functools import lru_cache
import hashlib

@lru_cache(maxsize=1000)
def cached_tool(query_hash: str) -> str:
    """Tool with cached results."""
    # This won't be called if result is cached
    return expensive_operation(query_hash)

def tool_with_cache(query: str) -> str:
    """Wrapper that enables caching."""
    query_hash = hashlib.md5(query.encode()).hexdigest()
    return cached_tool(query_hash)
```

### Rate Limiting

```python
from datetime import datetime, timedelta
from collections import defaultdict

class RateLimitedTool:
    """Tool with built-in rate limiting."""
    
    def __init__(self, tool, max_calls: int, window: timedelta):
        self.tool = tool
        self.max_calls = max_calls
        self.window = window
        self.calls = defaultdict(list)
    
    def __call__(self, input: str, user_id: str = "default") -> str:
        now = datetime.now()
        cutoff = now - self.window
        
        # Clean old calls
        self.calls[user_id] = [
            t for t in self.calls[user_id]
            if t > cutoff
        ]
        
        # Check rate limit
        if len(self.calls[user_id]) >= self.max_calls:
            return f"Error: Rate limit exceeded. Max {self.max_calls} calls per {self.window}"
        
        # Execute tool
        result = self.tool.invoke(input)
        self.calls[user_id].append(now)
        
        return result

# Usage
limited_search = RateLimitedTool(
    search_tool,
    max_calls=10,
    window=timedelta(minutes=1)
)
```

## Testing Tools

### Unit Testing

```python
import pytest

def test_calculator_tool():
    """Test calculator tool."""
    result = calculator_tool.invoke("2+2")
    assert result == "4"
    
    result = calculator_tool.invoke("10*5")
    assert result == "50"

def test_calculator_error_handling():
    """Test calculator handles errors."""
    result = calculator_tool.invoke("invalid")
    assert "Error" in result

@pytest.mark.asyncio
async def test_async_tool():
    """Test async tool execution."""
    result = await async_search_tool.ainvoke("test query")
    assert result is not None
```

### Integration Testing

```python
def test_tool_in_agent():
    """Test tool integration with agent."""
    agent = build_agent_with_tools([calculator_tool])
    
    result = agent.invoke({
        "messages": [HumanMessage(content="What is 25 * 4?")]
    })
    
    assert "tool_results" in result
    assert "100" in str(result["tool_results"])
```

## Security Best Practices

### Input Sanitization

```python
import re

def sanitize_tool_input(input: str) -> str:
    """Sanitize tool input for security."""
    # Remove control characters
    cleaned = re.sub(r'[\x00-\x1f\x7f-\x9f]', '', input)
    
    # Remove potentially dangerous patterns
    dangerous_patterns = [
        r'<script.*?>.*?</script>',
        r'javascript:',
        r'on\w+\s*=',
    ]
    
    for pattern in dangerous_patterns:
        cleaned = re.sub(pattern, '', cleaned, flags=re.IGNORECASE)
    
    return cleaned.strip()
```

### Permission Checks

```python
def file_operation_tool(file_path: str, operation: str) -> str:
    """File tool with permission checks."""
    path = Path(file_path).resolve()
    
    # Restrict to allowed directories
    allowed_dirs = [Path("/allowed/path1"), Path("/allowed/path2")]
    
    if not any(path.is_relative_to(allowed) for allowed in allowed_dirs):
        return "Error: Access denied to this directory"
    
    # Check file size limits
    if operation == "read" and path.stat().st_size > 10_000_000:
        return "Error: File too large (max 10MB)"
    
    # Proceed with operation
    if operation == "read":
        return path.read_text()
    # ...
```

### Audit Logging

```python
import logging
from datetime import datetime

logger = logging.getLogger(__name__)

def audit_tool_call(tool_name: str, args: dict, user_id: str, result: any):
    """Log tool usage for audit."""
    logger.info(f"""
Tool Call Audit:
- Timestamp: {datetime.now().isoformat()}
- User: {user_id}
- Tool: {tool_name}
- Args: {args}
- Result Size: {len(str(result))} chars
- Status: Success
    """)

def audited_tool(tool, user_id: str):
    """Wrapper that adds audit logging."""
    def wrapper(input: str) -> str:
        result = tool.invoke(input)
        audit_tool_call(tool.name, {"input": input}, user_id, result)
        return result
    return wrapper
```

## Example: Complete Tool-Using Agent

```python
from typing import TypedDict, Annotated, Sequence
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain_openai import ChatOpenAI
from langgraph.graph import StateGraph, END
import operator

class ToolAgentState(TypedDict):
    messages: Annotated[Sequence[BaseMessage], operator.add]
    tool_results: list[dict]
    next_action: str

# Define tools
search_tool = Tool(name="search", func=search_func, description="Search web")
calc_tool = Tool(name="calculator", func=calc_func, description="Calculate")

tools = [search_tool, calc_tool]

def should_use_tools_node(state: ToolAgentState) -> ToolAgentState:
    """Decide if tools are needed."""
    llm = ChatOpenAI(model="gpt-4", temperature=0)
    
    prompt = f"""Does this request require external tools?
    
Request: {state['messages'][-1].content}

Available tools: search (web search), calculator (math)

Answer: yes or no
"""
    
    response = llm.invoke([HumanMessage(content=prompt)])
    
    if "yes" in response.content.lower():
        next_action = "use_tools"
    else:
        next_action = "respond"
    
    return {**state, "next_action": next_action}

def tool_execution_node(state: ToolAgentState) -> ToolAgentState:
    """Execute tools."""
    llm = ChatOpenAI(model="gpt-4")
    llm_with_tools = llm.bind_tools(tools)
    
    response = llm_with_tools.invoke(state["messages"])
    
    results = []
    if response.tool_calls:
        for tool_call in response.tool_calls:
            tool = next((t for t in tools if t.name == tool_call["name"]), None)
            if tool:
                result = tool.invoke(tool_call["args"])
                results.append({"tool": tool.name, "result": result})
    
    return {**state, "tool_results": results}

def response_node(state: ToolAgentState) -> ToolAgentState:
    """Generate final response."""
    llm = ChatOpenAI(model="gpt-4")
    
    context = f"""User: {state['messages'][-1].content}
Tool results: {state.get('tool_results', [])}

Provide helpful response."""
    
    response = llm.invoke([HumanMessage(content=context)])
    
    return {**state, "messages": [response]}

def route(state: ToolAgentState) -> str:
    return state.get("next_action", "respond")

# Build graph
workflow = StateGraph(ToolAgentState)
workflow.add_node("decide", should_use_tools_node)
workflow.add_node("use_tools", tool_execution_node)
workflow.add_node("respond", response_node)

workflow.set_entry_point("decide")
workflow.add_conditional_edges("decide", route, {
    "use_tools": "use_tools",
    "respond": "respond"
})
workflow.add_edge("use_tools", "respond")
workflow.add_edge("respond", END)

agent = workflow.compile()
```

---

**Key Takeaways:**

1. **Clear Descriptions**: Tools need clear descriptions for LLM to choose correctly
2. **Validation**: Always validate tool inputs
3. **Error Handling**: Tools should never crash the agent
4. **Performance**: Cache results, use async, add timeouts
5. **Security**: Sanitize inputs, check permissions, audit usage
