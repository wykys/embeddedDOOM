#include "basic_print.h"

struct {
    uint32_t x;
    uint32_t y;
} static volatile cursor = { .x = 0, .y = 0 };

void set_cursor(uint32_t x, uint32_t y)
{
    cursor.x = x;
    cursor.y = y;
}

const uint32_t CODE_4B_TO_32B[16] = {
    0x00000000, // 0x00
    0x000000FF, // 0x01
    0x0000FF00, // 0x02
    0x0000FFFF, // 0x03
    0x00FF0000, // 0x04
    0x00FF00FF, // 0x05
    0x00FFFF00, // 0x06
    0x00FFFFFF, // 0x07
    0xFF000000, // 0x08
    0xFF0000FF, // 0x09
    0xFF00FF00, // 0x0A
    0xFF00FFFF, // 0x0B
    0xFFFF0000, // 0x0C
    0xFFFF00FF, // 0x0D
    0xFFFFFF00, // 0x0E
    0xFFFFFFFF  // 0x0F
};

void basic_print(char *str)
{
    for (uint32_t i = 0; str[i]; i++)
    {
        if (str[i] == '\n')
        {
            cursor.x = 0;
            if (++cursor.y > SCREEN_CHAR_HEIGHT)
            {
                cursor.y = 0;
            }
            continue;
        }
        else if (str[i] == '\r')
        {
            cursor.x = 0;
            continue;
        }

        for (uint32_t y = 0; y < CHAR_Y_SIZE; y++)
        {
            uint32_t address;
            uint32_t value;

            uint8_t char_line = ASCII[(uint8_t) str[i]][y];

            address = (cursor.x * CHAR_X_SIZE) + ((y + (cursor.y * CHAR_Y_SIZE)) * SCREEN_PX_WIDTH);
            value   = CODE_4B_TO_32B[char_line & 0x0F];
            vram_write_32b(address, value);

            address += 4;
            value    = CODE_4B_TO_32B[char_line >> 4];
            vram_write_32b(address, value);
        }

        if (++cursor.x > SCREEN_CHAR_WIDTH)
        {
            cursor.x = 0;
            if (++cursor.y > SCREEN_CHAR_HEIGHT)
            {
                cursor.y = 0;
            }
        }
    }
} /* basic_print */
