#!/usr/bin/python3
# the program generates an initialization assembler
# with a dump .data section of the elf file
# wykys 2022


def load_data_from_bin(path: str) -> tuple:
    with open(path, 'rb') as fr:
        return tuple(
            int.from_bytes(bytes(data), 'little')
            for data in zip(*(iter(fr.read()),) * 4)
        )


def generate_init_asm(path: str, data: tuple) -> None:

    asm = '''
.global _init
.section .text.init, "ax"

_init:'''

    for i, value in enumerate(data):
        address = i * 4
        asm += f'''
        li      t0,0x{address:08x}
        li      t1,0x{value:08x}
        sw      t1,0(t0)'''

    asm += '\n        ret\n'

    with open(path, 'w') as fw:
        fw.writelines(asm)


if __name__ == '__main__':

    rodata = load_data_from_bin('build/rodata.bin')
    data = load_data_from_bin('build/data.bin')
    generate_init_asm('build/init.S', rodata + data)
