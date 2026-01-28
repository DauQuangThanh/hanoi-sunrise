# LangGraph Best Practices

Comprehensive guide to building production-ready LangGraph agents.

## State Management

### Keep State Minimal

**DO:**
```python
class AgentState(TypedDict):
    user_input: str
    messages: Annotated[Sequence[BaseMessage], operator.add]
    result: str
```

**DON'T:**
```python
class AgentState(TypedDict):
    user_input: str
    messages: Annotated[Sequence[BaseMessage], operator.add]
    intermediate_step_1: str
    intermediate_step_2: str
    intermediate_step_3: str
    debug_info: dict
    timestamp: str
    # ... too many fields
```

**Why:** Smaller state = less memory, faster serialization, easier debugging.

### Use Type Hints Consistently

**DO:**
```python
from typing import TypedDict, Sequence, Annotated
from langchain_core.messages import BaseMessage

class AgentState(TypedDict):
    messages: Annotated[Sequence[BaseMessage], operator.add]
    count: int
    results: list[dict]
```

**DON'T:**
```python
class AgentState(TypedDict):
    messages: list  # Too generic
    count: ...      # No type
    results: dict   # Should be list[dict]
```

**Why:** Type hints enable better IDE support, catch errors early, improve documentation.

### Immutable State Updates

**DO:**
```python
def my_node(state: AgentState) -> AgentState:
    return {
        **state,  # Preserve existing fields
        "new_field": "value"  # Add/update fields
    }
```

**DON'T:**
```python
def my_node(state: AgentState) -> AgentState:
    state["new_field"] = "value"  # Modifies in place!
    return state
```

**Why:** Immutability prevents bugs, enables time-travel debugging, supports checkpointing.

## Node Design

### Single Responsibility Principle

**DO:**
```python
def plan_node(state: State) -> State:
    """Only handles planning logic."""
    plan = create_plan(state["input"])
    return {**state, "plan": plan}

def execute_node(state: State) -> State:
    """Only handles execution."""
    result = execute(state["plan"])
    return {**state, "result": result}
```

**DON'T:**
```python
def do_everything_node(state: State) -> State:
    """Planning, execution, validation, output - all in one."""
    plan = create_plan(state["input"])
    result = execute(plan)
    validated = validate(result)
    output = format_output(validated)
    return {**state, "output": output}
```

**Why:** Smaller nodes are easier to test, debug, reuse, and maintain.

### Error Handling in Nodes

**DO:**
```python
def api_call_node(state: State) -> State:
    """Call external API with proper error handling."""
    try:
        result = call_api(state["input"])
        return {**state, "result": result, "error": None}
    except APIError as e:
        logger.error(f"API error: {e}")
        return {**state, "error": f"API failed: {e}"}
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        return {**state, "error": f"Unexpected error: {e}"}
```

**DON'T:**
```python
def api_call_node(state: State) -> State:
    """No error handling - will crash agent."""
    result = call_api(state["input"])  # What if this fails?
    return {**state, "result": result}
```

**Why:** Graceful error handling keeps agent running, provides clear feedback.

### Logging for Observability

**DO:**
```python
import logging

logger = logging.getLogger(__name__)

def processing_node(state: State) -> State:
    logger.info(f"Processing input: {state['input'][:50]}...")
    
    try:
        result = process(state["input"])
        logger.info(f"Processing complete: {len(result)} results")
        return {**state, "result": result}
    except Exception as e:
        logger.error(f"Processing failed: {e}", exc_info=True)
        return {**state, "error": str(e)}
```

**DON'T:**
```python
def processing_node(state: State) -> State:
    # No logging - debugging is impossible
    result = process(state["input"])
    return {**state, "result": result}
```

**Why:** Logs are essential for debugging, monitoring, and understanding agent behavior.

## Graph Structure

### Clear Entry and Exit Points

**DO:**
```python
workflow = StateGraph(State)
workflow.add_node("start", start_node)
workflow.add_node("process", process_node)
workflow.add_node("end", end_node)

workflow.set_entry_point("start")
workflow.add_edge("start", "process")
workflow.add_edge("process", "end")
workflow.add_edge("end", END)
```

