from fastapi import FastAPI, HTTPException
from fastapi.responses import PlainTextResponse, HTMLResponse
from scrapers import (
    get_sub_mibei, get_urls_mibei,
    get_sub_changfeng, get_urls_changfeng,
    get_sub_v2rayshare, get_urls_v2rayshare,
    get_sub_nodefree, get_urls_nodefree,
    get_sub_openrunner, get_urls_openrunner,
    get_sub_clashnode, get_urls_clashnode
)
from utils.fetch import fetch_text

app = FastAPI(title="Free Node API", version="1.0")

# ========== 通用路由工厂 ==========
def make_node_route(url_fetcher, sub_fetcher, index: int = 0):
    async def clash_route():
        try:
            url = sub_fetcher(url_fetcher()[index])[1]  # clash
            return PlainTextResponse(await fetch_text(url))
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))

    async def v2ray_route():
        try:
            url = sub_fetcher(url_fetcher()[index])[0]  # v2ray
            return PlainTextResponse(await fetch_text(url))
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))

    return clash_route, v2ray_route

# ========== 动态注册路由 ==========
sources = {
    "mibei": (get_urls_mibei, get_sub_mibei),
    "changfeng": (get_urls_changfeng, get_sub_changfeng),
    "v2rayshare": (get_urls_v2rayshare, get_sub_v2rayshare),
    "nodefree": (get_urls_nodefree, get_sub_nodefree),
    "openrunner": (get_urls_openrunner, get_sub_openrunner),
    "clashnode": (get_urls_clashnode, get_sub_clashnode),
}

for name, (url_fetcher, sub_fetcher) in sources.items():
    clash_handler, v2ray_handler = make_node_route(url_fetcher, sub_fetcher)
    app.get(f"/c/{name}", summary=f"Get Clash config from {name}")(clash_handler)
    app.get(f"/v/{name}", summary=f"Get V2Ray config from {name}")(v2ray_handler)

# ========== 使用说明 ==========
@app.get("/", response_class=HTMLResponse)
async def usage():
    host_url = "http://localhost:8000"
    return f"""
    <h1>Free Node API</h1>
    <ul>
        <li><a href="/docs">API Docs</a></li>
        <li><a href="/redoc">ReDoc</a></li>
    </ul>
    <h2>Examples</h2>
    <ul>
        <li><a href="{host_url}/c/mibei">Clash - 米贝</a></li>
        <li><a href="{host_url}/v/mibei">V2Ray - 米贝</a></li>
        <li><a href="{host_url}/c/changfeng">Clash - 长风</a></li>
        <li><a href="{host_url}/v/changfeng">V2Ray - 长风</a></li>
    </ul>
    """
