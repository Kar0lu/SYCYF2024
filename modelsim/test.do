project compileall
restart -f
delete wave *

add wave -position insertpoint  \
sim:/tb/clk


add wave -position insertpoint  \
sim:/tb/UUT/reg_c/shift
add wave -position insertpoint  \
sim:/tb/UUT/reg_c/reg_c
add wave -position insertpoint  \
sim:/tb/UUT/reg_c/data_out
add wave -position insertpoint  \
sim:/tb/UUT/reg_p/shift
add wave -position insertpoint  \
sim:/tb/UUT/reg_p/reg_p
add wave -position insertpoint  \
sim:/tb/UUT/reg_p/data_out

run