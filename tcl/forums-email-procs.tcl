ad_library {

    Forums Library

    @creation-date 2002-05-17
    @author Ben Adida <ben@openforce.biz>
    @cvs-id $Id$

}

namespace eval forum { namespace eval email {} }

ad_proc -public forum::email::create_forward_email {
    {-pre_body:required}
    message_passed
} {
    create email content to forward a message
} {
    # Get the message data array
    upvar $message_passed message

    # Variables for I18N message lookup:
    set posting_date $message(posting_date)
    set user_name $message(user_name)

    # Set up the message body
    set new_body "[ad_html_to_text -- $pre_body]"
    append new_body "\n\n===================================\n\n"
    append new_body "[_ forums.email_alert_body_header]\n\n"
    append new_body "[ad_html_to_text -- $message(content)]\n"

    return $new_body
}