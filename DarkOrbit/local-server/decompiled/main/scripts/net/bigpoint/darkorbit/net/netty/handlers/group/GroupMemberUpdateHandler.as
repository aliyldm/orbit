package net.bigpoint.darkorbit.net.netty.handlers.group
{
   import net.bigpoint.darkorbit.com.module.GroupMemberUpdateCommand;
   import net.bigpoint.darkorbit.net.netty.handlers.group.base.GroupSystemHandler;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class GroupMemberUpdateHandler extends GroupSystemHandler
   {
      
      public function GroupMemberUpdateHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:GroupMemberUpdateCommand = param1.getBody() as GroupMemberUpdateCommand;
         if(groupProxy)
         {
            groupProxy.updateMember(_loc2_.playerId,_loc2_.updates);
         }
      }
   }
}

