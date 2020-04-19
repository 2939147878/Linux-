#!/bin/bash

zh_interface=("dict_cn_zh" "youdao_com_zh")
en_interface=("dict_cn_en" "youdao_com_en")

dict_cn_zh(){
        echo '---------dict---';
        res=`curl -s http://dict.cn/$1 |  grep '<a href="http://dict.cn/[a-zA-Z]' |  tr -d '\t' |  sed 's/<a href="http:\/\/dict.cn\///g'| sed 's/">/ /g' | sed '$d' `
}
dict_cn_en(){
        echo '---------dict---'
        res=`curl -s http://dict.cn/$1 |  tr -d '\t' | grep '^<strong>' | sed 's/<\/*strong>//g'`
}

youdao_com_zh(){
        echo '---------youdao---'
        res=`curl -s http://www.youdao.com/w/$1 | grep '[a-zA-Z]</span>' | tr -d ' ' | grep "^[a-zA-Z]" | sed 's/<\/span>/ /g'`
}

youdao_com_en(){
        echo '---------youdao---'
        res=`curl -s http://www.youdao.com/w/$1  | tr -d ' ' | tr -d '\t' | grep '[^a-zA-Z]</span>'  | grep "^[^a-zA-Z<>)(]" | sed 's/<\/span>/ /g'`
}

str_replace(){
        res_in=$*
        res_out=${res_in//"%20"/" "}
        res_out=${res_out//"%27"/"'"}
        res_out=${res_out//"%28"/"("}
        res_out=${res_out//"%29"/")"}
        res_out=${res_out//"%2C"/","}
        res_out=${res_out//"_2E"/"."}
}
if [ ! -z $1 ];then
        if [[ $1 =~ ^[a-zA-Z] ]];then
                for interface in ${en_interface[@]};do
                        $interface $1
                        str_replace $res
                        echo $res_out
                done
        else
                for interface in ${zh_interface[@]};do
                        $interface $1
                        str_replace $res
                        echo $res_out
                done
        fi
else
    echo '请输入... '
fi
