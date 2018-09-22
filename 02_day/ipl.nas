;hello-os
;TAB=4:设置TAB宽度为4
;标准FAT12格式软盘专用的代码
;DB:一个字节,可输入英文
;DW:16位,2字节
;DD:32位,4字节
;RESB:预留多少字节
;ORG:指明程序装载地址,$表示将要读入的内存地址
;JMP,跳转,类似goto
;entry:标签的声明,指定JMP指令的跳转目的地等
;MOV:赋值,
;	AX,0:AX赋值0。
;	SI,msg:msg地址是0x7c74,0x7c74代入SI寄存器
;	AL,[SI]:[]里面表示内存地址,把SI内存地址的一个字节内容写入AL中
;	BYTE [678],123:用内存678号地址8个存储单元(因为指定了byte)保存123,
;	WORD [678],123:123解释成16位数值,下位保存678,上位保存679
;	[SI]:如果SI保存是678,指定地址为678的内存
;ADD SI,1:SI=SI+1
;CMP:比较指令
;JE:跳转指令之一,fin表示结束
;	CMP a,3 JE fin <==> if(a==3){goto fin;}
;INT:软件中断指令,函数调用
;HLT:CPU停止,进入待机状态
;0x10:控制显卡
;JC:jump if carry,如果进位标志是1的话就跳转,0true,1false
;AX:累加寄存器
;CX:计数寄存器
;DX:数据寄存器
;BX:基址寄存器
;SP:栈指针寄存器
;BP:基址指针寄存器
;SI:源变址寄存器
;DI:目的变址制寄存器
;AL/AH:累加寄存器低/高位
;CL/CH:计数寄存器低/高位
;DL/DH:数据寄存器低/高位
;BL/BH:基址寄存器低/高位


		ORG		0x7c00			
;以下的记述用于标准FAT12格式的软盘
		JMP		entry			
		DB		0x90


		DB		"HELLOIPL"		;启动扇区名称(8字节)
		DW		512			;每个扇区(sector)大小(必须512字节)
		DB		1			;簇(cluster)大小(必须为1个扇区)
		DW		1			;FAT起始位置(一般为第一个扇区)
		DB		2			;FAT个数(必须为2)
		DW		224			;根目录大小(一般为224项)
		DW		2880			;该磁盘大小(必须为2880扇区1440*1024/512)
		DB		0xf0			;磁盘类型(必须0xf0)
		DW		9			;FAT的长度(必须是9扇区)
		DW		18			;1个磁道(track)有几个扇区(必须是18)
		DW		2			;磁头数(必须是2)
		DD		0			;不使用分区,必须是0
		DD		2880			;重写一次磁盘大小
		DB		0,0,0x29		;意义不明(固定)
		DD		0xffffffff		;(可能是)卷标号码
		DB		"HELLO-OS   "		;磁盘的名称(必须11字,不足填空格)
		DB		"FAT12   "		;磁盘格式名称(必须8字,不足填空格)
		RESB		18			;先空出18字节
; 程序主体
	entry:						
		MOV		AX,0			;初始化寄存器
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX
		MOV		ES,AX
		MOV		SI,msg
	putloop:
		MOV		AL,[SI]
		ADD		SI,1			;给SI加1

		CMP		AL,0
		JE		fin

		MOV		AH,0x0e			;显示一个文字
		MOV		BX,15			;指定字符颜色
		INT		0x10			;调用显卡BIOS
		JMP		putloop
	fin:
		HLT					;让CPU停止,等待指令
		JMP		fin			;无限循环
	msg:
		DB		0x0a, 0x0a
		DB		"hello, world"
		DB		0x0a
		DB		0

		RESB	0x7dfe-$		; 填写0x00直到0x001fe

		DB		0x55, 0xaa







