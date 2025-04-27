// ==UserScript==
// @name         Dynamic Table Generator
// @namespace    your-namespace
// @version      1.0
// @description  根据data数据生成带操作按钮的表格
// @author       Your Name
// @match        *://*/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // 示例数据结构（需替换为实际数据）
    const data = [
        { name: "商品A", buyBtn: document.querySelector('#btn1') },
        { name: "商品B", buyBtn: document.querySelector('#btn2') }
    ];

    // 创建表格元素
    const table = document.createElement('table');
    table.style.cssText = `
        border-collapse: collapse;
        width: 80%;
        margin: 20px auto;
        font-family: Arial, sans-serif;
    `;

    // 表格头部
    const thead = document.createElement('thead');
    thead.innerHTML = `
        <tr style="background: #f5f5f5;">
            <th style="border: 1px solid #ddd; padding: 12px;">商品名称</th>
            <th style="border: 1px solid #ddd; padding: 12px;">操作</th>
        </tr>
    `;
    table.appendChild(thead);

    // 表格主体
    const tbody = document.createElement('tbody');
    
    data.forEach(item => {
        const row = document.createElement('tr');
        
        // 商品名称列
        const nameCell = document.createElement('td');
        nameCell.textContent = item.name;
        nameCell.style.border = "1px solid #ddd";
        nameCell.style.padding = "12px";
        
        // 操作按钮列
        const actionCell = document.createElement('td');
        const actionBtn = document.createElement('button');
        actionBtn.textContent = "立即购买";
        actionBtn.style.cssText = `
            background: #4CAF50;
            color: white;
            border: none;
            padding: 8px 16px;
            cursor: pointer;
            border-radius: 4px;
            font-size: 14px;
        `;
        
        // 绑定点击事件
        actionBtn.addEventListener('click', () => {
            // 触发原始购买按钮的点击事件
            if (typeof item.buyBtn.click === 'function') {
                item.buyBtn.click();
            } else {
                // 兼容通过 addEventListener 绑定的情况
                const event = new MouseEvent('click', {
                    view: window,
                    bubbles: true,
                    cancelable: true
                });
                item.buyBtn.dispatchEvent(event);
            }
        });

        actionCell.appendChild(actionBtn);
        
        row.appendChild(nameCell);
        row.appendChild(actionCell);
        tbody.appendChild(row);
    });

    table.appendChild(tbody);
    
    // 插入到页面中（可根据需要修改选择器）
    const container = document.querySelector('#container') || document.body;
    container.appendChild(table);
})();