**DON'T:**
```python
workflow = StateGraph(State)
# No clear entry point
workflow.add_node("maybe_start", node1)
# Multiple unmarked exit points
workflow.add_edge("random_node", END)
```

**Why:** Clear structure makes graphs easier to understand and debug.

### Use Conditional Edges for Branching

**DO:**
```python
def route_decision(state: State) -> str:
    """Clear routing logic."""
    if state["type"] == "urgent":
        return "priority_path"
    elif state["type"] == "normal":
        return "standard_path"
    else:
        return "low_priority_path"

workflow.add_conditional_edges(
    "decision",
    route_decision,
    {
        "priority_path": "priority_handler",
        "standard_path": "standard_handler",
        "low_priority_path": "low_priority_handler"
    }
)
```

**DON'T:**
```python
# Implicit branching in node
def confusing_node(state: State) -> State:
    if state["type"] == "urgent":
        # Handle urgent case
        pass
    elif state["type"] == "normal":
        # Handle normal case
        pass
    # No clear flow
```

**Why:** Conditional edges make branching explicit and visible in graph visualization.

### Avoid Deep Nesting

**DO:**
```python
# Flat structure
workflow.add_node("step1", step1)
workflow.add_node("step2", step2)
workflow.add_node("step3", step3)

workflow.set_entry_point("step1")
workflow.add_edge("step1", "step2")
workflow.add_edge("step2", "step3")
```

**DON'T:**
```python
# Deep nesting - hard to follow
workflow.add_conditional_edges(
    "node1",
    lambda s: "branch1" if s["x"] else "branch2",
    {
        "branch1": "node2",
        "branch2": "node3"
    }
)
workflow.add_conditional_edges(
    "node2",
    lambda s: "subbranch1" if s["y"] else "subbranch2",
    # More nesting...
)
```

**Why:** Flat structures are easier to visualize, test, and maintain.

## Memory and Persistence

### Use Appropriate Checkpointer

**Development:**
```python
from langgraph.checkpoint.sqlite import SqliteSaver

# In-memory for development
memory = SqliteSaver.from_conn_string(":memory:")
agent = workflow.compile(checkpointer=memory)
```

**Production:**
```python
from langgraph.checkpoint.postgres import PostgresSaver

# Persistent database for production
memory = PostgresSaver.from_conn_string(
    "postgresql://user:pass@host:5432/db"
)
agent = workflow.compile(checkpointer=memory)
```

**Why:** In-memory is fast for testing, persistent storage needed for production.

### Implement Cleanup

**DO:**
```python
from datetime import datetime, timedelta

def cleanup_old_threads(checkpointer, days=30):
    """Remove conversation threads older than N days."""
    cutoff = datetime.now() - timedelta(days=days)
    
    # Implementation depends on checkpointer type
    if isinstance(checkpointer, SqliteSaver):
        checkpointer.conn.execute(
            "DELETE FROM checkpoints WHERE created_at < ?",
            (cutoff,)
        )
        checkpointer.conn.commit()

# Run periodically
cleanup_old_threads(memory, days=30)
```

**Why:** Prevents database bloat, maintains performance, respects privacy.

### Thread ID Strategy

**DO:**
```python
# Use meaningful thread IDs
thread_id = f"user-{user_id}-session-{session_id}"
config = {"configurable": {"thread_id": thread_id}}

# Or for multi-tenant
thread_id = f"tenant-{tenant_id}-user-{user_id}"
config = {"configurable": {"thread_id": thread_id}}
```

**DON'T:**
```python
# Random thread IDs are hard to manage
thread_id = str(uuid.uuid4())  # Who does this belong to?
```

**Why:** Meaningful IDs enable debugging, user management, and data isolation.

## LLM Integration

### Token Usage Monitoring

**DO:**
```python
from langchain.callbacks import get_openai_callback

def llm_node(state: State) -> State:
    llm = ChatOpenAI(model="gpt-4")
    
    with get_openai_callback() as cb:
        response = llm.invoke(state["messages"])
        
        logger.info(f"Tokens: {cb.total_tokens}, Cost: ${cb.total_cost:.4f}")
    
    return {**state, "messages": state["messages"] + [response]}
```

