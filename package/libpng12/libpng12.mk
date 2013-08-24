################################################################################
#
# libpng12
#
################################################################################

LIBPNG12_VERSION = 1.2.50
LIBPNG12_SERIES = 12
LIBPNG12_SOURCE = libpng-$(LIBPNG12_VERSION).tar.bz2
LIBPNG12_SITE = http://downloads.sourceforge.net/project/libpng/libpng$(LIBPNG12_SERIES)/$(LIBPNG12_VERSION)
LIBPNG12_LICENSE = libpng license
LIBPNG12_LICENSE_FILES = LICENSE
LIBPNG12_INSTALL_STAGING = YES
LIBPNG12_DEPENDENCIES = host-pkgconf zlib
LIBPNG12_CONFIG_SCRIPTS = libpng$(LIBPNG12_SERIES)-config libpng-config

$(eval $(autotools-package))
$(eval $(host-autotools-package))
