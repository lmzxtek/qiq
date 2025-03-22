'''
获取下载链接地址函数

'''
from urllib.parse import urljoin 
from bs4 import BeautifulSoup
import requests


def extract_url_from_string(string):
    """ 
    提取字符串中的url链接
    """
    import re 
    
    pattern = r'(https?://\S+)'
    match = re.search(pattern, string)
    if match:
        return match.group(1)
    else:
        return None
    
    
def get_urls_mibei():
    '''     获取链接中的文章的子链接     '''
    url = "https://www.mibei77.com"
    # 发送HTTP请求获取网页内容
    response = requests.get(url)
    html_content = response.content

    # 使用BeautifulSoup解析网页内容
    soup = BeautifulSoup(html_content, "html.parser")

    # 查找id为"main"的<div>元素
    main_div = soup.find("div", id="main")

    # 查找所有<article>元素
    articles = main_div.find_all("article")

    links = []
    # 打印找到的<article>元素
    for article in articles:
        link = article.find("a")
        if link: 
            # 获取链接的hre属性
            href = link.get("href")
            links.append(href)
            # print(href)
            
    return links


def get_sub_mibei(url):
    """
    查找链接中网页的v2ray和clash订阅地址

    返回:
        字符串数组: v2ray订阅链接, clash订阅链接
        
    eg.: 
        -   urlv,urlc = get_sub_mibei(get_urls_mibei()[0])
        -   print(urlv)
        -   print(urlc)
    """
    # 发送HTTP请求获取链接对应的网页内容
    response = requests.get(url)
    html_content = response.content

    # 使用BeautifulSoup解析网页内容
    soup = BeautifulSoup(html_content, "html.parser")

    # 查找id为"post-body"的<div>元素
    post_body_div = soup.find("div", id="post-body")

    # 查找<div>元素内的所有<p>元素
    paragraphs = post_body_div.find_all("p")

    urlv2ray = ''
    urlclash = ''
    
    # 遍历<p>元素
    for paragraph in paragraphs:
        # 获取<p>元素的文本内容
        text = paragraph.get_text()

        # 判断文本内容是否符合条件
        if text.endswith(".txt"):
            urlv2ray = text 
        if text.endswith(".yaml"):
            urlclash = text 
            
    return urlv2ray,urlclash


def get_urls_changfeng():
    '''     获取链接中的文章的子链接     '''
    # 发送HTTP请求获取网页内容
    url = "https://www.cfmem.com/"  
    
    response = requests.get(url)
    html_content = response.content

    # 使用BeautifulSoup解析网页内容
    soup = BeautifulSoup(html_content, "html.parser")

    # 查找id为"main"的<div>元素
    main_div = soup.find("div", id="main")

    # 查找所有<article>元素
    # articles = main_div.find_all("article")
    # 查找所有<h2>元素
    articles = main_div.find_all("h2")

    links = []
    # 打印找到的<article>元素
    for article in articles:
        link = article.find("a")
        if link: 
            # 获取链接的hre属性
            href = link.get("href")
            links.append(href)
            # print(href)
            
    return links 


def get_sub_changfeng(url):
    """
    查找链接中网页的v2ray和clash订阅地址

    返回:
        字符串数组: v2ray订阅链接, clash订阅链接
    """

    base64ss   = ''
    url_v2ray  = ''
    url_clash  = ''
    url_mihomo = ''
    url_sb     = ''

    # 发送HTTP请求获取链接对应的网页内容
    response = requests.get(url)
    html_content = response.content

    # 使用BeautifulSoup解析网页内容
    soup = BeautifulSoup(html_content, "html.parser")

    # 查找id为"post-body"的<div>元素
    post_body_div = soup.find("div", id="post-body")

    # 定位 h2 下的 pre 元素
    header = post_body_div.find("h2", string="节点Base64")
    if header:
        target_element = header.find_next("pre")
        if target_element:
            base64ss = target_element.text
            # print(target_element.text)
    
    # 定位 h2 下的 pre 元素
    header = post_body_div.find("h2", string="订阅链接")
    parent_div = header.find_next_sibling("div")
    if parent_div:
        # 查找目标父 <div> 中的所有子 <div>
        all_sub_divs = parent_div.find_all("div", recursive=False)
        res = []
        for div in all_sub_divs:
            uuu = extract_url_from_string(div.text.strip())
            res.append(uuu)
            # print(uuu)
            
        if len(res)>0: 
            url_v2ray  = res[0]
            url_clash  = res[1]
            url_mihomo = res[2]
            url_sb     = res[3]
    
    return base64ss,url_v2ray,url_clash,url_mihomo,url_sb

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


