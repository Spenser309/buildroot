################################################################################
#
# mesa3d-demos
#
################################################################################

MESA3D_DEMOS_VERSION = 8.1.0
MESA3D_DEMOS_SOURCE = mesa-demos-$(MESA3D_DEMOS_VERSION).tar.bz2
MESA3D_DEMOS_SITE = ftp://ftp.freedesktop.org/pub/mesa/demos/$(MESA3D_DEMOS_VERSION)
MESA3D_DEMOS_INSTALL_STAGING = YES
MESA3D_DEMOS_AUTORECONF = YES
MESA3D_DEMOS_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_HAS_OPENGL),y)
MESA3D_DEMOS_DEPENDENCIES += libgl
MESA3D_DEMOS_CONF_OPT += --enable-gl
else
MESA3D_DEMOS_CONF_OPT += --disable-gl
endif

ifeq ($(BR2_PACKAGE_HAS_OPENGL_EGL),y)
MESA3D_DEMOS_DEPENDENCIES += libegl
MESA3D_DEMOS_CONF_OPT += --enable-egl
else
MESA3D_DEMOS_CONF_OPT += --disable-egl
endif

ifeq ($(BR2_PACKAGE_HAS_OPENGL_ES),y)
MESA3D_DEMOS_DEPENDENCIES += libgles
MESA3D_DEMOS_CONF_OPT += --enable-gles1 --enable-gles2
else
MESA3D_DEMOS_CONF_OPT += --disable-gles1 --disable-gles2
endif

ifeq ($(BR2_PACKAGE_HAS_OPENVG),y)
MESA3D_DEMOS_DEPENDENCIES += libopenvg
MESA3D_DEMOS_CONF_OPT += --enable-vg
else
MESA3D_DEMOS_CONF_OPT += --disable-vg
endif

ifeq ($(BR2_PACKAGE_MESA3D_GBM),y)
MESA3D_DEMOS_DEPENDENCIES += mesa3d
MESA3D_DEMOS_CONF_OPT += --enable-gbm
else
MESA3D_DEMOS_CONF_OPT += --disable-gbm
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
MESA3D_DEMOS_DEPENDENCIES += freetype
MESA3D_DEMOS_CONF_OPT += --enable-freetype2
else
MESA3D_DEMOS_CONF_OPT += --disable-freetype2
endif

ifeq ($(BR2_PACKAGE_WAYLAND),y)
MESA3D_DEMOS_DEPENDENCIES += wayland
MESA3D_DEMOS_CONF_OPT += --enable-wayland
else
MESA3D_DEMOS_CONF_OPT += --disable-wayland
endif

$(eval $(autotools-package))
