ad_page_contract {

    Forums Administration

    @author Ben Adida (ben@openforce)
    @creation-date 2002-05-24
    @version $Id$

}

# scoping 
set package_id [ad_conn package_id]

# List of forums
db_multirow forums select_forums {}

ad_return_template
