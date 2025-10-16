'''
#!/usr/bin/env bash
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

'''

from fastapi import FastAPI, HTTPException
from fastapi.responses import PlainTextResponse, HTMLResponse

from bs4 import BeautifulSoup
import httpx
from urllib.parse import urljoin

app = FastAPI(title="Free Node API", version="1.1")

BASE = "https://www.mibei77.com"

async def fetch_text(url: str) -> str:
    async with httpx.AsyncClient() as client:
        r = await client.get(url, timeout=10)
        r.raise_for_status()
        return r.text
    
def get_urls_mibei():
    r = httpx.get(BASE)
    soup = BeautifulSoup(r.content, "lxml")
    main = soup.find("div", id="main")
    return [urljoin(BASE, a["href"]) for a in main.find_all("article") if a.find("a")]

def get_sub_mibei(url: str):
    r = httpx.get(url)
    soup = BeautifulSoup(r.content, "lxml")
    body = soup.find("div", id="post-body")
    txt = yaml = ""
    for p in body.find_all("p"):
        t = p.get_text(strip=True)
        if t.endswith(".txt"): txt = t
        if t.endswith(".yaml"): yaml = t
    return txt, yaml

def make_routes(url_fetcher, sub_fetcher, idx: int = 0):
    async def clash():
        try:
            url = sub_fetcher(url_fetcher()[idx])[1]
            return PlainTextResponse(await fetch_text(url))
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))

    async def v2ray():
        try:
            url = sub_fetcher(url_fetcher()[idx])[0]
            return PlainTextResponse(await fetch_text(url))
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))

    return clash, v2ray

sources = {
    "mibei": (get_urls_mibei, get_sub_mibei),
    # "changfeng": (get_urls_changfeng, get_sub_changfeng),
    # "v2rayshare": (get_urls_v2rayshare, get_sub_v2rayshare),
    # "nodefree": (get_urls_nodefree, get_sub_nodefree),
    # "openrunner": (get_urls_openrunner, get_sub_openrunner),
    # "clashnode": (get_urls_clashnode, get_sub_clashnode),
}

for name, (uf, sf) in sources.items():
    clash, v2ray = make_routes(uf, sf)
    app.get(f"/c/{name}", summary=f"Clash config from {name}")(clash)
    app.get(f"/v/{name}", summary=f"V2Ray config from {name}")(v2ray)

@app.get("/", response_class=HTMLResponse)
async def index():
    return """
    <h1>Free Node API</h1>
    <p><a href="/docs">📘 API Docs</a> | <a href="/redoc">📙 ReDoc</a></p>
    <ul>
        <li><a href="/c/mibei">Clash - 米贝</a></li>
        <li><a href="/v/mibei">V2Ray - 米贝</a></li>
        <li><a href="/c/changfeng">Clash - 长风</a></li>
        <li><a href="/v/changfeng">V2Ray - 长风</a></li>
        <li><a href="/c/clashnode">Clash - ClashNode</a></li>
        <li><a href="/v/clashnode">V2Ray - ClashNode</a></li>
    </ul>
    """
