#!/usr/bin/env bash
scriptVersion="1.0.000"

if [ -z "$arrUrl" ] || [ -z "$arrApiKey" ]; then
  arrUrlBase="$(cat /config/config.xml | xq | jq -r .Config.UrlBase)"
  if [ "$arrUrlBase" == "null" ]; then
    arrUrlBase=""
  else
    arrUrlBase="/$(echo "$arrUrlBase" | sed "s/\///g")"
  fi
  arrApiKey="$(cat /config/config.xml | xq | jq -r .Config.ApiKey)"
  arrPort="$(cat /config/config.xml | xq | jq -r .Config.Port)"
  arrUrl="http://localhost:${arrPort}${arrUrlBase}"
  arrAppName="$(cat /config/config.xml | xq | jq -r .Config.InstanceName)"
fi

# auto-clean up log file to reduce space usage
if [ -f "/config/logs/AutoConfig.txt" ]; then
	find /config/logs -type f -name "AutoConfig.txt" -size +1024k -delete
fi

touch "/config/logs/AutoConfig.txt"
chmod 666 "/config/logs/AutoConfig.txt"
exec &> >(tee -a "/config/logs/AutoConfig.txt")

log () {
  m_time=`date "+%F %T"`
  echo $m_time" :: AutoConfig :: $scriptVersion :: "$1
}

if [ -f /config/extended/logs/autoconfig ]; then
	log "$arrAppName previously configured with optimal settings, skipping..."
	log "To re-configure $arrAppName, delete the following file:"
	log "/config/extended/logs/autoconfig" 
	exit
fi


if [ -f /config/extended/configs/AutoConfig.json ]; then
	log "Using custom $arrAppName AutoConfig settings (/config/extended/configs/AutoConfig.json)..."
	autoConfigJson=$(cat /config/extended/configs/AutoConfig.json)
else
	log "Using provided AutoConfig setttings (/config/extended/scripts/AutoConfig.json)..."
	autoConfigJson=$(cat /config/extended/scripts/AutoConfig.json)
fi

renameBooks=$(echo "$autoConfigJson" | jq -r '.MediaManagement[].renameBooks')
replaceIllegalCharacters=$(echo "$autoConfigJson" | jq -r '.MediaManagement[].replaceIllegalCharacters')
standardBookFormat=$(echo "$autoConfigJson" | jq -r '.MediaManagement[].standardBookFormat')
authorFolderFormat=$(echo "$autoConfigJson" | jq -r '.MediaManagement[].authorFolderFormat')
deleteEmptyFolders=$(echo "$autoConfigJson" | jq -r '.MediaManagement[].deleteEmptyFolders')
watchLibraryForChanges=$(echo "$autoConfigJson" | jq -r '.MediaManagement[].watchLibraryForChanges')
chmodFolder=$(echo "$autoConfigJson" | jq -r '.MediaManagement[].chmodFolder')
fileDate=$(echo "$autoConfigJson" | jq -r '.MediaManagement[].fileDate')
writeAudioTags=$(echo "$autoConfigJson" | jq -r '.Metadata[].writeAudioTags')
scrubAudioTags=$(echo "$autoConfigJson" | jq -r '.Metadata[].scrubAudioTags')
writeBookTags=$(echo "$autoConfigJson" | jq -r '.Metadata[].writeBookTags')
updateCovers=$(echo "$autoConfigJson" | jq -r '.Metadata[].updateCovers')
embedMetadata=$(echo "$autoConfigJson" | jq -r '.Metadata[].embedMetadata')


log "Updating $arrAppName File Naming..."
updateArr=$(curl -s "$arrUrl/api/v1/config/naming" -X PUT -H "Content-Type: application/json" -H "X-Api-Key: $arrApiKey" --data-raw "{
	\"renameBooks\": $renameBooks,
	\"replaceIllegalCharacters\": $replaceIllegalCharacters,
	\"standardBookFormat\": \"$standardBookFormat\",
	\"authorFolderFormat\": \"$authorFolderFormat\",
	\"includeAuthorName\": false,
	\"includeBookTitle\": false,
	\"includeQuality\": false,
	\"replaceSpaces\": false,
	\"id\": 1
	}")    
log "Complete"

