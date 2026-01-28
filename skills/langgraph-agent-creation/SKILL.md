---
name: langgraph-agent-creation
description: Creates AI agents using LangGraph framework with state management, tool integration, and multi-agent workflows. Use when building agentic systems, orchestrating LLM workflows, implementing state machines, or when user mentions LangGraph, agent orchestration, state graphs, or multi-agent systems.
license: MIT
metadata:
  author: Dau Quang Thanh
  version: "1.0.0"
  last-updated: "2026-01-28"
  category: ai-development
---

# LangGraph Agent Creation

## When to Use

Use this skill when:

- Building AI agents with complex state management
- Creating multi-agent systems with coordinated workflows
- Implementing agentic workflows with LangGraph
- Designing stateful conversation agents
- Orchestrating LLM tool calling and decision making
- Building human-in-the-loop AI systems
- Creating agents with memory and persistence
- Implementing conditional routing and branching logic
- Developing agents with error handling and retry mechanisms

## Prerequisites

**Required:**

- Python 3.9 or higher
- pip or poetry for package management
- Basic understanding of LangChain concepts
- API keys for LLM providers (OpenAI, Anthropic, etc.)

**Recommended:**

- Virtual environment (venv, conda, or poetry)
- Git for version control
- Understanding of graph theory basics
- Familiarity with async/await patterns

**Install LangGraph:**

```bash
pip install langgraph langchain-openai langchain-anthropic
```

## Instructions

### Step 1: Define Agent Architecture

Before writing code, design your agent's architecture:

1. **Identify States**: What distinct states does your agent need?
   - Example: `input`, `planning`, `tool_execution`, `response`, `error`

2. **Map State Transitions**: How does the agent move between states?
   - Example: `planning` → `tool_execution` (if tools needed) OR `response` (if ready)

3. **Define Node Functions**: What happens in each state?
   - Each node is a function that processes state and returns updated state

4. **Plan Conditional Logic**: When should the agent branch?
   - Example: After planning, decide whether to use tools or respond directly

5. **Design State Schema**: What data persists across nodes?
   - User input, conversation history, tool results, intermediate outputs

### Step 2: Create State Schema

Define a TypedDict or Pydantic model for your agent state:

```python
from typing import TypedDict, Annotated, Sequence
from langchain_core.messages import BaseMessage
import operator

class AgentState(TypedDict):
    """State schema for the agent."""
    messages: Annotated[Sequence[BaseMessage], operator.add]
    user_input: str
    plan: str
    tool_results: list[dict]
    next_action: str
    error: str | None
```

**Best Practices:**

- Use `Annotated[Sequence[BaseMessage], operator.add]` for message history
- Include fields for intermediate results
- Add error tracking fields
- Use type hints for clarity

### Step 3: Implement Node Functions

Create functions for each state in your graph:

```python
from langchain_core.messages import HumanMessage, AIMessage
from langchain_openai import ChatOpenAI

def planning_node(state: AgentState) -> AgentState:
    """Analyze input and create execution plan."""
    llm = ChatOpenAI(model="gpt-4", temperature=0)
    
    prompt = f"""Analyze this request and create a plan:
    User: {state['user_input']}
    
    Decide if you need to:
    1. Use tools (search, calculate, API calls)
    2. Respond directly with existing knowledge
    
    Return your plan as JSON:
    {{"action": "use_tools" or "respond", "reasoning": "why", "steps": ["step1", "step2"]}}
    """
    
    response = llm.invoke([HumanMessage(content=prompt)])
    plan = response.content
    
    return {
        **state,
        "plan": plan,
        "messages": [AIMessage(content=f"Plan created: {plan}")]
    }

def tool_execution_node(state: AgentState) -> AgentState:
    """Execute tools based on plan."""
    # Parse plan and execute tools
    tools = load_tools_from_plan(state["plan"])
    results = []
    
    for tool in tools:
        try:
            result = tool.invoke(state["user_input"])
            results.append({"tool": tool.name, "result": result})
        except Exception as e:
            return {**state, "error": str(e)}
    
    return {
        **state,
        "tool_results": results,
        "messages": [AIMessage(content=f"Tools executed: {len(results)} results")]
    }

def response_node(state: AgentState) -> AgentState:
    """Generate final response."""
    llm = ChatOpenAI(model="gpt-4")
    
    context = f"""
    User request: {state['user_input']}
    Plan: {state['plan']}
    Tool results: {state['tool_results']}
    
    Provide a comprehensive answer.
    """
    
    response = llm.invoke([HumanMessage(content=context)])
    
    return {
        **state,
        "messages": state["messages"] + [response]
    }
```

