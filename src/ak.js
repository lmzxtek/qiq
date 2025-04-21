// ==UserScript==
// @name         AkileCloud 自动加载更多
// @namespace    https://yourname.github.io
// @version      1.0.0
// @description  在AkileCloud页面右下角添加自动加载按钮
// @author       AI助手
// @match        https://akile.io/console/pushshop*
// @grant        GM_addStyle
// @grant        GM_xmlhttpRequest
// @grant        unsafeWindow  // 添加这一行
// ==/UserScript==

(function() {
    'use strict';

    // 创建容器样式
    GM_addStyle(`
        .center-panel {
            position: fixed;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 20px;
            z-index: 9999;
        }
        .action-btn {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        #loadMoreBtn {
            background: linear-gradient(135deg, #6c5ce7, #a88beb);
        }
        #jumpBtn {
            background: linear-gradient(135deg, #ff6b6b, #ff8e8e);
        }
        .loading {
            animation: pulse 1.2s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
    `);

    // 创建容器
    const panel = document.createElement('div');
    panel.className = 'center-panel';
    document.body.appendChild(panel);

    // 加载更多按钮
    const loadBtn = document.createElement('button');
    loadBtn.id = 'loadMoreBtn';
    loadBtn.className = 'action-btn';
    loadBtn.innerHTML = '↻';
    panel.appendChild(loadBtn);

    // 滚动到底部按钮
    const jumpBtn = document.createElement('button');
    jumpBtn.id = 'jumpBtn';
    jumpBtn.className = 'action-btn';
    jumpBtn.innerHTML = '↓';
    panel.appendChild(jumpBtn);

    // 智能按钮查找函数
    function findLoadButton() {
        return new Promise(resolve => {
            const check = () => {
                const candidates = [
                    ...document.querySelectorAll('.load-more, .next-page, .pagination-next'),
                    ...document.querySelectorAll('[aria-label^="加载更多"], [data-action="load"]'),
                    ...document.querySelectorAll('button:not([disabled]):not([hidden])')
                ];

                const validBtn = candidates.find(btn =>
                    btn.offsetHeight > 0 &&
                    btn.offsetWidth > 0 &&
                    btn.getBoundingClientRect().top < window.innerHeight
                );

                validBtn ? resolve(validBtn) : setTimeout(check, 500);
            };
            check();
        });
    }

    // 真实点击模拟器
    function simulateRealClick(element) {
        const rect = element.getBoundingClientRect();
        const clickEvent = new MouseEvent('click', {
            bubbles: true,
            cancelable: true,
            view: unsafeWindow,
            button: 0,
            buttons: 1,
            clientX: rect.left + 1,
            clientY: rect.top + 1
        });

        ['mousedown', 'click', 'mouseup'].forEach(event => {
            element.dispatchEvent(new MouseEvent(event, {
                bubbles: true,
                cancelable: true,
                view: unsafeWindow
            }));
        });

        if (typeof element.click === 'function') {
            element.click();
        }
    }

    // 智能等待加载完成
    function waitForLoad() {
        return new Promise((resolve, reject) => {
            const check = () => {
                const isLoading = document.querySelector('.loading, .spinner, .is-loading');
                const hasMore = document.querySelector('.load-more');

                if (isLoading) {
                    setTimeout(check, 300);
                } else if (hasMore) {
                    resolve();
                } else {
                    reject(new Error('加载失败或无更多内容'));
                }
            };
            check();
        });
    }

    // 主逻辑
    async function handleLoadMore() {
        try {
            const btn = await findLoadButton();
            if (!btn) throw new Error('未找到加载按钮');

            btn.disabled = true;
            btn.classList.add('loading-indicator');

            simulateRealClick(btn);

            await waitForLoad();
            console.log('加载成功');
        } catch (error) {
            console.error('加载失败:', error);
        } finally {
            // 重置按钮状态
        }
    }

    // 模拟点击加载更多
    async function triggerLoadMore() {
        const btn = document.querySelector('.load-more, .next-page, [aria-label^="加载更多"]');
        if (!btn) {
            alert('未找到加载按钮！请检查选择器配置');
            return;
        }

        try {
            loadBtn.classList.add('loading');
            btn.disabled = true;

            // 模拟真实用户点击
            const clickEvent = new MouseEvent('click', {
                bubbles: true,
                cancelable: true,
                view: unsafeWindow
            });
            console.log('Start to click LoadMore...')
            btn.dispatchEvent(clickEvent);
            // btn.click();  // 有些情况下比dispatchEvent更可靠

            // 等待内容加载
            console.log('Wait to LoadMore...')
            await new Promise(resolve => setTimeout(resolve, 1500));
        } finally {
            loadBtn.classList.remove('loading');
            btn.disabled = false;
        }
    }

    // 智能滚动到底部
    function smoothScrollToBottom() {
        const scrollHeight = Math.max(
            document.body.scrollHeight,
            document.documentElement.scrollHeight
        );

        window.scrollTo({
            top: scrollHeight,
            behavior: 'smooth'
        });
    }

    // 事件绑定
    // 绑定点击事件
    loadBtn.addEventListener('click', handleLoadMore);
    // loadBtn.addEventListener('click', triggerLoadMore);
    jumpBtn.addEventListener('click', smoothScrollToBottom);

    // 按钮状态管理
    let isScrolled = false;
    window.addEventListener('scroll', () => {
        const threshold = 200;
        const shouldShow = window.scrollY < (document.documentElement.scrollHeight - threshold);

        loadBtn.style.display = shouldShow ? 'flex' : 'none';
        jumpBtn.style.display = shouldShow ? 'flex' : 'none';
    });

    // 初始状态设置
    window.dispatchEvent(new Event('scroll'));

})();