.global _start
.word _estack
.section .text.start, "ax"

_start:
        // set stack pointer
        lui     sp, %hi(_estack)     // load high 20b into SP
        addi    sp,sp, %lo(_estack)  // add low 12b into SP

        // run init function
        jal     ra, _init

        // run main function
        jal     ra, main
_exit:
        // program loop
        j       _exit

.weak  _init
_init:
        ret
