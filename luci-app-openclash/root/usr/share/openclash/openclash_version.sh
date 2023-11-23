#!/bin/bash

echo "0.0.0" > /tmp/openclash_last_version

#TIME=$(date "+%Y-%m-%d-%H")
#CHTIME=$(date "+%Y-%m-%d-%H" -r "/tmp/openclash_last_version")
#LAST_OPVER="/tmp/openclash_last_version"
#RELEASE_BRANCH=$(uci -q get openclash.config.release_branch || echo "master")
#OP_CV=$(rm -f /var/lock/opkg.lock && opkg status luci-app-openclash 2>/dev/null |grep 'Version' |awk -F '-' '{print $1}' |awk -F 'Version: ' '{print $2}' |awk -F '.' '{print $2$3}' 2>/dev/null)
#OP_LV=$(sed -n 1p $LAST_OPVER 2>/dev/null |awk -F '-' '{print $1}' |awk -F 'v' '{print $2}' |awk -F '.' '{print $2$3}' 2>/dev/null)
#github_address_mod=$(uci -q get openclash.config.github_address_mod || echo 0)
#LOG_FILE="/tmp/openclash.log"
#
#if [ "$TIME" != "$CHTIME" ]; then
#   curl -SsL --connect-timeout 10 -m 30 --speed-time 15 --speed-limit 1 --retry 2 https://raw.githubusercontent.com/vernesong/OpenClash/"$RELEASE_BRANCH"/version -o $LAST_OPVER 2>&1 | awk -v time="$(date "+%Y-%m-%d %H:%M:%S")" -v file="$LAST_OPVER" '{print time "【" file "】Download Failed:【"$0"】"}' >> "$LOG_FILE"
#
#   if [ "${PIPESTATUS[0]}" -ne 0 ] || [ -n "$(cat $LAST_OPVER |grep '<html>')" ]; then
#      curl_status=${PIPESTATUS[0]}
#   else
#      curl_status=0
#   fi
#
#   if [ "$curl_status" -eq 0 ] && [ -z "$(cat $LAST_OPVER |grep '<html>')" ]; then
#   	OP_LV=$(sed -n 1p $LAST_OPVER 2>/dev/null |awk -F '-' '{print $1}' |awk -F 'v' '{print $2}' |awk -F '.' '{print $2$3}' 2>/dev/null)
#      if [ "$(expr "$OP_CV" \>= "$OP_LV")" = "1" ]; then
#         sed -i '/^https:/,$d' $LAST_OPVER
#      elif [ "$(expr "$OP_LV" \> "$OP_CV")" = "1" ] && [ -n "$OP_LV" ]; then
#         exit 2
#      else
#         exit 0
#      fi
#   else
#      rm -rf "$LAST_OPVER"
#   fi
#elif [ "$(expr "$OP_LV" \> "$OP_CV")" = "1" ] && [ -n "$OP_LV" ]; then
#   exit 2
#else
#   exit 0
#fi 2>/dev/null
#