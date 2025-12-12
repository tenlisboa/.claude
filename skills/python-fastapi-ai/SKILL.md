---
name: python-fastapi-ai
description: Python FastAPI patterns, Alembic migrations, Pydantic v2, and AI Engineering (raw patterns, LangChain, Google ADK). Use when working with Python APIs, database migrations, or AI/LLM applications.
allowed-tools: Read, Grep, Glob, Bash
---

# Helper Scripts Available:

- `scripts/linter-formatter.sh` - Formats Python code with ruff, always execute with --help flag first

# FastAPI Development Patterns

## Project Structure

### Module-Functionality Structure (Recommended for larger apps)

```
app/
├── core/
│   ├── config.py      # Settings with pydantic-settings
│   ├── security.py    # Auth utilities
│   └── deps.py        # Shared dependencies
├── models/            # SQLAlchemy models
├── schemas/           # Pydantic schemas
├── api/
│   ├── v1/
│   │   ├── endpoints/
│   │   └── router.py
│   └── deps.py
├── services/          # Business logic
├── repositories/      # Data access layer
└── main.py
```

## Async Best Practices

### Route Definition

- Use `async def` for I/O-bound operations (DB, HTTP calls)
- Use `def` for CPU-bound operations (FastAPI runs in threadpool)
- Never mix blocking calls in async routes

```python
@router.get("/users/{user_id}")
async def get_user(user_id: int, db: AsyncSession = Depends(get_db)):
    return await user_service.get_by_id(db, user_id)

@router.post("/process")
def process_cpu_intensive(data: ProcessRequest):
    return heavy_computation(data)
```

### Async Patterns

```python
async def fetch_multiple():
    async with httpx.AsyncClient() as client:
        tasks = [client.get(url) for url in urls]
        return await asyncio.gather(*tasks)

async with asyncio.TaskGroup() as tg:
    task1 = tg.create_task(fetch_data())
    task2 = tg.create_task(process_data())
```

## Dependencies

### Reusable Dependencies

```python
async def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: AsyncSession = Depends(get_db)
) -> User:
    return await auth_service.validate_token(db, token)

CurrentUser = Annotated[User, Depends(get_current_user)]

@router.get("/me")
async def read_current_user(user: CurrentUser):
    return user
```

### Dependency for Validation

```python
async def valid_post_id(post_id: UUID, db: AsyncSession = Depends(get_db)) -> Post:
    post = await post_repo.get(db, post_id)
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")
    return post

ValidPost = Annotated[Post, Depends(valid_post_id)]
```

## Service Layer Pattern

- Controllers should be thin (max 10 lines)
- Business logic lives in Service classes

```python
class UserService:
    def __init__(self, user_repo: UserRepository, email_service: EmailService):
        self.user_repo = user_repo
        self.email_service = email_service

    async def create_user(self, db: AsyncSession, data: UserCreate) -> User:
        if await self.user_repo.get_by_email(db, data.email):
            raise DuplicateEmailError()
        user = await self.user_repo.create(db, data)
        await self.email_service.send_welcome(user.email)
        return user
```

# Pydantic v2 Best Practices

## Schema Design

```python
from pydantic import BaseModel, Field, EmailStr, ConfigDict
from typing import Annotated

class UserBase(BaseModel):
    email: EmailStr
    name: Annotated[str, Field(min_length=1, max_length=100)]

class UserCreate(UserBase):
    password: Annotated[str, Field(min_length=8)]

class UserResponse(UserBase):
    id: int
    model_config = ConfigDict(from_attributes=True)

class UserUpdate(BaseModel):
    email: EmailStr | None = None
    name: str | None = None
```

## Validators

```python
from pydantic import field_validator, model_validator

class OrderCreate(BaseModel):
    items: list[OrderItem]
    discount_code: str | None = None

    @field_validator("items")
    @classmethod
    def validate_items_not_empty(cls, v):
        if not v:
            raise ValueError("Order must have at least one item")
        return v

    @model_validator(mode="after")
    def validate_total(self):
        if self.total < 0:
            raise ValueError("Total cannot be negative")
        return self
```

