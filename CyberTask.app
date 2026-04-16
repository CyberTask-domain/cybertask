searchhub/
│
├── app/
│   ├── main.py
│   ├── search.py
│   ├── shopping.py
│   ├── ai.py
│   └── templates/
│       └── index.html
│
├── static/
│   └── style.css
│
├── requirements.txt
└── README.md
from fastapi import FastAPI, Request, Form
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

from .search import web_search
from .shopping import shopping_search
from .ai import ai_code_help

app = FastAPI()
templates = Jinja2Templates(directory="app/templates")

@app.get("/", response_class=HTMLResponse)
async def home(request: Request):
    return templates.TemplateResponse("index.html", {"request": request, "results": None})

@app.post("/search", response_class=HTMLResponse)
async def search(request: Request, query: str = Form(...), mode: str = Form(...)):
    if mode == "web":
        results = web_search(query)
    else:
        results = shopping_search(query)

    return templates.TemplateResponse("index.html", {
        "request": request,
        "results": results,
        "query": query,
        "mode": mode
    })

@app.post("/ai", response_class=HTMLResponse)
async def ai(request: Request, prompt: str = Form(...)):
    answer = ai_code_help(prompt)
    return templates.TemplateResponse("index.html", {
        "request": request,
        "ai_answer": answer,
        "prompt": prompt
    })
import requests

def web_search(query):
    # Replace with a real search API later
    return [
        {"title": "Example result 1", "url": f"https://www.google.com/search?q={query}"},
        {"title": "Example result 2", "url": f"https://duckduckgo.com/?q={query}"}
    ]
def shopping_search(query):
    # Replace with Amazon/eBay APIs later
    return [
        {"title": "Sample Product A", "price": "$19.99", "url": "https://amazon.com"},
        {"title": "Sample Product B", "price": "$29.99", "url": "https://ebay.com"}
    ]
def ai_code_help(prompt):
    # Replace with a real AI API later
    return f"AI suggestion for: {prompt}\n\n# Example code\nprint('Hello from AI!')"
<!DOCTYPE html>
<html>
<head>
    <title>SearchHub</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <h1>SearchHub</h1>

    <form method="POST" action="/search">
        <input name="query" placeholder="Search..." required>
        <select name="mode">
            <option value="web">Web Search</option>
            <option value="shop">Shopping Search</option>
        </select>
        <button type="submit">Go</button>
    </form>

    {% if results %}
        <h2>Results</h2>
        <ul>
            {% for r in results %}
                <li>
                    <a href="{{ r.url }}" target="_blank">{{ r.title }}</a>
                    {% if r.price %} - {{ r.price }}{% endif %}
                </li>
            {% endfor %}
        </ul>
    {% endif %}

    <h2>AI Coding Helper</h2>
    <form method="POST" action="/ai">
        <textarea name="prompt" rows="4" placeholder="Describe your coding problem..."></textarea>
        <button type="submit">Ask AI</button>
    </form>

    {% if ai_answer %}
        <pre>{{ ai_answer }}</pre>
    {% endif %}
</body>
</html>
body {
    background: #050810;
    color: #00ff88;
    font-family: Consolas, monospace;
    padding: 20px;
}

input, textarea, select, button {
    margin: 5px 0;
    padding: 8px;
}
fastapi
uvicorn
jinja2
requests
pip install -r requirements.txt
uvicorn app.main:app --reload
