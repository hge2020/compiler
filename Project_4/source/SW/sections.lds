SECTIONS
{
  . = 0x00000000;
	.text : 
	{
		*(.text) 
		*(.rodata)
	}

	. = ALIGN(0x00016000);

	.data : {*(.data)}

	.bss : {*(.bss)}
}