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

import os
import requests

from sub_url import * 


app = Flask(__name__)

HOST  = "localhost"
PORT  = 5003
DEBUG = False
DEBUG = True
FLD_DATA = 'data'

# 指定文件根目录
BASE_DIRECTORY = Path(FLD_DATA).resolve()

# 检查文件根目录是否存在，如果不存在则创建
BASE_DIRECTORY.mkdir(parents=True, exist_ok=True)

fpath = f'{FLD_DATA}/test.txt'
if not os.path.exists(fpath): 
    with open(fpath, 'w') as file:
        file.write(f' This is a file for remote url request test. ')

def download_file_to_local(url, filename):
    '''下载链接中的文件，并将其保存为filename定义的文件名'''
    response = requests.get(url)
    if response.status_code == 200:
        with open(filename, "wb") as file:
            file.write(response.content)
        # print("文件已成功下载并保存为", filename)
    else:
        print("无法访问链接:", url)        
        
@app.route('/download/<path:filepath>', methods=['GET'])
def route_download_file(filepath):
    # 将请求路径拼接到根目录，确保路径合法
    file_path = (BASE_DIRECTORY / filepath).resolve()

    # 确保文件路径在根目录内，防止目录遍历攻击
    if not file_path.is_file() or BASE_DIRECTORY not in file_path.parents:
        abort(404)  # 文件未找到则返回404错误

    # 返回文件下载
    return send_from_directory(BASE_DIRECTORY, filepath, as_attachment=True)

# 文件上传（可选），允许将文件上传到服务器的子目录
@app.route('/upload/<path:filepath>', methods=['POST'])
def route_upload_file(filepath):
    if 'file' not in request.files:
        return "No file part", 400

    file = request.files['file']
    if file.filename == '':
        return "No selected file", 400

    # 将上传的文件保存到指定的子目录
    upload_path = (BASE_DIRECTORY / filepath).resolve()
    if BASE_DIRECTORY not in upload_path.parents:
        abort(403)  # 禁止访问超出根目录的路径

    # 创建子目录（如果不存在）
    upload_path.parent.mkdir(parents=True, exist_ok=True)

    # 保存文件
    file.save(upload_path)
    return "File uploaded successfully", 200


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
    
def usage():
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
    
    