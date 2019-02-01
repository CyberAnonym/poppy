#!/usr/bin/python
#coding:utf-8
import xlrd
import xlwt
from datetime import date,datetime

file=r'F:\test\demo.xlsx'
#参考url：http://www.jb51.net/article/60510.htm
def read_excel():
    #打开文件
    workbook = xlrd.open_workbook(file)
    # 获取所有sheet
    print workbook.sheet_names()  # [u'sheet1', u'sheet2'] 打印的是sheet的名字，中文会转为unicode编码
    sheet2_name = workbook.sheet_names()[1]
    # 根据sheet索引或者名称获取sheet内容
    sheet2 = workbook.sheet_by_index(1)  # sheet索引从0开始
    # sheet的名称，行数，列数
    print sheet2.name,sheet2.nrows,sheet2.ncols  #nrows 是sheet的行数，ncols是sheet的列数。
    # 获取整行和整列的值（数组）
    #print
    rows = sheet2.row_values(3) # 获取第四行内容
    cols = sheet2.col_values(2)  # 获取第三列内容

    print('the line 4 content is: ' + str(rows))
    print('The column 3 content is ' + str(cols))

    # 获取单元格内容
    print ('第二行第一列的值是：' + sheet2.cell(1, 0).value.encode('utf-8')) #打印第二行第一列的值，转编码为utf-8
    print sheet2.cell_value(1, 0).encode('utf-8')
    print sheet2.row(1)[0].value.encode('utf-8')
    # 获取单元格内容的数据类型，返回的值是0，说明这个单元格的值是空值
    print sheet2.cell(1, 0).ctype


if __name__== '__main__':
 read_excel()