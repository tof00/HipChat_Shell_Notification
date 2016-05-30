##################################################################
#
# HipCHat Notification Library
#
##################################################################
# Source : https://www.hipchat.com/docs/apiv2/method/send_room_notification

# TOKEN
declare -r AUTH_TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" # Shell Notifier

declare -r ROOM_ID=7777777

declare COLOR="gray"

declare FROM="Marvin"

declare NOTIFY=0

# gray		 : Log nonproduction environment
# yellow	 : Production environement log
# green		 : actions (creating, package deployment)
# purple	 : warning
# red		 : incident

##################################################################
# Purpose: Message Text API V1
# Arguments:
#   $1 -> Message
#   $2 -> From
#   $3 -> Color
# Return: True or False
##################################################################
hipchat_notify() 
{
	COLOR="green"
	NOTIFY=0
	MESSAGE_FORMAT="html"
	AUTH_TOKEN_V1="9b69c93be8263f74cbcd64577a35e3"
	FROM="Exalead"

	MESSAGE=$1

	if [ ! -z "$2" ]; then
		FROM=$2
	fi	

	if [ ! -z "$3" ]; then
		COLOR=$3
	fi	

	## API v1
	CONFIG="room_id=${ROOM_ID}&from=${FROM}&color=${COLOR}&notify=${NOTIFY}"
	curl -s -o /dev/null -d $CONFIG --data-urlencode "message=${MESSAGE}" 'https://api.hipchat.com/v1/rooms/message?auth_token='${AUTH_TOKEN_V1}'&format=json'
}

##################################################################
# Purpose: Message API V2
# Arguments:
#   $1 -> Message
#   $2 -> From
#   $3 -> Color
#   $4 -> Notify
# Return: True or False
##################################################################
hipchat_message ()
{
	if [ -z "${1}" ]; then
		echo "Tu veux dire quoi au juste ?"
		exit 1;
	else
		MESSAGE=${1}		
	fi

	if [ ! -z "${2}" ]; then
	    FROM=${2}
	fi

	if [ ! -z "${3}" ]; then
	    COLOR=${3}
	fi

	if [ ! -z "${4}" ]; then
	    NOTIFY=${4}
	fi

	## API v2
	curl -H "Content-Type: application/json" \
	-X POST -d "{\"message\": \"${MESSAGE}\", \
	\"from\": \"${FROM}\", \
	\"color\": \"${COLOR}\", \
	\"notify\": \"${NOTIFY}\"}" \
	https://api.hipchat.com/v2/room/${ROOM_ID}/notification?auth_token=${AUTH_TOKEN}
}

##################################################################
# Purpose: Message Card Image API V2
# Arguments:
#   $1 -> Message
#   $2 -> From
#   $3 -> Color
#   $4 -> Notify
#   $5 -> URL Image URL
#   $6 -> Title
#   $7 -> Id : An id that will help HipChat recognise the same card when it is sent multiple times
#   $8 -> Image Width
#   $9 -> Image Height
#   $10 -> URL Image thumbnail
#   $11 -> URL Image thumbnail X2
# Return: True or False
##################################################################
hipchat_card_image ()
{
	if [ -z "${1}" ]; then
		echo "Tu veux dire quoi au juste ?"
		exit 1;
	else
		MESSAGE=${1}		
	fi

	if [ ! -z "${2}" ]; then
	    FROM=${2}
	fi

	if [ ! -z "${3}" ]; then
	    COLOR=${3}
	fi

	if [ ! -z "${4}" ]; then
	    NOTIFY=${4}
	fi

	IMAGE_URL=${5}
	ID=${7}
	THUMBNAIL_WIDTH=${8}
	THUMBNAIL_HEIGHT=${9}

	TITLE=${6}

	THUMBNAIL_URL=${10}
	THUMBNAIL_URLX2=${11}

	# "http://bit.ly/1TmKuKQ"

	FORMAT="compact" # compact, medium


echo "{ \"message\": \"${MESSAGE}\",
	\"from\": \"${FROM}\", \
	\"color\": \"${COLOR}\", \
	\"notify\": \"${NOTIFY}\", \
	\"card\": \
		{ \
		  \"style\": \"image\", 		
		  \"format\": \"${FORMAT}\", \
		  \"id\": \"${ID}\", \
		  \"url\": \"${IMAGE_URL}\", \
		  \"title\": \"${TITLE}\", \
		  \"thumbnail\": { \
		    \"url\": \"${THUMBNAIL_URL}\", \
		    \"url@2x\": \"${THUMBNAIL_URLX2}\", \
		    \"width\": ${THUMBNAIL_WIDTH}, \
		    \"height\": ${THUMBNAIL_HEIGHT} \
		  } \
		} \
	}"


	## API v2
	curl -H "Content-Type: application/json" \
	-X POST -d "{ \"message\": \"${MESSAGE}\",
	\"from\": \"${FROM}\", \
	\"color\": \"${COLOR}\", \
	\"notify\": \"${NOTIFY}\", \
	\"card\": \
		{ \
		  \"style\": \"image\",	
		  \"format\": \"${FORMAT}\", \
		  \"id\": \"${ID}\", \
		  \"url\": \"${IMAGE_URL}\", \
		  \"title\": \"${TITLE}\" \
		} \
	}" \
	https://api.hipchat.com/v2/room/${ROOM_ID}/notification?auth_token=${AUTH_TOKEN}
}