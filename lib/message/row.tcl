ad_page_contract {
    
    a message chunk to be included in a listing of messages

    @author yon (yon@openforce.net)
    @author arjun (arjun@openforce.net)
    @creation-date 2002-06-02
    @cvs-id $Id$

}

set viewer_id [ad_conn user_id]

if {![exists_and_not_null rownum]} { 
    set rownum 1
}

set message(content) [ad_html_text_convert -from $message(format) -to text/html -- $message(content)]

# convert emoticons to images if the parameter is set
if { [string is true [parameter::get -parameter DisplayEmoticonsAsImagesP -default 0]] } {
    set message(content) [forum::format::emoticons -content $message(content)]
}

# JCD: display subject only if changed from the root subject
if {![info exists root_subject]} {
    set display_subject_p 1
} else {
    regsub {^(Response to |\s*Re:\s*)*} $message(subject) {} subject
    set display_subject_p [expr ![string equal $subject $root_subject]]
}

if {[exists_and_not_null alt_template]} {
  ad_return_template $alt_template
}


if {![info exists message(message_id)]} { 
    set message(message_id) none
}
if {![info exists message(tree_level)]} { 
    set message(tree_level) 0
}

if {![exists_and_not_null level_exp]} { 
    set level_exp 0
}

if {![exists_and_not_null moderate_p]} { 
    set moderate_p 0
}

if {![exists_and_not_null message(reply_p)]} { 
    set message(reply_p) 0
}

if {![exists_and_not_null display_mode]} { 
    set display_mode dynamic_minimal
}

if { $moderate_p } {
    set table_name "forums_messages"
} else {
    set table_name "forums_messages_approved"
}

set links ""

set allow_edit_own_p [parameter::get -parameter AllowUsersToEditOwnPostsP -default 0]
set own_p [expr [string equal $message(user_id) $viewer_id] && $allow_edit_own_p]

switch -exact $display_mode {
    flat {
        ad_return_template "../lib/message/row-flat"
        return
    }
    nested {
        ad_return_template "../lib/message/row-nested"
        return
    }
    threaded {
        ad_return_template "../lib/message/row-threaded"
        return
    }
    minimal {
        ad_return_template "../lib/message/row-minimal"
        return
    }
    default {
	ad_return_template "../lib/message/row"
        return
    }
}
