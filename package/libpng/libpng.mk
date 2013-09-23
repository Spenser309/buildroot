################################################################################
#
# libpng
#
################################################################################

LIBPNG_VERSION = 1.6.8
LIBPNG_SERIES = 16
LIBPNG_SOURCE = libpng-$(LIBPNG_VERSION).tar.xz
LIBPNG_SITE = http://downloads.sourceforge.net/project/libpng/libpng${LIBPNG_SERIES}/$(LIBPNG_VERSION)
LIBPNG_LICENSE = libpng license
LIBPNG_LICENSE_FILES = LICENSE
LIBPNG_INSTALL_STAGING = YES
LIBPNG_DEPENDENCIES = host-pkgconf zlib
LIBPNG_CONFIG_SCRIPTS = libpng$(LIBPNG_SERIES)-config libpng-config
LIBPNG_CONF_OPT = $(if $(BR2_ARM_CPU_HAS_NEON),--enable-arm-neon=yes,--enable-arm-neon=no)

# Ensure this libpng is the last installed in the case of multiple libpng
# installs.
LIBPNG_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBPNG12),libpng12)

$(eval $(autotools-package))
$(eval $(host-autotools-package))
