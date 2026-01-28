"""
Advanced LangGraph Agent Template

Template for agents with:
- Multiple nodes and conditional routing
- Tool integration
- Error handling
- Memory/persistence
"""

from typing import TypedDict, Annotated, Sequence, Literal
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain_openai import ChatOpenAI
from langgraph.graph import StateGraph, END
from langgraph.checkpoint.sqlite import SqliteSaver
import operator
import logging

logger = logging.getLogger(__name__)


# 1. DEFINE STATE SCHEMA
class AgentState(TypedDict):
    """State for advanced agent with multiple processing stages."""
    messages: Annotated[Sequence[BaseMessage], operator.add]
    user_input: str
    plan: str
    tool_results: list[dict]
    next_action: Literal["tools", "respond", "error"]
    error: str | None


# 2. DEFINE NODE FUNCTIONS

def planning_node(state: AgentState) -> AgentState:
    """
    Analyze input and create execution plan.
    
    This node decides what the agent should do next.
    """
    logger.info("Planning: Analyzing user input")
    
    llm = ChatOpenAI(model="gpt-4", temperature=0)
    
    prompt = f"""Analyze this request and decide the best action:

User: {state['user_input']}

Actions:
1. "tools" - Need to use external tools (search, API, etc.)
2. "respond" - Can answer directly with knowledge
3. "error" - Request is unclear or problematic

Respond with ONLY the action name and brief reasoning.
"""
    
    try:
        response = llm.invoke([HumanMessage(content=prompt)])
        plan = response.content
        
        # Determine next action
        if "tools" in plan.lower():
            next_action = "tools"
        elif "error" in plan.lower():
            next_action = "error"
        else:
            next_action = "respond"
        
        return {
            **state,
            "plan": plan,
            "next_action": next_action
        }
    
    except Exception as e:
        logger.error(f"Planning error: {e}")
        return {
            **state,
            "error": str(e),
            "next_action": "error"
        }


def tool_execution_node(state: AgentState) -> AgentState:
    """
    Execute tools based on plan.
    
    TODO: Implement actual tool execution.
    This is a placeholder showing the pattern.
    """
    logger.info("Tools: Executing tools")
    
    # Placeholder - replace with actual tool execution
    results = [
        {
            "tool": "example_tool",
            "result": f"Processed: {state['user_input']}"
        }
    ]
    
    return {
        **state,
        "tool_results": results,
        "next_action": "respond"
    }


def response_node(state: AgentState) -> AgentState:
    """Generate final response using plan and tool results."""
    logger.info("Response: Generating final answer")
    
    llm = ChatOpenAI(model="gpt-4", temperature=0.7)
    
    # Build context
    context_parts = [
        f"User request: {state['user_input']}",
        f"Plan: {state.get('plan', 'N/A')}"
    ]
    
    if state.get('tool_results'):
        context_parts.append(f"Tool results: {state['tool_results']}")
    
    context = "\n".join(context_parts)
    
    prompt = f"""{context}

Based on the above, provide a helpful and accurate response.
"""
    
    try:
        response = llm.invoke([HumanMessage(content=prompt)])
        
        return {
            **state,
            "messages": [response]
        }
    
    except Exception as e:
        logger.error(f"Response error: {e}")
        return {
            **state,
            "error": str(e),
            "next_action": "error"
        }


def error_handler_node(state: AgentState) -> AgentState:
    """Handle errors gracefully."""
    logger.error(f"Error handler: {state.get('error')}")
    
    error_message = AIMessage(
        content=f"I encountered an error: {state.get('error', 'Unknown error')}. Please try rephrasing your request."
    )
    
    return {
        **state,
        "messages": [error_message],
        "error": None  # Clear error after handling
    }


# 3. DEFINE ROUTING LOGIC

def route_after_planning(state: AgentState) -> str:
    """
    Route based on planning decision.
    
    Conditional edges use this to decide which node comes next.
    """
    if state.get("error"):
        return "error"
    
    action = state.get("next_action", "respond")
    logger.info(f"Routing to: {action}")
    
    return action


# 4. BUILD THE GRAPH

def build_agent(use_memory: bool = False):
    """
    Build advanced agent with conditional routing.
    
    Args:
        use_memory: Enable persistent memory across conversations
    
    Returns:
        Compiled LangGraph agent
    """
    logger.info("Building agent graph")
    
    # Initialize graph
    workflow = StateGraph(AgentState)
    
    # Add nodes
    workflow.add_node("planning", planning_node)
    workflow.add_node("tools", tool_execution_node)
    workflow.add_node("respond", response_node)
    workflow.add_node("error", error_handler_node)
    
    # Set entry point
    workflow.set_entry_point("planning")
    
    # Add conditional routing after planning
    workflow.add_conditional_edges(
        "planning",
        route_after_planning,
        {
            "tools": "tools",
            "respond": "respond",
            "error": "error"
        }
    )
    
    # Tool execution flows to response
    workflow.add_edge("tools", "respond")
    
    # Terminal nodes
    workflow.add_edge("respond", END)
    workflow.add_edge("error", END)
    
    # Compile with optional memory
    if use_memory:
        memory = SqliteSaver.from_conn_string(":memory:")
        agent = workflow.compile(checkpointer=memory)
    else:
        agent = workflow.compile()
    
    logger.info("Agent compiled successfully")
    return agent


# 5. RUN THE AGENT

def run_agent(user_input: str, thread_id: str = None):
    """
    Run agent with user input.
    
    Args:
        user_input: User's message
        thread_id: Optional thread ID for persistent memory
    
    Returns:
        Final state with results
    """
    use_memory = thread_id is not None
    agent = build_agent(use_memory=use_memory)
    
    config = None
    if thread_id:
        config = {"configurable": {"thread_id": thread_id}}
    
    result = agent.invoke(
        {
            "user_input": user_input,
            "messages": [],
            "tool_results": [],
            "next_action": "respond"
        },
        config=config
    )
    
    return result


def stream_agent(user_input: str, thread_id: str = None):
    """
    Stream agent execution step-by-step.
    
    Useful for observing agent's decision-making process.
    """
    use_memory = thread_id is not None
    agent = build_agent(use_memory=use_memory)
    
    config = None
    if thread_id:
        config = {"configurable": {"thread_id": thread_id}}
    
    for chunk in agent.stream(
        {
            "user_input": user_input,
            "messages": [],
            "tool_results": [],
            "next_action": "respond"
        },
        config=config
    ):
        yield chunk


# 6. EXAMPLE USAGE

if __name__ == "__main__":
    # Configure logging
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )
    
    # Example 1: Basic usage
    print("=== Basic Usage ===")
    result = run_agent("What are the benefits of LangGraph?")
    print(f"Response: {result['messages'][-1].content}\n")
    
    # Example 2: With memory
    print("=== With Memory ===")
    thread = "user-123"
    
    result1 = run_agent("My name is Alice", thread_id=thread)
    print(f"Response 1: {result1['messages'][-1].content}")
    
    result2 = run_agent("What's my name?", thread_id=thread)
    print(f"Response 2: {result2['messages'][-1].content}\n")
    
    # Example 3: Streaming
    print("=== Streaming ===")
    for step in stream_agent("Tell me about AI agents"):
        print(f"Step: {step}")
