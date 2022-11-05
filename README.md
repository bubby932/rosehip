# rosehip
A Work-In-Progress 64-bit operating system written in x86 assembly and Davis.

# Notable Features
* All code is run in kernel space, there is minimal virtualization of memory and no disk swapping.
* The full system, including the bootloader, kernel, and OS itself, are 100% independent of **any** standard, (yes, including unix and POSIX), and fully custom.
* The entire system is written in either [Davis](https://github.com/bubby932/DavisRewrite) or raw x86 assembly (Assembled using `nasm`).

# NOTES
* Anything in the `/scratch` directory is for planning or reference purposes ONLY and does not actually contain any real Rosehip source.