#!/bin/bash
. /usr/share/openclash/openclash_ps.sh
. /usr/share/openclash/log.sh

   set_lock() {
      exec 880>"/tmp/lock/openclash_ipdb.lock" 2>/dev/null
      flock -x 880 2>/dev/null
   }

   del_lock() {
      flock -u 880 2>/dev/null
      rm -rf "/tmp/lock/openclash_ipdb.lock"
   }
   
   small_flash_memory=$(uci get openclash.config.small_flash_memory 2>/dev/null)
   GEOIP_CUSTOM_URL=$(uci get openclash.config.geo_custom_url 2>/dev/null)
   github_address_mod=$(uci -q get openclash.config.github_address_mod || echo 0)
   LOG_FILE="/tmp/openclash.log"
   restart=0
   set_lock
   
   if [ "$small_flash_memory" != "1" ]; then
   	  geoip_path="/etc/openclash/Country.mmdb"
   	  mkdir -p /etc/openclash
   else
   	  geoip_path="/tmp/etc/openclash/Country.mmdb"
   	  mkdir -p /tmp/etc/openclash
   fi
   LOG_OUT "Start Downloading Geoip Database..."
   LOG_OUT "Geoip Database Update Error, Please Try Again Later..."
   sleep 3

   if [ "$restart" -eq 1 ] && [ "$(unify_ps_prevent)" -eq 0 ] && [ "$(find /tmp/lock/ |grep -v "openclash.lock" |grep -c "openclash")" -le 1 ]; then
      /etc/init.d/openclash restart >/dev/null 2>&1 &
   elif [ "$restart" -eq 0 ] && [ "$(unify_ps_prevent)" -eq 0 ] && [ "$(find /tmp/lock/ |grep -v "openclash.lock" |grep -c "openclash")" -le 1 ] && [ "$(uci -q get openclash.config.restart)" -eq 1 ]; then
      /etc/init.d/openclash restart >/dev/null 2>&1 &
      uci -q set openclash.config.restart=0
      uci -q commit openclash
   elif [ "$restart" -eq 1 ] && [ "$(unify_ps_prevent)" -eq 0 ]; then
      uci -q set openclash.config.restart=1
      uci -q commit openclash
   fi

   rm -rf /tmp/Country.mmdb >/dev/null 2>&1
   SLOG_CLEAN
   del_lock