def get_urls_nodefree():
    '''     获取链接中的文章的子链接     '''
    url = "https://nodefree.org"
    # 发送HTTP请求获取网页内容
    response = requests.get(url)
    html_content = response.content

    # 使用BeautifulSoup解析网页内容
    soup = BeautifulSoup(html_content, "html.parser")

    # 查找id为"main"的<div>元素
    main_div = soup.find("div", id="wrap")

    # 查找所有<article>元素
    # articles = main_div.find_all("article")
    # 查找所有<h2>元素
    articles = main_div.find_all("h2")

    links = []
    # 打印找到的<article>元素
    for article in articles:
        link = article.find("a")
        if link: 
            # 获取链接的hre属性
            href = link.get("href")
            links.append(href)
            # print(href)
            
    return links 

def get_sub_nodefree(url):
    """
    查找链接中网页的v2ray和clash订阅地址

    返回:
        字符串数组: v2ray订阅链接, clash订阅链接
    """
    # 发送HTTP请求获取链接对应的网页内容
    response = requests.get(url)
    html_content = response.content

    # 使用BeautifulSoup解析网页内容
    soup = BeautifulSoup(html_content, "html.parser")

    # 查找id为"post-body"的<div>元素
    post_body_div = soup.find("div", id="wrap")

    # 查找<div>元素内的所有<p>元素
    paragraphs = post_body_div.find_all("p")

    urlv2ray = ''
    urlclash = ''
    
    # 遍历<p>元素
    for paragraph in paragraphs:
        # 获取<p>元素的文本内容
        text = paragraph.get_text()

        # 判断文本内容是否符合条件
        if text.endswith(".txt"):
            urlv2ray = text 
        if text.endswith(".yaml"):
            urlclash = text 
            
    return urlv2ray,urlclash


def get_urls_v2rayshare():
    '''     获取链接中的文章的子链接     '''
    url = "https://v2rayshare.com/"
    # 发送HTTP请求获取网页内容
    response = requests.get(url)
    html_content = response.content

    # 使用BeautifulSoup解析网页内容
    soup = BeautifulSoup(html_content, "html.parser")
    articles = soup.find_all("div", class_="list-body")

    links = []
    # 打印找到的<article>元素
    for article in articles:
        link = article.find("a")
        if link: 
            # 获取链接的hre属性
            href = link.get("href")
            links.append(href)
            # print(href)
            
    return links 
    
def get_sub_v2rayshare(url):
    """
    查找链接中网页的v2ray和clash订阅地址

    返回:
        字符串数组: v2ray订阅链接, clash订阅链接
    """

    # 发送HTTP请求获取链接对应的网页内容
    response = requests.get(url)
    html_content = response.content

    # 使用BeautifulSoup解析网页内容
    soup = BeautifulSoup(html_content, "html.parser")
    ps = soup.find_all("p")

    urlv2ray = ''
    urlclash = ''
    # 遍历<p>元素
    for p in ps:
        # 获取<div>元素的文本内容
        text = p.get_text()

        # 判断文本内容是否符合条件
        if text.endswith(".txt"):
            urlv2ray = text 
        if text.endswith(".yaml"):
            urlclash = text    
    
    return urlv2ray,urlclash


def get_urls_openrunner():
    '''     获取链接中的文章的子链接     '''
    url = "https://freenode.openrunner.net/"
    # 发送HTTP请求获取网页内容
    response = requests.get(url)
    html_content = response.content

    # 使用BeautifulSoup解析网页内容
    soup = BeautifulSoup(html_content, "html.parser")
    articles = soup.find_all("a", class_="mb-5")

    links = []
    # 打印找到的<article>元素
    for article in articles:
        link = url+article.get("href","");
        links.append(link);
            
    return links 
    
def get_sub_openrunner(url):
    """
    查找链接中网页的v2ray和clash订阅地址

    返回:
        字符串数组: v2ray订阅链接, clash订阅链接
    """

    # 发送HTTP请求获取链接对应的网页内容
    response = requests.get(url)
    html_content = response.content

    # 使用BeautifulSoup解析网页内容
    soup = BeautifulSoup(html_content, "html.parser")
    codes = soup.find_all("code")

    urlv2ray = ''
    urlclash = ''
    # 遍历<p>元素
    for p in codes:
        text = p.text.replace("\n","").replace(" ","")

        # 判断文本内容是否符合条件
        if text.endswith(".txt"):
            urlv2ray = text 
        if text.endswith(".yaml"):
            urlclash = text    
    
    return urlv2ray,urlclash
