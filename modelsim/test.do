project compileall
restart -f
delete wave *

add wave -position insertpoint  \
sim:/tb/clk
add wave -position insertpoint  \
sim:/tb/UUT/mode

add wave -position insertpoint  \
sim:/tb/UUT/u_controler/state
add wave -position insertpoint  \
sim:/tb/UUT/u_controler/data_in
add wave -position insertpoint  \
sim:/tb/UUT/u_controler/data_out

add wave -position insertpoint  \
sim:/tb/UUT/u_reg_e/shift
add wave -position insertpoint  \
sim:/tb/UUT/u_reg_e/local_reg

add wave -position insertpoint  \
sim:/tb/UUT/u_reg_c/shift
add wave -position insertpoint  \
sim:/tb/UUT/u_reg_c/local_reg
add wave -radix decimal -position insertpoint  \
sim:/tb/UUT/u_reg_c/count

add wave -position insertpoint  \
sim:/tb/UUT/u_reg_p/shift
add wave -position insertpoint  \
sim:/tb/UUT/u_reg_p/local_reg
add wave -radix decimal -position insertpoint  \
sim:/tb/UUT/u_reg_p/count

run 4000