// ==UserScript==
// @name         Toggleable Table with Button
// @namespace    akttabll
// @version      1.2
// @description  左下角按钮控制表格显示
// @author       Your Name
// @match        https://akile.io/console/pushshop
// @grant        GM_addStyle
// ==/UserScript==

(function() {
    'use strict';

  // 创建容器样式
  GM_addStyle(`
    .center-panel {
        position: fixed;
        bottom: 50px;
        left: 30px;
        transform: translateX(-50%);
        display: flex;
        gap: 10px;
        z-index: 9999;
    }
    .table-container {
        position: relative;
        z-index: 9998;
        background: rgba(149, 144, 144, 0.97);
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 6px 24px rgba(74, 73, 73, 0.15);
        max-width: 90vw;
        min-width: 600px;
        margin: 20px auto;
        font-family: system-ui, sans-serif;
    }
    .table-container h3 {
        margin: 0 0 15px 0;
        color: #1890ff;
        border-bottom: 2px solid #f0f0f0;
        padding-bottom: 10px;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .table-container:hover {
        box-shadow: 0 8px 24px rgba(118, 250, 61, 0.25);
    }
    .action-btn {
        width: 40px;
        height: 40px;
        border: none;
        border-radius: 45%;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    /* 按钮悬停效果 */
    .action-btn:hover {
        background-color: #45a049 !important;
        transform: scale(1.05);
        box-shadow: 0 6px 16px rgba(232, 253, 113, 0.2);
    }
    .buy-btn {
        width: 20px;
        height: 20px;
        border: none;
        border-radius: 30%;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 16px;
        color: rgb(0, 72, 253);
        background-color: rgba(199, 253, 218, 0.87);
        box-shadow: 0 4px 14px rgba(113, 111, 128, 0.6);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    /* 按钮悬停效果 */
    .buy-btn:hover {
      transform: scale(1.05);
      background-color:rgba(69, 160, 73, 0.68) !important;
      box-shadow: 0 4px 14px rgba(248, 54, 54, 0.48);
    }
  `);
  
  function showMessage(message) {
    // 移除已存在的消息
    const existing = document.getElementById('gm-temp-message');
    if (existing) existing.remove();

    // 创建消息元素
    const msgBox = document.createElement('div');
    msgBox.id = 'gm-temp-message';
    msgBox.textContent = message;
    
    // 设置样式
    Object.assign(msgBox.style, {
        position: 'fixed',
        top: '50%',
        left: '50%',
        transform: 'translate(-50%, -50%)',
        padding: '12px 24px',
        background: 'rgba(0, 0, 0, 0.8)',
        color: '#fff',
        borderRadius: '4px',
        boxShadow: '0 2px 10px rgba(0,0,0,0.2)',
        zIndex: 9999,
        fontFamily: 'Arial, sans-serif',
        fontSize: '14px',
        fontWeight: 'bold'
    });

    // 添加到页面
    document.body.appendChild(msgBox);

    // 1秒后移除
    setTimeout(() => {
        msgBox.remove();
    }, 1000);
  }
  
  // 创建容器
  const panel = document.createElement("div");
  panel.className = "center-panel";
  panel.style.flexDirection = 'column';
  document.body.appendChild(panel);

  // 整理表格按钮
  const allBtn = document.createElement("button");
  allBtn.id = "allBtn";
  allBtn.innerHTML = "A";
  allBtn.className = "action-btn";

  // 关闭按钮
  const closeBtn = document.createElement("button");
  closeBtn.id = "closeBtn";
  // closeBtn.innerHTML = "x";
  closeBtn.innerHTML = "❌";
  closeBtn.className = "action-btn";

  // 加载更多按钮
  const loadBtn = document.createElement("button");
  loadBtn.id = "loadBtn";
  loadBtn.innerHTML = "↻";
  loadBtn.className = "action-btn";

  // 添加按钮到容器
  panel.appendChild(closeBtn);
  panel.appendChild(allBtn);
  panel.appendChild(loadBtn);

  // 数据抓取和表格生成
  async function scrapeData(isFiltered = false, isOnlySuper = false) {
    // 移除旧结果
    const oldTable = document.querySelector('#akile-scrape-table');
    if (oldTable) oldTable.remove();

    // 获取数据容器
    const cardBodies = document.querySelectorAll('div.arco-card-body');
    const data = [];

  // 计算时间差函数
    function calculateTimeDifference(expireStr) {
        // 解析目标时间
        const expireDate = new Date(expireStr.replace(' ', 'T') + 'Z');
        const now = new Date();

        // 计算时间差（毫秒）
        let diffMs = expireDate - now;

        // 处理时区差异（确保使用UTC时间计算）
        const offsetMs = now.getTimezoneOffset() * 60 * 1000;
        diffMs = expireDate.getTime() - (now.getTime() + offsetMs);

        // 计算天和小时
        const days = Math.floor(Math.abs(diffMs) / (1000 * 60 * 60 * 24));
        const hours = Math.floor((Math.abs(diffMs) % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));

        // 判断是否已过期
        const isExpired = diffMs < 0;

        return {
            days: isExpired ? 0 : days,
            hours: isExpired ? 0 : hours,
            isExpired,
            totalHours: Math.floor(Math.abs(diffMs) / (1000 * 60 * 60)),
            formatted: formatTimeDifference(days, hours, isExpired)
        };
    }
    function parseQuantity(inputStr) {
        // 增强型正则表达式（支持小数和多字符单位）
        const regex = /^(\d+\.?\d*)([^\d\s]+)$/;
        const match = inputStr.match(regex);
  
        if (!match) return null;
  
        // 处理数字部分
        const num = parseFloat(match[1]);
  
        // 处理单位部分（自动去除首尾空白）
        const unit = match[2].trim();
  
        return {
            num: Number.isNaN(num) ? 0 : num, // 处理无效数字
            unit: unit || "", // 处理空单位
        };
    }
    
  // * 解析价格周期字符串（增强版）
    function parsePricePeriod(inputStr) {
        // 增强型正则表达式（支持无周期标识）
        const regex = /^¥([\d,]+(?:\.\d{1,2})?)(?:\/([^\s/]+))?$/;
        const match = inputStr.match(regex);

        if (!match) {
            throw new Error('Invalid price format');
        }

        // 处理价格部分
        let priceStr = match[1].replace(/,/g, '');
        // 处理无小数部分的情况
        if (!/\./.test(priceStr)) {
            priceStr += '.00';
        }
        const price = parseFloat(priceStr).toFixed(2);

        // 处理周期部分（自动处理空值）
        const period = match[2] ? match[2].trim() : '';

        return {
            price: Number(price),
            period: period || ''  // 显式处理空字符串
        };
    }
    
    function safeCombinePriceAndRenew(price, renew) {
        // 转换前验证数值类型
        if (typeof price !== "number" || typeof renew !== "number") {
        throw new Error("参数必须为数值类型");
        }
        return `${price}/${renew}`;
    }
    // 遍历数据卡片
    cardBodies.forEach(card => {
        try {
            const name = card.querySelector('.server-name')?.textContent.trim() || 'N/A';
            const detailStr = card.querySelector('.server-detail')?.textContent.trim() || 'N/A';
            let detail = detailStr.slice(-3).split(']')[0] || 'N/A';

            const infoBodies = card.querySelectorAll('div.server-info');
            const location   = infoBodies[0].querySelector('.info-value')?.textContent.trim() || 'N/A';
            const node       = infoBodies[1].querySelector('.info-value')?.textContent.trim() || 'N/A';
            const type       = infoBodies[2].querySelector('.info-value')?.textContent.trim() || 'N/A';

            const conf = infoBodies[3].querySelector('.info-value')?.textContent.trim() || 'N/A';
            const cpu  = conf.split(' ')[0].split('核')[0] || 'N/A';
            const mem  = conf.split(' ')[0].split('核')[1] || 'N/A';
            const disk = conf.split(' ')[1] || 'N/A';

            const network = infoBodies[4].querySelector('.info-value')?.textContent.trim() || 'N/A';
            const bandw   = network.split(' ')[1]  || 'N/A' ;
            const used    = network.split(' ')[3]  || 'N/A' ;
            const total   = network.split(' ')[5]  || 'N/A' ;
            let usedv  = parseQuantity(used).num || 0;
            let totalv = parseQuantity(total).num || 0;
            let usedu  = parseQuantity(used).unit || '';
            let totalu = parseQuantity(total).unit || '';
            if (usedv == 0 ) { usedu = ''; } // 处理0的情况
            if (usedu === 'TB' ) { usedv = (usedv * 1024).toFixed(2); usedu = 'GB'; }
            if (usedu === 'MB' ) { usedv = (usedv / 1024).toFixed(2); usedu = 'GB'; }
            if (usedu === 'KB' ) { usedv = (usedv / 1024 / 1024).toFixed(2); usedu = 'GB'; }
            if (totalu === 'TB' ) { totalv = (totalv * 1024).toFixed(2); totalu = 'GB'; }
            if (totalu === 'MB' ) { totalv = (totalv / 1024).toFixed(2); totalu = 'GB'; }

            const ipstr = infoBodies[5].querySelector('.info-value')?.textContent.trim() || 'N/A';
            const ipv4  = ipstr.split(' ')[1] || 'N/A';
            const ipv6  = ipstr.split(' ')[3] || 'N/A';

            const renewStr   = infoBodies[6].querySelector('.info-value')?.textContent.trim() || 'N/A';
            const renew      = parsePricePeriod(renewStr)
            const period     = renewStr.slice(-1) || 'N/A';
            const renewPrice = renew.price;
        //   console.log(period, renewPrice);

            const expire     = infoBodies[8].querySelector('.info-value')?.textContent.trim() || 'N/A';
            const timeDiff   = calculateTimeDifference(expire);
            const daysleft   = timeDiff.days.toString();
            const hourleft   = timeDiff.hours.toString();

            const srvManage = card.querySelector('.server-manage') || 'N/A';
            const priceStr  = srvManage.querySelector('.shop-server-price')?.textContent.trim() || 'N/A';
            const price     = parsePricePeriod(priceStr).price;
            const sellPrice = Math.ceil(price/0.9) || 0;
            
            const buyBtn = document.createElement('button');
            buyBtn.id = "buyBtn";
            buyBtn.innerHTML = "B";
            buyBtn.className = "buy-btn";
            buyBtn.addEventListener('click', () => {
              const realBtn = srvManage.querySelector('.manage-btn button');
              if (realBtn) {
                realBtn.click();
              } else {
                showMessage('⚠️ >> 未找到购买按钮 << ');
              }
            });

            // 买的条件：剩余流量大于50%，剩余天数大于14天
            const okBuy = timeDiff.days >= 23 && usedv < totalv*0.5 && (period === '月' && price<renewPrice*0.7 ) ? '✅' : '';
            const isBuy = timeDiff.days >= 23 && usedv < totalv*0.5 && (period === '月' && price<renewPrice*0.7 ) ? 'Y' : 'N';
            const pricetorenew = safeCombinePriceAndRenew(price, renewPrice);

            let is2Push = false;
            if (isOnlySuper) {
              is2Push = cpu>1;
            } else {
              is2Push = daysleft > 12 || price<7 || ( cpu>1);
              is2Push = is2Push && (( (isFiltered && isBuy === 'Y')  ) || ( !isFiltered ));
            }

            if ( is2Push ) {
                data.push({ name, detail, location, period,node, type, cpu, mem, disk,
                    network, bandw, usedv,usedu, totalv,totalu, ipv4,ipv6,
                    price,sellPrice, renew,renewPrice, pricetorenew,
                    expire, daysleft,hourleft,dayOK: okBuy,isBuy,buyBtn,
                });
            }
        } catch (error) {
            console.error('数据处理错误:', error,card);
        }
    });

    // 生成结果表格
    const table = createResultTable(data);
    document.body.appendChild(table);
    table.scrollIntoView({ behavior: 'smooth' });
    }

    // 示例数据
    const data = [
        { name: "商品A", buyBtn: document.querySelector('#btn1') },
        { name: "商品B", buyBtn: document.querySelector('#btn2') }
    ];

    // 创建控制按钮
    const toggleBtn = document.createElement('button');
    toggleBtn.textContent = "显示";
    toggleBtn.style.cssText = `
        position: fixed;
        left: 20px;
        bottom: 20px;
        padding: 12px 24px;
        background: #2196F3;
        color: white;
        border: none;
        border-radius: 25px;
        cursor: pointer;
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        z-index: 9999;
        transition: all 0.3s ease;
    `;
    
    // 按钮悬停效果
    toggleBtn.addEventListener('mouseover', () => {
        toggleBtn.style.transform = 'translateY(-2px)';
        toggleBtn.style.boxShadow = '0 6px 16px rgba(0,0,0,0.3)';
    });
    
    toggleBtn.addEventListener('mouseout', () => {
        toggleBtn.style.transform = 'translateY(0)';
        toggleBtn.style.boxShadow = '0 4px 12px rgba(0,0,0,0.2)';
    });

    // 创建滚动容器（初始隐藏）
    const scrollContainer = document.createElement('div');
    scrollContainer.style.cssText = `
        display: none; /* 初始隐藏 */
        overflow-x: auto;
        width: 90%;
        max-width: 1200px;
        margin: 20px auto;
        background: white;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        padding: 20px;
    `;

  // 创建结果表格
  function createResultTable(data) {
    const tabdiv = document.createElement('div');
    tabdiv.id = 'akile-scrape-table';
    tabdiv.className = 'table-container';
    
  }
  
    // 创建表格
    const table = document.createElement('table');
    table.style.cssText = `
        border-collapse: collapse;
        min-width: 600px;
        width: 100%;
        user-select: none;
    `;

    // 创建表头
    const thead = document.createElement('thead');
    const headerRow = document.createElement('tr');
    headerRow.style.cssText = `
        background: #f8f9fa;
        position: sticky;
        top: 0;
        z-index: 2;
    `;
    
    const tbhList = ['商品名称', '操作'];
    tbhList.forEach(text => {
        const th = document.createElement('th');
        th.textContent = text;
        th.style.cssText = `
            border: 1px solid #e9ecef;
            padding: 15px;
            min-width: 150px;
            font-weight: 600;
        `;
        headerRow.appendChild(th);
    });
    thead.appendChild(headerRow);
    table.appendChild(thead);

    // 创建表格内容
    const tbody = document.createElement('tbody');
    data.forEach(item => {
        const row = document.createElement('tr');
        
        // 名称列
        const nameCell = document.createElement('td');
        nameCell.textContent = item.name;
        nameCell.style.cssText = `
            border: 1px solid #e9ecef;
            padding: 15px;
            word-break: break-word;
        `;
        row.appendChild(nameCell);

        // 操作按钮列
        const actionCell = document.createElement('td');
        const actionBtn = document.createElement('button');
        actionBtn.textContent = "立即购买";
        actionBtn.style.cssText = `
            background: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.2s;
        `;
        
        // 按钮点击逻辑
        actionBtn.addEventListener('click', () => {
            if (typeof item.buyBtn.click === 'function') {
                item.buyBtn.click();
            } else {
                const event = new MouseEvent('click', {
                    view: window,
                    bubbles: true,
                    cancelable: true
                });
                item.buyBtn.dispatchEvent(event);
            }
        });
        
        actionBtn.addEventListener('mouseover', () => {
            actionBtn.style.transform = 'scale(1.05)';
            actionBtn.style.backgroundColor = '#45a049';
        });
        
        actionBtn.addEventListener('mouseout', () => {
            actionBtn.style.transform = 'scale(1)';
            actionBtn.style.backgroundColor = '#4CAF50';
        });
        
        actionCell.appendChild(actionBtn);
        row.appendChild(actionCell);
        tbody.appendChild(row);
    });
    table.appendChild(tbody);
    
    // 组装界面
    scrollContainer.appendChild(table);
    document.body.appendChild(scrollContainer);
    document.body.appendChild(toggleBtn);

    // 按钮点击切换显示状态
    toggleBtn.addEventListener('click', () => {
        const isVisible = scrollContainer.style.display !== 'none';
        scrollContainer.style.display = isVisible ? 'none' : 'block';
        toggleBtn.textContent = isVisible ? "显示" : "隐藏";
    });
})();