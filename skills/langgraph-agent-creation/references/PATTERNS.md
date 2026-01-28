# LangGraph Architecture Patterns

This document describes common architecture patterns for building LangGraph agents.

## Pattern 1: Linear Pipeline

**Use Case:** Simple sequential processing tasks.

**Structure:**
```
Input → Process → Validate → Output
```

**When to Use:**
- Data transformation tasks
- Document processing workflows
- Simple analysis tasks
- No conditional branching needed

**Example:**
```python
workflow = StateGraph(State)
workflow.add_node("process", process_node)
workflow.add_node("validate", validate_node)
workflow.add_node("output", output_node)

workflow.set_entry_point("process")
workflow.add_edge("process", "validate")
workflow.add_edge("validate", "output")
workflow.add_edge("output", END)
```

## Pattern 2: Conditional Router

**Use Case:** Decision-based routing to different processing paths.

**Structure:**
```
Input → Decision → [Path A | Path B | Path C] → Merge → Output
```

**When to Use:**
- Different handling based on input type
- Priority-based routing
- Error vs success paths
- Category-based processing

**Example:**
```python
def route_by_category(state: State) -> str:
    category = state["category"]
    if category == "urgent":
        return "priority_handler"
    elif category == "normal":
        return "standard_handler"
    else:
        return "low_priority_handler"

workflow.add_conditional_edges(
    "decision",
    route_by_category,
    {
        "priority_handler": "priority_handler",
        "standard_handler": "standard_handler",
        "low_priority_handler": "low_priority_handler"
    }
)
```

## Pattern 3: Iterative Refinement

**Use Case:** Improve output through multiple iterations.

**Structure:**
```
Input → Process → Evaluate → [Continue → Process | Done → Output]
```

**When to Use:**
- Code generation with validation
- Content creation with quality checks
- Search with relevance filtering
- Optimization tasks

**Example:**
```python
def should_refine(state: State) -> str:
    if state["quality_score"] < 0.8 and state["iterations"] < 3:
        return "refine"
    return "output"

workflow.add_conditional_edges(
    "evaluate",
    should_refine,
    {"refine": "process", "output": "output"}
)
```

## Pattern 4: Multi-Agent Collaboration

**Use Case:** Multiple specialized agents working together.

**Structure:**
```
Input → Coordinator → [Agent A, Agent B, Agent C] → Synthesizer → Output
```

**When to Use:**
- Complex tasks requiring different expertise
- Parallel processing of subtasks
- Review/approval workflows
- Research and synthesis tasks

**Example:**
```python
# Coordinator assigns tasks
def coordinator(state: State) -> State:
    tasks = analyze_and_split_task(state["input"])
    return {**state, "tasks": tasks}

# Individual agents process in parallel (conceptual)
workflow.add_node("researcher", researcher_agent)
workflow.add_node("analyst", analyst_agent)
workflow.add_node("writer", writer_agent)

# Synthesizer combines results
workflow.add_node("synthesizer", synthesize_results)
```

## Pattern 5: Human-in-the-Loop

**Use Case:** Require human approval or input at key points.

**Structure:**
```
Input → Process → Human Approval → [Approved → Continue | Rejected → Retry]
```

**When to Use:**
- Sensitive operations (delete, payment, etc.)
- Quality control checkpoints
- Decision validation
- Compliance requirements

**Example:**
```python
# Compile with interrupts
agent = workflow.compile(
    checkpointer=memory,
    interrupt_before=["human_approval"]
)

# Execution pauses at approval node
agent.invoke({"input": "sensitive operation"}, config)

# Resume after human reviews
agent.invoke(None, config)  # Continue from checkpoint
```

## Pattern 6: Error Recovery with Retry

**Use Case:** Automatic retry with fallback strategies.

**Structure:**
```
Input → Try → [Success → Output | Error → Retry → Try | Max Retries → Fallback]
```

**When to Use:**
- External API calls that might fail
- Network-dependent operations
- Resource-intensive tasks
- Rate-limited services

**Example:**
```python
def should_retry(state: State) -> str:
    if state["error"] and state["attempts"] < 3:
        return "retry"
    elif state["error"]:
        return "fallback"
    return "success"

workflow.add_conditional_edges(
    "execute",
    should_retry,
    {
        "retry": "increment_attempts",
        "fallback": "fallback_handler",
        "success": END
    }
)
```

## Pattern 7: Streaming and Chunking

**Use Case:** Process large inputs in manageable chunks.

**Structure:**
```
Input → Chunk → Process Chunk → Aggregate → [More Chunks → Process | Done → Output]
```

**When to Use:**
- Large file processing
- Long document analysis
- Batch operations
- Memory-constrained environments

**Example:**
```python
def process_chunk(state: State) -> State:
    chunk = get_next_chunk(state["input"], state["offset"])
    result = process(chunk)
    
    return {
        **state,
        "results": state["results"] + [result],
        "offset": state["offset"] + len(chunk)
    }

def has_more_chunks(state: State) -> str:
    if state["offset"] < len(state["input"]):
        return "process"
    return "aggregate"
```

## Pattern 8: Memory and Context Management

**Use Case:** Long-running conversations with memory.

**Structure:**
```
Input + History → Retrieve Context → Process → Update Memory → Output
```

**When to Use:**
- Conversational agents
- Session-based interactions
- Progressive information gathering
- Personalized experiences

