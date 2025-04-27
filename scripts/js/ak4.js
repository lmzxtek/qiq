// ==UserScript==
// @name         Auto Load More (Promise Edition)
// @namespace    http://tampermonkey.net/
// @version      1.1
// @description  使用异步循环自动加载内容
// @author       Your Name
// @match        https://akile.io/console/pushshop
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // 创建控制按钮
    const controlBtn = document.createElement('button');
    controlBtn.textContent = '开始自动加载';
    Object.assign(controlBtn.style, {
        position: 'fixed',
        bottom: '20px',
        left: '20px',
        zIndex: 9999,
        padding: '8px 16px',
        backgroundColor: '#2196F3',
        color: 'white',
        border: 'none',
        borderRadius: '4px',
        cursor: 'pointer'
    });
    document.body.appendChild(controlBtn);

    // 创建延迟函数
    const delay = ms => new Promise(resolve => setTimeout(resolve, ms));

    // 异步加载函数
    async function autoClicker(btn) {
        let isRunning = true;
        btn.disabled = true;
        btn.textContent = '加载中...';

        function smoothScrollToBottom() {
            const scrollHeight = Math.max(
              document.body.scrollHeight,
              document.documentElement.scrollHeight
            );
        
            window.scrollTo({
              top: scrollHeight,
              behavior: "smooth",
            });
        
          }
        try {
            while (isRunning) {
                smoothScrollToBottom();
                const loadMoreBtn = document.querySelector('.load-more button');
                
                if (!loadMoreBtn) {
                    console.log('加载完成');
                    break;
                }

                // 执行点击并等待响应
                loadMoreBtn.click();
                await delay(1500); // 给服务器响应时间
                // 可选：检测页面内容是否变化（需要根据实际情况实现）
                // if (!contentChanged()) break;
            }
        } catch (error) {
            console.error('自动加载出错:', error);
        } finally {
            smoothScrollToBottom();
            btn.disabled = false;
            btn.textContent = '开始自动加载';
        }
    }

    controlBtn.addEventListener('click', () => {
        if (!controlBtn.disabled) autoClicker(controlBtn);
    });

    // 初始隐藏原按钮（可选）
    // const originalBtn = document.querySelector('.load-more button');
    // originalBtn?.style.display = 'none';
})();