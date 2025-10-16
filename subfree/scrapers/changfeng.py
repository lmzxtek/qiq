import requests
from bs4 import BeautifulSoup

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


