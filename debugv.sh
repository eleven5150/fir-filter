#!/bin/bash


SIMULATOR_PATH="/mnt/c/Study/Orlov/gtkwave/bin/gtkwave.exe"


simulate() {
    $SIMULATOR_PATH "$SOURCE_NAME.vcd"
}


execute() {
    vvp "$SOURCE_NAME.vvp" &
    sleep 1
    kill -9 $!
}


verify() {
    SOURCE_NAME=$(basename "$SOURCE_PATH" ".v")
    ERROR=$(iverilog -o "$SOURCE_NAME.vvp" "$TESTBENCH_PATH" "$SOURCE_PATH" 2>&1 > /dev/null)
    if [ "$ERROR" ]; then
        echo "Error in verification"
        echo "$ERROR"
        exit 1
    fi
}


print_usage() {
    echo "Usage: bash debugv.sh - tool for debugging a programs on verilog.

            Options:
            -s, --source - path to source file,
            -t, --testbench - path to testbench file,
            -h, --help - show this help message."
}


parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
        -s | --source)
            SOURCE_PATH="$2"
            shift
            shift
            ;;
        -t | --testbench)
            TESTBENCH_PATH="$2"
            shift
            shift
            ;;
        -h | --help)
            print_usage
            exit 0
            ;;
        -*)
            echo "Unknown option $1, see -h|--help"
            exit 1
            ;;
        esac
    done
    if [ -z "$SOURCE_PATH" ]; then
        echo "Source verilog file required!"
        print_usage
        exit 0
    fi
    if [ -z "$TESTBENCH_PATH" ]; then
        echo "Testbench verilog file required!"
        print_usage
        exit 0
    fi
}


main() {
    parse_args "$@"

    verify
    execute
    simulate
}


main "$@"
exit 0
