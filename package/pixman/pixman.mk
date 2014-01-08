################################################################################
#
# pixman
#
################################################################################

PIXMAN_VERSION = 0.30.0
PIXMAN_SITE = http://xorg.freedesktop.org/releases/individual/lib
PIXMAN_LICENSE = MIT
PIXMAN_LICENSE_FILES = COPYING

PIXMAN_INSTALL_STAGING = YES
PIXMAN_DEPENDENCIES = host-pkgconf
PIXMAN_AUTORECONF = YES

# don't build gtk based demos
PIXMAN_CONF_OPT = --disable-gtk --disable-tests --disable-demos

# disable iwmmxt support for CPU's that don't have
# this feature
ifneq ($(BR2_iwmmxt),y)
PIXMAN_CONF_OPT += --disable-arm-iwmmxt
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
