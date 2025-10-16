'''
#!/usr/bin/env bash
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8333

'''

from fastapi import FastAPI, HTTPException
from fastapi.responses import PlainTextResponse, HTMLResponse

import toml,os 
import httpx,base64 
from bs4 import BeautifulSoup
from urllib.parse import urljoin

from cachetools import cached, TTLCache
from functools import lru_cache

from typing import Tuple,List

app = FastAPI(title="Free Node from WebSites", version="1.1")

urls = dict(
    mibei="https://www.mibei77.com" ,
    nodefree="https://nodefree.me" ,
    changfeng="https://www.cfmem.com"  ,
    v2rayshare="https://v2rayshare.net"  ,
    openrunner="https://freenode.openrunner.net", # 这个的V2Ray链接访问不了 
    # 下面2个链接是一样的，其中还包括了上面的3个
    clashnode="https://clashnode.cc"  ,
    freeclashnode="https://www.freeclashnode.com"  ,
)

#=========== Tools =====================

@lru_cache(maxsize=15)
def fetch_text_sync(url: str) -> str:
    with httpx.Client(timeout=15) as cli:
        r = cli.get(url)
        r.raise_for_status()
        return r.text
    
# @lru_cache(maxsize=10)
async def fetch_text_async(url: str) -> str:
    async with httpx.AsyncClient(timeout=15) as cli:
        r = await cli.get(url)
        r.raise_for_status()
        return r.text


# 设置60分钟缓存
@cached(cache=TTLCache(maxsize=2, ttl=3600))
def get_urls_mibei(url):
    r = httpx.get(url)
    
    # 使用兼容性更好的解析器
    soup = BeautifulSoup(r.text, "html.parser")
    articles = soup.select("div#main article")
    
    return [
        a["href"] 
        for article in articles 
        if (a := article.find("a", href=True))
    ]

@lru_cache(maxsize=2)
def get_sub_mibei(url: str):
    r = httpx.get(url)
    # soup = BeautifulSoup(r.content, "lxml")
    soup = BeautifulSoup(r.content, "html.parser")
    body = soup.find("div", id="post-body")
    txt = yaml = ""
    for p in body.find_all("p"):
        t = p.get_text(strip=True)
        if t.endswith(".txt"): txt = t
        elif t.endswith(".yaml"): yaml = t
    return txt, yaml

# 设置60分钟缓存
@cached(cache=TTLCache(maxsize=2, ttl=3600))
def get_urls_changfeng(url):
    r = httpx.get(url)
    
    # 使用兼容性更好的解析器
    soup = BeautifulSoup(r.text, "html.parser")
    articles = soup.select("div#main h2")
    
    return [
        a["href"] 
        for article in articles 
        if (a := article.find("a", href=True))
    ]

def extract_url_from_string(text: str) -> str:
    """原逻辑：从一段文字里提取第一个 https?:// 链接"""
    import re
    m = re.search(r'https?://\S+', text)
    return m.group(0) if m else ''


@lru_cache(maxsize=2)
def get_sub_changfeng(url: str) -> Tuple[str, str, str, str, str]:
    html = httpx.get(url, timeout=15).text
    # soup = BeautifulSoup(html, 'lxml')
    soup = BeautifulSoup(html, 'html.parser')

    post = soup.select_one('div#post-body')
    if not post: raise 

    # 1. Base64 节点块
    base64ss = ''
    # pre = post.select_one('h2:-soup-contains("节点Base64") + pre')
    pre = post.find("h2", string="节点Base64").find_next("pre")
    # print(pre)
    if pre:
        base64ss = pre.get_text(strip=True)

    # 2. 订阅链接块
    sub_div = post.select_one('h2:-soup-contains("订阅链接") + div')
    if not sub_div:
        return (base64ss, ) + ('', ) * 4

    # 按顺序提取 4 个链接（v2ray/clash/mihomo/singbox）
    links = []
    for d in sub_div.select(':scope > div'):   # 只取直接子 div
        links.append(extract_url_from_string(d.get_text(' ')))

    # 缺位自动补空串
    links.extend([''] * 4)
    v2ray, clash, mihomo, singbox = links[:4]

    return base64ss, v2ray, clash, mihomo, singbox


# 设置60分钟缓存
@cached(cache=TTLCache(maxsize=2, ttl=3600))
def get_urls_openrunner(url):
    r = httpx.get(url)
    
    # 使用兼容性更好的解析器
    soup = BeautifulSoup(r.text, "html.parser")
    articles = soup.find_all("a", class_="mb-5")
    print(len(articles),articles)
    
    return [
        urljoin(url, a["href"])
        for a in articles 
    ]

@lru_cache(maxsize=2)
def get_sub_openrunner(url: str):
    r = httpx.get(url)
    # soup = BeautifulSoup(r.content, "lxml")
    soup = BeautifulSoup(r.content, "html.parser")
    # body = soup.find("code")
    txt = yaml = ""
    for p in soup.find_all("code"):
        t = p.get_text(strip=True)
        if t.endswith(".txt"): txt = t
        elif t.endswith(".yaml"): yaml = t
    return txt, yaml

