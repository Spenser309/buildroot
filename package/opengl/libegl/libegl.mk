################################################################################
#
# libegl
#
################################################################################

LIBEGL_SOURCE =
LIBEGL_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENGL_EGL))

ifeq ($(BR2_PACKAGE_MESA3D_EGL),y)
LIBEGL_DEPENDENCIES += mesa3d
endif

ifeq ($(LIBEGL_DEPENDENCIES),)
define LIBEGL_CONFIGURE_CMDS
	echo "No libEGL implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
