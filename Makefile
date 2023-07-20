
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

build-all: build-shooter01
clear-all: clear-shooter01

# ******************** shooter01 ********************
build-shooter01:
	$(call build-project, sdl2Shooter/shooter01)

clear-shooter01:
	$(call clear-project, sdl2Shooter/shooter01)

write-shooter01:
	$(call write-project, sdl2Shooter/shooter01)

run-shooter01:
	$(call run-project, sdl2Shooter/shooter01, shooter01)

# ******************** shooter01 ********************
build-shooter02:
	$(call build-project, sdl2Shooter/shooter02)

clear-shooter02:
	$(call clear-project, sdl2Shooter/shooter02)

write-shooter02:
	$(call write-project, sdl2Shooter/shooter02)

run-shooter02:
	$(call run-project, sdl2Shooter/shooter02, shooter02)

# ******************** shooter03 ********************
build-shooter03:
	$(call build-project, sdl2Shooter/shooter03)

clear-shooter03:
	$(call clear-project, sdl2Shooter/shooter03)

write-shooter03:
	$(call write-project, sdl2Shooter/shooter03)

run-shooter03:
	$(call run-project, sdl2Shooter/shooter03, shooter03)

# ******************** shooter04 ********************
build-shooter04:
	$(call build-project, sdl2Shooter/shooter04)

clear-shooter04:
	$(call clear-project, sdl2Shooter/shooter04)

write-shooter04:
	$(call write-project, sdl2Shooter/shooter04)

run-shooter04:
	$(call run-project, sdl2Shooter/shooter04, shooter04)

# ******************** shooter05 ********************
build-shooter05:
	$(call build-project, sdl2Shooter/shooter05)

clear-shooter05:
	$(call clear-project, sdl2Shooter/shooter05)

write-shooter05:
	$(call write-project, sdl2Shooter/shooter05)

run-shooter05:
	$(call run-project, sdl2Shooter/shooter05, shooter05)
