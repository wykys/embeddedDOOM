/* Program entry point */
ENTRY(_start)

/* Highest address of the user mode stack */
_estack = 0x7FFFC;    /* end of RAM */

/* Generate a link error if heap and stack don't fit into RAM */
_min_heap_size = 0x200;      /* required amount of heap  */
_min_stack_size = 0x400; /* required amount of stack */

/* Specify the memory areas */
MEMORY
{
    RAM (rw)   : ORIGIN = 0x00000000, LENGTH = 512K   /* KiB */
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 16384K /* KiB */
}

SECTIONS
{
    /* The program code and other data goes into FLASH */
    .text :
    {
        . = ALIGN(4);
        *(.text.start)
        *(.text.init)
        *(.text)           /* .text sections (code) */
        *(.text*)          /* .text* sections (code) */
        . = ALIGN(4);
        _etext = .;        /* define a global symbols at end of code */
    } >FLASH

    /* Constant data goes into FLASH */
    .rodata :
    {
        . = ALIGN(4);
        *(.rodata)         /* .rodata sections (constants, strings, etc.) */
        *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
        . = ALIGN(4);
    } >RAM AT> FLASH

    /* Initialized data sections goes into RAM, load LMA copy after code */
    .data :
    {
        . = ALIGN(4);
        *(.data)           /* .data sections */
        *(.data*)          /* .data* sections */
        *(.*data*)         /* .data* sections */
        . = ALIGN(4);
    } >RAM AT> FLASH

    /* Uninitialized data section */
    .bss :
    {
        /* This is used by the startup in order to initialize the .bss secion */
        _sbss = .;         /* define a global symbol at bss start */
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;         /* define a global symbol at bss end */
    } >RAM

    /* User_heap_stack section, used to check that there is enough RAM left */
    ._user_heap_stack :
    {
        . = ALIGN(8);
        PROVIDE ( end = . );
        PROVIDE ( _end = . );
        . = . + _min_heap_size;
        . = . + _min_stack_size;
        . = ALIGN(8);
    } >RAM
}
