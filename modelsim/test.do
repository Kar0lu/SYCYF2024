project compileall
restart -f
delete wave *

add wave -position insertpoint  \
sim:/tb/clk
add wave -position insertpoint  \
sim:/tb/UUT/mode

add wave -position insertpoint  \
sim:/tb/UUT/controler/state
add wave -position insertpoint  \
sim:/tb/UUT/controler/data_in
add wave -position insertpoint  \
sim:/tb/UUT/controler/data_out

add wave -position insertpoint  \
sim:/tb/UUT/reg_e/shift
add wave -position insertpoint  \
sim:/tb/UUT/reg_e/local_reg

add wave -position insertpoint  \
sim:/tb/UUT/reg_c/shift
add wave -position insertpoint  \
sim:/tb/UUT/reg_c/local_reg

add wave -position insertpoint  \
sim:/tb/UUT/reg_p/shift
add wave -position insertpoint  \
sim:/tb/UUT/reg_p/local_reg

run