**Best Practices:**

- Keep node functions pure (deterministic)
- Return updated state, don't modify in place
- Handle errors gracefully within nodes
- Log important state transitions
- Use spread operator (`**state`) to preserve existing state

### Step 4: Build the Graph

Create the LangGraph StateGraph:

```python
from langgraph.graph import StateGraph, END

# Initialize graph
workflow = StateGraph(AgentState)

# Add nodes
workflow.add_node("planning", planning_node)
workflow.add_node("tool_execution", tool_execution_node)
workflow.add_node("response", response_node)
workflow.add_node("error_handler", error_handler_node)

# Set entry point
workflow.set_entry_point("planning")

# Add conditional edges
def route_after_planning(state: AgentState) -> str:
    """Decide next step after planning."""
    if state.get("error"):
        return "error_handler"
    
    plan = state.get("plan", "")
    if "use_tools" in plan.lower():
        return "tool_execution"
    else:
        return "response"

workflow.add_conditional_edges(
    "planning",
    route_after_planning,
    {
        "tool_execution": "tool_execution",
        "response": "response",
        "error_handler": "error_handler"
    }
)

# Add regular edges
workflow.add_edge("tool_execution", "response")
workflow.add_edge("response", END)
workflow.add_edge("error_handler", END)

# Compile graph
agent = workflow.compile()
```

**Best Practices:**

- Use descriptive node names
- Add conditional edges for branching logic
- Always have an error handling path
- Use `END` to mark terminal nodes
- Compile graph before execution

### Step 5: Add Memory and Persistence (Optional)

For stateful agents that remember conversations:

```python
from langgraph.checkpoint.sqlite import SqliteSaver

# Create checkpointer for persistence
memory = SqliteSaver.from_conn_string(":memory:")  # or use file path

# Compile with checkpointer
agent = workflow.compile(checkpointer=memory)

# Invoke with thread_id for conversation continuity
config = {"configurable": {"thread_id": "conversation-1"}}
result = agent.invoke(
    {"user_input": "Hello, remember this: I like Python"},
    config=config
)

# Later messages in same thread will have access to history
result = agent.invoke(
    {"user_input": "What programming language do I like?"},
    config=config
)
```

**Best Practices:**

- Use SQLite for development, PostgreSQL for production
- Implement cleanup for old conversations
- Consider privacy implications of storing conversations
- Use thread IDs to isolate different users/sessions

### Step 6: Implement Tool Integration

Integrate external tools using LangChain tools:

```python
from langchain.tools import Tool
from langchain_community.tools import DuckDuckGoSearchRun

# Define custom tool
def calculator(expression: str) -> str:
    """Evaluate mathematical expressions safely."""
    try:
        # Use safe evaluation (never use eval() directly!)
        result = safe_eval(expression)
        return str(result)
    except Exception as e:
        return f"Error: {e}"

# Create tool instances
search_tool = DuckDuckGoSearchRun()
calc_tool = Tool(
    name="calculator",
    func=calculator,
    description="Evaluate mathematical expressions. Input: '2+2', Output: '4'"
)

tools = [search_tool, calc_tool]

# Use in agent nodes
def tool_execution_node(state: AgentState) -> AgentState:
    """Execute tools based on plan."""
    llm = ChatOpenAI(model="gpt-4")
    llm_with_tools = llm.bind_tools(tools)
    
    response = llm_with_tools.invoke(state["messages"])
    
    # Check if tools were called
    if response.tool_calls:
        results = []
        for tool_call in response.tool_calls:
            tool = next(t for t in tools if t.name == tool_call["name"])
            result = tool.invoke(tool_call["args"])
            results.append({"tool": tool.name, "result": result})
        
        return {**state, "tool_results": results}
    
    return state
```

**Best Practices:**

- Always validate tool inputs
- Implement timeouts for external API calls
- Handle tool errors gracefully
- Provide clear tool descriptions for LLM
- Log tool usage for debugging

### Step 7: Add Human-in-the-Loop

Implement human approval for sensitive actions:

