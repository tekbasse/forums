ad_library {

    Forums Library - Reply Handling

    @creation-date 2002-05-17
    @author Ben Adida <ben@openforce.biz>
    @cvs-id $Id$

}

namespace eval forum::notification {

    ad_proc -public get_url {
        object_id
    } {

    }

    ad_proc -public process_reply {
        reply_id
    } {
        ns_log Notice "FORUM-NOTIF: processing reply $reply_id"

        # Get the data
        notification::reply::get -reply_id $reply_id -array reply

        # Get the message information
        forum::message::get -message_id $reply(object_id) -array message
        
        # Insert the message
        forum::message::new -forum_id $message(forum_id) \
                -parent_id $message(message_id) \
                -subject $reply(subject) \
                -content $reply(content) \
                -user_id $reply(from_user)
    }
        
    
}