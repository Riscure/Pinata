/* Different target formats
elf32-littlearm: ELF file for a little-endian ARM architecture
elf32-bigarm: ELF file for a big-endian ARM architecture.
*/
OUTPUT_FORMAT ("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
/* Internal Memory Map
rom: read-executable region
ram: read-write-executable region
*/
MEMORY
{
	rom (rx)  : ORIGIN = 0x08000000, LENGTH = 0x00100000 
	ram (rwx) : ORIGIN = 0x20000000, LENGTH = 0x00020000
	ram1 (rwx) : ORIGIN = 0x10000000, LENGTH = 0x00010000
}
/* end address of ram memory */
_eram = 0x20000000 + 0x00020000;
/* Section Definitions */ 
SECTIONS 
{ 
    /* code */
    .text : 
    { 
        KEEP(*(.isr_vector .isr_vector.*)) 
        *(.text .text.* .gnu.linkonce.t.*) 	      
        *(.glue_7t) *(.glue_7)		                
        *(.rodata .rodata* .gnu.linkonce.r.*)		    	                  
    } > rom
    /* exception handling 
    __exidx_start: start of the exception index section
    __exidx_end: end of the exception index section
    */
    .ARM.extab : 
    {
        *(.ARM.extab* .gnu.linkonce.armextab.*)
    } > rom
    
    __exidx_start = .;
    .ARM.exidx :
    {
        *(.ARM.exidx* .gnu.linkonce.armexidx.*)
    } > rom
    __exidx_end = .;
    
    . = ALIGN(4); 
    _etext = .;
    _sidata = .; 
    /* initialized data section
    */
    .data : AT (_etext) 
    { 
        _sdata = .; 
        *(.data .data.*) 
        . = ALIGN(4); 
        _edata = . ;
    } > ram

    /* .bss section which is used for uninitialized data */ 
    .bss (NOLOAD) : 
    { 
        _sbss = . ; 
        *(.bss .bss.*) 
        *(COMMON) 
        . = ALIGN(4); 
        _ebss = . ; 
    } > ram
    
    /* stack section */
    .co_stack (NOLOAD):
    {
        . = ALIGN(8);
        *(.co_stack .co_stack.*)
    } > ram
       
    . = ALIGN(4); 
    _end = . ; 
} 