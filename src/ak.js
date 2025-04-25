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

(function () {
    "use strict";

    // 创建容器样式
    GM_addStyle(`
          .center-panel {
              position: fixed;
              bottom: 50px;
              left: 45%;
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
              background: linear-gradient(135deg,rgba(108, 92, 231, 0.94),rgba(168, 139, 235, 0.9));
          }
          #jumpBtn {
              background: linear-gradient(135deg,rgba(255, 107, 107, 0.94),rgba(255, 142, 142, 0.92));
          }
          #allBtn {
              background: linear-gradient(135deg,rgba(102, 255, 0, 0.93),rgba(222, 245, 176, 0.81));
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
    const panel = document.createElement("div");
    panel.className = "center-panel";
    document.body.appendChild(panel);

    // 滚动到底部按钮
    const closeBtn = document.createElement("button");
    closeBtn.id = "closeBtn";
    closeBtn.className = "action-btn";
    // closeBtn.innerHTML = "x";
    closeBtn.innerHTML = "❌";
    panel.appendChild(closeBtn);

    // 加载更多按钮
    const loadMoreBtn = document.createElement("button");
    loadMoreBtn.id = "loadMoreBtn";
    loadMoreBtn.className = "action-btn";
    loadMoreBtn.innerHTML = "↻";
    panel.appendChild(loadMoreBtn);

    // 整理表格按钮
    const allBtn = document.createElement("button");
    allBtn.id = "allBtn";
    allBtn.className = "action-btn";
    allBtn.innerHTML = "A";
    panel.appendChild(allBtn);

    // 筛选按钮
    const filtBtn = document.createElement("button");
    filtBtn.id = "loadMoreBtn";
    filtBtn.className = "action-btn";
    filtBtn.innerHTML = "✔️";
    panel.appendChild(filtBtn);

    // 滚动到底部按钮
    const jumpBtn = document.createElement("button");
    jumpBtn.id = "jumpBtn";
    jumpBtn.className = "action-btn";
    jumpBtn.innerHTML = "↓";
    panel.appendChild(jumpBtn);

    // 智能按钮查找函数
    function findLoadButton() {
      return new Promise((resolve) => {
        const check = () => {
          const candidates = [
            ...document.querySelectorAll(
              ".load-more, .next-page, .pagination-next"
            ),
            ...document.querySelectorAll(
              '[aria-label^="加载更多"], [data-action="load"]'
            ),
            ...document.querySelectorAll("button:not([disabled]):not([hidden])"),
          ];

          const validBtn = candidates.find(
            (btn) =>
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
      const clickEvent = new MouseEvent("click", {
        bubbles: true,
        cancelable: true,
        view: unsafeWindow,
        button: 0,
        buttons: 1,
        clientX: rect.left + 1,
        clientY: rect.top + 1,
      });

      ["mousedown", "click", "mouseup"].forEach((event) => {
        element.dispatchEvent(
          new MouseEvent(event, {
            bubbles: true,
            cancelable: true,
            view: unsafeWindow,
          })
        );
      });

      if (typeof element.click === "function") {
        element.click();
      }
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
        const btn = await findLoadButton();
        if (!btn) throw new Error("未找到加载按钮");

        btn.disabled = true;
        btn.classList.add("loading-indicator");

        simulateRealClick(btn);

        await waitForLoad();
        console.log("加载成功");
      } catch (error) {
        console.error("加载失败:", error);
      } finally {
        // 重置按钮状态
      }
    }

    // 模拟点击加载更多
    async function triggerLoadMore() {
      const btn = document.querySelector(
        '.load-more, .next-page, [aria-label^="加载更多"]'
      );
      if (!btn) {
        alert("未找到加载按钮！请检查选择器配置");
        return;
      }

      try {
        filtBtn.classList.add("loading");
        btn.disabled = true;

        // 模拟真实用户点击
        const clickEvent = new MouseEvent("click", {
          bubbles: true,
          cancelable: true,
          view: unsafeWindow,
        });
        console.log("Start to click LoadMore...");
        btn.dispatchEvent(clickEvent);
        // btn.click();  // 有些情况下比dispatchEvent更可靠

        // 等待内容加载
        console.log("Wait to LoadMore...");
        await new Promise((resolve) => setTimeout(resolve, 1500));
      } finally {
        filtBtn.classList.remove("loading");
        btn.disabled = false;
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
        if (isExpired) {
            return "已过期";
        }
        return `${days}天${hours}小时`;
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
    // 进阶版本（带单位白名单验证）：parseQuantityAdvanced("100核", ['核', 'M'])
    function parseQuantityAdvanced(inputStr, validUnits = []) {
      const result = parseQuantity(inputStr);

      if (!result) return null;

      // 单位白名单验证
      if (validUnits.length > 0 && !validUnits.includes(result.unit)) {
        console.warn(`无效单位: ${result.unit}`);
        return null;
      }

      return result;
    }

    function safeCombinePriceAndRenew(price, renew) {
      // 转换前验证数值类型
      if (typeof price !== "number" || typeof renew !== "number") {
        throw new Error("参数必须为数值类型");
      }
      return `${price}/${renew}`;
    }
      // 数据抓取和表格生成
    async function scrapeData(isFiltered = false) {
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
                const total   = network.split(' ')[5]  || 'N/A' ;
                let usedv = parseQuantity(used).num || 0;
                let totalv = parseQuantity(total).num || 0;
                let usedu = parseQuantity(used).unit || '';
                let totalu = parseQuantity(total).unit || '';
                if (usedu === 'TB' ) { usedv = (usedv * 1024).toFixed(2); usedu = 'GB'; }
                if (usedu === 'MB' ) { usedv = (usedv / 1024).toFixed(2); usedu = 'GB'; }
                if (usedv == 0 ) { usedu = ''; } // 处理0的情况
                if (totalu === 'TB' ) { totalv = (totalv * 1024).toFixed(2); totalu = 'GB'; }
                if (totalu === 'MB' ) { totalv = (totalv / 1024).toFixed(2); totalu = 'GB'; }


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

                // 买的条件：剩余流量大于50%，剩余天数大于14天
                const okBuy = timeDiff.days >= 23 && usedv < totalv*0.5 && (period === '月' && price<renewPrice*0.7 ) ? '✅' : '';
                const isBuy = timeDiff.days >= 23 && usedv < totalv*0.5 && (period === '月' && price<renewPrice*0.7 ) ? 'Y' : 'N';
                const pricetorenew = safeCombinePriceAndRenew(price, renewPrice);

                if ( daysleft > 12 || price<7 || ( cpu>1) ) {
                    if (( (isFiltered && isBuy === 'Y')  ) || ( !isFiltered )) {
                        data.push({ name, detail, location, period,node, type, cpu, mem, disk,
                            network, bandw, usedv,usedu, totalv,totalu, ipv4,ipv6,
                            price,sellPrice, renew,renewPrice, pricetorenew,
                            expire, daysleft,hourleft,dayOK: okBuy,isBuy,
                        });
                    }
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

    // 创建关闭按钮
    function createCloseButton(table) {
        const btn = document.createElement('button');
        btn.id = 'akile-close-btn';
        btn.style.cssText = `
            width: 40px;
            height: 40px;
            border: none;
            border-radius: 50%;
            background: #ff4d4f;
            color: white;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
            box-shadow: 0 2px 8px rgba(255, 77, 79, 0.4);
        `;

        btn.innerHTML = `
            <i class="fas fa-times" aria-hidden="true"></i>
        `;

        btn.addEventListener('click', () => {
            table.remove();
            document.getElementById('akile-btn-container').remove();
        });
        return btn;
    }
    // 创建结果表格
    function createResultTable(data) {
        const table = document.createElement('div');
        table.id = 'akile-scrape-table';
        table.style.cssText = `
            position: relative;
            z-index: 9999;
            background: rgba(149, 144, 144, 0.97);
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 6px 24px rgba(74, 73, 73, 0.15);
            max-width: 90vw;
            min-width: 600px;
            margin: 20px auto;
            font-family: system-ui, sans-serif;
        `;

        // 表格标题
        const title = document.createElement('h3');
        title.textContent = '服务器数据抓取结果';
        title.style.cssText = `
            margin: 0 0 15px 0;
            color: #1890ff;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        `;
        title.innerHTML = `
            <i class="fas fa-server fa-lg" aria-hidden="true"></i>
            <span>服务器数据抓取结果</span>
        `;
        table.appendChild(title);
        
        // 添加关闭按钮
        const closeButton = createCloseButton(table);
        title.appendChild(closeButton);

        // 表格内容
        const tableHtml = `
            <table style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="color:rgb(254, 253, 253);">
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">节点</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">状态</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">周期</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">保底</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">售/续</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">剩余</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">已用</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">流量</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">到期</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">带宽</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">CPU</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">RAM</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">Disk</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">IPv4</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">IPv6</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">地区</th>
                        <th style="padding: 12px; text-align: left; border-bottom: 1px solid #eee;">套餐</th>
                    </tr>
                </thead>
                <tbody>
                    ${data.map(item => `
                        <tr >
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;">${escapeHtml(item.node)}</td>
                            <td style="padding: 15px; border-bottom: 1px solid #f5f5f5;
                                ${item.detail === '被墙' ? 'color: #ff4d4f; font-weight: 700;' : 'color:rgba(1, 4, 0, 0.96);'}">
                                ${escapeHtml(item.detail)}
                            </td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;
                                ${item.period === '年' ? 'color:rgb(255, 0, 140);' : 'color:rgba(1, 4, 0, 0.96);'}">
                                ${escapeHtml(item.period)}
                            </td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;
                                ${item.isBuy === 'Y' ? 'color:rgb(0, 255, 51); font-weight: 700;' : 'color:rgba(1, 4, 0, 0.96);'}">
                                ￥${escapeHtml(item.sellPrice.toString())}${item.isBuy==='Y' ? '👈' : ''}
                            </td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;
                                ${item.price < item.renew.price*0.8 ? 'color:rgb(255, 242, 0); ' : 'color:rgb(4, 4, 4);'}">
                                ${item.pricetorenew}
                            </td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;
                                ${item.daysleft > 25 ? 'color:rgba(255, 238, 0, 0.93);font-weight: 700; ' : 'color:rgb(0, 0, 0);'}">
                                ${escapeHtml(item.daysleft)}天
                            </td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;
                                ${item.usedv > item.totalv*0.4 ? 'color:rgba(255, 0, 0, 0.93); ' : 'color:rgb(0, 0, 0);'}">
                                ${escapeHtml(item.usedv.toString())}${escapeHtml(item.usedu)}
                            </td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.totalv.toString())}${escapeHtml(item.totalu)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;white-space: nowrap;overflow: hidden;">${escapeHtml(item.expire)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.bandw)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;
                                ${item.cpu > 1 ? 'color:rgb(0, 26, 255);font-weight: 700; ' : 'color:rgb(0, 0, 0);'}">
                                ${escapeHtml(item.cpu)}核
                            </td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.mem)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.disk)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.ipv4)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.ipv6)}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;">${escapeHtml(item.location.slice(-2) || 'N/A')}</td>
                            <td style="padding: 12px; border-bottom: 1px solid #f5f5f5;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;">${escapeHtml(item.type)}</td>
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
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#039;",
      };
      return text.replace(/[&<>"']/g, (m) => map[m]);
    }
    // 智能滚动到底部
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

    // 滚动到底部功能
    function scrollToBottom() {
      window.scrollTo({
        top: document.body.scrollHeight,
        behavior: "smooth",
      });
    }

    // 滚动到底部功能
    function closeTable() {
        const oldTable = document.querySelector('#akile-scrape-table');
        if (oldTable) oldTable.remove();
      }
  
    function triggerAllData() {scrapeData(false);}
    function triggerFilteredData() {scrapeData(true);}

    // 绑定点击事件
    // loadBtn.addEventListener("click", handleLoadMore);
    allBtn.addEventListener("click", triggerAllData);
    filtBtn.addEventListener("click", triggerFilteredData);
    // loadBtn.addEventListener('click', triggerLoadMore);
    jumpBtn.addEventListener("click", smoothScrollToBottom);
    closeBtn.addEventListener("click", closeTable);

    // 按钮状态管理
    let isScrolled = false;
    window.addEventListener("scroll", () => {
      const threshold = 200;
      const shouldShow =
        window.scrollY < document.documentElement.scrollHeight - threshold;

      loadBtn.style.display = shouldShow ? "flex" : "none";
      allBtn.style.display = shouldShow ? "flex" : "none";
      filtBtn.style.display = shouldShow ? "flex" : "none";
      jumpBtn.style.display = shouldShow ? "flex" : "none";
    });

    // 初始状态设置
    window.dispatchEvent(new Event("scroll"));
  })();
