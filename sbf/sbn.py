'''
#!/usr/bin/env bash
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8333

'''

from fastapi import FastAPI, HTTPException
from fastapi.responses import PlainTextResponse, HTMLResponse
import toml 
import os

app = FastAPI(title="Custom Nodes", version="0.1")

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


#=========== Route =====================
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

    if tag=='all':
        nodes = ""
        for k,v in cfg.items():
            if k.strip() in ['TOKEN']: continue 
            nodes += v
        return nodes

    return cfg[tag]

#=========== Index =====================
@app.get("/", response_class=HTMLResponse,tags=['首页'])
async def index():
    return """
    <h1>Free Node from Web</h1>
    <p><a href="/docs">📘 API Docs</a> | <a href="/redoc">📙 ReDoc</a></p>
    <ul>
        <li><a href="/sb/main">常用</a></li>
        <li><a href="/sb/all">所有</a></li>
    </ul>
    """

#=========== Main =====================
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8300,reload=True)