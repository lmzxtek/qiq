// ==========  工具函数  ==========
const USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36';

// 简单 HTML 解析：返回第一个匹配属性的数组
function parseLinks(html, selector, attr = 'href') {
  const regex = new RegExp(`${attr}=["']([^"']+)["']`, 'g');
  const out = [];
  let m;
  while ((m = regex.exec(html)) !== null) {
    if (m[1].startsWith('http')) out.push(m[1]);
  }
  return out;
}

// 统一 fetch 包装：自动带 UA、10 s 超时
async function fetchText(url, opts = {}) {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), 10000);
  try {
    const res = await fetch(url, {
      headers: { 'User-Agent': USER_AGENT },
      signal: controller.signal,
      ...opts,
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return await res.text();
  } finally {
    clearTimeout(timer);
  }
}

export const changfeng = async () => {
  const root = await fetchText("https://www.cfmem.com/");
  const links = parseLinks(root, "h2 a");
  const latest = links[0];
  const page = await fetchText(latest);
  const base64 =
    (page.match(/节点Base64.*?<pre[^>]*>([^<]+)<\/pre>/is) || [])[1]?.trim() ||
    "";
  const subs = parseLinks(page, "div", "href");
  return {
    base64,
    v2ray: subs[0] || "",
    clash: subs[1] || "",
    mihomo: subs[2] || "",
    singbox: subs[3] || "",
  };
};


export const mibei = async () => {
    const root = await fetchText('https://www.mibei77.com');
    const links = parseLinks(root, 'article a')
    const latest = links[0];
    console.log(links);

    const page = await fetchText(latest);
    const txt = parseLinks(page, 'p', 'href').find(u => u.endsWith('.txt')) || '';
    const yaml = parseLinks(page, 'p', 'href').find(u => u.endsWith('.yaml')) || '';
    return { v2ray: txt, clash: yaml };
  }

// const rsp = await changfeng();
const rsp = await mibei();
console.log(rsp);