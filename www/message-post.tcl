ad_page_contract {
    
    Form to create message and insert it

    @author Ben Adida (ben@openforce.net)
    @creation-date 2002-05-25
    @cvs-id $Id$

} -query {
    {forum_id ""}
    {parent_id ""}
} -validate {
    forum_id_or_parent_id {
        if {[empty_string_p $forum_id] && [empty_string_p $parent_id]} {
            ad_complain "You either have to post to a forum or in reply to another message"
        }
    }
}

set user_id [ad_verify_and_get_user_id]

# get the colors from the params
set table_border_color [parameter::get -parameter table_border_color]
set table_bgcolor [parameter::get -parameter table_bgcolor]

form create message

element create message message_id \
    -label "Message ID" \
    -datatype integer \
    -widget hidden

element create message subject \
    -label Subject \
    -datatype text \
    -widget text \
    -html {size 60} \
    -validate { {expr ![empty_string_p [string trim $value]]} {Please enter a subject} }

# we use ns_queryget to get the value of html_p because it won't be defined
# until the next element -DaveB

element create message content \
    -label Body \
    -datatype text \
    -widget textarea \
    -html {rows 20 cols 60 wrap soft} \
    -validate {
	empty {expr ![empty_string_p [string trim $value]]} {Please enter a message}
	html { expr {( [string match [set l_html_p [ns_queryget html_p f]] "t"] && [empty_string_p [set v_message [ad_html_security_check $value]]] ) || [string match $l_html_p "f"] } }
	     {}	
	}

element create message html_p \
    -label Format \
    -datatype text \
    -widget select \
    -options {{text f} {html t}}

element create message parent_id \
    -label "parent ID" \
    -datatype integer \
    -widget hidden \
    -optional

element create message forum_id \
    -label "forum ID" \
    -datatype integer \
    -widget hidden

element create message confirm_p \
    -label "Confirm?" \
    -datatype text \
    -widget hidden

element create message subscribe_p \
    -label "Subscribe?" \
    -datatype text \
    -widget hidden \
    -optional

set attachments_enabled_p [forum::attachments_enabled_p]

if {$attachments_enabled_p} {
    element create message attach_p \
            -label "Attach?" \
            -datatype text \
            -widget hidden \
            -optional
}

if {[form is_valid message]} {
    form get_values message \
        message_id forum_id parent_id subject content html_p confirm_p subscribe_p

    if {!$confirm_p} {
        forum::get -forum_id $forum_id -array forum

        set confirm_p 1
        set content [string trimright $content]
        set exported_vars [export_form_vars message_id forum_id parent_id subject content html_p confirm_p]
        
        set message(html_p) $html_p
        set message(subject) $subject
        set message(content) $content
        set message(user_id) $user_id
        set message(user_name) [db_string select_name {}]
        set message(posting_date) [db_string select_date {}]

        # Let's check if this person is subscribed to the forum
        # in case we might want to subscribe them to the thread
        if {[empty_string_p $parent_id]} {
            if {![empty_string_p [notification::request::get_request_id \
                    -type_id [notification::type::get_type_id -short_name forums_forum_notif] \
                    -object_id $forum_id \
                    -user_id [ad_conn user_id]]]} {
                set forum_notification_p 1
            } else {
                set forum_notification_p 0
            }
        }

        set context [list [list "./forum-view?forum_id=$forum_id" "$forum(name)"]]
        lappend context {Post a Message}

        ad_return_template message-post-confirm
        return
    }

    forum::message::new \
        -forum_id $forum_id \
        -message_id $message_id \
        -parent_id $parent_id \
        -subject $subject \
        -content $content \
        -html_p $html_p

    if {[empty_string_p $parent_id]} {
        set redirect_url "[ad_conn package_url]message-view?message_id=$message_id"
    } else {
        set redirect_url "[ad_conn package_url]message-view?message_id=$parent_id"
    }

    # Wrap the notifications URL
    if {![empty_string_p $subscribe_p] && $subscribe_p && [empty_string_p $parent_id]} {
        set notification_url [notification::display::subscribe_url \
            -type forums_message_notif \
            -object_id $message_id \
            -url $redirect_url \
            -user_id [ad_conn user_id] \
        ]

        # redirect to notification stuff
        set redirect_url $notification_url
    }

    # Wrap the attachments URL
    if {$attachments_enabled_p} {
        form get_values message attach_p

        if {$attach_p} {
            set redirect_url [attachments::add_attachment_url -object_id $message_id -return_url $redirect_url -pretty_name "Forum Posting \"$subject\""]
        }
    }
    
    # Do the redirection
    ad_returnredirect $redirect_url

    ad_script_abort
}

set message_id [db_nextval acs_object_id_seq]
#set subject ""

if {![empty_string_p $parent_id]} {
    # get the parent message information
    forum::message::get -message_id $parent_id -array parent_message
    set forum_id $parent_message(forum_id)
    set subject "Re: $parent_message(subject)"

    # trim multiple leading Re:
    regsub {^(\s*Re:\s*)*} $subject {Re: } subject
}

forum::security::require_post_forum -forum_id $forum_id

forum::get -forum_id $forum_id -array forum

# Prepare the other data 
element set_properties message forum_id -value $forum_id
element set_properties message parent_id -value $parent_id
element set_properties message message_id -value $message_id
# only set subject is this is a reply to a previous message
if {[info exists subject]} {
    element set_properties message subject -value $subject
}
element set_properties message confirm_p -value 0
element set_properties message subscribe_p -value 0

set context [list [list "./forum-view?forum_id=$forum_id" "$forum(name)"]]
if {![empty_string_p $parent_id]} {
    lappend context [list "./message-view?message_id=$parent_message(message_id)" "$parent_message(subject)"]
    lappend context {Post a Reply}
} else {
    lappend context {Post a Message}
}

ad_return_template
