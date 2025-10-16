import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin 

def get_urls_clashnode():
    '''     获取链接中的文章的子链接     '''
    # 发送HTTP请求获取网页内容
    url = "https://www.freeclashnode.com/" 
    url = "https://clashnode.cc" 
    
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36"
        }
    response = requests.get(url,headers=headers)
    html_content = response.content

    # 使用BeautifulSoup解析网页内容
    soup = BeautifulSoup(html_content, "html.parser")

    # 查找id为"main"的<div>元素
    main_div = soup.find("main",)    
    articles = []
    if main_div: 
        articles = main_div.find_all("div",class_='item-heading pb-2')
        # print(articles)

    links = []
    # 打印找到的<article>元素
    for article in articles:
        link = article.find("a")
        if link: 
            # 获取链接的hre属性
            href = link.get("href").strip()
            links.append(href)
            # print(href)
    
    if len(links)>0: 
        links = [urljoin(url,route) for route in links]
    return links 


def get_sub_clashnode(url):
    """
    查找链接中网页的v2ray和clash订阅地址
    
    注：这个网站包含米贝的节点
    
    返回:
        字符串数组: v2ray订阅链接, clash订阅链接
    """
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36"
        }
    # 发送HTTP请求获取链接对应的网页内容
    response = requests.get(url,headers=headers)
    html_content = response.content

    # 使用BeautifulSoup解析网页内容
    soup = BeautifulSoup(html_content, "html.parser")
    # app = soup.find("div", id="app")
    # 定位 <h2> 的文本内容为 "订阅链接"
    h2 = soup.find("h2", string="订阅链接")
    
    # 获取 <h2> 到下一个 <hr> 之间的内容
    ps = []
    if h2:
        current = h2.find_next_sibling()
        while current and current.name != "hr":
            if current.name == "p" and "https://" in current.text:  # 判断是否是 <p> 且包含 HTTPS 链接
                ps.append(current.text.strip())
            current = current.find_next_sibling()
    # ps = app.find_all("p")
    
    print(ps)

    url_v2ray = []
    url_clash = []
    url_singbox = []
    
    # 遍历<p>元素
    for text in ps:
        # 判断文本内容是否符合条件
        if text.endswith(".txt"):
            url_v2ray.append(text )
        if text.endswith(".yaml"):
            url_clash.append(text )
        if text.endswith(".json"):
            url_singbox.append(text )
    
    return url_v2ray,url_clash,url_singbox
