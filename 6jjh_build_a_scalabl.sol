pragma solidity ^0.8.0;

contract ScalableNotifier {
    // Event emitted when a new notification is triggered
    event NewNotification(address indexed user, string message);

    // Mapping of user addresses to their notification preferences
    mapping(address => NotificationPreferences) public userPrefs;

    // Struct to store notification preferences
    struct NotificationPreferences {
        bool email;
        bool sms;
        bool inApp;
    }

    // Mapping of notification types to their corresponding callbacks
    mapping(string => Callback) public callbacks;

    // Function to set notification preferences for a user
    function setPreferences(address user, bool email, bool sms, bool inApp) public {
        userPrefs[user] = NotificationPreferences(email, sms, inApp);
    }

    // Function to trigger a new notification
    function triggerNotification(address user, string message) public {
        // Get the user's notification preferences
        NotificationPreferences storage prefs = userPrefs[user];

        // Check if the user has opted-in for email notifications
        if (prefs.email) {
            // Trigger email notification callback
            callbacks["email"](user, message);
        }

        // Check if the user has opted-in for SMS notifications
        if (prefs.sms) {
            // Trigger SMS notification callback
            callbacks["sms"](user, message);
        }

        // Check if the user has opted-in for in-app notifications
        if (prefs.inApp) {
            // Trigger in-app notification callback
            callbacks["inApp"](user, message);
        }

        // Emit the NewNotification event
        emit NewNotification(user, message);
    }

    // Function to register a callback for a notification type
    function registerCallback(string memory notificationType, Callback callback) public {
        callbacks[notificationType] = callback;
    }

    // Callback function type
    type Callback = function(address, string) external;
}