**Why:** Monitor costs, optimize prompts, prevent budget overruns.

### Model Selection Strategy

**DO:**
```python
def smart_model_selection(task_complexity: str) -> str:
    """Choose model based on task complexity."""
    if task_complexity == "simple":
        return "gpt-3.5-turbo"  # Cheaper, faster
    elif task_complexity == "complex":
        return "gpt-4"           # More capable
    else:
        return "gpt-4-turbo"     # Balanced
```

**Why:** Optimize cost/performance tradeoff for different tasks.

### Prompt Engineering

**DO:**
```python
def create_structured_prompt(user_input: str, context: dict) -> str:
    """Well-structured prompt with clear instructions."""
    return f"""You are an expert assistant. Analyze this request carefully.

User Request: {user_input}

Context:
{json.dumps(context, indent=2)}

Instructions:
1. Understand the user's intent
2. Consider the provided context
3. Provide a clear, actionable response
4. If uncertain, ask clarifying questions

Response:"""
```

**DON'T:**
```python
def create_bad_prompt(user_input: str) -> str:
    return f"Do this: {user_input}"  # Too vague
```

**Why:** Clear prompts = better results, fewer retries, lower costs.

### Rate Limiting and Retries

**DO:**
```python
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10)
)
def call_llm_with_retry(messages):
    """Call LLM with automatic retry."""
    llm = ChatOpenAI(model="gpt-4", request_timeout=30)
    return llm.invoke(messages)
```

**Why:** Handle transient failures, respect rate limits, improve reliability.

## Tool Integration

### Tool Validation

**DO:**
```python
from pydantic import BaseModel, Field, validator

class SearchInput(BaseModel):
    """Validated search tool input."""
    query: str = Field(..., min_length=1, max_length=500)
    max_results: int = Field(default=10, ge=1, le=100)
    
    @validator('query')
    def validate_query(cls, v):
        if not v.strip():
            raise ValueError("Query cannot be empty")
        return v.strip()

def search_tool(input: SearchInput) -> dict:
    """Search with validated input."""
    # Implementation
```

**DON'T:**
```python
def search_tool(query: str, max_results: int) -> dict:
    """No validation - vulnerable to bad inputs."""
    # What if query is empty? max_results is negative?
```

**Why:** Validation prevents errors, improves security, provides clear feedback.

### Tool Timeout

**DO:**
```python
import asyncio

async def tool_with_timeout(tool, input_data, timeout=30):
    """Execute tool with timeout protection."""
    try:
        return await asyncio.wait_for(
            tool.ainvoke(input_data),
            timeout=timeout
        )
    except asyncio.TimeoutError:
        logger.warning(f"Tool {tool.name} timed out after {timeout}s")
        return {"error": f"Tool execution timed out after {timeout}s"}
```

**Why:** Prevents hanging, provides fallback, maintains responsiveness.

### Tool Error Handling

**DO:**
```python
def execute_tool_safely(tool, input_data):
    """Execute tool with comprehensive error handling."""
    try:
        result = tool.invoke(input_data)
        return {"success": True, "result": result}
    except ToolAuthError as e:
        logger.error(f"Auth error: {e}")
        return {"success": False, "error": "Authentication failed"}
    except ToolRateLimitError as e:
        logger.warning(f"Rate limit: {e}")
        return {"success": False, "error": "Rate limit exceeded, try later"}
    except Exception as e:
        logger.error(f"Unexpected error: {e}", exc_info=True)
        return {"success": False, "error": "Tool execution failed"}
```

**Why:** Graceful degradation, clear error messages, maintained agent flow.

## Testing

### Unit Test Nodes

**DO:**
```python
import pytest

def test_planning_node():
    """Test planning node in isolation."""
    state = {
        "user_input": "Test request",
        "messages": []
    }
    
    result = planning_node(state)
    
    assert "plan" in result
    assert result["plan"]
    assert len(result["messages"]) > 0
```

**Why:** Catch bugs early, verify node behavior, enable refactoring.

### Integration Test Workflows