```python
from langgraph.graph import StateGraph, END
from langgraph.checkpoint.sqlite import SqliteSaver

# Add human approval node
workflow.add_node("human_approval", human_approval_node)

def human_approval_node(state: AgentState) -> AgentState:
    """Pause execution and wait for human approval."""
    # This node interrupts execution
    # Agent will pause here until explicitly resumed
    return state

# Add conditional edge to check if approval needed
def route_after_planning(state: AgentState) -> str:
    plan = state.get("plan", "")
    
    # Require approval for sensitive actions
    if "delete" in plan.lower() or "payment" in plan.lower():
        return "human_approval"
    
    return "tool_execution"

workflow.add_conditional_edges(
    "planning",
    route_after_planning,
    {
        "human_approval": "human_approval",
        "tool_execution": "tool_execution"
    }
)

workflow.add_edge("human_approval", "tool_execution")

# Compile with interrupts
agent = workflow.compile(
    checkpointer=memory,
    interrupt_before=["human_approval"]  # Pause before this node
)

# Execution will pause at human_approval
config = {"configurable": {"thread_id": "user-123"}}
agent.invoke({"user_input": "Delete all files"}, config=config)

# Resume after approval (in separate request)
agent.invoke(None, config=config)  # Continue from checkpoint
```

**Best Practices:**

- Use interrupts for sensitive operations
- Implement timeout for approval requests
- Log approval decisions for audit trail
- Allow rejection with explanation
- Resume from exact checkpoint state

### Step 8: Test and Debug

Use LangGraph's visualization and debugging tools:

```python
# Visualize graph structure
from IPython.display import Image, display

try:
    display(Image(agent.get_graph().draw_mermaid_png()))
except Exception:
    print(agent.get_graph().draw_ascii())

# Enable debug logging
import logging
logging.basicConfig(level=logging.DEBUG)

# Stream agent execution
for chunk in agent.stream(
    {"user_input": "What's the weather in Paris?"},
    config={"configurable": {"thread_id": "test-1"}}
):
    print(chunk)
    print("---")

# Inspect state at each step
final_state = agent.invoke({"user_input": "Test"})
print(f"Final state: {final_state}")
```

**Best Practices:**

- Visualize graph before deployment
- Test all conditional paths
- Verify state transitions
- Monitor token usage
- Test error handling paths
- Use streaming for long-running agents

## Examples

### Example 1: Simple Research Agent

```python
from typing import TypedDict, Annotated, Sequence
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain_openai import ChatOpenAI
from langgraph.graph import StateGraph, END
import operator

class ResearchState(TypedDict):
    messages: Annotated[Sequence[BaseMessage], operator.add]
    query: str
    research_findings: list[str]

def research_node(state: ResearchState) -> ResearchState:
    # Simulate research
    findings = [f"Finding about: {state['query']}"]
    return {
        **state,
        "research_findings": findings,
        "messages": [AIMessage(content=f"Research complete: {findings}")]
    }

def synthesis_node(state: ResearchState) -> ResearchState:
    llm = ChatOpenAI(model="gpt-4")
    response = llm.invoke([
        HumanMessage(content=f"Synthesize: {state['research_findings']}")
    ])
    return {**state, "messages": state["messages"] + [response]}

# Build graph
workflow = StateGraph(ResearchState)
workflow.add_node("research", research_node)
workflow.add_node("synthesis", synthesis_node)
workflow.set_entry_point("research")
workflow.add_edge("research", "synthesis")
workflow.add_edge("synthesis", END)

agent = workflow.compile()

# Run
result = agent.invoke({"query": "LangGraph benefits", "messages": []})
print(result["messages"][-1].content)
```

**Output:**
```
Research complete with synthesis of LangGraph benefits including state management, modularity, and debugging capabilities.
```

### Example 2: Multi-Agent Collaboration

```python
from typing import TypedDict
from langgraph.graph import StateGraph, END

class CollaborationState(TypedDict):
    task: str
    researcher_output: str
    writer_output: str
    reviewer_output: str

def researcher_agent(state: CollaborationState) -> CollaborationState:
    # Research task
    output = f"Research findings for: {state['task']}"
    return {**state, "researcher_output": output}

def writer_agent(state: CollaborationState) -> CollaborationState:
    # Write based on research
    output = f"Article based on: {state['researcher_output']}"
    return {**state, "writer_output": output}

def reviewer_agent(state: CollaborationState) -> CollaborationState:
    # Review and approve
    output = f"Reviewed and approved: {state['writer_output']}"
    return {**state, "reviewer_output": output}

# Build collaboration workflow
workflow = StateGraph(CollaborationState)
workflow.add_node("researcher", researcher_agent)
workflow.add_node("writer", writer_agent)
workflow.add_node("reviewer", reviewer_agent)

workflow.set_entry_point("researcher")
workflow.add_edge("researcher", "writer")
workflow.add_edge("writer", "reviewer")
workflow.add_edge("reviewer", END)

agent = workflow.compile()

# Execute collaboration
result = agent.invoke({"task": "Write article about AI agents"})
print(result["reviewer_output"])
```

