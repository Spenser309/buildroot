################################################################################
#
# libgles
#
################################################################################

LIBGLES_SOURCE =
LIBGLES_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENGL_ES))

ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_ES),y)
LIBGLES_DEPENDENCIES += mesa3d
endif

ifeq ($(LIBGLES_DEPENDENCIES),)
define LIBGLES_CONFIGURE_CMDS
	echo "No libGLES implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
