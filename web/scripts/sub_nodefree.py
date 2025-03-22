# 爬取nodefree节点
import os
import requests
from bs4 import BeautifulSoup
def get_urls(url):
    '''     获取链接中的文章的子链接     '''
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


def get_sub(url):
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

def download_file(url, filename):
    '''下载链接中的文件，并将其保存为filename定义的文件名'''
    response = requests.get(url)
    if response.status_code == 200:
        with open(filename, "wb") as file:
            file.write(response.content)
        # print("文件已成功下载并保存为", filename)
    else:
        print("无法访问链接:", url)        

if __name__ == '__main__':
    url = "https://nodefree.org"  # 替换为您要访问的网页的URL
    
    links = get_urls(url)
    print("The latest link is :",links[0])

    uv,uc = get_sub(links[0])
    print("Subscript of v2ray: ", uv)
    print("Subscript of clash: ", uc)
    
    # 检查文件是否已存在，如果存在则删除
    if os.path.exists(uv):
        os.remove(uv)
        
    if os.path.exists(uc):
        os.remove(uc)
        
    download_file(uv,'nodefree-v2ray.txt')
    download_file(uc,'nodefree-clash.yaml')