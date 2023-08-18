
.PHONY: build clear write build-all clear-all write-all

define build-project
	@cd $(1) && make
endef

define clear-project
	@cd $(1) && make cleardist
endef

define write-project
	@cd $(1) && fpcmake -w
endef

define run-project
	@cd $(1) && $(2)
endef

define debug-project
	@cd $(1) && cgdb $(2)
endef

build-all: \
	build-shooter01 \
	build-shooter02 \
	build-shooter03 \
	build-shooter04 \
	build-shooter05 \
	build-shooter06 \
	build-shooter07 \
	build-shooter08 \
	build-shooter09 \
	build-shooter10 \
	build-shooter11 \
	build-shooter12 \
	build-shooter13 \
	build-shooter14 \
	build-shooter15

clear-all: \
	clear-shooter01 \
	clear-shooter02 \
	clear-shooter03 \
	clear-shooter04 \
	clear-shooter05 \
	clear-shooter06 \
	clear-shooter07 \
	clear-shooter08 \
	clear-shooter09 \
	clear-shooter10 \
	clear-shooter11 \
	clear-shooter12 \
	clear-shooter13 \
	clear-shooter14 \
	clear-shooter15

write-all: \
	write-shooter01 \
	write-shooter02 \
	write-shooter03 \
	write-shooter04 \
	write-shooter05 \
	write-shooter06 \
	write-shooter07 \
	write-shooter08 \
	write-shooter09 \
	write-shooter10 \
	write-shooter11 \
	write-shooter12 \
	write-shooter13 \
	write-shooter14 \
	write-shooter15

# ******************** shooter01 ********************
build-shooter01:
	$(call build-project, sdl2Shooter/shooter01)

clear-shooter01:
	$(call clear-project, sdl2Shooter/shooter01)

write-shooter01:
	$(call write-project, sdl2Shooter/shooter01)

run-shooter01:
	$(call run-project, sdl2Shooter/shooter01, shooter01)

debug-shooter01:
	$(call debug-project, sdl2Shooter/shooter01, shooter01)

# ******************** shooter02 ********************
build-shooter02:
	$(call build-project, sdl2Shooter/shooter02)

clear-shooter02:
	$(call clear-project, sdl2Shooter/shooter02)

write-shooter02:
	$(call write-project, sdl2Shooter/shooter02)

run-shooter02:
	$(call run-project, sdl2Shooter/shooter02, shooter02)

debug-shooter02:
	$(call debug-project, sdl2Shooter/shooter02, shooter02)

# ******************** shooter03 ********************
build-shooter03:
	$(call build-project, sdl2Shooter/shooter03)

clear-shooter03:
	$(call clear-project, sdl2Shooter/shooter03)

write-shooter03:
	$(call write-project, sdl2Shooter/shooter03)

run-shooter03:
	$(call run-project, sdl2Shooter/shooter03, shooter03)

debug-shooter03:
	$(call debug-project, sdl2Shooter/shooter03, shooter03)

# ******************** shooter04 ********************
build-shooter04:
	$(call build-project, sdl2Shooter/shooter04)

clear-shooter04:
	$(call clear-project, sdl2Shooter/shooter04)

write-shooter04:
	$(call write-project, sdl2Shooter/shooter04)

run-shooter04:
	$(call run-project, sdl2Shooter/shooter04, shooter04)

debug-shooter04:
	$(call debug-project, sdl2Shooter/shooter04, shooter04)

# ******************** shooter05 ********************
build-shooter05:
	$(call build-project, sdl2Shooter/shooter05)

clear-shooter05:
	$(call clear-project, sdl2Shooter/shooter05)

write-shooter05:
	$(call write-project, sdl2Shooter/shooter05)

run-shooter05:
	$(call run-project, sdl2Shooter/shooter05, shooter05)

debug-shooter05:
	$(call debug-project, sdl2Shooter/shooter05, shooter05)

# ******************** shooter06 ********************
build-shooter06:
	$(call build-project, sdl2Shooter/shooter06)

clear-shooter06:
	$(call clear-project, sdl2Shooter/shooter06)

write-shooter06:
	$(call write-project, sdl2Shooter/shooter06)

run-shooter06:
	$(call run-project, sdl2Shooter/shooter06, shooter06)

