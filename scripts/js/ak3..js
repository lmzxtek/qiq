// ==UserScript==
// @name         Akile.io 加载更多助手（双按钮）
// @namespace    http://tampermonkey.net/
// @version      1.1
// @description  添加两个按钮：模拟点击“加载更多” & 滚动到底部
// @match        https://akile.io/console/pushshop
// @icon         https://akile.io/favicon.ico
// @grant        none
// ==/UserScript==

(function () {
    'use strict';
  
    window.addEventListener('load', () => {
      // 创建按钮容器
      const container = document.createElement('div');
      container.style.position = 'fixed';
      container.style.bottom = '20px';
      container.style.left = '20px';
      container.style.zIndex = '9999';
      container.style.display = 'flex';
      container.style.flexDirection = 'column';
      container.style.gap = '10px';
  
      // 样式生成函数
      function styleButton(btn, color) {
        btn.style.padding = '10px 16px';
        btn.style.backgroundColor = color || '#409EFF';
        btn.style.color = '#fff';
        btn.style.border = 'none';
        btn.style.borderRadius = '4px';
        btn.style.cursor = 'pointer';
        btn.style.boxShadow = '0 2px 8px rgba(0,0,0,0.2)';
      }
  
      // 创建“加载更多”按钮
      const loadMoreBtn = document.createElement('button');
      loadMoreBtn.textContent = '📥';
      styleButton(loadMoreBtn, '#409EFF');
      loadMoreBtn.addEventListener('click', () => {
        const realBtn = document.querySelector('.load-more button');
        if (realBtn) {
          realBtn.click();
          console.log('✅ 已点击加载更多');
        } else {
          console.warn('⚠️ 未找到加载更多按钮');
          alert('未找到加载更多按钮');
        }
      });
  
      // 创建“滚动到底部”按钮
      const scrollBtn = document.createElement('button');
      scrollBtn.textContent = '⬇️';
      styleButton(scrollBtn, '#67C23A');
      scrollBtn.addEventListener('click', () => {
        window.scrollTo({
          top: document.body.scrollHeight,
          behavior: 'smooth'
        });
        console.log('⬇️ 页面滚动到底部');
      });
  
      // 加入页面
      container.appendChild(loadMoreBtn);
      container.appendChild(scrollBtn);
      document.body.appendChild(container);
    });
  })();
  