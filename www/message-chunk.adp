    <tr bgcolor="@bgcolor@">
      <td><b><a href="message-view?message_id=@message.message_id@">@message.subject@</a></b></td>
      <td width="15%"><a href="user-history?user_id=@message.user_id@">@message.user_name@</a></td>
      <td width="20%">@message.posting_date@</td>
      <td align="right" width="25%">
        <nobr><small>
          [
            <a href="message-post?parent_id=@message.message_id@">reply</a>
            | <a href="message-email?message_id=@message.message_id@">email</a>
<if @moderate_p@>
            | <a href="moderate/message-edit?message_id=@message.message_id@">edit</a>
            | <a href="moderate/message-delete?message_id=@message.message_id@">delete</a>
            <if @message.state@ ne approved> | <a href="moderate/message-approve?message_id=@message.message_id@">approve</a></if>
            <if @message.state@ ne rejected> | <a href="moderate/message-reject?message_id=@message.message_id@">reject</a></if>
</if>
          ]
        </small></nobr>
      </td>
    </tr>
    <tr bgcolor="@bgcolor@">
      <td colspan="4"><blockquote>@message.content@</blockquote></td>
    </tr>
