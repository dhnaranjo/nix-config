#include <security/pam_appl.h>
#include <security/pam_modules.h>
#include <IOKit/IOKitLib.h>
#include <CoreFoundation/CoreFoundation.h>
#include <syslog.h>
#include <string.h>

#define PAM_SM_AUTH

static int check_monitor_present(const char *required_uuid) {
    io_iterator_t iter;
    io_service_t service;
    int found = 0;

    kern_return_t kr = IOServiceGetMatchingServices(kIOMasterPortDefault,
                                                     IOServiceMatching("AppleCLCD2"),
                                                     &iter);
    if (kr != KERN_SUCCESS) {
        syslog(LOG_AUTH | LOG_ERR, "pam_monitor: IOServiceGetMatchingServices failed: %d", kr);
        return 0;
    }

    while ((service = IOIteratorNext(iter)) != 0) {
        CFTypeRef edid_uuid_ref = IORegistryEntryCreateCFProperty(
            service,
            CFSTR("EDID UUID"),
            kCFAllocatorDefault,
            0
        );

        if (edid_uuid_ref && CFGetTypeID(edid_uuid_ref) == CFStringGetTypeID()) {
            char uuid_str[128];
            if (CFStringGetCString((CFStringRef)edid_uuid_ref, uuid_str, sizeof(uuid_str), kCFStringEncodingUTF8)) {
                if (strcasecmp(uuid_str, required_uuid) == 0) {
                    found = 1;
                }
            }
            CFRelease(edid_uuid_ref);
        }

        IOObjectRelease(service);
        if (found) break;
    }

    IOObjectRelease(iter);
    return found;
}

PAM_EXTERN int pam_sm_authenticate(pam_handle_t *pamh, int flags, int argc, const char **argv) {
    const char *monitor_uuid = NULL;

    for (int i = 0; i < argc; i++) {
        if (strncmp(argv[i], "monitor_uuid=", 13) == 0) {
            monitor_uuid = argv[i] + 13;
            break;
        }
    }

    if (!monitor_uuid) {
        syslog(LOG_AUTH | LOG_ERR, "pam_monitor: No monitor_uuid argument provided");
        return PAM_AUTH_ERR;
    }

    return check_monitor_present(monitor_uuid) ? PAM_SUCCESS : PAM_AUTH_ERR;
}

PAM_EXTERN int pam_sm_setcred(pam_handle_t *pamh, int flags, int argc, const char **argv) {
    return PAM_SUCCESS;
}

PAM_EXTERN int pam_sm_acct_mgmt(pam_handle_t *pamh, int flags, int argc, const char **argv) {
    return PAM_SUCCESS;
}

PAM_EXTERN int pam_sm_open_session(pam_handle_t *pamh, int flags, int argc, const char **argv) {
    return PAM_SUCCESS;
}

PAM_EXTERN int pam_sm_close_session(pam_handle_t *pamh, int flags, int argc, const char **argv) {
    return PAM_SUCCESS;
}

PAM_EXTERN int pam_sm_chauthtok(pam_handle_t *pamh, int flags, int argc, const char **argv) {
    return PAM_IGNORE;
}
