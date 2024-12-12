#include "gtk_helpers.h"

GtkWidget *wrapped_gtk_message_dialog_new() {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return gtk_message_dialog_new(
        NULL,
        GTK_DIALOG_MODAL | GTK_DIALOG_DESTROY_WITH_PARENT,
        GTK_MESSAGE_OTHER,
        GTK_BUTTONS_NONE,
        ""
    );
    #pragma clang diagnostic pop
}
