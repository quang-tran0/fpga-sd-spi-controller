VLIB ?= vlib
VLOG ?= vlog
VSIM ?= vsim

TOP := tb_spi_master
WORK := work
WLF ?= spi_master.wlf
FILELIST := compile.f

.PHONY: all compile test wave clean

all: test

compile: $(WORK)
	$(VLOG) -sv -work $(WORK) -f $(FILELIST)

$(WORK):
	$(VLIB) $(WORK)

test: compile
	rm -f $(WLF)
	$(VSIM) -c -voptargs=+acc -wlf $(WLF) $(WORK).$(TOP) \
		-do "onbreak {quit -code 1}; onerror {quit -code 1}; log -r /*; run -all; quit -f"
	test -s $(WLF)

wave: test
	$(VSIM) -view $(WLF) -do "add wave -r /*"

clean:
	rm -rf $(WORK) transcript vsim.wlf $(WLF)
