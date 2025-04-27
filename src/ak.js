// ==UserScript==
// @name         AkileCloud 自动加载更多
// @namespace    https://akak.github.io
// @version      1.0.0
// @description  在AkileCloud页面右下角添加自动加载按钮
// @author       AI助手
// @match        https://akile.io/console/pushshop
// @grant        GM_addStyle
// @grant        GM_xmlhttpRequest
// @grant        unsafeWindow  // 添加这一行
// ==/UserScript==
// ×♥∨↓↑▽△▼☆★

(function () {
  "use strict";

  // 创建容器样式
  GM_addStyle(`
      .center-panel {
          z-index: 9998;
          position: fixed;
          bottom: 50px;
          left: 30px;
          transform: translateX(-50%);
          display: flex;
          gap: 10px;
      }
      .table-container {
          z-index: 9997;
          position: relative;
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
          color:rgb(166, 208, 248);
          border-bottom: 2px solid #f0f0f0;
          padding-bottom: 10px;
          display: flex;
          align-items: center;
          gap: 10px;
      }
      .table-container:hover {
          box-shadow: 0 8px 24px rgba(118, 250, 61, 0.25);
      }
      /* 基础表格样式 */
      .table-style {
        width: 100%;
        border-collapse: collapse; /* 合并边框 */
        margin: 20px 0;
        font-family: 'Segoe UI', system-ui, sans-serif;
        box-shadow: 0 1px 3px rgba(0,0,0,0.12);
      }
      .table-second {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      /* 表头样式 */
      .table-style th {
        background: linear-gradient(135deg, #2c3e50, #3498db); /* 渐变背景 */
        color: white;
        padding: 15px 20px;
        text-align: left;
        border-bottom: 3px solid #34495e; /* 加粗底部边框 */
        text-transform: uppercase; /* 字母大写 */
        letter-spacing: 0.05em; /* 字间距 */
        position: sticky; /* 粘性定位 */
        top: 0; /* 固定表头 */
        z-index: 2; /* 确保表头在最上层 */
      }

      /* 表格行样式 */
      .table-style tr {
        transition: all 0.3s ease; /* 平滑过渡效果 */
      }

      /* 鼠标悬停行效果 */
      .table-style tr:hover {
        background-color: rgba(40, 195, 209, 0.27); /* 悬停半透明背景 */
        transform: translateY(-1px); /* 轻微上移 */
        box-shadow: 0 4px 8px rgba(0,0,0,0.1); /* 添加阴影 */
      }

      /* 表格单元格样式 */
      .table-style td {
        padding: 12px 20px;
        border-bottom: 1px solid #ecf0f1; /* 浅灰色分割线 */
        color: #34495e;
      }
      .table-style td.td-second {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      /* 斑马条纹效果（偶数行） */
      .table-style tr:nth-child(even) td {
        background-color:rgba(165, 190, 214, 0.96); /* 浅灰背景 */
      }

      /* 最后一行强调 */
      .table-style tr:last-child td {
        border-bottom: 2px solid #3498db; /* 加粗底部边框 */
      }

      /* 响应式设计（移动端适配） */
      @media screen and (max-width: 600px) {
        .table-style {
          display: block;
          overflow-x: auto;
        }
        
        .table-style td,
        .table-style th {
          padding: 8px 12px;
          font-size: 14px;
        }
      }

      /* 焦点状态（可访问性） */
      .table-style tr:focus-within {
        outline: 3px solid #3498db;
        outline-offset: 2px;
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
          background: linear-gradient(135deg,rgb(133, 160, 144),rgb(208, 216, 211));
          box-shadow: 
              inset 0 -4px 6px rgba(0,0,0,0.1),
              inset 0 4px 6px rgba(255,255,255,0.2);
          box-shadow: 0 4px 12px rgba(0,0,0,0.2);
          transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      }
      /* 按钮悬停效果 */
      .action-btn:hover {
          background-color: #45a049 !important;
          transform: scale(1.05);
          box-shadow: 0 6px 16px rgba(232, 253, 113, 0.2);
      }
      .buy-button {
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
      .buy-button:hover {
        transform: scale(1.05);
        background-color:rgba(69, 160, 73, 0.68) !important;
        box-shadow: 0 4px 14px rgba(248, 54, 54, 0.3);
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
        top: '60px',
        left: '50%',
        transform: 'translate(-50%, -50%)',
        padding: '12px 24px',
        background: 'rgba(100, 90, 90, 0.8)',
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
    // 2秒后移除
    setTimeout(() => { msgBox.remove(); }, 2000);
  }
  // 创建容器
  const panel = document.createElement("div");
  panel.className = "center-panel";
  panel.style.flexDirection = 'column';
  document.body.appendChild(panel);

  // 关闭按钮
  const closeBtn = document.createElement("button");
  closeBtn.id = "closeBtn";
  // closeBtn.innerHTML = "x";
  closeBtn.innerHTML = "❌";
  closeBtn.className = "action-btn";

  // 显隐按钮
  const toggleBtn = document.createElement("button");
  toggleBtn.id = "toggleBtn";
  toggleBtn.innerHTML = "隐";
  toggleBtn.display = "none"; // 默认隐藏
  toggleBtn.className = "action-btn";
  toggleBtn.style.color = "rgb(249, 21, 0)";
  
  // 加载更多按钮
  const loadMoreBtn = document.createElement("button");
  loadMoreBtn.id = "loadMoreBtn";
  loadMoreBtn.innerHTML = "↻";
  loadMoreBtn.className = "action-btn";

  // 加载并滚动按钮
  const loadScrollBtn = document.createElement("button");
  loadScrollBtn.id = "loadScrollBtn";
  loadScrollBtn.innerHTML = "∨";
  loadScrollBtn.className = "action-btn";
  loadScrollBtn.style.color = "rgb(0, 4, 255)";

  // 整理表格按钮
  const allBtn = document.createElement("button");
  allBtn.id = "allBtn";
  allBtn.innerHTML = "A";
  allBtn.className = "action-btn";
  allBtn.style.color = "rgb(9, 255, 0)";

  // 筛选按钮
  const filtBtn = document.createElement("button");
  filtBtn.id = "filtBtn";
  filtBtn.innerHTML = "✔️";
  filtBtn.className = "action-btn";

  // 筛选按钮
  const supperBtn = document.createElement("button");
  supperBtn.id = "supperBtn";
  supperBtn.innerHTML = "S";
  supperBtn.className = "action-btn";
  supperBtn.style.color = "rgba(0, 21, 249, 0.94)";

  // 滚动到底部按钮
  const jumpBtn = document.createElement("button");
  jumpBtn.id = "jumpBtn";
  jumpBtn.innerHTML = "↓";
  jumpBtn.className = "action-btn";
  jumpBtn.style.color = "rgba(208, 0, 255, 0.94)";

  // 添加按钮到容器
  // panel.appendChild(closeBtn);
  panel.appendChild(toggleBtn);
  panel.appendChild(filtBtn);
  panel.appendChild(supperBtn);
  panel.appendChild(allBtn);
  panel.appendChild(jumpBtn);
  panel.appendChild(loadMoreBtn);
  panel.appendChild(loadScrollBtn);

  // 真实点击模拟器
  function simulateRealClick(element) {
    if (!element || !(element instanceof Element)) {
      console.warn('Invalid element provided for click simulation');
      return;
    }

    const rect = element.getBoundingClientRect();
    const clickOptions = {
      bubbles: true,
      cancelable: true,
      view: unsafeWindow,
      button: 0,
      buttons: 1,
      clientX: rect.left + rect.width / 2,
      clientY: rect.top + rect.height / 2
    };

    // 触发完整点击事件序列
    ['mousedown', 'click', 'mouseup'].forEach(eventType => {
      element.dispatchEvent(new MouseEvent(eventType, clickOptions));
    });

    // 调用原生click方法作为后备
    if (typeof element.click === 'function') {
      element.click();
    }
    }

  // 智能按钮查找函数
  function findLoadButton() {
    return new Promise((resolve, reject) => {
      let retryCount = 0;
      const maxRetries = 3;
      const checkInterval = 500;
  
      const check = () => {
        const candidates = [...document.querySelectorAll(".load-more button")];
        const validBtn = candidates.find(
          (btn) =>
            btn.offsetHeight > 0 &&
            btn.offsetWidth > 0 &&
            btn.getBoundingClientRect().top < window.innerHeight
        );
        // const validBtn = document.querySelectorAll(".load-more button")
  
        if (validBtn) {
          resolve(validBtn);
        } else if (retryCount < maxRetries) {
          retryCount++;
          setTimeout(check, checkInterval);
        } else {
          reject(new Error("Max retries reached without finding button"));
        }
      };
      
      check();
    });
  }

  // 智能等待加载完成
  function waitForLoad() {
    return new Promise((resolve, reject) => {
      const check = () => {
        const isLoading = document.querySelector(
          ".loading, .spinner, .is-loading"
        );
        const hasMore = document.querySelector(".load-more");

        if (isLoading) {
          // smoothScrollToBottom();
          setTimeout(check, 300);
        } else if (hasMore) {
          resolve();
        } else {
          reject(new Error("加载失败或无更多内容"));
        }
      };
      check();
    });
  }

  // 主逻辑
  async function handleLoadMore() {
    try {
      smoothScrollToBottom();
      const btn = await findLoadButton();
      if (!btn) {
        throw new Error("未找到加载更多按钮");
        // showMessage(" 📛 未找到加载更多按钮！📛 ");
      }

      btn.disabled = true;
      btn.classList.add("loading-indicator");
      simulateRealClick(btn);

      await waitForLoad();
      // showMessage(" ✨ 加载成功  ");
      // console.log("✅ 加载成功");
    } catch (error) {
      showMessage(" ⛔ 加载失败:"+ error);
      console.log(error);
    } finally {
      // 重置按钮状态
      if (btn) {
        btn.disabled = false;
        btn.classList.remove("loading-indicator");
        smoothScrollToBottom();
      }
    }
  }

  function handleAutoLoadMore(btn){
    let isRunning = false;
    let intervalId = null;

    if (isRunning) return;
        
    function resetButton() {
        isRunning = false;
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

    // btn.textContent = '正在加载...';
    showMessage(" 👉 正在加载...");
    btn.disabled = true;

    intervalId = setInterval(() => {
        const loadMoreBtn = document.querySelector('.load-more button');
        
        if (loadMoreBtn) {
            try {
                loadMoreBtn.click();
                showMessage(" 👉 正在自动加载 ...");
                smoothScrollToBottom();
            } catch (error) {
                console.error(' 点击按钮时出错:', error);
                clearInterval(intervalId);
                resetButton();
            }
        } else {
            // 没有更多按钮时停止
            showMessage(" 👉 自动加载完成 👈 ");
            smoothScrollToBottom();
            clearInterval(intervalId);
            resetButton();
        }
    }, 1000); // 每秒检查一次
  }
  // 模拟点击加载更多
  async function triggerLoadMore() {
    const btn = document.querySelector( '.load-more button' );
    if (!btn) {
      showMessage(" ⚠️ 未找到加载更多按钮！⚠️ ");
      smoothScrollToBottom();
      return;
    }

    try {
      loadMoreBtn.classList.add("loading");
      btn.disabled = true;

      // 模拟真实用户点击
      const clickEvent = new MouseEvent("click", {
        bubbles: true,
        cancelable: true,
        view: unsafeWindow,
      });
      showMessage(" 👉 Start to click LoadMore...");
      btn.dispatchEvent(clickEvent);
      // btn.click();  // 有些情况下比dispatchEvent更可靠

      // 等待内容加载
      showMessage(" 👉 Wait to LoadMore ...");
      await new Promise((resolve) => setTimeout(resolve, 1500));
    } finally {
      loadMoreBtn.classList.remove("loading");
      btn.disabled = false;
      smoothScrollToBottom();
    }
  }

  function clickLoadMore(is2Scroll = false, ) {
    const realBtn = document.querySelector('.load-more button');
    if (realBtn) {
      realBtn.click();
      if (is2Scroll) { smoothScrollToBottom(false); }
      // console.log('✅ 已点击加载更多');
    } else {
      // console.warn('⚠️ 未找到加载更多按钮');
      showMessage(' >> 未找到加载更多按钮 << ');
    }
  }

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

  // 时间格式化函数
  function formatTimeDifference(days, hours, isExpired) {
      if (isExpired) { return "已过期"; }
      return `${days}天${hours}小时`;
  }

  // * 解析价格周期字符串（增强版）
  function parsePricePeriod(inputStr) {
      // 增强型正则表达式（支持无周期标识）
      const regex = /^¥([\d,]+(?:\.\d{1,2})?)(?:\/([^\s/]+))?$/;
      const match = inputStr.match(regex);

      if (!match) { throw new Error('Invalid price format'); }

      // 处理价格部分
      let priceStr = match[1].replace(/,/g, '');
      // 处理无小数部分的情况
      if (!/\./.test(priceStr)) { priceStr += '.00'; }
      const price = parseFloat(priceStr).toFixed(2);

      // 处理周期部分（自动处理空值）
      const period = match[2] ? match[2].trim() : '';

      return {
          price: Number(price),
          period: period || ''  // 显式处理空字符串
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
  
  function safeCombinePriceAndRenew(price, renew) {
    // 转换前验证数值类型
    if (typeof price !== "number" || typeof renew !== "number") {
      throw new Error("参数必须为数值类型");
    }
    return `${price}/${renew}`;
  }
  
  // 数据抓取和表格生成
  async function scrapeData(isFiltered = false, isOnlySuper = false) {
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
              const detailStr = card.querySelector('.server-detail')?.textContent.trim() || 'N/A';
              let detail = detailStr.slice(-3).split(']')[0] || 'N/A';

              const infoBodies = card.querySelectorAll('div.server-info');
              const location   = infoBodies[0].querySelector('.info-value')?.textContent.trim() || 'N/A';
              const node       = infoBodies[1].querySelector('.info-value')?.textContent.trim() || 'N/A';
              const type       = infoBodies[2].querySelector('.info-value')?.textContent.trim() || 'N/A';

              const conf = infoBodies[3].querySelector('.info-value')?.textContent.trim() || 'N/A';
          //   const cpu  = conf.split(' ')[0] || 'N/A';
              const cpu  = conf.split(' ')[0].split('核')[0] || 'N/A';
              const mem  = conf.split(' ')[0].split('核')[1] || 'N/A';
              const disk = conf.split(' ')[1] || 'N/A';

              const network = infoBodies[4].querySelector('.info-value')?.textContent.trim() || 'N/A';
              const bandw   = network.split(' ')[1]  || 'N/A' ;
              const used    = network.split(' ')[3]  || 'N/A' ;
              let usedv  = 0;
              let totalv = 0;
              let usedu  = '';
              let totalu = '';
              if (used === '无限制') {
                usedu   = '无限制' ;
                totalu  = '无限制' ;
              }else{
                const total   = network.split(' ')[5]  || 'N/A' ;
                usedv  = parseQuantity(used).num   || 0;
                totalv = parseQuantity(total).num  || 0;
                usedu  = parseQuantity(used).unit  || '';
                totalu = parseQuantity(total).unit || '';
                if (usedu === 'TB' ) { usedv = (usedv * 1024).toFixed(2); usedu = 'GB'; }
                if (usedu === 'MB' ) { usedv = (usedv / 1024).toFixed(2); usedu = 'GB'; }
                if (usedu === 'KB' ) { usedv = (usedv / 1024 / 1024).toFixed(2); usedu = 'GB'; }
                if (usedv == 0 ) { usedu = ''; } // 处理0的情况
                if (totalu === 'TB' ) { totalv = (totalv * 1024).toFixed(2); totalu = 'GB'; }
                if (totalu === 'MB' ) { totalv = (totalv / 1024).toFixed(2); totalu = 'GB'; }
              }

              const ipstr = infoBodies[5].querySelector('.info-value')?.textContent.trim() || 'N/A';
              const ipv4  = ipstr.split(' ')[1] || 'N/A';
              const ipv6  = ipstr.split(' ')[3] || 'N/A';

              const renewStr   = infoBodies[6].querySelector('.info-value')?.textContent.trim() || 'N/A';
              const renew      = parsePricePeriod(renewStr)
          //   const period     = renew.period[renew.period.length - 1] || 'N/A'; // 获取最后一个字符作为周期
          //   const period     = renewStr[renewStr.length - 1] || 'N/A';
              const period     = renewStr.slice(-1) || 'N/A';
              const renewPrice = renew.price;
          //   console.log(period, renewPrice);

              const expire     = infoBodies[8].querySelector('.info-value')?.textContent.trim() || 'N/A';
              const timeDiff   = calculateTimeDifference(expire);
              const daysleft   = timeDiff.days.toString();
              const hourleft   = timeDiff.hours.toString();
          //   const dayOK = timeDiff.days >= 14 ? '✔️' : '❌';
              // const dayOK = timeDiff.days >= 14 ? '✅' : '⛔';
              //   const dayOK = timeDiff.days >= 14 ? 'Yes' : 'No';

              const srvManage = card.querySelector('.server-manage') || 'N/A';
              const priceStr  = srvManage.querySelector('.shop-server-price')?.textContent.trim() || 'N/A';
              const price     = parsePricePeriod(priceStr).price;
              const sellPrice = Math.ceil(price/0.9) || 0;
            //   const buyButton = srvManage.querySelector('.manage-btn button');
              const buyBtn = document.createElement('button');
              buyBtn.id = "buyBtn";
              buyBtn.innerHTML = "B";
              buyBtn.className = "buy-button";
              buyBtn.addEventListener('click', () => {
                const realBtn = srvManage.querySelector('.manage-btn button');
                if (realBtn) {
                  realBtn.click();
                } else {
                  console.warn('⚠️ 未找到加载更多按钮');
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
              } else if (isFiltered) {
                is2Push = isBuy === 'Y';
              }
              else{
                is2Push = true;
              }
                // is2Push = daysleft > 12 || price<7 || ( cpu>1);
                // is2Push = is2Push && (( (isFiltered && isBuy === 'Y')  ) || ( !isFiltered ));
              // }

              if ( is2Push ) {
                  data.push({ card, name, detail, location, period,node, type, cpu, mem, disk,
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
      toggleBtn.style.display = 'block'; // 显示隐藏按钮
  }

  // 创建关闭按钮
  function createCloseButton(table) {
      const btn = document.createElement('button');
      btn.id = 'akile-close-btn';
      btn.style.cssText = `
          width: 20px;
          height: 20px;
          border: none;
          border-radius: 40%;
          background:rgb(251, 71, 74);
          color: white;
          cursor: pointer;
          display: flex;
          align-items: center;
          justify-content: center;
          transition: all 0.3s;
          box-shadow: 0 2px 8px rgba(255, 77, 79, 0.4);
      `;

      // btn.innerHTML = `⛔`;
      btn.innerHTML = `x`;

      btn.addEventListener('click', () => {
          table.remove();
          toggleBtn.style.display = 'none'; // 显示隐藏按钮
          document.getElementById('akile-btn-container').remove();
      });
      return btn;
  }
  // 创建关闭按钮
  function createHideButton(table) {
      const btn = document.createElement('button');
      btn.id = 'akile-hide-btn';
      btn.style.cssText = `
          width: 20px;
          height: 20px;
          border: none;
          border-radius: 40%;
          background:rgba(202, 250, 10, 0.98);
          color: white;
          cursor: pointer;
          display: flex;
          align-items: center;
          justify-content: center;
          transition: all 0.3s;
          box-shadow: 0 2px 8px rgba(255, 77, 79, 0.4);
      `;

      btn.innerHTML = `-`;
      btn.addEventListener('click', () => { showTable(); });
      return btn;
  }
  // 创建结果表格
  function createResultTable(data) {
      const tabdiv = document.createElement('div');
      tabdiv.id = 'akile-scrape-table';
      tabdiv.className = 'table-container';

      // 表格标题
      const title = document.createElement('h3');
      title.textContent = '服务器列表';
      title.innerHTML = `
          <i class="fas fa-server fa-lg" aria-hidden="true"></i>
          <span>服务器列表</span>
      `;
      tabdiv.appendChild(title);

      // 添加关闭按钮
      const closeButton = createCloseButton(tabdiv);
      title.appendChild(closeButton);

      const hideButton = createHideButton(tabdiv);
      title.appendChild(hideButton);

    const table = document.createElement('table');
    table.className = 'table-style';
    // 创建表头
    const thead = document.createElement('thead');
    const headerRow = document.createElement('tr');
    
    const tbhList = ['节点', '状态', '周期', '购买', '保底', '售/续', '剩余', '已用', '流量', '到期', '带宽', 'CPU', 'RAM', 'Disk', 'IPv4', 'IPv6', '地区', '套餐'];
    // const tbhList = ['节点', '状态', '周期', '购买', '保底'];
    tbhList.forEach(text => {
        const th = document.createElement('th');
        th.textContent = text;
        headerRow.appendChild(th);
    });
    thead.appendChild(headerRow);
    table.appendChild(thead);

    // 创建表格内容
    const tbody = document.createElement('tbody');
    data.forEach(item => {
        const row = document.createElement('tr');
        
        // 名称列
        const nodeCell = document.createElement('td');
        nodeCell.textContent = item.node;
        nodeCell.className = 'td-second';
        
        const detailCell = document.createElement('td');
        detailCell.textContent = item.detail;
        if (item.detail === '被墙') {
            detailCell.style.color = '#ff4d4f';
            detailCell.style.fontWeight = '700';
        }
        detailCell.className = 'td-second';

        const periodCell = document.createElement('td');
        periodCell.textContent = item.period;

        // 操作按钮列
        const buyBtn = document.createElement('button');
        buyBtn.textContent = "B";
        buyBtn.className = "buy-button";
        
        // 按钮点击逻辑
        buyBtn.addEventListener('click', () => {
            if (typeof item.buyBtn.click === 'function') {
                item.buyBtn.click();
                showTable();
                item.card.scrollIntoView({ behavior: 'smooth' });
                showMessage(' >> 触发购买按钮 << ');
            } else {
                const event = new MouseEvent('click', {
                    view: window,
                    bubbles: true,
                    cancelable: true
                });
                item.buyBtn.dispatchEvent(event);
            }
        });

        const actionCell = document.createElement('td');
        // 创建包裹容器（用于处理布局）
        const container = document.createElement('span');
        container.style.whiteSpace = 'nowrap';    // 强制不换行
        container.style.verticalAlign = 'middle'; // 垂直居中
        buyBtn.style.display = 'inline-flex';     // 使用弹性布局更好控制
        container.appendChild(buyBtn);
        if (item.isBuy === 'Y') {
          const tagright = document.createTextNode('👈');
          container.appendChild(tagright); 
        }
        actionCell.appendChild(container);   

        const sellPriceCell = document.createElement('td');
        sellPriceCell.textContent = "￥" + item.sellPrice;
        if (item.isBuy === 'Y') {
            sellPriceCell.style.color = 'rgb(0, 255, 51)';
            sellPriceCell.style.fontWeight = '700';
        } 

        const price2renewCell = document.createElement('td');
        price2renewCell.textContent = item.pricetorenew;
        if (item.price < item.renew.price*0.8) {
            price2renewCell.style.color = 'rgb(255, 242, 0)';
            // price2renewCell.style.fontWeight = '700';
        } 

        const daysleftCell = document.createElement('td');
        daysleftCell.className = 'td-second';
        daysleftCell.textContent = item.daysleft+"天";
        if (item.daysleft > 25) {
            daysleftCell.style.color = 'rgba(255, 238, 0, 0.93)';
            // daysleftCell.style.fontWeight = '700';
        } else if (item.daysleft < 12) {
            daysleftCell.style.color = 'rgba(255, 0, 0, 0.93)'; 
        }
        
        const usedvCell = document.createElement('td');
        usedvCell.textContent = item.usedv.toString()+item.usedu;
        if (item.usedv  > item.totalv*0.4) {
            usedvCell.style.color = 'rgba(255, 0, 0, 0.93)'; 
        }

        const totalvCell = document.createElement('td');
        totalvCell.textContent = item.totalv.toString()+item.totalu;

        const expireCell = document.createElement('td');
        expireCell.className = 'td-second';
        expireCell.textContent = item.expire;

        const bandwCell = document.createElement('td');
        bandwCell.textContent = item.bandw;

        const cpuCell = document.createElement('td');
        cpuCell.textContent = item.cpu.toString()+'核';
        if (item.cpu  > 1) {
            cpuCell.style.color = 'rgb(51, 0, 255)'; 
            cpuCell.style.fontWeight = '700';
        }

        const memCell = document.createElement('td');
        memCell.textContent = item.mem;

        const diskCell = document.createElement('td');
        diskCell.textContent = item.disk;

        const ipv4Cell = document.createElement('td');
        ipv4Cell.textContent = item.ipv4;

        const ipv6Cell = document.createElement('td');
        ipv6Cell.textContent = item.ipv6;

        const locationCell = document.createElement('td');
        locationCell.className = 'td-second';
        locationCell.textContent = item.location.slice(-2) || 'N/A';

        const typeCell = document.createElement('td');
        typeCell.textContent = item.type;
        typeCell.className = 'td-second';

        row.appendChild(nodeCell);
        row.appendChild(detailCell);
        row.appendChild(periodCell);
        row.appendChild(actionCell);
        row.appendChild(sellPriceCell);
        row.appendChild(price2renewCell);
        row.appendChild(daysleftCell);
        row.appendChild(usedvCell);
        row.appendChild(totalvCell);
        row.appendChild(expireCell);
        row.appendChild(bandwCell);
        row.appendChild(cpuCell);
        row.appendChild(memCell);
        row.appendChild(diskCell);
        row.appendChild(ipv4Cell);
        row.appendChild(ipv6Cell);
        row.appendChild(locationCell);
        row.appendChild(typeCell);

        tbody.appendChild(row);
    });
    table.appendChild(tbody);

    tabdiv.appendChild(table);
    return tabdiv;
  }

  // HTML转义函数
  function escapeHtml(text) {
    const map = {
      "&": "&amp;",
      "<": "&lt;",
      ">": "&gt;",
      '"': "&quot;",
      "'": "&#039;",
    };
    return text.replace(/[&<>"']/g, (m) => map[m]);
  }

  //===============
  // 智能滚动到底部
  function smoothScrollToBottom(is2LoadMore=false) {
    const scrollHeight = Math.max(
      document.body.scrollHeight,
      document.documentElement.scrollHeight
    );

    window.scrollTo({
      top: scrollHeight,
      behavior: "smooth",
    });

    if (is2LoadMore) { clickLoadMore();}
  }

  function smoothScrollToTable(is2LoadMore=false) {
    const scrollHeight = Math.max(
      document.body.scrollHeight,
      document.documentElement.scrollHeight
    );
    
    const targetTable = document.querySelector('#akile-scrape-table');
    if (!targetTable) return;
    // const tableHeight = targetTable.getBoundingClientRect().top + window.scrollY;
    targetTable.scrollIntoView({
        behavior: 'smooth',
        block: 'start'
    });

    // 可选：高亮表格（添加延时移除）
    targetTable.style.outline = '2px solid #ff9800';
    setTimeout(() => {
        targetTable.style.outline = '';
    }, 2000);
    
  }

  // 关闭结果表格
  function closeTable() {
      const oldTable = document.querySelector('#akile-scrape-table');
      if (oldTable) oldTable.remove();
    }
  // 关闭结果表格
  function showTable() {
    const oldTable = document.querySelector('#akile-scrape-table');
    if (!oldTable) { 
      toggleBtn.style.display = 'none';
      return; 
    }
    const isVisible = oldTable.style.display !== 'none';
    oldTable.style.display = isVisible ? 'none' : 'block';
    toggleBtn.textContent = isVisible ? "显" : "隐";
    if (!isVisible) { smoothScrollToTable(); }
  }

  //==============
  // 绑定点击事件
  closeBtn.addEventListener("click", closeTable);
  allBtn.addEventListener("click", () => {scrapeData(false);});
  filtBtn.addEventListener("click", () => {scrapeData(true);});
  supperBtn.addEventListener("click", () => {scrapeData(false,true);});
  jumpBtn.addEventListener("click", () => {smoothScrollToBottom(false);});

  // loadMoreBtn.addEventListener('click', () => {clickLoadMore(false);});
  loadMoreBtn.addEventListener('click', () => {triggerLoadMore();});

  // loadScrollBtn.addEventListener('click', () => {clickLoadMore(true);});
  // loadScrollBtn.addEventListener('click', () => {handleLoadMore();});
  loadScrollBtn.addEventListener('click', () => {handleAutoLoadMore(loadScrollBtn);});


  // 按钮点击切换显示状态
  toggleBtn.addEventListener('click', () => { showTable(); });

  // 按钮状态管理
  let isScrolled = false;
  window.addEventListener("scroll", () => {
    const threshold = 200;
    const shouldShow = window.scrollY < document.documentElement.scrollHeight - threshold;

    jumpBtn.style.display       = shouldShow ? "flex" : "none";
    closeBtn.style.display      = shouldShow ? "flex" : "none";
    // toggleBtn.style.display     = shouldShow ? "flex" : "none";

    allBtn.style.display        = shouldShow ? "flex" : "none";
    filtBtn.style.display       = shouldShow ? "flex" : "none";
    supperBtn.style.display     = shouldShow ? "flex" : "none";
    loadMoreBtn.style.display   = shouldShow ? "flex" : "none";
    loadScrollBtn.style.display = shouldShow ? "flex" : "none";
  });

  // 初始状态设置
  window.dispatchEvent(new Event("scroll"));
})();
