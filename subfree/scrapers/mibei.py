import requests
from bs4 import BeautifulSoup

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