log "Updating $arrAppName  Media Management..."
updateArr=$(curl -s "$arrUrl/api/v3/config/mediamanagement" -X PUT -H "Content-Type: application/json" -H "X-Api-Key: $arrApiKey" --data-raw "{
  \"autoUnmonitorPreviouslyDownloadedBooks\": false,
  \"recycleBin\": \"\",
  \"recycleBinCleanupDays\": 7,
  \"downloadPropersAndRepacks\": \"preferAndUpgrade\",
  \"createEmptyAuthorFolders\": false,
  \"deleteEmptyFolders\": $deleteEmptyFolders,
  \"fileDate\": \"$fileDate\",
  \"watchLibraryForChanges\": $watchLibraryForChanges,
  \"rescanAfterRefresh\": \"always\",
  \"allowFingerprinting\": \"newFiles\",
  \"setPermissionsLinux\": false,
  \"chmodFolder\": \"$chmodFolder\",
  \"chownGroup\": \"\",
  \"skipFreeSpaceCheckWhenImporting\": false,
  \"minimumFreeSpaceWhenImporting\": 100,
  \"copyUsingHardlinks\": true,
  \"importExtraFiles\": false,
  \"extraFileExtensions\": \"srt\",
  \"id\": 1
  }")
log "Complete"

log "Updating $arrAppName Medata Settings..."
updateArr=$(curl -s "$arrUrl/api/v1/config/metadataProvider" -X PUT -H "Content-Type: application/json" -H "X-Api-Key: $arrApiKey" --data-raw "{
	\"writeAudioTags\":\"$writeAudioTags\",
	\"scrubAudioTags\":$scrubAudioTags,
	\"writeBookTags\":\"$writeBookTags\",
	\"updateCovers\":$updateCovers,
	\"embedMetadata\":$embedMetadata,
	\"id\":1
	}")
log "Complete"

log "Configuring $arrAppName Custom Scripts"
if curl -s "$arrUrl/api/v1/notification" -H "X-Api-Key: ${arrApiKey}" | jq -r .[].name | grep "PlexNotify.bash" | read; then
	log "PlexNotify.bash already added to $arrAppName custom scripts"
else
	log "Adding PlexNotify.bash to $arrAppName custom scripts"
  # Send a command to check file path, to prevent error with adding...
	updateArr=$(curl -s "$arrUrl/api/v3/filesystem?path=%2Fconfig%2Fextended%2Fscripts%2FPlexNotify.bash&allowFoldersWithoutTrailingSlashes=true&includeFiles=true" -H "X-Api-Key: ${arrApiKey}")
  
  # Add PlexNotify.bash
  updateArr=$(curl -s "$arrUrl/api/v1/notification?" -X POST -H "Content-Type: application/json" -H "X-Api-Key: ${arrApiKey}" --data-raw '{"onGrab":false,"onReleaseImport":true,"onUpgrade":true,"onRename":false,"onAuthorDelete":true,"onBookDelete":true,"onBookFileDelete":false,"onBookFileDeleteForUpgrade":false,"onHealthIssue":false,"onDownloadFailure":false,"onImportFailure":false,"onBookRetag":false,"onApplicationUpdate":false,"supportsOnGrab":true,"supportsOnReleaseImport":true,"supportsOnUpgrade":true,"supportsOnRename":true,"supportsOnAuthorDelete":true,"supportsOnBookDelete":true,"supportsOnBookFileDelete":true,"supportsOnBookFileDeleteForUpgrade":true,"supportsOnHealthIssue":true,"includeHealthWarnings":false,"supportsOnDownloadFailure":false,"supportsOnImportFailure":false,"supportsOnBookRetag":true,"supportsOnApplicationUpdate":true,"name":"PlexNotify.bash","fields":[{"name":"path","value":"/config/extended/scripts/PlexNotify.bash"},{"name":"arguments"}],"implementationName":"Custom Script","implementation":"CustomScript","configContract":"CustomScriptSettings","infoLink":"https://wiki.servarr.com/readarr/supported#customscript","message":{"message":"Testing will execute the script with the EventType set to Test, ensure your script handles this correctly","type":"warning"},"tags":[]}')
  log "Complete"
fi



touch /config/extended/logs/autoconfig
chmod 666 /config/extended/logs/autoconfig

exit