@cached(cache=TTLCache(maxsize=2, ttl=3600))
def get_urls_nodefree(url:str) -> List[str]:
    """
    获取 NodeFree 首页文章链接（绝对路径）
    默认入口：https://nodefree.org
    """
    # soup = _get_soup(entry)
    soup = BeautifulSoup(httpx.get(url, timeout=15).text, "html.parser")
    # h2 下直接 a 标签
    links = [urljoin(url, a["href"])
             for h2 in soup.select("section#boxmoe_theme_container h3")
             if (a := h2.find("a")) and a.get("href")]
    return links


@lru_cache(maxsize=2)
def get_sub_nodefree(url: str) -> Tuple[str, str]:
    soup = BeautifulSoup(httpx.get(url, timeout=15).text, "html.parser")
    post = soup.select_one("section#boxmoe_theme_container")
    if not post: raise 

    # 一次性拿到所有段落
    txt = yaml = ""
    for p in post.select("p"):
        text = p.get_text(" ", strip=True)
        if text.endswith(".txt"): txt = text
        elif text.endswith(".yaml"): yaml = text
    return txt, yaml


@cached(cache=TTLCache(maxsize=2, ttl=3600))
def get_urls_v2rayshare(url:str) -> List[str]:
    """
    获取 NodeFree 首页文章链接（绝对路径）
    默认入口：https://v2rayshare.com
    """
    soup = BeautifulSoup(httpx.get(url, timeout=15).text, "html.parser")
    articles = soup.select("div article")
    
    return [
        a["href"] 
        for article in articles 
        if (a := article.find("a", href=True))
    ]


@lru_cache(maxsize=2)
def get_sub_v2rayshare(url: str) -> Tuple[str, str]:
    
    soup = BeautifulSoup(httpx.get(url, timeout=15).text, "html.parser")
    if not soup: raise 

    # 一次性拿到所有段落
    txt = yaml = ""
    for p in soup.select("p"):
        text = p.get_text(" ", strip=True)
        if text.endswith(".txt"): txt = text
        elif text.endswith(".yaml"): yaml = text
        
    return txt, yaml


@cached(cache=TTLCache(maxsize=2, ttl=3600))
def get_urls_clashnode(url:str) -> List[str]:
    
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36"
        }
    
    soup = BeautifulSoup(httpx.get(url, timeout=30,headers=headers).text, "html.parser")
    articles = soup.select("div.panel-body")
    
    urls = [
        a["href"] 
        for article in articles 
        if (a := article.find("a", href=True))
    ]
    return [ urljoin(url, a) for a in urls if a.endswith(".htm")]

@lru_cache(maxsize=2)
def get_sub_clashnode(url: str):
    
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36"
        }
    
    soup = BeautifulSoup(httpx.get(url, timeout=30,headers=headers).text, "html.parser")
    if not soup: raise

    # 一次性拿到所有段落
    txt = []
    yaml = []
    json_list = []
    for p in soup.select("p"):
        text = p.get_text(" ", strip=True)
        if text.endswith(".txt"): txt.append(text)
        elif text.endswith(".yaml"): yaml.append(text)
        elif text.endswith(".json"): json_list.append(text)
        
    return txt, yaml,json_list


#=========== Route =====================
@app.get("/{type}/mb", 
         response_class=PlainTextResponse,
         summary="米贝",tags=["米贝",],
         description=f"米贝的V2Ray|Clash节点:  {urls['mibei']}",         
         )
async def route_mibei(    type: str ):
    url = urls["mibei"]

    urls_list = get_urls_mibei(url)
    urlv,urlc = get_sub_mibei(urls_list[0])

    if type == 'v': return fetch_text_sync(urlv)
    elif type == 'c': return fetch_text_sync(urlc)

    raise HTTPException(status_code=404, detail="Invalid node type: {type}")

#=========== Route =====================
@app.get("/{type}/cf", 
         response_class=PlainTextResponse,
         summary="长风",tags=["长风",],
         description=f"长风的V2Ray|Clash节点:  {urls['changfeng']}",         
         )
async def route_changfeng(    type: str ):
    url = urls["changfeng"]

    urls_list = get_urls_changfeng(url)
    base64ss, v2ray, clash, mihomo, singbox = get_sub_changfeng(urls_list[0])

    if type == 'v': return fetch_text_sync(v2ray)
    elif type == 'c': return fetch_text_sync(clash)

    raise HTTPException(status_code=404, detail="Invalid node type: {type}")

#=========== Route =====================
@app.get("/{type}/vs", 
         response_class=PlainTextResponse,
         summary="V2RayShare",tags=["V2RayShare",],
         description=f"V2RayShare的V2Ray|Clash节点:  {urls['v2rayshare']}",         
         )
