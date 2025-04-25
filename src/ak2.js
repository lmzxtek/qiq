// ==UserScript==
// @name         Akile Data Scraper
// @namespace    http://tampermonkey.net/
// @version      1.1
// @description  在Akile控制台抓取服务器数据并生成表格
// @author       YourName
// @match        https://akile.io/console/pushshop
// @icon         https://www.google.com/s2/favicons?domain=akile.io
// @grant        none
// @run-at       document-end
// ==/UserScript==

(function() {
    'use strict';

    // 创建抓取按钮
    function createButton() {
        const btn = document.createElement('button');
        btn.textContent = '抓取数据';
        btn.style.cssText = `
            position: fixed;
            right: 20px;
            bottom: 20px;
            z-index: 9999;
            padding: 12px 24px;
            background: #1890ff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: 0.3s;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        `;
        
        btn.addEventListener('click', scrapeData);
        document.body.appendChild(btn);
    }

    // 数据抓取和表格生成
    async function scrapeData() {
        // 移除旧结果
        const oldTable = document.querySelector('#akile-scrape-table');
        if (oldTable) oldTable.remove();

        // 获取数据容器
        const cardBodies = document.querySelectorAll('div.arco-card-body');
        const data = [];

        // 遍历数据卡片
        cardBodies.forEach(card => {
            try {
                const name = card.querySelector('.server-name')?.textContent.trim() || 'N/A';
                const detail = card.querySelector('.server-detail')?.textContent.trim() || 'N/A';

                const infoBodies = card.querySelectorAll('div.server-info');
                const location   = infoBodies[0].querySelector('.info-value')?.textContent.trim() || 'N/A';
                const node       = infoBodies[1].querySelector('.info-value')?.textContent.trim() || 'N/A';
                const type       = infoBodies[2].querySelector('.info-value')?.textContent.trim() || 'N/A';
                const conf       = infoBodies[3].querySelector('.info-value')?.textContent.trim() || 'N/A';
                const network    = infoBodies[4].querySelector('.info-value')?.textContent.trim() || 'N/A';
                const ip         = infoBodies[5].querySelector('.info-value')?.textContent.trim() || 'N/A';
                const renew      = infoBodies[6].querySelector('.info-value')?.textContent.trim() || 'N/A';
                const expire     = infoBodies[8].querySelector('.info-value')?.textContent.trim() || 'N/A';
                
                const srvManage = card.querySelector('.server-manage') || 'N/A';
                const price     = srvManage.querySelector('.shop-server-price')?.textContent.trim() || 'N/A';
                
                if (name && detail && location && node) {
                    data.push({ name, detail, location, node, type, conf, network, ip, renew, expire, price });
                }
            } catch (error) {
                console.error('数据处理错误:', error);
            }
        });

        // 生成结果表格
        const table = createResultTable(data);
        document.body.appendChild(table);
        table.scrollIntoView({ behavior: 'smooth' });
    }

    // 创建结果表格
    function createResultTable(data) {
        const table = document.createElement('div');
        table.id = 'akile-scrape-table';
        table.style.cssText = `
            position: relative;
            z-index: 9999;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            max-width: 90vw;
            margin: 20px auto;
            font-family: system-ui, sans-serif;
        `;

        // 表格标题
        const title = document.createElement('h3');
        title.textContent = '服务器数据抓取结果';
        title.style.cssText = `
            margin-top: 0;
            color: #1890ff;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 10px;
            margin-bottom: 15px;
        `;
        table.appendChild(title);

        // 表格内容
        const tableHtml = `
            <table style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="background: #fafafa;">
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">名称</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">状态</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">地区</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">节点</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">套餐</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">配置</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">网络</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">IP</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">续费</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">到期</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">售价</th>
                    </tr>
                </thead>
                <tbody>
                    ${data.map(item => `
                        <tr>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.name)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.detail)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.location)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.node)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.type)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.conf)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.network)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.ip)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.renew)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.expire)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.price)}</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        `;

        table.innerHTML = tableHtml;
        return table;
    }

    // HTML转义函数
    function escapeHtml(text) {
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return text.replace(/[&<>"']/g, m => map[m]);
    }

    // 初始化脚本
    window.addEventListener('load', () => {
        createButton();
        console.log('Akile数据抓取器已就绪');
    });
})();