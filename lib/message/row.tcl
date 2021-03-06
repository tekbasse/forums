ad_page_contract {

    a message chunk to be included in a table listing of messages

    @author yon (yon@openforce.net)
    @author arjun (arjun@openforce.net)
    @creation-date 2002-06-02
    @cvs-id $Id$

}

set viewer_id [ad_conn user_id]
set useScreenNameP [parameter::get -parameter "UseScreenNameP" -default 0]

if {(![info exists rownum] || $rownum eq "")} { 
    set rownum 1
}

if {(![info exists presentation_type] || $presentation_type eq "")} {
    set presentation_type ""
}

set message(content) [ad_html_text_convert -from $message(format) -to text/html -- $message(content)]

if {$useScreenNameP} {
    acs_user::get -user_id $viewer_id -array user_info
    set message(screen_name) $user_info(screen_name)
} else {
    set message(screen_name) ""
}



# convert emoticons to images if the parameter is set
if { [string is true [parameter::get -parameter DisplayEmoticonsAsImagesP -default 0]] } {
    set message(content) [forum::format::emoticons -content $message(content)]
}

# JCD: display subject only if changed from the root subject
if {![info exists root_subject]} {
    set display_subject_p 1
} else {
    regsub {^(Response to |\s*Re:\s*)*} $message(subject) {} subject
    set display_subject_p [expr {$subject ne $root_subject }] 
}

if {([info exists alt_template] && $alt_template ne "")} {
  ad_return_template $alt_template
}
if {![info exists message(message_id)]} {
    set message(message_id) none
}
if {![info exists message(tree_level)] || $presentation_type eq "flat"} {
    set message(tree_level) 0
}

set allow_edit_own_p [parameter::get -parameter AllowUsersToEditOwnPostsP -default 0]
set own_p [expr {$message(user_id) eq $viewer_id && $allow_edit_own_p}]

if { [info exists preview] } {
    set any_action_p 0
} else {
    set notflat_p [expr {$presentation_type ne "flat"}]
    set post_and_notflat_p [expr {$permissions(post_p) && $notflat_p}]
    set any_action_p [expr { $post_and_notflat_p || $viewer_id || $moderate_p }]
}
