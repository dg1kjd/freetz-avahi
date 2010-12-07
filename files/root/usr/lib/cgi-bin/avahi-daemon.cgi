#!/bin/sh

PATH=/bin:/usr/bin:/sbin:/usr/sbin
. /usr/lib/libmodcgi.sh

check "$AVAHI_DAEMON_ENABLED" yes:auto "*":man

sec_begin '$(lang de:"Starttyp" en:"Start type")'

cat << EOF
<p>
<input id='e1' type='radio' name='enabled' value='yes'$auto_chk><label for='e1'>$(lang de:"Automatisch" en:"Automatic")</label>
<input id='e2' type='radio' name='enabled' value='no'$man_chk><label for='e2'>$(lang de:"Manuell" en:"Manual")</label>
</p>
EOF

sec_end
sec_begin '$(lang de:"Einstellungen" en:"Settings")'

cat << EOF
<ul>
<li><a href='$(href file avahi-daemon avahi-daemon_conf)'>$(lang de:"Hauptkonfigurationsdatei" en:"Main config file") (avahi-daemon_conf)</a></li>
<li><a href='$(href file avahi-daemon avahi_hosts)'>$(lang de:"Statische Hosts" en:"Static hosts") (avahi_hosts)</a></li>
<li><a href='$(href file avahi-daemon avahi_service)'>$(lang de:"Statische Dienste" en:"Static services") (avahi_service)</a></li>
</ul>
EOF

sec_end
