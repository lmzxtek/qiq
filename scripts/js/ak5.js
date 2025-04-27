// ==UserScript==
// @name         Auto Load More Button
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  自动循环点击加载更多按钮
// @author       Your Name
// @match        https://akile.io/console/pushshop
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // 创建控制按钮
    const controlBtn = document.createElement('button');
    controlBtn.textContent = '开始自动加载';
    controlBtn.style.position = 'fixed';
    controlBtn.style.bottom = '20px';
    controlBtn.style.left = '20px';
    controlBtn.style.zIndex = 9999;
    controlBtn.style.padding = '8px 16px';
    controlBtn.style.backgroundColor = '#4CAF50';
    controlBtn.style.color = 'white';
    controlBtn.style.border = 'none';
    controlBtn.style.borderRadius = '4px';
    controlBtn.style.cursor = 'pointer';
    document.body.appendChild(controlBtn);

    
    function handleAutoLoadMore(btn){
        let isRunning = false;
        let intervalId = null;

        if (isRunning) return;
            
        function resetButton() {
            isRunning = false;
            btn.textContent = '开始自动加载';
            btn.disabled = false;
        }
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

        btn.textContent = '正在加载...';
        btn.disabled = true;

        intervalId = setInterval(() => {
            const loadMoreBtn = document.querySelector('.load-more button');
            
            if (loadMoreBtn) {
                try {
                    loadMoreBtn.click();
                    smoothScrollToBottom();
                } catch (error) {
                    console.error('点击按钮时出错:', error);
                    clearInterval(intervalId);
                    resetButton();
                }
            } else {
                // 没有更多按钮时停止
                smoothScrollToBottom();
                clearInterval(intervalId);
                resetButton();
            }
        }, 1000); // 每秒检查一次

    }

    // 点击事件处理
    controlBtn.addEventListener('click', () => { handleAutoLoadMore(controlBtn);});

    // 初始隐藏原加载更多按钮（可选）
    // const originalBtn = document.querySelector('.load-more button');
    // if (originalBtn) originalBtn.style.display = 'none';
})();