
<tr style="color: black; background-color: @table_bgcolor@;">
  <if @display_subject_p@>
    <td align=left style="padding-left: 1em">
      <strong>
        <if @preview@ nil>
          <a name="@message.message_id@"><a href="@message.direct_url@" title="Direct link to this post">@message.number@</a></a>:
          <a href="message-view?message_id=@message.message_id@" title="Link to this post on a separate page">@message.subject@</a>
        </if>
        <else>
          @message.subject@
        </else>
      </strong>  
    </td>
  </if>
  <else>
    <td align=left style="padding-left: 1em">
      <strong>
        <a name="@message.message_id@"><a href="@message.direct_url@" title="Direct link to this post">@message.number@</a></a>
      </strong>
    </td>
  </else>
  <td align="left">
    <if @message.parent_number@ not nil>
      In response to <a href="@message.parent_direct_url@">@message.parent_number@</a>
    </if>
  </td> 
  <td align="left">@message.posting_date_pretty@</td>

  <if @preview@ nil>
  
    <td align="right" style="padding-right: 1em; padding-left: 1em;">
      <div style="white-space: nowrap; font-size: x-small">
        [
	<if @presentation_type@ ne flat>
	  <a href="message-post?parent_id=@message.message_id@">#forums.reply#</a> |
        </if>
	<a href="message-email?message_id=@message.message_id@">#forums.forward#</a>  
        ]
        <if @moderate_p@>
          <br>
          [ <a href="moderate/message-edit?message_id=@message.message_id@">#forums.edit#</a>
          | <a href="moderate/message-delete?message_id=@message.message_id@">#forums.delete#</a>
	  <if @message.parent_id@ nil>
	  | <a href="moderate/thread-move?message_id=@message.message_id@">#forums.Move_thread_to_other_forum#</a> 
	  | <a href="moderate/thread-move-thread?message_id=@message.message_id@">#forums.Move_thread_to_other_thread#</a> 
	  </if>
	  <else>
	      | <a href="moderate/message-move?message_id=@message.message_id@">#forums.Move_to_other_thread#</a> 
	  </else>
          
          <if @forum_moderated_p@>
            <if @message.state@ ne approved>
              | <a href="moderate/message-approve?message_id=@message.message_id@">#forums.approve#</a>
            </if>
            <if @message.state@ ne rejected and @message.max_child_sortkey@ nil>
              | <a href="moderate/message-reject?message_id=@message.message_id@">#forums.reject#</a>
            </if>
          </if>
          ]
        </if>
      </div>
    </td>

  </if>

</tr>

<tr style="color: black; background-color: @table_bgcolor@">
  <if @preview@ nil>
    <td align="left" colspan="4" style="padding: 1em">
  </if>
  <else>
    <td align="left" colspan="3" style="padding: 1em">  
  </else>

    <div align="left">
      @message.content;noquote@
      <p style="color: #999999;">
        #forums.Posted_by# <a href="user-history?user_id=@message.user_id@">@message.user_name@</a>
      </p>
    </div>
  </td>
</tr>

<if @message.n_attachments@ not nil and @message.n_attachments@ gt 0>
<tr bgcolor=@table_bgcolor;noquote@>
  <td colspan="4">
    #forums.Attachments#
    <include src="attachment-list" &message="message" bgcolor=@table_bgcolor;noquote@>
  </td>
</tr>
</if>
