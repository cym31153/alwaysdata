import requests

# 定义登录信息
login_url = "https://admin.alwaysdata.com/login/"
username = "corn31153@gmail.com"
password = "Corn2580852@"
user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36"

# 创建一个session对象
session = requests.Session()

# 设置User-Agent
session.headers.update({'User-Agent': user_agent})

# 获取登录页面
response = session.get(login_url)

# 获取CSRF token
csrf_token = response.cookies['csrftoken']

# 定义登录数据
login_data = {
    'csrfmiddlewaretoken': csrf_token,
    'login': username,
    'password': password,
}

# 提交登录请求
response = session.post(login_url, data=login_data, headers={'Referer': login_url})

# 访问https://admin.alwaysdata.com/log
response = session.get('https://admin.alwaysdata.com/log/', allow_redirects=False)

# 检查响应状态
if response.status_code == 200:
    print("登录成功")
elif response.status_code in [301, 302]:
    print("登录失败，状态码：", response.status_code)
else:
    print("未知状态，状态码：", response.status_code)
