#!/usr/bin/env python3
"""
LangGraph Agent Project Scaffolding Script

Creates a new LangGraph agent project with proper structure and boilerplate code.

Usage:
    python create-langgraph-agent.py --name my-agent --type basic
    python create-langgraph-agent.py --name research-agent --type advanced --memory --tools

Platforms:
    - Windows (PowerShell/CMD)
    - macOS (Bash/Zsh)
    - Linux (Bash)

Requirements:
    - Python 3.9+
    - No additional dependencies (uses only stdlib)

Author: Dau Quang Thanh
License: MIT
Version: 1.0.0
"""

import argparse
import os
import sys
from pathlib import Path
from typing import Literal


def create_directory_structure(base_path: Path, agent_name: str) -> dict[str, Path]:
    """Create project directory structure."""
    directories = {
        'root': base_path / agent_name,
        'src': base_path / agent_name / 'src',
        'tests': base_path / agent_name / 'tests',
        'config': base_path / agent_name / 'config',
        'data': base_path / agent_name / 'data',
    }
    
    for dir_name, dir_path in directories.items():
        dir_path.mkdir(parents=True, exist_ok=True)
        print(f"✓ Created: {dir_path}")
    
    return directories


def create_basic_agent(dirs: dict[str, Path], agent_name: str, use_memory: bool, use_tools: bool):
    """Create basic agent template."""
    
    # Build conditional code sections
    memory_import = '\nfrom langgraph.checkpoint.sqlite import SqliteSaver' if use_memory else ''
    tool_state_field = '\n    tool_results: list[dict]' if use_tools else ''
    
    tool_node_code = ''
    if use_tools:
        tool_node_code = '''


def tool_execution_node(state: AgentState) -> AgentState:
    """Execute tools based on user request."""
    # TODO: Implement tool execution logic
    return state'''
    
    tool_node_add = '\n    workflow.add_node("tools", tool_execution_node)' if use_tools else ''
    tool_edges = ''
    if use_tools:
        tool_edges = '''
    workflow.add_edge("process", "tools")
    workflow.add_edge("tools", END)'''
    else:
        tool_edges = '\n    workflow.add_edge("process", END)'
    
    memory_setup = ''
    if use_memory:
        memory_setup = '''
    memory = SqliteSaver.from_conn_string(":memory:")
    agent = workflow.compile(checkpointer=memory)'''
    else:
        memory_setup = '\n    agent = workflow.compile()'
    
    run_params = ', thread_id: str = "default"' if use_memory else ''
    run_config_setup = ''
    run_config_param = ''
    if use_memory:
        run_config_setup = '\n    config = {"configurable": {"thread_id": thread_id}}'
        run_config_param = ',\n        config=config'
    
    # Create main agent file
    agent_code = f'''"""
{agent_name.replace("-", " ").title()} - LangGraph Agent

A basic LangGraph agent with state management.
"""

from typing import TypedDict, Annotated, Sequence
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain_openai import ChatOpenAI
from langgraph.graph import StateGraph, END
import operator{memory_import}


class AgentState(TypedDict):
    """State schema for {agent_name}."""
    messages: Annotated[Sequence[BaseMessage], operator.add]
    user_input: str{tool_state_field}


def process_input_node(state: AgentState) -> AgentState:
    """Process user input and generate response."""
    llm = ChatOpenAI(model="gpt-4", temperature=0.7)
    
    messages = state.get("messages", [])
    user_msg = HumanMessage(content=state["user_input"])
    
    response = llm.invoke(messages + [user_msg])
    
    return {{
        **state,
        "messages": [user_msg, response]
    }}
{tool_node_code}


def build_agent():
    """Build and compile the LangGraph agent."""
    # Initialize graph
    workflow = StateGraph(AgentState)
    
    # Add nodes
    workflow.add_node("process", process_input_node){tool_node_add}
    
    # Set entry point
    workflow.set_entry_point("process")
    
    # Add edges{tool_edges}
    
    # Compile graph{memory_setup}
    
    return agent


def run_agent(user_input: str{run_params}):
    """Run the agent with user input."""
    agent = build_agent(){run_config_setup}
    
    result = agent.invoke(
        {{"user_input": user_input, "messages": []}}{run_config_param}
    )
    
    return result


if __name__ == "__main__":
    # Example usage
    result = run_agent("Hello! What can you do?")
    print(f"Agent response: {{result['messages'][-1].content}}")
'''
    
    (dirs['src'] / f'{agent_name.replace("-", "_")}_agent.py').write_text(agent_code)
    print(f"✓ Created: agent implementation")
    
    # Create requirements.txt
    requirements = '''langgraph>=0.0.20
langchain>=0.1.0
langchain-openai>=0.0.5
langchain-anthropic>=0.1.0
python-dotenv>=1.0.0
'''
    
    (dirs['root'] / 'requirements.txt').write_text(requirements)
    print(f"✓ Created: requirements.txt")
    
    # Create .env.example
    env_example = '''# API Keys
OPENAI_API_KEY=your-openai-api-key-here
ANTHROPIC_API_KEY=your-anthropic-api-key-here

# Model Configuration
DEFAULT_MODEL=gpt-4
TEMPERATURE=0.7

# Optional: LangSmith Tracing
LANGCHAIN_TRACING_V2=false
LANGCHAIN_API_KEY=your-langsmith-key-here
'''
    
    (dirs['root'] / '.env.example').write_text(env_example)
    print(f"✓ Created: .env.example")
    
    # Build feature list
    features = ['- State-based conversation flow']
    if use_memory:
        features.append('- Persistent memory across conversations')
    if use_tools:
        features.append('- Tool integration capabilities')
    features.append('- Error handling and recovery')
    features_text = '\n'.join(features)
    
    # Create README
    readme = f'''# {agent_name.replace("-", " ").title()}

A LangGraph-based AI agent with state management.

## Features

{features_text}

## Setup

1. **Install dependencies:**

```bash
pip install -r requirements.txt
```

2. **Configure API keys:**

Copy `.env.example` to `.env` and add your API keys:

```bash
cp .env.example .env
```

3. **Run the agent:**

```bash
python src/{agent_name.replace("-", "_")}_agent.py
```

## Project Structure

```
{agent_name}/
├── src/                  # Source code
│   └── {agent_name.replace("-", "_")}_agent.py
├── tests/                # Test files
├── config/               # Configuration files
├── data/                 # Data and checkpoints
├── requirements.txt      # Python dependencies
├── .env.example         # Environment variables template
└── README.md            # This file
```

## Usage

```python
from src.{agent_name.replace("-", "_")}_agent import run_agent

# Run agent
result = run_agent("Your question here")
print(result['messages'][-1].content)
```

## Development

### Testing

```bash
pytest tests/
```

### Debugging

Enable debug logging:

```python
import logging
logging.basicConfig(level=logging.DEBUG)
```

## License

MIT
'''
    
    (dirs['root'] / 'README.md').write_text(readme)
    print(f"✓ Created: README.md")
    
    # Create basic test
    test_code = f'''"""
Tests for {agent_name} agent.
"""

import pytest
from src.{agent_name.replace("-", "_")}_agent import build_agent, run_agent


def test_agent_builds():
    """Test that agent compiles successfully."""
    agent = build_agent()
    assert agent is not None


def test_agent_responds():
    """Test that agent generates response."""
    result = run_agent("Hello")
    assert "messages" in result
    assert len(result["messages"]) > 0


def test_agent_state_structure():
    """Test that agent state has expected structure."""
    result = run_agent("Test input")
    assert "user_input" in result
    assert "messages" in result
'''
    
    (dirs['tests'] / f'test_{agent_name.replace("-", "_")}.py').write_text(test_code)
    print(f"✓ Created: tests")
    
    # Create pytest config
    pytest_ini = '''[pytest]
testpaths = tests
python_files = test_*.py
python_functions = test_*
'''
    
    (dirs['root'] / 'pytest.ini').write_text(pytest_ini)
    print(f"✓ Created: pytest.ini")


