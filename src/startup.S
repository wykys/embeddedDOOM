.global _start
.section .text.start, "ax"

_start:
        // run main function
        jal     ra, main
_exit:
        // program loop
        j       _exit
