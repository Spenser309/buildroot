################################################################################
#
# libgl
#
################################################################################

LIBGL_SOURCE =

ifeq ($(BR2_PACKAGE_MESA_OPENGL),y)
LIBGL_DEPENDENCIES += mesa3d
endif

ifeq ($(LIBGL_DEPENDENCIES),)
define LIBOPENGL_CONFIGURE_CMDS
	echo "No libOpenGL implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