def create_advanced_agent(dirs: dict[str, Path], agent_name: str, use_memory: bool, use_tools: bool):
    """Create advanced agent template with more features."""
    
    # For simplicity, use the template files instead of generating complex code
    template_path = Path(__file__).parent.parent / 'templates' / 'advanced-agent-template.py'
    
    if template_path.exists():
        # Copy and customize template
        template_content = template_path.read_text()
        
        # Replace placeholder names
        customized = template_content.replace(
            'Advanced LangGraph Agent Template',
            f'{agent_name.replace("-", " ").title()} Agent'
        )
        
        (dirs['src'] / f'{agent_name.replace("-", "_")}_agent.py').write_text(customized)
        print(f"✓ Created: advanced agent implementation from template")
    else:
        # Fallback to basic if template not found
        print(f"⚠ Advanced template not found, creating basic agent instead")
        create_basic_agent(dirs, agent_name, use_memory, use_tools)
        return
    
    # Create requirements and other files (same as basic)
    requirements = '''langgraph>=0.0.20
langchain>=0.1.0
langchain-openai>=0.0.5
langchain-anthropic>=0.1.0
python-dotenv>=1.0.0
'''
    
    (dirs['root'] / 'requirements.txt').write_text(requirements)
    print(f"✓ Created: requirements.txt")
    
    # Create .env.example
    env_example = '''# API Keys
OPENAI_API_KEY=your-openai-api-key-here
ANTHROPIC_API_KEY=your-anthropic-api-key-here

# Model Configuration
DEFAULT_MODEL=gpt-4
TEMPERATURE=0.7

# Optional: LangSmith Tracing
LANGCHAIN_TRACING_V2=false
LANGCHAIN_API_KEY=your-langsmith-key-here
'''
    
    (dirs['root'] / '.env.example').write_text(env_example)
    print(f"✓ Created: .env.example")
    
    # Build feature list
    features = ['- State-based conversation flow']
    if use_memory:
        features.append('- Persistent memory across conversations')
    if use_tools:
        features.append('- Tool integration capabilities')
    features.append('- Error handling and recovery')
    features.append('- Multiple processing nodes')
    features.append('- Conditional routing')
    features_text = '\n'.join(features)
    
    # Create README
    readme = f'''# {agent_name.replace("-", " ").title()}

An advanced LangGraph-based AI agent with state management and conditional routing.

## Features

{features_text}

## Setup

1. **Install dependencies:**

```bash
pip install -r requirements.txt
```

2. **Configure API keys:**

Copy `.env.example` to `.env` and add your API keys:

```bash
cp .env.example .env
```

3. **Run the agent:**

```bash
python src/{agent_name.replace("-", "_")}_agent.py
```

## Project Structure

```
{agent_name}/
├── src/                  # Source code
│   └── {agent_name.replace("-", "_")}_agent.py
├── tests/                # Test files
├── config/               # Configuration files
├── data/                 # Data and checkpoints
├── requirements.txt      # Python dependencies
├── .env.example         # Environment variables template
└── README.md            # This file
```

## Usage

```python
from src.{agent_name.replace("-", "_")}_agent import run_agent

# Run agent
result = run_agent("Your question here")
print(result['messages'][-1].content)
```

## Development

### Testing

```bash
pytest tests/
```

### Debugging

Enable debug logging:

```python
import logging
logging.basicConfig(level=logging.DEBUG)
```

## License

MIT
'''
    
    (dirs['root'] / 'README.md').write_text(readme)
    print(f"✓ Created: README.md")
    
    # Create basic test
    test_code = f'''"""
Tests for {agent_name} agent.
"""

import pytest
from src.{agent_name.replace("-", "_")}_agent import build_agent, run_agent


def test_agent_builds():
    """Test that agent compiles successfully."""
    agent = build_agent()
    assert agent is not None


def test_agent_responds():
    """Test that agent generates response."""
    result = run_agent("Hello")
    assert "messages" in result
    assert len(result["messages"]) > 0


def test_agent_state_structure():
    """Test that agent state has expected structure."""
    result = run_agent("Test input")
    assert "user_input" in result
    assert "messages" in result
'''
    
    (dirs['tests'] / f'test_{agent_name.replace("-", "_")}.py').write_text(test_code)
    print(f"✓ Created: tests")
    
    # Create pytest config
    pytest_ini = '''[pytest]
testpaths = tests
python_files = test_*.py
python_functions = test_*
'''
    
    (dirs['root'] / 'pytest.ini').write_text(pytest_ini)
    print(f"✓ Created: pytest.ini")


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Create a new LangGraph agent project",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python create-langgraph-agent.py --name my-agent --type basic
  python create-langgraph-agent.py --name research-agent --type advanced --memory --tools
        """
    )
    
    parser.add_argument(
        '--name',
        required=True,
        help='Agent name (lowercase with hyphens, e.g., my-research-agent)'
    )
    
    parser.add_argument(
        '--type',
        choices=['basic', 'advanced'],
        default='basic',
        help='Agent complexity level (default: basic)'
    )
    
    parser.add_argument(
        '--memory',
        action='store_true',
        help='Include persistent memory/checkpointing'
    )
    
    parser.add_argument(
        '--tools',
        action='store_true',
        help='Include tool integration capabilities'
    )
    
    parser.add_argument(
        '--output',
        default='.',
        help='Output directory (default: current directory)'
    )
    
    args = parser.parse_args()
    
    # Validate agent name
    if not all(c.islower() or c.isdigit() or c == '-' for c in args.name):
        print("❌ Error: Agent name must be lowercase with hyphens only")
        sys.exit(1)
    
    if args.name.startswith('-') or args.name.endswith('-'):
        print("❌ Error: Agent name cannot start or end with hyphen")
        sys.exit(1)
    
    if '--' in args.name:
        print("❌ Error: Agent name cannot contain consecutive hyphens")
        sys.exit(1)
    
    # Create project
    print(f"\\n🚀 Creating LangGraph agent: {args.name}")
    print(f"   Type: {args.type}")
    print(f"   Memory: {'Yes' if args.memory else 'No'}")
    print(f"   Tools: {'Yes' if args.tools else 'No'}")
    print()
    
    base_path = Path(args.output).resolve()
    dirs = create_directory_structure(base_path, args.name)
    
    if args.type == 'basic':
        create_basic_agent(dirs, args.name, args.memory, args.tools)
    else:
        create_advanced_agent(dirs, args.name, args.memory, args.tools)
    
    print(f"\\n✅ Project created successfully!")
    print(f"\\nNext steps:")
    print(f"  1. cd {args.name}")
    print(f"  2. python -m venv venv")
    print(f"  3. source venv/bin/activate  # On Windows: venv\\Scripts\\activate")
    print(f"  4. pip install -r requirements.txt")
    print(f"  5. cp .env.example .env")
    print(f"  6. # Add your API keys to .env")
    print(f"  7. python src/{args.name.replace('-', '_')}_agent.py")
    print()


if __name__ == "__main__":
    main()