async def route_varyshare(    type: str ):
    url = urls["v2rayshare"]

    urls_list = get_urls_v2rayshare(url)
    v2ray, clash = get_sub_v2rayshare(urls_list[0])

    if type == 'v': return fetch_text_sync(v2ray)
    elif type == 'c': return fetch_text_sync(clash)

    raise HTTPException(status_code=404, detail="Invalid node type: {type}")

#=========== Route =====================
@app.get("/{type}/nf", 
         response_class=PlainTextResponse,
         summary="NodeFree",tags=["NodeFree",],
         description=f"NodeFree的V2Ray|Clash节点:  {urls['nodefree']}",         
         )
async def route_nodefree(    type: str ):
    url = urls["nodefree"]

    urls_list = get_urls_nodefree(url)
    v2ray, clash = get_sub_nodefree(urls_list[0])

    if type == 'v': return fetch_text_sync(v2ray)
    elif type == 'c': return fetch_text_sync(clash)

    raise HTTPException(status_code=404, detail="Invalid node type: {type}")

#=========== Route =====================
@app.get("/{type}/or", 
         response_class=PlainTextResponse,
         summary="OpenRunner",tags=["OpenRunner",],
         description=f"OpenRunner的V2Ray|Clash节点:  {urls['openrunner']}",         
         )
async def route_openrunner(    type: str ):
    url = urls["openrunner"]

    urls_list = get_urls_openrunner(url)
    v2ray, clash = get_sub_openrunner(urls_list[0])

    if type == 'v': return fetch_text_sync(v2ray)
    elif type == 'c': return fetch_text_sync(clash)

    raise HTTPException(status_code=404, detail="Invalid node type: {type}")

#=========== Route =====================
@app.get("/{type}/cn", 
         response_class=PlainTextResponse,
         summary="ClashNode",tags=["ClashNode",],
         description=f"ClashNode的V2Ray|Clash节点:  {urls['clashnode']}",         
         )
async def route_clashnode(    type: str ):
    url = urls["clashnode"]

    urls_list = get_urls_clashnode(url)
    v2ray_list, clash_list,_ = get_sub_clashnode(urls_list[0])

    if type == 'v': return fetch_text_sync(v2ray_list[0])
    elif type == 'c': return fetch_text_sync(clash_list[0])

    raise HTTPException(status_code=404, detail="Invalid node type: {type}")


def load_nodes(fpath:str = "nodes.toml"):
    """    加载节点信息    """
    
    # 检查配置文件是否存在
    if not os.path.exists(fpath):
        print(f"节点文件 {fpath} 不存在")
        raise FileNotFoundError(f"文件 {fpath} 不存在")
    
    # 读取现有配置文件
    try: 
        with open(fpath, "r", encoding="utf-8") as f:
            cfg = toml.load(f)
        return cfg
    except Exception as e:
        print(f"加载节点配置文件失败: {e}") 
        return {}

@app.get("/sb/{tag}", 
         response_class=PlainTextResponse,
         summary="SingBox Nodes",tags=["SingBox",],
         description=f"QiQ的节点(singbox)", 
         )
async def route_mibei(tag: str,t:str ):
    cfg = load_nodes()

    if t!=cfg['TOKEN']:
        raise HTTPException(status_code=401, detail="Invalid token")

    if tag not in [ "all"] and tag not in cfg:
        raise HTTPException(status_code=404, detail=f"Invalid node tag: {tag}")

    nodes_list = []
    if tag=='all':
        for k,v in cfg.items():
            if k.strip() in ['TOKEN']: continue 
            
            # nodes = v.strip().split('\n')
            lines = [line.strip() for line in v.splitlines() if line.strip()]
            nodes_list.extend(lines)
    else: 
        # nodes_list = cfg[tag].strip().split('\n')
        nodes_list = [line.strip() for line in cfg[tag].splitlines() if line.strip()]
    
    nodes_list = list(set(nodes_list)) # 去重 
    result_str = '\n'.join(nodes_list).replace('hy2:','hysteria2:') 
    return base64.b64encode(result_str.encode()).decode()


#=========== Index =====================
@app.get("/", response_class=HTMLResponse,tags=['首页'])
async def index():
    return """
    <h1>Free Node from Web</h1>
    <p><a href="/docs">📘 API Docs</a> | <a href="/redoc">📙 ReDoc</a></p>
    <ul>
        <li><a href="/c/mb">Clash - 米贝</a></li>
        <li><a href="/v/mb">V2Ray - 米贝</a></li>
        <li><a href="/c/cf">Clash - 长风</a></li>
        <li><a href="/v/cf">V2Ray - 长风</a></li>
        <li><a href="/c/nf">Clash - NodeFree</a></li>
        <li><a href="/v/nf">V2Ray - NodeFree</a></li>
        <li><a href="/c/vs">Clash - V2RayShare</a></li>
        <li><a href="/v/vs">V2Ray - V2RayShare</a></li>
        <li><a href="/c/or">Clash - OpenRunner</a></li>
        <li><a href="/v/or">V2Ray - OpenRunner</a></li>
    </ul>
    """

#=========== Main =====================
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8300,reload=True)