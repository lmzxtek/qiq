'''
免费节点获取服务

poetry run hypercorn sub_free:app --bind 127.0.0.1:5333 --workers
poetry run hypercorn sub_free:app --bind 0.0.0.0:5333 --workers 9
poetry run hypercorn sub_free:app --bind [::]:5333 --workers 9
poetry run gunicorn sub_free:app -b 0.0.0.0:5333 -w 9

1Panel: deploy on Python Environment
run cmd: pip install poetry && poetry install && poetry run hypercorn sub_free:app --bind 0.0.0.0:5333 --workers 9


'''
from flask import Flask, request, jsonify, send_from_directory, request, abort
from pathlib import Path

from urllib.parse import urljoin 
from bs4 import BeautifulSoup
import requests

import os
import requests

from sub_url import * 


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


app = Flask(__name__)

HOST  = "localhost"
PORT  = 5003
DEBUG = False
DEBUG = True
FLD_DATA = 'data'

# # 指定文件根目录
# BASE_DIRECTORY = Path(FLD_DATA).resolve()

# # 检查文件根目录是否存在，如果不存在则创建
# BASE_DIRECTORY.mkdir(parents=True, exist_ok=True)

# fpath = f'{FLD_DATA}/test.txt'
# if not os.path.exists(fpath): 
#     with open(fpath, 'w') as file:
#         file.write(f' This is a file for remote url request test. ')

# def download_file_to_local(url, filename):
#     '''下载链接中的文件，并将其保存为filename定义的文件名'''
#     response = requests.get(url)
#     if response.status_code == 200:
#         with open(filename, "wb") as file:
#             file.write(response.content)
#         # print("文件已成功下载并保存为", filename)
#     else:
#         print("无法访问链接:", url)        
        
# @app.route('/download/<path:filepath>', methods=['GET'])
# def route_download_file(filepath):
#     # 将请求路径拼接到根目录，确保路径合法
#     file_path = (BASE_DIRECTORY / filepath).resolve()

#     # 确保文件路径在根目录内，防止目录遍历攻击
#     if not file_path.is_file() or BASE_DIRECTORY not in file_path.parents:
#         abort(404)  # 文件未找到则返回404错误

#     # 返回文件下载
#     return send_from_directory(BASE_DIRECTORY, filepath, as_attachment=True)

# # 文件上传（可选），允许将文件上传到服务器的子目录
# @app.route('/upload/<path:filepath>', methods=['POST'])
# def route_upload_file(filepath):
#     if 'file' not in request.files:
#         return "No file part", 400

#     file = request.files['file']
#     if file.filename == '':
#         return "No selected file", 400

#     # 将上传的文件保存到指定的子目录
#     upload_path = (BASE_DIRECTORY / filepath).resolve()
#     if BASE_DIRECTORY not in upload_path.parents:
#         abort(403)  # 禁止访问超出根目录的路径

#     # 创建子目录（如果不存在）
#     upload_path.parent.mkdir(parents=True, exist_ok=True)

#     # 保存文件
#     file.save(upload_path)
#     return "File uploaded successfully", 200


@app.route('/c/mibei', methods=['GET'])
def route_clash_mibei():
    
    urlv,urlc = get_sub_mibei(get_urls_mibei()[0])
    
    response = requests.get(urlc)
    
    if response.status_code == 200:
        # return response.content
        return response.text
    else: 
        return None

@app.route('/v/mibei', methods=['GET'])
def route_v2ray_mibei():
    
    urlv,urlc = get_sub_mibei(get_urls_mibei()[0])
    
    response = requests.get(urlv)
    
    if response.status_code == 200:
        # return response.content
        return response.text
    else: 
        return None

@app.route('/c/v2rayshare', methods=['GET'])
def route_clash_v2rayshare():
    
    urlv,urlc = get_sub_v2rayshare(get_urls_v2rayshare()[0])
    
    response = requests.get(urlc)
    
    if response.status_code == 200:
        # return response.content
        return response.text
    else: 
        return None

