package net.bigpoint.darkorbit.mvc.chatclient.model
{
   public class DOChatProposalVO extends DOChatMessageVO
   {
      
      private var _inviteVo:DOChatInviteVO;
      
      public function DOChatProposalVO(param1:String, param2:DOChatUserVO, param3:DOChatInviteVO, param4:String = "0")
      {
         super(param1,param2,param4);
         this._inviteVo = param3;
      }
      
      public function get inviteVo() : DOChatInviteVO
      {
         return this._inviteVo;
      }
   }
}

