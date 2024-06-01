project compileall
restart -f
delete wave *
add wave -position insertpoint  \
sim:/tb/clk
add wave -position insertpoint  \
sim:/tb/reset
add wave -position insertpoint  \
sim:/tb/enc/start
add wave -position insertpoint  \
sim:/tb/enc/data_in
add wave -position insertpoint  \
sim:/tb/enc/data_out

add wave -position insertpoint  \
sim:/tb/dec/start
add wave -position insertpoint  \
sim:/tb/dec/data_in
add wave -position insertpoint  \
sim:/tb/dec/state
add wave -position insertpoint  \
sim:/tb/dec/reg_c
add wave -position insertpoint  \
sim:/tb/dec/reg_p
add wave -position insertpoint  \
sim:/tb/dec/data_out

run 130000