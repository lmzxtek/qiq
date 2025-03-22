# 爬取Clashnode.com节点
import os
import re 
import requests
from bs4 import BeautifulSoup

def get_urls(url):
    '''     获取链接中的文章的子链接     '''
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

def extract_url_from_string(string):
    """ 
    提取字符串中的url链接
    """
    pattern = r'(https?://\S+)'
    match = re.search(pattern, string)
    if match:
        return match.group(1)
    else:
        return None
    
    
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
    url = "https://v2rayshare.com/"  # 替换为您要访问的网页的URL
    
    links = get_urls(url)
    print("The latest link is :",links[0])

    uv,uc = get_sub(links[0])
    
    print("Subscript of  v2ray: ", uv)
    print("Subscript of  clash: ", uc)
    
    download_file(uv,'v2rayshare-v2ray.txt')
    download_file(uc,'v2rayshare-clash.yaml')