/*
 * January 2004 - Changed to support H4 device
 * Copyright (c) 2004-2008 Texas Instruments
 *
 * (C) Copyright 2002
 * Gary Jennejohn, DENX Software Engineering, <garyj@denx.de>
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

//输出可执行文件是elf格式，32位ARM指令，小端
OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
//输出可执行文件的运行环境是arm平台
OUTPUT_ARCH(arm)
//指定输出可执行文件的起始代码段为_start(在start.S中定义)
ENTRY(_start)
SECTIONS
{
	. = 0x00000000;//将当前地址定位到ox00000000处，操作符用来表示当前地址

	. = ALIGN(4);//代码以四字节对齐
	.text	://定义.text段
	{
	//段由start.o cpu_init.o等中的.text段所有段组成
		cpu/arm_cortexa9/start.o		(.text)//代码的第一个代码部分
		cpu/arm_cortexa9/s5pc210/cpu_init.o	(.text)
		board/samsung/smdkc210/lowlevel_init.o	(.text)
		common/ace_sha1.o (.text)
		*(.text)
	}

	. = ALIGN(4);
	.rodata : { *(SORT_BY_ALIGNMENT(SORT_BY_NAME(.rodata*))) }//指定.rodata段(只读数据段)由所有输入文件的.rodata段组成

	. = ALIGN(4);
	.data : { *(.data) }//指定.data段读写数据段，由所有输入文件的.rodata段组成

	. = ALIGN(4);
	.got : { *(.got) }//.got段由所有输入文件的.got段组成，got段是uboot自定义的一个段，非标准段

	__u_boot_cmd_start = .;//_u_boot_cmd_start的值被设置为了当前地址
	.u_boot_cmd : { *(.u_boot_cmd) }//.uboot_cmd段由所有文件的.u_boot_cmd组成
	__u_boot_cmd_end = .;//_u_boot_cmd_end变量的值被赋值为了当前地址

	. = ALIGN(4);//定位器当前地址，4字节对齐
	__bss_start = .;//把_bss_start赋值为当前地址，即bss段的开始位置
	.bss : { *(.bss) }//.bss段由所有输入文件的.bss段组成
	_end = .;//把_end赋值为当前位置，即bss段的结束位置
}
