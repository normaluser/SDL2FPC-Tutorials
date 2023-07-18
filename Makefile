
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

build-shooter01:
	$(call build-project, sdl2Shooter/shooter01)

clear-shooter01:
	$(call clear-project, sdl2Shooter/shooter01)

write-shooter01:
	$(call write-project, sdl2Shooter/shooter01)

run-shooter01:
	$(call run-project, sdl2Shooter/shooter01, shooter01)