debug-shooter06:
	$(call debug-project, sdl2Shooter/shooter06, shooter06)

# ******************** shooter07 ********************
build-shooter07:
	$(call build-project, sdl2Shooter/shooter07)

clear-shooter07:
	$(call clear-project, sdl2Shooter/shooter07)

write-shooter07:
	$(call write-project, sdl2Shooter/shooter07)

run-shooter07:
	$(call run-project, sdl2Shooter/shooter07, shooter07)

debug-shooter07:
	$(call debug-project, sdl2Shooter/shooter07, shooter07)

# ******************** shooter08 ********************
build-shooter08:
	$(call build-project, sdl2Shooter/shooter08)

clear-shooter08:
	$(call clear-project, sdl2Shooter/shooter08)

write-shooter08:
	$(call write-project, sdl2Shooter/shooter08)

run-shooter08:
	$(call run-project, sdl2Shooter/shooter08, shooter08)

debug-shooter08:
	$(call debug-project, sdl2Shooter/shooter08, shooter08)

# ******************** shooter09 ********************
build-shooter09:
	$(call build-project, sdl2Shooter/shooter09)

clear-shooter09:
	$(call clear-project, sdl2Shooter/shooter09)

write-shooter09:
	$(call write-project, sdl2Shooter/shooter09)

run-shooter09:
	$(call run-project, sdl2Shooter/shooter09, shooter09)

debug-shooter09:
	$(call debug-project, sdl2Shooter/shooter09, shooter09)

# ******************** shooter10 ********************
build-shooter10:
	$(call build-project, sdl2Shooter/shooter10)

clear-shooter10:
	$(call clear-project, sdl2Shooter/shooter10)

write-shooter10:
	$(call write-project, sdl2Shooter/shooter10)

run-shooter10:
	$(call run-project, sdl2Shooter/shooter10, shooter10)

debug-shooter10:
	$(call debug-project, sdl2Shooter/shooter10, shooter10)

# ******************** shooter11 ********************
build-shooter11:
	$(call build-project, sdl2Shooter/shooter11)

clear-shooter11:
	$(call clear-project, sdl2Shooter/shooter11)

write-shooter11:
	$(call write-project, sdl2Shooter/shooter11)

run-shooter11:
	$(call run-project, sdl2Shooter/shooter11, shooter11)

debug-shooter11:
	$(call debug-project, sdl2Shooter/shooter11, shooter11)

# ******************** shooter12 ********************
build-shooter12:
	$(call build-project, sdl2Shooter/shooter12)

clear-shooter12:
	$(call clear-project, sdl2Shooter/shooter12)

write-shooter12:
	$(call write-project, sdl2Shooter/shooter12)

run-shooter12:
	$(call run-project, sdl2Shooter/shooter12, shooter12)

debug-shooter12:
	$(call debug-project, sdl2Shooter/shooter12, shooter12)

# ******************** shooter13 ********************
build-shooter13:
	$(call build-project, sdl2Shooter/shooter13)

clear-shooter13:
	$(call clear-project, sdl2Shooter/shooter13)

write-shooter13:
	$(call write-project, sdl2Shooter/shooter13)

run-shooter13:
	$(call run-project, sdl2Shooter/shooter13, shooter13)

debug-shooter13:
	$(call debug-project, sdl2Shooter/shooter13, shooter13)

# ******************** shooter14 ********************
build-shooter14:
	$(call build-project, sdl2Shooter/shooter14)

clear-shooter14:
	$(call clear-project, sdl2Shooter/shooter14)

write-shooter14:
	$(call write-project, sdl2Shooter/shooter14)

run-shooter14:
	$(call run-project, sdl2Shooter/shooter14, shooter14)

debug-shooter14:
	$(call debug-project, sdl2Shooter/shooter14, shooter14)

# ******************** shooter15 ********************
build-shooter15:
	$(call build-project, sdl2Shooter/shooter15)

clear-shooter15:
	$(call clear-project, sdl2Shooter/shooter15)

write-shooter15:
	$(call write-project, sdl2Shooter/shooter15)

run-shooter15:
	$(call run-project, sdl2Shooter/shooter15, shooter15)

debug-shooter15:
	$(call debug-project, sdl2Shooter/shooter15, shooter15)
