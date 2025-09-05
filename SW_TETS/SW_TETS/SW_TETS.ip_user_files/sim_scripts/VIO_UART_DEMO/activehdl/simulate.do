transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+VIO_UART_DEMO  -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.VIO_UART_DEMO xil_defaultlib.glbl

do {VIO_UART_DEMO.udo}

run 1000ns

endsim

quit -force
