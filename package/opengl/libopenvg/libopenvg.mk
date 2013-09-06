################################################################################
#
# libopenvg
#
################################################################################

LIBOPENVG_SOURCE =
LIBOPENVG_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENVG))

ifeq ($(BR2_PACKAGE_MESA3D_OPENVG),y)
LIBOPENVG_DEPENDENCIES += mesa3d
endif

ifeq ($(LIBOPENVG_DEPENDENCIES),)
define LIBOPENVG_CONFIGURE_CMDS
	echo "No libOpenVG implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
