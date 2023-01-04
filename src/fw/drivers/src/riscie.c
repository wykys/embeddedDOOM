#include "riscie.h"

inline void vga_clear()
{
    for (int i = 0; i < 4950; i += 4)
        vram_write_32b(i, 0);
}

inline void vga_power(const uint8_t state)
{
    if (state == 0 || state == 1) SR->VGA_POWER = state;
}
