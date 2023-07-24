
.PHONY: build clear build-all clear-all

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
	build-shooter08

clear-all: \
	clear-shooter01 \
	clear-shooter02 \
	clear-shooter03 \
	clear-shooter04 \
	clear-shooter05 \
	clear-shooter06 \
	clear-shooter07 \
	clear-shooter08

write-all: \
	write-shooter01 \
	write-shooter02 \
	write-shooter03 \
	write-shooter04 \
	write-shooter05 \
	write-shooter06 \
	write-shooter07 \
	write-shooter08

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

# ******************** shooter01 ********************
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
