# LangGraph Agent Creation Skill

This skill helps you build AI agents using the LangGraph framework with state management, tool integration, and multi-agent workflows.

## Quick Start

### Using the Scaffolding Script

Create a new LangGraph agent project:

```bash
# Basic agent
python scripts/create-langgraph-agent.py --name my-agent --type basic

# Advanced agent with memory and tools
python scripts/create-langgraph-agent.py --name research-agent --type advanced --memory --tools
```

### Using Templates

Copy and customize templates:

```bash
# Basic template
cp templates/basic-agent-template.py my_agent.py

# Advanced template
cp templates/advanced-agent-template.py my_agent.py
```

## Contents

### Main Skill File
- **SKILL.md**: Complete instructions for building LangGraph agents

### Scripts
- **create-langgraph-agent.py**: Cross-platform project scaffolding script

### Templates
- **basic-agent-template.py**: Minimal agent with linear flow
- **advanced-agent-template.py**: Agent with conditional routing, tools, and memory

### References
- **PATTERNS.md**: 10 common LangGraph architecture patterns
- **BEST-PRACTICES.md**: Production-ready development guidelines
- **TOOLS.md**: Comprehensive tool integration guide

## Architecture Patterns

The skill covers 10 proven patterns:

1. **Linear Pipeline**: Sequential processing
2. **Conditional Router**: Decision-based routing
3. **Iterative Refinement**: Quality improvement loops
4. **Multi-Agent Collaboration**: Specialized agents working together
5. **Human-in-the-Loop**: Human approval for sensitive operations
6. **Error Recovery**: Retry with fallback strategies
7. **Streaming and Chunking**: Large data processing
8. **Memory and Context**: Stateful conversations
9. **Hierarchical Planning**: Complex task breakdown
10. **Tool Orchestration**: Dynamic tool selection

## Key Features

### State Management
- Type-safe state definitions
- Immutable state updates
- Efficient serialization

### Node Design
- Single responsibility principle
- Comprehensive error handling
- Observable logging

### Tool Integration
- Multiple tool types (search, API, file ops, custom)
- Parallel execution
- Timeout protection
- Rate limiting

### Memory Options
- In-memory (development)
- SQLite (local persistence)
- PostgreSQL (production)

### Testing Support
- Unit test patterns
- Integration test examples
- Edge case coverage

## Prerequisites

- Python 3.9+
- LangGraph library
- LangChain
- LLM API keys (OpenAI, Anthropic, etc.)

## Installation

```bash
pip install langgraph langchain-openai langchain-anthropic
```

## Examples

### Simple Research Agent
```python
from typing import TypedDict
from langgraph.graph import StateGraph, END

class State(TypedDict):
    query: str
    result: str

def research(state): 
    return {**state, "result": f"Research on: {state['query']}"}

workflow = StateGraph(State)
workflow.add_node("research", research)
workflow.set_entry_point("research")
workflow.add_edge("research", END)
agent = workflow.compile()
```

### Agent with Tools
```python
from langchain.tools import Tool
from langchain_openai import ChatOpenAI

tools = [
    Tool(name="search", func=search_func, description="Web search"),
    Tool(name="calculator", func=calc_func, description="Math")
]

llm = ChatOpenAI(model="gpt-4")
llm_with_tools = llm.bind_tools(tools)
```

## Best Practices

1. **Keep state minimal** - Only essential data
2. **Use type hints** - Enable better tooling
3. **Log extensively** - Aid debugging
4. **Handle errors gracefully** - Keep agent running
5. **Test thoroughly** - Unit and integration tests
6. **Monitor tokens** - Control costs
7. **Secure tools** - Validate inputs, check permissions

## Performance Tips

- Use async for I/O operations
- Cache expensive computations
- Prune state regularly
- Choose models wisely (GPT-3.5 vs GPT-4)
- Implement rate limiting

## Security Considerations

- Sanitize all inputs
- Use environment variables for API keys
- Implement permission checks for file operations
- Add audit logging for compliance
- Set timeouts for external calls

## Resources

- [LangGraph Documentation](https://langchain-ai.github.io/langgraph/)
- [LangGraph Examples](https://github.com/langchain-ai/langgraph/tree/main/examples)
- See PATTERNS.md for architecture patterns
- See BEST-PRACTICES.md for production guidelines
- See TOOLS.md for tool integration details

## Troubleshooting

### Common Issues

**State Schema Mismatch**
```python
# Always return complete state
return {**state, "new_field": "value"}
```

**Infinite Loops**
```python
# Add loop counter
state["iteration"] = state.get("iteration", 0) + 1
if state["iteration"] > 10:
    return END
```

**Memory Leaks**
```python
# Clean up old conversations
cleanup_old_threads(checkpointer, days=30)
```

**Tool Timeouts**
```python
# Add timeout protection
await asyncio.wait_for(tool.ainvoke(input), timeout=30)
```

## Contributing

When enhancing this skill:

1. Follow Agent Skills specification
2. Keep SKILL.md under 500 lines
3. Add details to references/
4. Test on Windows, macOS, and Linux
5. Update examples and templates

## License

MIT

## Author

Dau Quang Thanh

## Version

1.0.0 (2026-01-28)