## Strict Types

```python
from pydantic import BaseModel, StrictInt, StrictStr

class StrictConfig(BaseModel):
    count: StrictInt
    name: StrictStr
```

# Alembic Migrations

## Setup & Configuration

```python
# alembic/env.py
from app.core.config import settings
from app.models import Base

config.set_main_option("sqlalchemy.url", settings.database_url)
target_metadata = Base.metadata
```

## Naming Conventions

- `create_users_table` - new tables
- `add_status_to_orders_table` - adding columns
- `drop_legacy_column_from_users` - removals

## Migration Best Practices

### Always Include Downgrade

```python
def upgrade():
    op.add_column("users", sa.Column("status", sa.String(50)))

def downgrade():
    op.drop_column("users", "status")
```

### Safe Non-Nullable Column Addition

```python
def upgrade():
    op.add_column("users", sa.Column("role", sa.String(50), nullable=True))
    op.execute("UPDATE users SET role = 'user' WHERE role IS NULL")
    op.alter_column("users", "role", nullable=False)
```

### Handle Renames Manually (Alembic sees DROP + ADD)

```python
def upgrade():
    op.alter_column("users", "old_name", new_column_name="new_name")
```

### Data Migrations with Inline Tables

```python
def upgrade():
    users = sa.table("users", sa.column("id"), sa.column("status"))
    op.execute(users.update().where(users.c.status == "old").values(status="new"))
```

## Workflow

```bash
alembic revision --autogenerate -m "add_status_to_orders"
alembic check
alembic upgrade head
alembic downgrade -1
```

# AI Engineering Patterns

## Raw Patterns (No Frameworks)

### Basic LLM Call Pattern

```python
import httpx

async def call_llm(messages: list[dict], model: str = "gpt-4") -> str:
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "https://api.openai.com/v1/chat/completions",
            headers={"Authorization": f"Bearer {settings.openai_api_key}"},
            json={"model": model, "messages": messages}
        )
        return response.json()["choices"][0]["message"]["content"]
```

### Conversation Memory (It's Just a List)

```python
class Conversation:
    def __init__(self, system_prompt: str):
        self.messages = [{"role": "system", "content": system_prompt}]

    async def chat(self, user_input: str) -> str:
        self.messages.append({"role": "user", "content": user_input})
        response = await call_llm(self.messages)
        self.messages.append({"role": "assistant", "content": response})
        return response
```

### Tool Calling Pattern

```python
tools = [
    {
        "type": "function",
        "function": {
            "name": "get_weather",
            "description": "Get weather for a location",
            "parameters": {
                "type": "object",
                "properties": {"location": {"type": "string"}},
                "required": ["location"]
            }
        }
    }
]

async def call_with_tools(messages: list[dict]) -> dict:
    response = await client.post(
        "https://api.openai.com/v1/chat/completions",
        json={"model": "gpt-4", "messages": messages, "tools": tools}
    )
    result = response.json()["choices"][0]
    if result.get("finish_reason") == "tool_calls":
        return await execute_tools(result["message"]["tool_calls"])
    return result["message"]["content"]
```

### RAG Pattern

```python
async def rag_query(query: str, documents: list[str]) -> str:
    query_embedding = await get_embedding(query)
    relevant_docs = find_similar(query_embedding, documents, top_k=3)
    context = "\n".join(relevant_docs)

    messages = [
        {"role": "system", "content": f"Answer based on context:\n{context}"},
        {"role": "user", "content": query}
    ]
    return await call_llm(messages)

async def get_embedding(text: str) -> list[float]:
    response = await client.post(
        "https://api.openai.com/v1/embeddings",
        json={"model": "text-embedding-3-small", "input": text}
    )
    return response.json()["data"][0]["embedding"]
```

