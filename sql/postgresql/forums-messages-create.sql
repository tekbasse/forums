--
-- The Forums Package
--
-- @author gwong@orchardlabs.com,ben@openforce.biz
-- @creation-date 2002-05-16
--
-- This code is newly concocted by Ben, but with significant concepts and code
-- lifted from Gilbert. Thanks Orchard Labs!
--

create table forums_messages (
    message_id                      integer
                                    constraint forums_message_id_fk
                                    references acs_objects (object_id)
                                    constraint forums_messages_pk
                                    primary key,
    forum_id                        integer
                                    constraint forums_mess_forum_id_fk
                                    references forums_forums (forum_id),
    subject                         varchar(200),
    content                         text,
    -- html_p only applies to the body. The subject is plaintext.
    html_p                          char(1)
                                    default 'f'
                                    constraint forums_mess_html_p_ck
                                    check (html_p in ('t','f'))
                                    constraint forums_mess_html_p_nn
                                    not null,
    user_id                         integer
                                    constraint forums_mess_user_id_fk
                                    references users(user_id)
                                    constraint forums_mess_user_id_nn
                                    not null,
    posting_date                    timestamp
                                    default now()
                                    constraint forum_mess_post_date_nn
                                    not null,
    state                           varchar(100)
                                    constraint forum_mess_state_ck
                                    check (state in ('pending','approved','rejected')),
    -- Hierarchy of messages
    parent_id                       integer
                                    constraint forum_mess_parent_id_fk
                                    references forums_messages (message_id),
    open_p                          char(1)
                                    default 't'
                                    constraint forum_mess_open_p_nn
                                    not null
                                    constraint forum_mess_open_p_ck
                                    check (open_p in ('t','f')),
    tree_sortkey                    varbit,
    max_child_sortkey               varbit,
    last_child_post                 timestamp,
    constraint forums_mess_sk_forum_un
    unique (tree_sortkey, forum_id)
);

-- We do a some big queries on forum_id (thread count on index.tcl) so create a second index 
-- ordered so it's useful for them
create unique index forums_mess_forum_sk_un on forums_messages(forum_id, tree_sortkey);

create view forums_messages_approved
as
    select *
    from forums_messages
    where state = 'approved';

create view forums_messages_pending
as
    select *
    from forums_messages
    where state= 'pending';

create function inline_0 ()
returns integer as '
begin
    perform acs_object_type__create_type(
        ''forums_message'',
        ''Forums Message'',
        ''Forums Messages'',
        ''acs_object'',
        ''forums_messages'',
        ''message_id'',
        ''forums_message'',
        ''f'',
        null,
        ''forums_message__name''
    );

    return null;
end;' language 'plpgsql';

select inline_0();
drop function inline_0 ();
