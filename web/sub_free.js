// ==========  工具函数  ==========
const USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36';

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

// ==========  各站抓取逻辑  ==========
const SOURCES = {
  // 米贝
  async mibei() {
    const root = await fetchText('https://www.mibei77.com');
    const links = parseLinks(root, 'article a');
    const latest = links[0];
    const page = await fetchText(latest);
    const txt = parseLinks(page, 'p', 'href').find(u => u.endsWith('.txt')) || '';
    const yaml = parseLinks(page, 'p', 'href').find(u => u.endsWith('.yaml')) || '';
    return { v2ray: txt, clash: yaml };
  },

  // 长风
  async changfeng() {
    const root = await fetchText('https://www.cfmem.com/');
    const links = parseLinks(root, 'h2 a');
    const latest = links[0];
    const page = await fetchText(latest);
    const base64 = (page.match(/节点Base64.*?<pre[^>]*>([^<]+)<\/pre>/is) || [])[1]?.trim() || '';
    const subs = parseLinks(page, 'div', 'href');
    return {
      base64,
      v2ray: subs[0] || '',
      clash: subs[1] || '',
      mihomo: subs[2] || '',
      singbox: subs[3] || '',
    };
  },

  // 以下站点结构类似，只给出最简实现，可按需补全
  async nodefree() {
    const root = await fetchText('https://nodefree.org');
    const links = parseLinks(root, 'h2 a');
    const page = await fetchText(links[0]);
    const txt = parseLinks(page, 'p', 'href').find(u => u.endsWith('.txt')) || '';
    const yaml = parseLinks(page, 'p', 'href').find(u => u.endsWith('.yaml')) || '';
    return { v2ray: txt, clash: yaml };
  },

  async v2rayshare() {
    const root = await fetchText('https://v2rayshare.com/');
    const links = parseLinks(root, 'div.list-body a');
    const page = await fetchText(links[0]);
    const txt = parseLinks(page, 'p', 'href').find(u => u.endsWith('.txt')) || '';
    const yaml = parseLinks(page, 'p', 'href').find(u => u.endsWith('.yaml')) || '';
    return { v2ray: txt, clash: yaml };
  },

  async openrunner() {
    const root = await fetchText('https://freenode.openrunner.net/');
    const links = parseLinks(root, 'a.mb-5');
    const page = await fetchText(links[0]);
    const codes = (page.match(/<code[^>]*>([^<]+)<\/code>/g) || []).map(c => c.replace(/<[^>]+>/g, ''));
    const txt = codes.find(c => c.trim().endsWith('.txt')) || '';
    const yaml = codes.find(c => c.trim().endsWith('.yaml')) || '';
    return { v2ray: txt, clash: yaml };
  },

  async clashnode() {
    const root = await fetchText('https://clashnode.cc');
    const links = parseLinks(root, 'main a');
    const page = await fetchText(links[0]);
    const ps = (page.match(/<p[^>]*>([^<]+)<\/p>/g) || []).map(p => p.replace(/<[^>]+>/g, ''));
    return {
      v2ray: ps.find(t => t.endsWith('.txt')) || '',
      clash: ps.find(t => t.endsWith('.yaml')) || '',
      singbox: ps.find(t => t.endsWith('.json')) || '',
    };
  },
};

// ==========  路由表  ==========
const ROUTER = {
  '/c/:site':  'clash',
  '/v/:site':  'v2ray',
  '/s/:site':  'singbox',
  '/m/:site':  'mihomo',
  '/b/changfeng': 'base64',
};

// ==========  主入口  ==========
addEventListener('fetch', event => {
  event.respondWith(handle(event.request));
});

async function handle(req) {
  const url = new URL(req.url);
  const path = url.pathname;

  // 首页用法
  if (path === '/') {
    const host = url.origin;
    const html = `<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>免费订阅中转</title></head>
<body>
<h1>用法列表（直接点击或复制到客户端）</h1>
<h3>米贝</h3>
<ul><li><a href="${host}/c/mibei" target="_blank">Clash</a></li>
    <li><a href="${host}/v/mibei" target="_blank">V2Ray</a></li></ul>
<h3>长风</h3>
<ul><li><a href="${host}/c/changfeng" target="_blank">Clash</a></li>
    <li><a href="${host}/v/changfeng" target="_blank">V2Ray</a></li>
    <li><a href="${host}/s/changfeng" target="_blank">SingBox</a></li>
    <li><a href="${host}/m/changfeng" target="_blank">Mihomo</a></li>
    <li><a href="${host}/b/changfeng" target="_blank">Base64</a></li></ul>
<h3>NodeFree</h3>
<ul><li><a href="${host}/c/nodefree" target="_blank">Clash</a></li>
    <li><a href="${host}/v/nodefree" target="_blank">V2Ray</a></li></ul>
<h3>V2rayShare</h3>
<ul><li><a href="${host}/c/v2rayshare" target="_blank">Clash</a></li>
    <li><a href="${host}/v/v2rayshare" target="_blank">V2Ray</a></li></ul>
<h3>OpenRunner</h3>
<ul><li><a href="${host}/c/openrunner" target="_blank">Clash</a></li>
    <li><a href="${host}/v/openrunner" target="_blank">V2Ray</a></li></ul>
<h3>ClashNode</h3>
<ul><li><a href="${host}/c/clashnode" target="_blank">Clash</a></li>
    <li><a href="${host}/v/clashnode" target="_blank">V2Ray</a></li>
    <li><a href="${host}/s/clashnode" target="_blank">SingBox</a></li></ul>
</body></html>`;
    return new Response(html, { headers: { 'content-type': 'text/html;charset=utf-8' } });
  }

  // 匹配路由
  for (const [pattern, type] of Object.entries(ROUTER)) {
    const reg = new RegExp(`^${pattern.replace(':site', '([\\w-]+)')}$`);
    const m = path.match(reg);
    if (!m) continue;
    const site = m[1];
    if (!SOURCES[site]) return notFound();

    try {
      const data = await SOURCES[site]();
      let url = '';
      if (type === 'base64') url = data.base64;
      else url = data[type];
      if (!url) return notFound();
      // 直接 302 到真实订阅地址（减少 Workers 流量）
      return Response.redirect(url, 302);
    } catch (e) {
      return new Response(`后端抓取失败: ${e.message}`, { status: 502 });
    }
  }

  return notFound();
}

function notFound() {
  return new Response('404 Not Found', { status: 404 });
}