@app.route('/v/v2rayshare', methods=['GET'])
def route_v2ray_v2rayshare():
    
    urlv,urlc = get_sub_v2rayshare(get_urls_v2rayshare()[0])
    
    response = requests.get(urlv)
    
    if response.status_code == 200:
        # return response.content
        return response.text
    else: 
        return None

@app.route('/c/openrunner', methods=['GET'])
def route_clash_openrunner():
    
    urlv,urlc = get_sub_openrunner(get_urls_openrunner()[0])
    
    response = requests.get(urlc)
    
    if response.status_code == 200:
        # return response.content
        return response.text
    else: 
        return None

@app.route('/v/openrunner', methods=['GET'])
def route_v2ray_openrunner():
    
    urlv,urlc = get_sub_openrunner(get_urls_openrunner()[0])
    
    response = requests.get(urlv)
    
    if response.status_code == 200:
        # return response.content
        return response.text
    else: 
        return None

@app.route('/c/nodefree', methods=['GET'])
def route_clash_nodefree():
    
    urlv,urlc = get_sub_nodefree(get_urls_nodefree()[0])
    
    response = requests.get(urlc)
    
    if response.status_code == 200:
        # return response.content
        return response.text
    else: 
        return None

@app.route('/v/nodefree', methods=['GET'])
def route_v2ray_nodefree():
    
    urlv,urlc = get_sub_nodefree(get_urls_nodefree()[0])
    
    response = requests.get(urlv)
    
    if response.status_code == 200:
        # return response.content
        return response.text
    else: 
        return None

@app.route('/c/clashnode', methods=['GET'])
def route_clash_clashnode(): 
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36"
        }
    
    urlv,urlc,urls = get_sub_clashnode(get_urls_clashnode()[0])
    
    response = requests.get(urlc[0],headers=headers)
    
    if response.status_code == 200:
        # return response.content
        return response.text
    else: 
        return None

@app.route('/v/clashnode', methods=['GET'])
def route_v2ray_clashnode():    
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36"
        }
    urlv,urlc,urls = get_sub_clashnode(get_urls_clashnode()[0])
    
    url = urlv[0]
    response = requests.get(url,headers=headers)
    if DEBUG: print(f'url: {url}')
    
    if response.status_code == 200:
        # return response.content
        return response.text
    else: 
        return None

@app.route('/s/clashnode', methods=['GET'])
def route_singbox_clashnode(): 
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36"
        }
    
    urlv,urlc,urls = get_sub_clashnode(get_urls_clashnode()[0])
    
    response = requests.get(urls[0],headers=headers)
    
    if response.status_code == 200:
        # return response.content
        return response.text
    else: 
        return None

@app.route('/b/changfeng', methods=['GET'])
def route_base64_changfeng():
    
    bs64,urlv,urlc,urlm,urls = get_sub_changfeng(get_urls_changfeng()[0])
    
    return bs64


@app.route('/c/changfeng', methods=['GET'])
def route_clash_changfeng():
    
    bs64,urlv,urlc,urlm,urls = get_sub_changfeng(get_urls_changfeng()[0])
    
    response = requests.get(urlc)
    
    if response.status_code == 200:
        # return response.content
        return response.text
    else: 
        return None

@app.route('/v/changfeng', methods=['GET'])
def route_v2ray_changfeng():
    
    bs64,urlv,urlc,urlm,urls = get_sub_changfeng(get_urls_changfeng()[0])
    
    response = requests.get(urlv)
    
    if response.status_code == 200:
        # return response.content
        return response.text
    else: 
        return None

@app.route('/s/changfeng', methods=['GET'])
def route_singbox_changfeng():
    
    bs64,urlv,urlc,urlm,urls = get_sub_changfeng(get_urls_changfeng()[0])
    
    response = requests.get(urls)
    
    if response.status_code == 200:
        # return response.content
        return response.text
    else: 
        return None

@app.route('/m/changfeng', methods=['GET'])
def route_mihomo_changfeng():
    
    bs64,urlv,urlc,urlm,urls = get_sub_changfeng(get_urls_changfeng()[0])
    
    response = requests.get(urlm)
    
    if response.status_code == 200:
        # return response.content
        return response.text
    else: 
        return None
    
@app.route('/usage', methods=['GET'])
def route_usage():
    # host_url = str(request.base_url)
    host_url = str(request.host_url)
    
    html_content = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Links Usage List</title>