**DO:**
```python
def test_complete_workflow():
    """Test end-to-end agent execution."""
    agent = build_agent()
    
    result = agent.invoke({
        "user_input": "Test query",
        "messages": []
    })
    
    assert "messages" in result
    assert len(result["messages"]) > 0
    assert result["messages"][-1].content
```

**Why:** Verify complete functionality, catch integration issues.

### Test Edge Cases

**DO:**
```python
@pytest.mark.parametrize("iterations,expected", [
    (0, "continue"),
    (5, "continue"),
    (10, "stop"),      # At limit
    (15, "stop"),      # Over limit
])
def test_iteration_limits(iterations, expected):
    """Test iteration limit enforcement."""
    state = {"iterations": iterations, "max_iterations": 10}
    result = should_continue(state)
    assert result == expected
```

**Why:** Ensure robustness, prevent edge case failures in production.

## Performance Optimization

### Async for I/O Operations

**DO:**
```python
import asyncio

async def parallel_tools_node(state: State) -> State:
    """Execute multiple tools in parallel."""
    tools = [search_tool, api_tool, db_tool]
    
    results = await asyncio.gather(
        *[tool.ainvoke(state["input"]) for tool in tools],
        return_exceptions=True
    )
    
    return {**state, "tool_results": results}
```

**Why:** Significant speedup for I/O-bound operations.

### Caching Expensive Operations

**DO:**
```python
from functools import lru_cache

@lru_cache(maxsize=1000)
def expensive_computation(input_hash: str) -> dict:
    """Cache results of expensive computation."""
    # Expensive operation here
    return result

def smart_node(state: State) -> State:
    input_hash = hash(state["input"])
    result = expensive_computation(input_hash)
    return {**state, "result": result}
```

**Why:** Avoid redundant work, faster response times, lower costs.

### State Pruning

**DO:**
```python
def prune_state_node(state: State) -> State:
    """Remove unnecessary data to keep state small."""
    return {
        "messages": state["messages"][-10:],  # Last 10 only
        "user_input": state["user_input"],
        "current_result": state["current_result"],
        # Drop intermediate results, debug info, etc.
    }
```

**Why:** Smaller state = faster serialization, lower memory, better performance.

## Security

### Input Sanitization

**DO:**
```python
import re

def sanitize_input(user_input: str) -> str:
    """Sanitize user input before processing."""
    # Remove control characters
    cleaned = re.sub(r'[\x00-\x1f\x7f-\x9f]', '', user_input)
    
    # Limit length
    cleaned = cleaned[:10000]
    
    # Strip whitespace
    cleaned = cleaned.strip()
    
    return cleaned

def input_node(state: State) -> State:
    clean_input = sanitize_input(state["user_input"])
    return {**state, "user_input": clean_input}
```

**Why:** Prevent injection attacks, limit resource usage, ensure data quality.

### API Key Management

**DO:**
```python
import os
from dotenv import load_dotenv

load_dotenv()

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
if not OPENAI_API_KEY:
    raise ValueError("OPENAI_API_KEY not set")

llm = ChatOpenAI(api_key=OPENAI_API_KEY)
```

**DON'T:**
```python
llm = ChatOpenAI(api_key="sk-......")  # Hardcoded key!
```

**Why:** Protect credentials, enable key rotation, prevent leaks.

### Rate Limiting

**DO:**
```python
from datetime import datetime, timedelta

class RateLimiter:
    def __init__(self, max_requests: int, window: timedelta):
        self.max_requests = max_requests
        self.window = window
        self.requests = []
    
    def allow_request(self, user_id: str) -> bool:
        now = datetime.now()
        cutoff = now - self.window
        
        # Clean old requests
        self.requests = [
            (uid, ts) for uid, ts in self.requests
            if ts > cutoff
        ]
        
        # Count user's recent requests
        user_requests = sum(1 for uid, _ in self.requests if uid == user_id)
        
        if user_requests >= self.max_requests:
            return False
        
        self.requests.append((user_id, now))
        return True
```

**Why:** Prevent abuse, ensure fair usage, control costs.

---

**Remember:** Start simple, measure performance, optimize based on real usage patterns.
