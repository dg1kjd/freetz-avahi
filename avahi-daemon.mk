$(call PKG_INIT_BIN, 0.6.28)
$(PKG)_SOURCE:=avahi-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=d0143a5aa3265019072e53ab497818d0
$(PKG)_SITE:=http://avahi.org/download
AVAHI_DAEMON_DIR:=$(SOURCE_DIR)/avahi-$($(PKG)_VERSION)
$(PKG)_BINARY:=$(SOURCE_DIR)/avahi-$($(PKG)_VERSION)/$(pkg)/.libs/$(pkg)
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/$(pkg)
$(PKG)_AVAHI_DNSCONFD:=$(SOURCE_DIR)/avahi-$($(PKG)_VERSION)/avahi-dnsconfd/.libs/avahi-dnsconfd
$(PKG)_TARGET_AVAHI_DNSCONFD:=$($(PKG)_DEST_DIR)/usr/bin/avahi-dnsconfd
$(PKG)_LIB:=$(SOURCE_DIR)/avahi-$($(PKG)_VERSION)/avahi-common/.libs/libavahi-common.so.3.5.2
$(PKG)_TARGET_LIB:=$($(PKG)_DEST_LIBDIR)/libavahi-common.so.3.5.2
$(PKG)_LIB2:=$(SOURCE_DIR)/avahi-$($(PKG)_VERSION)/avahi-core/.libs/libavahi-core.so.7.0.0
$(PKG)_TARGET_LIB2:=$($(PKG)_DEST_LIBDIR)/libavahi-core.so.7.0.0

AVAHI_DAEMON_LIBS := -lpcap -lexpat -ldaemon -lintl
$(PKG)_DEPENDS_ON := expat libpcap libdaemon gettext
AVAHI_CFLAGS := -DDISABLE_SYSTEMD
AVAHI_LDFLAGS := -lpthread

$(PKG)_CONFIGURE_PRE_CMDS += $(call PKG_PREVENT_RPATH_HARDCODING,./configure)

$(PKG)_CONFIGURE_ENV += ac_cv_func_malloc_0_nonnull=yes
$(PKG)_CONFIGURE_ENV += ac_cv_func_realloc_0_nonnull=yes
$(PKG)_CONFIGURE_ENV += ac_cv_func_memcmp_working=yes

$(PKG)_CONFIGURE_OPTIONS += --with-avahi-user=nobody
$(PKG)_CONFIGURE_OPTIONS += --with-avahi-group=nobody
$(PKG)_CONFIGURE_OPTIONS += --with-avahi-priv-access-group=avahi
$(PKG)_CONFIGURE_OPTIONS += --with-xml=expat
$(PKG)_CONFIGURE_OPTIONS += --with-distro=none
$(PKG)_CONFIGURE_OPTIONS += --disable-qt3
$(PKG)_CONFIGURE_OPTIONS += --disable-qt4
$(PKG)_CONFIGURE_OPTIONS += --disable-gtk
$(PKG)_CONFIGURE_OPTIONS += --disable-gtk3
$(PKG)_CONFIGURE_OPTIONS += --disable-glib
$(PKG)_CONFIGURE_OPTIONS += --disable-gobject
$(PKG)_CONFIGURE_OPTIONS += --disable-dbus
$(PKG)_CONFIGURE_OPTIONS += --disable-gdbm
$(PKG)_CONFIGURE_OPTIONS += --disable-python
$(PKG)_CONFIGURE_OPTIONS += --disable-pygtk
$(PKG)_CONFIGURE_OPTIONS += --disable-python-dbus
$(PKG)_CONFIGURE_OPTIONS += --disable-mono
$(PKG)_CONFIGURE_OPTIONS += --disable-monodoc
$(PKG)_CONFIGURE_OPTIONS += --disable-autoipd
$(PKG)_CONFIGURE_OPTIONS += --disable-doxygen-doc
$(PKG)_CONFIGURE_OPTIONS += --disable-doxygen-dot
$(PKG)_CONFIGURE_OPTIONS += --disable-doxygen-xml
$(PKG)_CONFIGURE_OPTIONS += --disable-doxygen-html
$(PKG)_CONFIGURE_OPTIONS += --disable-manpages
$(PKG)_CONFIGURE_OPTIONS += --disable-xmltoman
$(PKG)_CONFIGURE_OPTIONS += --with-bdb="$(TARGET_TOOLCHAIN_STAGING_DIR)/usr"
$(PKG)_CONFIGURE_OPTIONS += --sysconfdir="/mod/etc"

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
		$(SUBMAKE) -C $(AVAHI_DAEMON_DIR) CFLAGS="$(TARGED_CFLAGS) $(AVAHI_CFLAGS)" LDFLAGS="$(TARGED_LDFLAGS) $(AVAHI_LDFLAGS)" \
		LIBS="$(AVAHI_DAEMON_LIBS)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$($(PKG)_TARGET_AVAHI_DNSCONFD): $($(PKG)_AVAHI_DNSCONFD)
	$(INSTALL_BINARY_STRIP)

$($(PKG)_TARGET_LIB): $($(PKG)_LIB)
	$(INSTALL_LIBRARY_STRIP)

$($(PKG)_TARGET_LIB2): $($(PKG)_LIB2)
	$(INSTALL_LIBRARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY) \
		    $($(PKG)_TARGET_AVAHI_DNSCONFD) \
		    $($(PKG)_TARGET_LIB) \
		    $($(PKG)_TARGET_LIB2)

$(pkg)-clean:
	-$(SUBMAKE) -C $(AVAHI_DAEMON_DIR) clean
	 $(RM) $(AVAHI_DAEMON_DIR)/.configured

$(pkg)-uninstall:
	$(RM) $(AVAHI_DAEMON_TARGET_BINARY) \
	      $(AVAHI_DAEMON_TARGET_AVAHI_DNSCONFD) \
	      $(AVAHI_DAEMON_TARGET_LIB) \
	      $(AVAHI_DAEMON_TARGET_LIB2)

$(PKG_FINISH)
