import datetime

# 获取当前日期和时间
now = datetime.datetime.now()

# 格式化日期和时间
date_time_str = now.strftime("%Y%m%d_%H-%M-%S")

# 创建一个以日期和时间命名的空文本文件
with open(f"{date_time_str}.txt", "w") as file:
    pass  # 什么也不做，只是创建文件

# 文件已创建，可以继续其他操作
print(f" -> 创建{date_time_str}.txt")