### Example 3: Agent with Retry Logic

```python
from typing import TypedDict
from langgraph.graph import StateGraph, END

class RetryState(TypedDict):
    task: str
    attempts: int
    max_attempts: int
    result: str | None
    error: str | None

def attempt_task(state: RetryState) -> RetryState:
    """Try to execute task."""
    try:
        # Simulate task that might fail
        if state["attempts"] < 2:
            raise Exception("Simulated failure")
        
        result = f"Success on attempt {state['attempts']}"
        return {**state, "result": result, "error": None}
    except Exception as e:
        return {**state, "error": str(e)}

def should_retry(state: RetryState) -> str:
    """Decide whether to retry or give up."""
    if state["error"] and state["attempts"] < state["max_attempts"]:
        return "retry"
    elif state["error"]:
        return "failed"
    else:
        return "success"

def increment_attempts(state: RetryState) -> RetryState:
    """Increment attempt counter."""
    return {**state, "attempts": state["attempts"] + 1}

# Build retry workflow
workflow = StateGraph(RetryState)
workflow.add_node("task", attempt_task)
workflow.add_node("increment", increment_attempts)

workflow.set_entry_point("task")

workflow.add_conditional_edges(
    "task",
    should_retry,
    {
        "retry": "increment",
        "success": END,
        "failed": END
    }
)

workflow.add_edge("increment", "task")

agent = workflow.compile()

# Execute with retry
result = agent.invoke({
    "task": "Important operation",
    "attempts": 0,
    "max_attempts": 3
})

print(f"Result: {result.get('result')}")
print(f"Attempts: {result['attempts']}")
```

## Edge Cases and Guidelines

### Edge Case 1: Circular Dependencies

**Problem:** Nodes that could loop infinitely.

**Solution:** Add max iteration counter or timeout:

```python
class State(TypedDict):
    iteration: int
    max_iterations: int

def should_continue(state: State) -> str:
    if state["iteration"] >= state["max_iterations"]:
        return "end"
    return "continue"
```

### Edge Case 2: Large State Objects

**Problem:** State grows too large with accumulated data.

**Solution:** Prune unnecessary data between nodes:

```python
def cleanup_node(state: AgentState) -> AgentState:
    # Keep only essential data
    return {
        "messages": state["messages"][-5:],  # Last 5 messages only
        "user_input": state["user_input"],
        # Drop intermediate results
    }
```

### Edge Case 3: API Rate Limits

**Problem:** External API calls hit rate limits.

**Solution:** Implement exponential backoff:

```python
import time
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10)
)
def call_external_api(params):
    # API call here
    pass
```

### Edge Case 4: Concurrent Tool Execution

**Problem:** Multiple tools could be executed in parallel for efficiency.

**Solution:** Use async nodes:

```python
import asyncio

async def parallel_tools_node(state: AgentState) -> AgentState:
    tools = [tool1, tool2, tool3]
    results = await asyncio.gather(
        *[tool.ainvoke(state["user_input"]) for tool in tools]
    )
    return {**state, "tool_results": results}
```

### Edge Case 5: State Serialization Issues

**Problem:** Complex objects in state can't be serialized for persistence.

**Solution:** Use serializable types or custom serializers:

```python
from datetime import datetime
import json

class CustomEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime):
            return obj.isoformat()
        return super().default(obj)

# Use simple types in state
class AgentState(TypedDict):
    timestamp: str  # ISO format instead of datetime object
    data: dict      # JSON-serializable dict
```

## Error Handling

### Error 1: State Schema Mismatch

**Error:** `KeyError: 'field_name'` or missing required fields.

**Cause:** Node returns state missing required fields.

**Solution:**
```python
def safe_node(state: AgentState) -> AgentState:
    # Always return complete state
    return {
        **state,  # Preserve existing fields
        "new_field": "value"  # Add new fields
    }
```

### Error 2: Infinite Loops

**Error:** Graph execution never ends, runs indefinitely.

**Cause:** Conditional edges create circular paths without termination.

**Solution:**
```python
def add_loop_protection(state: State) -> State:
    state["loop_counter"] = state.get("loop_counter", 0) + 1
    if state["loop_counter"] > 10:
        return {**state, "force_end": True}
    return state

def route_with_protection(state: State) -> str:
    if state.get("force_end"):
        return END
    # Normal routing logic
```

