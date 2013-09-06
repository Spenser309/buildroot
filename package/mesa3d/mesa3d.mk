################################################################################
#
# mesa3d
#
################################################################################

MESA3D_VERSION = 9.1.6
MESA3D_SOURCE = MesaLib-$(MESA3D_VERSION).tar.gz
MESA3D_SITE = ftp://ftp.freedesktop.org/pub/mesa/$(MESA3D_VERSION)
MESA3D_LICENSE = MIT, SGI, Khronos
MESA3D_LICENSE_FILES = docs/license.html

MESA3D_AUTORECONF = YES
MESA3D_INSTALL_STAGING = YES

MESA3D_DEPENDENCIES = \
	libdrm \
	expat \
	host-xutil_makedepend \
	host-libxml2 \
	host-python \
	host-bison \
	host-flex

MESA3D_CONF_OPT = \
	--disable-static

MESA3D_CONF_ENV = \
	LIBS="-lrt -lpthread"

# Libraries

ifeq ($(BR2_PACKAGE_MESA3D_GBM),y)
MESA3D_DEPENDENCIES += udev
MESA3D_CONF_OPT += --enable-gbm
else
MESA3D_CONF_OPT += --disable-gbm
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER),y)
MESA3D_DEPENDENCIES += \
	xproto_xf86driproto xproto_dri2proto xproto_glproto \
	xlib_libX11 xlib_libXext xlib_libXdamage xlib_libXfixes libxcb
MESA3D_CONF_OPT += \
	--enable-dri \
	--enable-xa \
	--enable-glx
else
MESA3D_CONF_OPT += \
	--disable-dri \
	--disable-xa \
	--disable-glx
endif

# Drivers

#Gallium Drivers
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_I915)     += i915
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_NOUVEAU)  += nouveau
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_R300)     += r300
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_R600)     += r600
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_RADEONSI) += radeonsi
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_SVGA)     += svga
MESA3D_GALLIUM_DRIVERS-$(BR2_PACKAGE_MESA3D_GALLIUM_DRIVER_SWRAST)   += swrast
# DRI Drivers
MESA3D_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_DRI_DRIVER_SWRAST) += swrast
MESA3D_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_DRI_DRIVER_I965)   += i965
MESA3D_DRI_DRIVERS-$(BR2_PACKAGE_MESA3D_DRI_DRIVER_RADEON) += radeon

ifneq ($(MESA3D_GALLIUM_DRIVERS),)
MESA3D_CONF_OPT += \
	--with-gallium-drivers=$(subst $(space),$(comma),$(MESA3D_GALLIUM_DRIVERS-y))
else
MESA3D_CONF_OPT += --without-gallium-drivers
endif

ifneq ($(MESA3D_DRI_DRIVERS),)
MESA3D_CONF_OPT += \
	--with-dri-drivers=$(subst $(space),$(comma),$(MESA3D_DRI_DRIVERS-y))
else
MESA3D_CONF_OPT += --without-dri-drivers
endif

# APIs

ifeq ($(BR2_PACKAGE_MESA3D_EGL),y)
MESA3D_EGL_PLATFORMS = drm
ifeq ($(BR2_PACKAGE_WAYLAND),y)
MESA3D_DEPENDENCIES += wayland
MESA3D_EGL_PLATFORMS += wayland
endif
ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER),y)
MESA3D_EGL_PLATFORMS += x11
endif
MESA3D_CONF_OPT += \
	--enable-egl \
	--with-egl-platforms=$(foreach subst $(space),$(comma),$(MESA3D_EGL_PLATFORMS))
else
MESA3D_CONF_OPT += --disable-egl
endif

ifeq ($(BR2_PACKAGE_MESA3D_OPENGL),y)
MESA3D_CONF_OPT += --enable-opengl
else
MESA3D_CONF_OPT += --disable-opengl
endif

ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_ES),y)
MESA3D_CONF_OPT += --enable-gles1 --enable-gles2
else
MESA3D_CONF_OPT += --disable-gles1 --disable-gles2
endif

ifeq ($(BR2_PACKAGE_MESA3D_OPENVG),y)
MESA3D_CONF_OPT += --enable-openvg --enable-gallium-egl
else
MESA3D_CONF_OPT += --disable-openvg --disable-gallium-egl
endif

ifeq ($(BR2_PACKAGE_MESA3D_OPENCL),y)
MESA3D_CONF_OPT += --enable-opencl
else
MESA3D_CONF_OPT += --disable-opencl
endif

$(eval $(autotools-package))
