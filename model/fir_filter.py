NUM_OF_TAPS: int = 3

INPUT_DATA: list[int] = [
    0xDE,
    0xAD,
    0xBE,
    0xEF,
    0xCA,
    0xFE,
    0xBA,
    0xBA,
    0xDE,
    0xDA
]

COEFS: list[int] = [
    2,
    4,
    8
]

DONE_FLAG: bool = False

DATA: list[int] = [
    1,
    2,
    3
]

CNT: int = 0
CURR_DATA: int = 0
CURR_COEF: int = 0
RESULT: int = 0


def print_all(input_data_flag: bool, input_data: int, mult: int) -> None:
    print(f"input_data_flag -> {input_data_flag}\n"
          f"input_data -> {hex(input_data)}\n"
          f"CNT -> {hex(CNT)}\n"
          f"CURR_DATA -> {hex(CURR_DATA)}\n"
          f"CURR_COEF -> {hex(CURR_COEF)}\n"
          f"mult -> {hex(mult)}\n"
          f"DONE_FLAG -> {hex(DONE_FLAG)}\n"
          f"    RESULT -> {hex(RESULT)}")


def fir_filter(input_data: int, input_data_flag: bool) -> int:
    global DONE_FLAG, DATA, CNT, CURR_DATA, CURR_COEF, RESULT

    if input_data_flag:
        RESULT = 0
        DONE_FLAG = False
        CURR_DATA = 0
        CURR_COEF = 0
        for it in range(NUM_OF_TAPS - 1, 0):
            if it != 0:
                DATA[it] = DATA[it - 1]
            else:
                DATA[it] = input_data

    if CNT != 0:
        CNT += 1
    else:
        CNT = input_data_flag

    if 0 < CNT < NUM_OF_TAPS + 1:
        CURR_DATA = DATA[CNT - 1]
        CURR_COEF = COEFS[CNT - 1]

    mult: int = CURR_DATA * CURR_COEF

    if not input_data_flag and not DONE_FLAG:
        RESULT += mult

    if CNT == NUM_OF_TAPS + 1:
        CNT = 0
        DONE_FLAG = True
    print_all(input_data_flag, input_data, mult)

    return RESULT


def main() -> None:
    idx: int = 0
    input_data_flag: bool = False
    for cycle in range(100):
        print(f"Cycle -> {cycle}")
        if cycle % 10 == 0:
            idx += 1
            input_data_flag = True
        else:
            input_data_flag = False
        fir_filter(INPUT_DATA[idx - 1], input_data_flag)


if __name__ == '__main__':
    main()