### Chunking Strategies

```python
def fixed_chunk(text: str, size: int = 500, overlap: int = 50) -> list[str]:
    chunks = []
    for i in range(0, len(text), size - overlap):
        chunks.append(text[i:i + size])
    return chunks

def semantic_chunk(text: str) -> list[str]:
    paragraphs = text.split("\n\n")
    return [p.strip() for p in paragraphs if p.strip()]
```

## LangChain Patterns

### Basic Chain

```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate

llm = ChatOpenAI(model="gpt-4")
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful assistant."),
    ("human", "{input}")
])
chain = prompt | llm
response = await chain.ainvoke({"input": "Hello"})
```

### RAG with LangChain

```python
from langchain_openai import OpenAIEmbeddings
from langchain_community.vectorstores import Chroma
from langchain.chains import RetrievalQA

embeddings = OpenAIEmbeddings()
vectorstore = Chroma.from_documents(documents, embeddings)
retriever = vectorstore.as_retriever(search_kwargs={"k": 3})

qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    retriever=retriever,
    return_source_documents=True
)
```

### LangGraph Agent

```python
from langgraph.graph import StateGraph, END
from typing import TypedDict

class AgentState(TypedDict):
    messages: list
    next_action: str

def should_continue(state: AgentState) -> str:
    if state["next_action"] == "end":
        return END
    return "agent"

graph = StateGraph(AgentState)
graph.add_node("agent", agent_node)
graph.add_node("tools", tool_node)
graph.add_conditional_edges("agent", should_continue)
graph.set_entry_point("agent")
app = graph.compile()
```

### Production Best Practices

- Use LangSmith for tracing and debugging
- Implement caching (SQLite/Redis) for repeated queries
- Batch operations (10-20 items) for throughput
- Human-in-the-loop for critical decisions

## Google ADK Patterns

### Basic Agent

```python
from google.adk.agents import Agent
from google.adk.tools import FunctionTool

def get_weather(location: str) -> str:
    """Get weather for a location.

    Args:
        location: City name or coordinates

    Returns:
        Weather description for the location
    """
    return f"Weather in {location}: Sunny, 22°C"

weather_tool = FunctionTool(get_weather)

root_agent = Agent(
    name="weather_agent",
    model="gemini-2.0-flash",
    instruction="Help users with weather queries",
    tools=[weather_tool]
)
```

### Multi-Agent System

```python
from google.adk.agents import Agent, SequentialAgent

researcher = Agent(
    name="researcher",
    model="gemini-2.0-flash",
    instruction="Research and gather information"
)

writer = Agent(
    name="writer",
    model="gemini-2.0-flash",
    instruction="Write based on research findings"
)

pipeline = SequentialAgent(
    name="content_pipeline",
    agents=[researcher, writer]
)
```

### Tool Docstring (Critical)

```python
def search_database(query: str, limit: int = 10) -> list[dict]:
    """Search the database for relevant records.

    The LLM uses this docstring to understand when and how to call
    this tool. Be specific about parameters and return values.

    Args:
        query: Search query string
        limit: Maximum number of results to return (default: 10)

    Returns:
        List of matching records with id, title, and content fields
    """
    pass
```

# Security Checklist

- [ ] Use environment variables for secrets (pydantic-settings)
- [ ] Validate all inputs with Pydantic models
- [ ] Use OAuth2/JWT authentication
- [ ] Configure CORS properly
- [ ] Use HTTPS in production
- [ ] Implement rate limiting
- [ ] Sanitize LLM outputs before execution
- [ ] PII detection/redaction for LLM inputs

# Performance

- Use async database drivers (asyncpg, aiomysql)
- Enable connection pooling
- Cache embeddings and repeated LLM calls
- Use `asyncio.gather()` for parallel operations
- Batch vector store operations
- Profile with py-spy or yappi
