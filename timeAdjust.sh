#!/bin/sh
[ $# -ne 1 ] && exit 1
path=$1
offset=15690399   # 偏差的创建时间，单位秒

files=$(ls $path)
for filename in $files
do
    cdate=$(stat -t %Y%m%d%H%M%S $path/$filename | awk '{print $10}')
    cdate=${cdate:1:14}
    # echo $cdate
    ctime=`date -j -f %Y%m%d%H%M%S $cdate +%s`
    mtime=$((ctime + offset))   # 如果时间偏差是变小了，这里 - 改为 +
    mdate=`date -r $mtime +%Y%m%d%H%M`
    echo $filename $cdate $mdate
    touch -t $mdate $path/$filename
    touch -mt $mdate $path/$filename
    jhead -dsft $path/$filename # 修改照片拍摄时间为文件修改时间，需要安装命令 brew install jhead
done