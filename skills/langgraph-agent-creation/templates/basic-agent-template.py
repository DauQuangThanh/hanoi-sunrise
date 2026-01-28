"""
Basic LangGraph Agent Template

A minimal template for creating a LangGraph agent with state management.
Copy and customize this template for your specific use case.
"""

from typing import TypedDict, Annotated, Sequence
from langchain_core.messages import BaseMessage, HumanMessage, AIMessage
from langchain_openai import ChatOpenAI
from langgraph.graph import StateGraph, END
import operator


# 1. DEFINE STATE SCHEMA
class AgentState(TypedDict):
    """
    Define what data flows through your agent.
    
    Required:
    - messages: Conversation history (use Annotated with operator.add)
    
    Optional: Add any fields your agent needs:
    - user_input: str
    - results: list[dict]
    - plan: str
    - error: str | None
    """
    messages: Annotated[Sequence[BaseMessage], operator.add]
    user_input: str


# 2. DEFINE NODE FUNCTIONS
def process_node(state: AgentState) -> AgentState:
    """
    Node that processes user input.
    
    Each node:
    - Takes state as input
    - Performs some action (call LLM, use tools, etc.)
    - Returns updated state
    
    Best practice: Return {**state, "new_field": value}
    """
    llm = ChatOpenAI(model="gpt-4", temperature=0.7)
    
    # Create message from user input
    user_msg = HumanMessage(content=state["user_input"])
    
    # Get LLM response
    response = llm.invoke([user_msg])
    
    # Return updated state
    return {
        **state,  # Preserve existing state
        "messages": [user_msg, response]  # Add new messages
    }


# 3. BUILD THE GRAPH
def build_agent():
    """
    Build and compile the agent graph.
    
    Steps:
    1. Create StateGraph with your state schema
    2. Add nodes (functions that process state)
    3. Set entry point
    4. Add edges (connections between nodes)
    5. Compile and return
    """
    # Initialize graph
    workflow = StateGraph(AgentState)
    
    # Add nodes
    workflow.add_node("process", process_node)
    
    # Set entry point (first node to execute)
    workflow.set_entry_point("process")
    
    # Add edges (node connections)
    workflow.add_edge("process", END)  # END marks termination
    
    # Compile graph
    agent = workflow.compile()
    
    return agent


# 4. RUN THE AGENT
def run_agent(user_input: str):
    """
    Run the agent with user input.
    
    Args:
        user_input: User's message or request
    
    Returns:
        Final state containing messages and results
    """
    agent = build_agent()
    
    # Invoke agent with initial state
    result = agent.invoke({
        "user_input": user_input,
        "messages": []
    })
    
    return result


# 5. EXAMPLE USAGE
if __name__ == "__main__":
    # Run agent
    result = run_agent("Hello! What can you help me with?")
    
    # Get final response
    final_message = result["messages"][-1]
    print(f"Agent: {final_message.content}")
    
    # Example 2: Access full state
    print(f"\nFull state: {result}")
