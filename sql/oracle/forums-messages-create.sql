
--
-- The Forums Package
--
-- @author gwong@orchardlabs.com,ben@openforce.biz
-- @creation-date 2002-05-16
--
-- This code is newly concocted by Ben, but with significant concepts and code
-- lifted from Gilbert. Thanks Orchard Labs!
--

-- privileges
-- NO PRIVILEGES FOR MESSAGES
-- we don't individually permission messages

--
-- The Data Model
--

create table forums_messages (
       message_id               integer not null
                                constraint forums_message_id_fk
                                references acs_objects(object_id)
                                constraint forums_message_id_pk
                                primary key,
       forum_id                 integer
                                constraint forums_mess_forum_id_fk
                                references forums_forums(forum_id),
       subject                  varchar(200),
       content                  clob,
       -- html_p only applies to the body. The subject is plaintext.
       html_p                   char(1) default 'f'
                                constraint forums_mess_html_p_ch
                                check (html_p in ('t','f'))
                                constraint forums_mess_html_p_nn not null,
       user_id                  integer
                                constraint forums_mess_user_id_fk
                                references users(user_id)
                                constraint forums_mess_user_id_nn
                                not null,
       posting_date             date
                                constraint forum_mess_post_date_nn not null,
       state                    varchar(100)
                                constraint forum_mess_state_ch check (state in ('pending','approved','rejected')),
       -- Hierarchy of messages
       parent_id                integer
                                constraint forum_mess_parent_id_fk
                                references forums_messages(message_id),
       open_p                   char(1) default 't' not null
                                constraint forum_mess_open_p_ch check (open_p in ('t','f')),
       tree_sortkey             raw(240),
       max_child_sortkey        raw(100),
       constraint forums_mess_sk_forum_un
       unique (tree_sortkey,forum_id)
);

-- views

create view forums_messages_approved as
select * from forums_messages where state='approved';

create view forums_messages_pending as
select * from forums_messages where state='pending';

--
-- Object Type
--

declare
begin
        acs_object_type.create_type (
            supertype => 'acs_object',
            object_type => 'forums_message',
            pretty_name => 'Forums Message',
            pretty_plural => 'Forums Messages',
            table_name => 'forums_messages',
            id_column => 'message_id',
            package_name => 'forums_message'
        );
end;
/
show errors
