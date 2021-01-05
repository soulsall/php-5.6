1.通过更改php_install_path.txt文件中的路径指定php-5.6.33安装的目录路径

2.若需要更改安装php-5.6.33的版本,修改php_install.sh脚本中verison="5.6.33" 为verison="需要安装的版本号"

3.错误日志路径为安装目录路径下的log/error_php56.log

4.慢日志路径为安装目录路径下log/slow_php56.log

5.一键安装脚本chmod +x php_install.sh && ./php_install.sh

安装步骤说明:
git 获取代码,进入代码目录,执行 chmod +x php_install.sh && ./php_install.sh 将自动完成php-5.6.33安装