</head>
<body>
    <h1>Usage Links</h1>
    <h2>米贝</h2>
    <a href="https://www.mibei77.com"/>
    <ul>
        <li><a href="{host_url}c/mibei" target="_blank">{host_url}c/mibei</a></li>\n
        <li><a href="{host_url}v/mibei" target="_blank">{host_url}v/mibei</a></li>\n\n
    </ul>
    <h2>NodeFree</h2>
    <ul>
        <li><a href="{host_url}c/nodefree" target="_blank">{host_url}c/nodefree</a></li>\n
        <li><a href="{host_url}v/nodefree" target="_blank">{host_url}v/nodefree</a></li>\n\n
    </ul>
    <h2>V2rayFree</h2>
    <ul>
        <li><a href="{host_url}c/v2rayshare" target="_blank">{host_url}c/v2rayshare</a></li>\n
        <li><a href="{host_url}v/v2rayshare" target="_blank">{host_url}v/v2rayshare</a></li>\n\n
    </ul>
    <h2>OpenRunner</h2>
    <ul>
        <li><a href="{host_url}c/openrunner" target="_blank">{host_url}c/openrunner</a></li>\n
        <li><a href="{host_url}v/openrunner" target="_blank">{host_url}v/openrunner</a></li>\n\n
    </ul>
    <h2>clashNode</h2>
    <ul>
        <li><a href="{host_url}c/clashnode" target="_blank">{host_url}c/clashnode</a></li>\n
        <li><a href="{host_url}v/clashnode" target="_blank">{host_url}v/clashnode</a></li>\n
        <li><a href="{host_url}s/clashnode" target="_blank">{host_url}s/clashnode</a></li>\n\n
    </ul>
    <h2>长风</h2>
    <ul>
        <li><a href="{host_url}c/changfeng" target="_blank">{host_url}c/changfeng</a></li>\n
        <li><a href="{host_url}v/changfeng" target="_blank">{host_url}v/changfeng</a></li>\n
        <li><a href="{host_url}s/changfeng" target="_blank">{host_url}s/changfeng</a></li>\n
        <li><a href="{host_url}m/changfeng" target="_blank">{host_url}m/changfeng</a></li>\n
    </ul>
</body>
</html>
"""
    sss = f'''
    \n
    \n{host_url}c/mibei
    \n{host_url}v/mibei
    \n
    \n{host_url}c/nodefree
    \n{host_url}v/nodefree
    \n
    \n{host_url}c/v2rayshare
    \n{host_url}v/v2rayshare
    \n
    \n{host_url}c/openrunner
    \n{host_url}v/openrunner
    \n
    \n{host_url}c/clashnode
    \n{host_url}v/clashnode
    \n{host_url}s/clashnode
    \n
    \n{host_url}c/changfeng
    \n{host_url}v/changfeng
    \n{host_url}s/changfeng
    \n{host_url}m/changfeng

    '''
    
    return html_content 
    
def usage(host_url):
    print(f'\n')
    print(f' http://{host_url}/c/mibei')
    print(f' http://{host_url}/v/mibei')
    
    # print(f'\n')
    print(f' http://{host_url}/c/nodefree')
    print(f' http://{host_url}/v/nodefree')
    
    # print(f'\n')
    print(f' http://{host_url}/c/v2rayshare')
    print(f' http://{host_url}/v/v2rayshare')
    
    # print(f'\n')
    print(f' http://{host_url}/c/openrunner')
    print(f' http://{host_url}/v/openrunner')
    
    # print(f'\n')
    print(f' http://{host_url}/c/clashnode')
    print(f' http://{host_url}/v/clashnode')
    print(f' http://{host_url}/s/clashnode')
    
    # print(f'\n')
    print(f' http://{host_url}/c/changfeng')
    print(f' http://{host_url}/v/changfeng')
    print(f' http://{host_url}/s/changfeng')
    print(f' http://{host_url}/m/changfeng')
    
    print(f'\n')

#==========================
if __name__ == '__main__':
    usage()
    app.run(host=HOST,port=PORT,debug=DEBUG)
    
    