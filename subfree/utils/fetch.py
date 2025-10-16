import httpx

async def fetch_text(url: str) -> str:
    async with httpx.AsyncClient() as client:
        r = await client.get(url, timeout=10)
        r.raise_for_status()
        return r.text
