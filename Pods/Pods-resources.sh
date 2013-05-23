#!/bin/sh

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "rsync -rp ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -rp "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xcdatamodeld`.momd"
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xcdatamodeld`.momd"
      ;;
    *)
      echo "rsync -av --exclude '*/.svn/*' ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
      rsync -av --exclude '*/.svn/*' "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
      ;;
  esac
}
install_resource 'SVProgressHUD/SVProgressHUD/SVProgressHUD.bundle'
install_resource 'TSMessages/Resources/design.json'
install_resource 'TSMessages/Resources/Images/NotificationBackgroundError.png'
install_resource 'TSMessages/Resources/Images/NotificationBackgroundError@2x.png'
install_resource 'TSMessages/Resources/Images/NotificationBackgroundErrorIcon.png'
install_resource 'TSMessages/Resources/Images/NotificationBackgroundErrorIcon@2x.png'
install_resource 'TSMessages/Resources/Images/NotificationBackgroundMessage.png'
install_resource 'TSMessages/Resources/Images/NotificationBackgroundMessage@2x.png'
install_resource 'TSMessages/Resources/Images/NotificationBackgroundSuccess.png'
install_resource 'TSMessages/Resources/Images/NotificationBackgroundSuccess@2x.png'
install_resource 'TSMessages/Resources/Images/NotificationBackgroundSuccessIcon.png'
install_resource 'TSMessages/Resources/Images/NotificationBackgroundSuccessIcon@2x.png'
install_resource 'TSMessages/Resources/Images/NotificationBackgroundWarning.png'
install_resource 'TSMessages/Resources/Images/NotificationBackgroundWarning@2x.png'
install_resource 'TSMessages/Resources/Images/NotificationBackgroundWarningIcon.png'
install_resource 'TSMessages/Resources/Images/NotificationBackgroundWarningIcon@2x.png'
install_resource 'TSMessages/Resources/Images/NotificationButtonBackground.png'
install_resource 'TSMessages/Resources/Images/NotificationButtonBackground@2x.png'
