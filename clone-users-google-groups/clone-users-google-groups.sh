#!/bin/sh

##########################################################################################
# clone-users-google-groups.sh - by Sean Kaiser
#
# This script uses the google apps manager tool, available at
#   https://code.google.com/p/google-apps-manager/
# to clone google group membership(s) for a user based on another user's memberships.
#
# The option exists to purge all group memberships for the target user before cloning the
# model user's memberships by specifying the purge_first argument as the 3rd argument on
# the command line.
#
# To use this script, adjust the two variables below (gam and my_domain) to reflect your
# environment. Then run the script with the model user's username first, followed by the
# target user's username, optionally followed by purge_first.
##########################################################################################

gam="python /path/to/your/gam.py"
my_domain="your-google-domain.com"

if [ $# -lt 2 ]; then
  echo "usage: ${0} model-user target-user (purge_first)"
  echo ""
  echo "         (optional 3rd argument will remove target user from any existing groups"
  echo "         before the clone process runs. The argument must be exactly"
  echo "         the phrase purge_first.)"
  exit -1
else
  model="${1}"
  target="${2}"
  if [ "${3}" == "purge_first" ]; then
    let purge_existing=1
  else
    let purge_existing=0
  fi
fi

model_user_info=`${gam} info user ${model} 2>/dev/null`
model_status=${?}

target_user_info=`${gam} info user ${target} 2>/dev/null`
target_status=${?}

if [ ${model_status} -ne 0 ]; then
  echo "ERROR: model user ${model} does not exist"
  exit -1
fi

if [ ${target_status} -ne 0 ]; then
  echo "ERROR: target user ${target} does not exist"
  exit -1
fi

if [ ${purge_existing} -eq 1 ]; then
  target_user_groups=`echo "${target_user_info}" | grep "${my_domain}>"`
  for group in ${target_user_groups}; do
    address=`echo ${group} | grep ${my_domain} | tr '>' '\0' | tr '<' '\0' | cut -d'@' -f1`
    if [ "${address}" != "" ]; then
      ${gam} update group ${address} remove ${target} && echo "removed ${target} from ${address}"
    fi
  done 
fi

model_user_groups=`echo "${model_user_info}" | grep "${my_domain}>"`
for group in ${model_user_groups}; do
  address=`echo ${group} | grep ${my_domain} | tr '>' '\0' | tr '<' '\0' | cut -d'@' -f1`
  if [ "${address}" != "" ]; then
    ${gam} update group ${address} add member ${target} && echo "added ${target} to ${address}"
  fi
done
