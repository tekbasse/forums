
--
-- The Forums Package
--
-- @author gwong@orchardlabs.com,ben@openforce.biz
-- @creation-date 2002-05-16
--
-- This code is newly concocted by Ben, but with heavy concepts and heavy code
-- chunks lifted from Gilbert. Thanks Orchard Labs.
--

-- privileges
declare
begin
   -- remove children
   acs_privilege.remove_child('read','forum_read');
   acs_privilege.remove_child('create','forum_create');
   acs_privilege.remove_child('write','forum_write');
   acs_privilege.remove_child('delete','forum_delete');
   acs_privilege.remove_child('admin','forum_moderate');
   acs_privilege.remove_child('forum_moderate','forum_read');
   acs_privilege.remove_child('forum_moderate','forum_post');
   acs_privilege.remove_child('forum_write','forum_read');
   acs_privilege.remove_child('forum_write','forum_post');
   
   acs_privilege.drop_privilege('forum_moderate');
   acs_privilege.drop_privilege('forum_post');
   acs_privilege.drop_privilege('forum_read');
   acs_privilege.drop_privilege('forum_create');
   acs_privilege.drop_privilege('forum_write');
   acs_privilege.drop_privilege('forum_delete');
end;
/
show errors


--
-- The Data Model
--

drop table forums_forums;

--
-- Object Type
--

declare
begin
        acs_object_type.drop_type (
            object_type => 'forums_forum'
        );
end;
/
show errors
