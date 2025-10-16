import requests
from bs4 import BeautifulSoup

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