**Example:**
```python
from langgraph.checkpoint.sqlite import SqliteSaver

memory = SqliteSaver.from_conn_string("conversations.db")

def retrieve_context(state: State) -> State:
    # Context automatically loaded from checkpointer
    history = state.get("messages", [])
    relevant_context = summarize_history(history[-10:])
    return {**state, "context": relevant_context}

agent = workflow.compile(checkpointer=memory)

# Each conversation has unique thread
config = {"configurable": {"thread_id": user_id}}
agent.invoke({"input": "Hello"}, config)
```

## Pattern 9: Hierarchical Planning

**Use Case:** Break complex tasks into subtasks.

**Structure:**
```
Input → High-Level Plan → [Subtask 1, Subtask 2, ...] → Execute Each → Synthesize
```

**When to Use:**
- Complex project planning
- Multi-step problem solving
- Research tasks
- Composition of simple tasks

**Example:**
```python
def planner(state: State) -> State:
    """Create high-level plan."""
    plan = llm.invoke(f"Break down this task: {state['task']}")
    subtasks = parse_plan(plan)
    return {**state, "subtasks": subtasks, "current_subtask": 0}

def executor(state: State) -> State:
    """Execute current subtask."""
    subtask = state["subtasks"][state["current_subtask"]]
    result = execute_subtask(subtask)
    return {
        **state,
        "results": state["results"] + [result],
        "current_subtask": state["current_subtask"] + 1
    }

def has_more_subtasks(state: State) -> str:
    if state["current_subtask"] < len(state["subtasks"]):
        return "executor"
    return "synthesize"
```

## Pattern 10: Tool Orchestration

**Use Case:** Dynamically select and use tools based on context.

**Structure:**
```
Input → Analyze → Select Tools → Execute Tools → Process Results → Output
```

**When to Use:**
- Multi-tool agents
- Dynamic capability selection
- API orchestration
- Complex information retrieval

**Example:**
```python
def tool_selector(state: State) -> State:
    """Analyze input and select appropriate tools."""
    available_tools = ["search", "calculator", "database", "api"]
    
    prompt = f"Which tools needed for: {state['input']}"
    selection = llm.invoke(prompt)
    selected = parse_tool_selection(selection)
    
    return {**state, "selected_tools": selected}

def tool_executor(state: State) -> State:
    """Execute selected tools."""
    results = []
    for tool_name in state["selected_tools"]:
        tool = get_tool(tool_name)
        result = tool.invoke(state["input"])
        results.append({"tool": tool_name, "result": result})
    
    return {**state, "tool_results": results}
```

## Choosing the Right Pattern

| Pattern | Complexity | Use Case | Key Benefit |
|---------|-----------|----------|-------------|
| Linear Pipeline | Low | Sequential processing | Simple, predictable |
| Conditional Router | Medium | Decision-based routing | Flexible branching |
| Iterative Refinement | Medium | Quality improvement | Self-improving output |
| Multi-Agent | High | Specialized tasks | Parallel expertise |
| Human-in-Loop | Medium | Sensitive operations | Safety and control |
| Error Recovery | Medium | Unreliable operations | Robustness |
| Streaming/Chunking | Medium | Large data | Memory efficiency |
| Memory/Context | Medium | Conversations | Stateful interactions |
| Hierarchical Planning | High | Complex tasks | Systematic breakdown |
| Tool Orchestration | High | Dynamic capabilities | Adaptive behavior |

## Combining Patterns

Patterns can be combined for more sophisticated agents:

**Example: Research Agent (Multi-Agent + Iterative + Tool Orchestration)**

```python
# Combines multiple patterns
workflow = StateGraph(State)

# Multi-agent collaboration
workflow.add_node("planner", planner_agent)
workflow.add_node("researcher", researcher_agent)
workflow.add_node("analyst", analyst_agent)

# Tool orchestration
workflow.add_node("tool_selector", select_tools)
workflow.add_node("tool_executor", execute_tools)

# Iterative refinement
workflow.add_node("evaluator", evaluate_quality)

# Conditional routing
workflow.add_conditional_edges(
    "evaluator",
    quality_check,
    {
        "refine": "researcher",
        "complete": END
    }
)
```

## Performance Considerations

### Token Optimization
- Minimize state size
- Truncate conversation history
- Use cheaper models for simple nodes

### Execution Speed
- Use async for I/O operations
- Parallelize independent operations
- Cache expensive computations

### Memory Management
- Regular state cleanup
- Limit conversation length
- Use efficient checkpointers

### Error Handling
- Graceful degradation
- Clear error messages
- Automatic recovery when possible

## Testing Strategies

### Unit Testing
Test individual nodes in isolation:

```python
def test_planner_node():
    state = {"task": "Test task"}
    result = planner_node(state)
    assert "subtasks" in result
```

### Integration Testing
Test complete workflows:

```python
def test_complete_workflow():
    agent = build_agent()
    result = agent.invoke({"input": "Test"})
    assert result["messages"][-1].content
```

### Edge Case Testing
Test boundary conditions:

```python
def test_max_iterations():
    state = {"iterations": 10, "max_iterations": 10}
    result = should_continue(state)
    assert result == "stop"
```

---

**Best Practice:** Start with simpler patterns and increase complexity only when needed. Most use cases can be solved with 2-3 combined patterns.