### Error 3: Memory Leaks with Persistence

**Error:** Database grows indefinitely, performance degrades.

**Cause:** Not cleaning up old conversation threads.

**Solution:**
```python
from datetime import datetime, timedelta

def cleanup_old_threads(checkpointer, days=30):
    """Remove threads older than specified days."""
    cutoff = datetime.now() - timedelta(days=days)
    # Implementation depends on checkpointer type
    checkpointer.delete_threads_before(cutoff)
```

### Error 4: Tool Execution Timeout

**Error:** Node hangs indefinitely waiting for tool response.

**Cause:** External API doesn't respond or takes too long.

**Solution:**
```python
import asyncio

async def tool_with_timeout(tool, input_data, timeout=30):
    """Execute tool with timeout."""
    try:
        return await asyncio.wait_for(
            tool.ainvoke(input_data),
            timeout=timeout
        )
    except asyncio.TimeoutError:
        return {"error": "Tool execution timed out"}
```

### Error 5: LLM API Errors

**Error:** `RateLimitError`, `APIError`, or authentication failures.

**Cause:** API quota exceeded or invalid credentials.

**Solution:**
```python
from langchain_openai import ChatOpenAI
from langchain.callbacks import get_openai_callback

def llm_node_with_error_handling(state: AgentState) -> AgentState:
    try:
        llm = ChatOpenAI(model="gpt-4", max_retries=2)
        with get_openai_callback() as cb:
            response = llm.invoke(state["messages"])
            print(f"Tokens used: {cb.total_tokens}")
        
        return {**state, "messages": state["messages"] + [response]}
    
    except Exception as e:
        error_msg = f"LLM error: {str(e)}"
        return {**state, "error": error_msg}
```

## Scripts

This skill includes a cross-platform Python script for scaffolding LangGraph agent projects:

```bash
# Create new LangGraph agent project
python scripts/create-langgraph-agent.py --name my-agent --type basic

# Create with advanced features
python scripts/create-langgraph-agent.py --name research-agent --type advanced --memory --tools
```

See [scripts/create-langgraph-agent.py](scripts/create-langgraph-agent.py) for full documentation.

## Additional Resources

- **LangGraph Documentation**: [Official Docs](https://langchain-ai.github.io/langgraph/)
- **LangGraph Tutorials**: [GitHub Examples](https://github.com/langchain-ai/langgraph/tree/main/examples)
- **Architecture Patterns**: See [references/PATTERNS.md](references/PATTERNS.md)
- **Best Practices**: See [references/BEST-PRACTICES.md](references/BEST-PRACTICES.md)
- **Tool Integration Guide**: See [references/TOOLS.md](references/TOOLS.md)

## Performance Optimization

### Token Usage Optimization

- Keep state minimal (only essential data)
- Truncate message history (last N messages)
- Use cheaper models for simple nodes
- Cache LLM responses when possible

### Execution Speed

- Use async nodes for I/O operations
- Parallelize independent tool calls
- Implement smart caching
- Optimize conditional routing logic

### Memory Management

- Regular cleanup of old threads
- Limit state size per conversation
- Use streaming for large outputs
- Implement pagination for long results

## Testing Strategy

```python
import pytest
from langgraph.graph import StateGraph

def test_agent_basic_flow():
    """Test agent completes basic workflow."""
    agent = build_agent()
    result = agent.invoke({"user_input": "Hello"})
    assert "messages" in result
    assert len(result["messages"]) > 0

def test_conditional_routing():
    """Test agent routes correctly based on state."""
    agent = build_agent()
    result = agent.invoke({"user_input": "Search for Python"})
    assert "tool_results" in result

def test_error_handling():
    """Test agent handles errors gracefully."""
    agent = build_agent()
    result = agent.invoke({"user_input": "CAUSE_ERROR"})
    assert result.get("error") is not None
```

## Security Considerations

1. **API Key Management**: Never hardcode API keys, use environment variables
2. **Input Validation**: Sanitize all user inputs before processing
3. **Tool Access Control**: Limit tools to necessary permissions only
4. **State Encryption**: Encrypt sensitive data in state when persisting
5. **Rate Limiting**: Implement rate limits to prevent abuse
6. **Audit Logging**: Log all tool executions and decisions for compliance

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28  
**Author:** Dau Quang Thanh  
**License:** MIT
