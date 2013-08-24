################################################################################
#
# glmark2
#
################################################################################

GLMARK2_VERSION = 279
GLMARK2_SITE = http://bazaar.launchpad.net/~laanwj/glmark2/fbdev
GLMARK2_SITE_METHOD = bzr
GLMARK2_LICENSE = GPLv3+ SGIv1
GLMARK2_LICENSE_FILES = COPYING COPYING.SGI

GLMARK2_DEPENDENCIES = jpeg libpng12 mesa3d host-pkgconf

GLMARK2_CONF_OPTS = --prefix=/usr/

GLMARK2_CONF_ENV = LDFLAGS="-lrt -lpthread"

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER)$(BR2_PACKAGE_HAS_OPENGL_ES),yy)
GLMARK2_DEPENDENCIES += libegl libgles
GLMARK2_FLAVORS += x11-glesv2
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER)$(BR2_PACKAGE_HAS_OPENGL),yy)
GLMARK2_DEPENDENCIES += libgl
GLMARK2_FLAVORS += x11-gl
endif

ifeq ($(BR2_PACKAGE_HAS_OPENGL_EGL)$(BR2_PACKAGE_HAS_OPENGL_ES),yy)
GLMARK2_DEPENDENCIES += libdrm libegl libgles
GLMARK2_FLAVORS += drm-glesv2 fbdev-glesv2
endif

ifeq ($(BR2_PACKAGE_HAS_OPENGL_EGL)$(BR2_PACKAGE_HAS_OPENGL),yy)
GLMARK2_DEPENDENCIES += libdrm libgl
GLMARK2_FLAVORS += drm-gl
endif

ifeq ($(BR2_PACKAGE_WAYLAND)$(BR2_PACKAGE_HAS_OPENGL_ES),yy)
GLMARK2_DEPENDENCIES += wayland libegl libgles
GLMARK2_FLAVORS += wayland-glesv2
endif

ifeq ($(BR2_PACKAGE_WAYLAND)$(BR2_PACKAGE_HAS_OPENGL),yy)
GLMARK2_DEPENDENCIES += wayland libgl
GLMARK2_FLAVORS += wayland-gl
endif

ifeq ($(BR2_PACKAGE_SUNXI_MALI),y)
GLMARK2_CONF_OPTS += --for-mali
endif

GLMARK2_CONF_OPTS += \
	--with-flavors=$(subst $(space),$(comma),$(GLMARK2_FLAVORS))

define GLMARK2_CONFIGURE_CMDS
	cd $(@D) && \
		$(TARGET_MAKE_ENV) $(GLMARK2_CONF_ENV) $(TARGET_CONFIGURE_OPTS) ./waf configure \
		$(GLMARK2_CONF_OPTS)
endef

define GLMARK2_BUILD_CMDS
	cd $(@D) && $(TARGET_MAKE_ENV) ./waf
endef

define GLMARK2_INSTALL_TARGET_CMDS
	cd $(@D) && $(TARGET_MAKE_ENV) ./waf install --destdir=$(TARGET_DIR)
endef

$(eval $(generic-package))
