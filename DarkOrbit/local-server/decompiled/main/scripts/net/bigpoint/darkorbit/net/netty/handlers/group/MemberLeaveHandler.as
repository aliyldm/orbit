package net.bigpoint.darkorbit.net.netty.handlers.group
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.MemberLeaveCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   import net.bigpoint.darkorbit.net.netty.handlers.group.base.GroupSystemHandler;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MemberLeaveHandler extends GroupSystemHandler
   {
      
      public function MemberLeaveHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:DOChatProxy = null;
         var _loc2_:MemberLeaveCommand = param1.getBody() as MemberLeaveCommand;
         groupProxy.onMemberLeft(_loc2_.playerId,_loc2_.reason);
         if(Hero.userID == _loc2_.playerId)
         {
            _loc3_ = facade.retrieveProxy(DOChatProxy.NAME) as DOChatProxy;
            _loc3_.leaveGroup();
         }
      }
   }
}

