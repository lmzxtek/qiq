// ==UserScript==
// @name         特定按钮响应数据捕获器
// @namespace    http://tampermonkey.net/
// @version      1.1
// @description  捕获特定按钮点击后的返回数据
// @author       You
// @match        https://console.akile.io/pushshop/
// @grant        unsafeWindow
// @grant        GM_setValue
// @grant        GM_getValue
// @grant        GM_addStyle
// @run-at       document-idle
// ==/UserScript==

(function() {
    'use strict';

    // 设置目标按钮的CSS选择器（示例用，实际需要替换）
    const TARGET_BUTTON_SELECTOR = "#submit-button";
    // 或者通过按钮文本识别：button:contains('提交订单')
    const BUTTON_TEXT = "加载更多";
    
    // 添加捕获状态提示样式
    GM_addStyle(`
        .tm-capture-status {
            position: fixed;
            top: 10px;
            right: 10px;
            padding: 8px 15px;
            background: rgba(0,150,255,0.85);
            color: white;
            border-radius: 4px;
            z-index: 9999;
            font-size: 14px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }
    `);
    
    // 显示捕获状态
    function showStatus(text, isError = false) {
        let statusEl = document.querySelector('.tm-capture-status');
        if (!statusEl) {
            statusEl = document.createElement('div');
            statusEl.className = 'tm-capture-status';
            document.body.appendChild(statusEl);
        }
        
        statusEl.textContent = text;
        statusEl.style.background = isError 
            ? 'rgba(255,50,50,0.85)' 
            : 'rgba(0,150,255,0.85)';
        
        setTimeout(() => statusEl.remove(), 3000);
    }

    // 保存原始fetch函数
    const originalFetch = unsafeWindow.fetch;
    const originalXHR = unsafeWindow.XMLHttpRequest;
    
    // 监听按钮点击事件的函数
    function initButtonListener() {
        // const targetButton = document.querySelector(TARGET_BUTTON_SELECTOR) ||
        //     [...document.querySelectorAll('button')].find(btn => 
        //         btn.innerText.includes(BUTTON_TEXT)
        //     );
        
        const rightpanel = document.querySelector('body > div:first-child > div:first-child > div:last-child');
        const targetButton = rightpanel.querySelector( '.flex.justify-center.items-center button' );
        
        if (!targetButton) {
            showStatus('错误: 目标按钮未找到', true);
            return false;
        }
        
        // 标志是否捕获到响应的全局变量
        let captureActive = false;
        
        // 监听按钮点击
        targetButton.addEventListener('click', function() {
            captureActive = true;
            showStatus("正在捕获响应数据...");
        }, true); // 使用捕获阶段确保优先执行
        
        // 重写fetch API
        unsafeWindow.fetch = function(...args) {
            const fetchStartTime = Date.now();
            
            return originalFetch.apply(this, args).then(response => {
                if (captureActive) {
                    const duration = Date.now() - fetchStartTime;
                    const clonedResponse = response.clone();
                    
                    clonedResponse.text().then(body => {
                        console.group("✨ 按钮触发请求捕获成功");
                        console.log("请求URL:", args[0]);
                        console.log("请求方法:", (args[1]?.method || "GET").toUpperCase());
                        console.log("响应状态:", response.status);
                        console.log("响应时间:", duration + "ms");
                        console.log("响应数据:", body);
                        console.groupEnd();
                        
                        // 保存数据以便后续使用
                        GM_setValue('buttonResponse', {
                            url: args[0],
                            status: response.status,
                            data: body,
                            timestamp: new Date().toISOString()
                        });
                        
                        showStatus(`成功捕获 ${response.status} 响应数据`);
                    });
                    
                    captureActive = false;
                }
                return response;
            });
        };
        
        // 重写XMLHttpRequest (AJAX请求)
        unsafeWindow.XMLHttpRequest = function() {
            const xhr = new originalXHR();
            const originalOpen = xhr.open;
            const originalSend = xhr.send;
            
            xhr.open = function(method, url) {
                this._method = method;
                this._url = url;
                return originalOpen.apply(xhr, arguments);
            };
            
            xhr.send = function(data) {
                this._requestData = data;
                const startTime = Date.now();
                
                xhr.addEventListener('load', function() {
                    if (captureActive) {
                        const duration = Date.now() - startTime;
                        console.group("🔔 按钮触发AJAX请求捕获");
                        console.log("请求URL:", this._url);
                        console.log("请求方法:", this._method);
                        console.log("请求数据:", this._requestData);
                        console.log("响应状态:", this.status);
                        console.log("响应时间:", duration + "ms");
                        console.log("响应数据:", this.responseText);
                        console.groupEnd();
                        
                        GM_setValue('buttonResponse', {
                            url: this._url,
                            status: this.status,
                            data: this.responseText,
                            timestamp: new Date().toISOString()
                        });
                        
                        showStatus(`成功捕获AJAX ${this.status} 响应`);
                        captureActive = false;
                    }
                });
                
                return originalSend.apply(xhr, arguments);
            };
            
            return xhr;
        };
        
        showStatus(`已监控按钮: "${targetButton.innerText.trim()}"`);
        return true;
    }

    // 主执行函数
    function main() {
        // 尝试立即初始化
        if (initButtonListener()) return;
        
        // 使用MutationObserver监听按钮动态加载
        const observer = new MutationObserver(() => {
            if (initButtonListener()) {
                observer.disconnect();
            }
        });
        
        observer.observe(document, {
            childList: true,
            subtree: true,
            attributes: false,
            characterData: false
        });
        
        // 设置超时限制
        setTimeout(() => {
            if (!document.querySelector(TARGET_BUTTON_SELECTOR)) {
                showStatus('错误: 按钮加载超时', true);
            }
        }, 10000);
    }

    // 延迟执行以确保DOM准备就绪
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', main);
    } else {
        main();
    }
})();