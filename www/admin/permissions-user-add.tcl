ad_page_contract {
    Redirect page for adding users to the permissions list.
    
    @author Lars Pind (lars@collaboraid.biz)
    @creation-date 2003-06-13
    @cvs-id $Id$
} {
    object_id:integer
}

forum::get -forum_id $object_id -array forum

set page_title "Add User"

set context [list [list [export_vars -base permissions { object_id }] "$forum(name) Permissions"] $page_title]
