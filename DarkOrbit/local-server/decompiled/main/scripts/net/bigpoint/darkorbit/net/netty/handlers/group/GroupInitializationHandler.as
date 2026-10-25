package net.bigpoint.darkorbit.net.netty.handlers.group
{
   import net.bigpoint.darkorbit.com.module.GroupInitializationCommand;
   import net.bigpoint.darkorbit.com.module.GroupMemberInitializationCommand;
   import net.bigpoint.darkorbit.net.netty.HandlerLookup;
   import net.bigpoint.darkorbit.net.netty.handlers.group.base.GroupSystemHandler;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class GroupInitializationHandler extends GroupSystemHandler
   {
      
      public function GroupInitializationHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:GroupMemberInitializationCommand = null;
         super.execute(param1);
         var _loc2_:GroupInitializationCommand = param1.getBody() as GroupInitializationCommand;
         groupProxy.initGroup(_loc2_.id,_loc2_.members.length,_loc2_.maxSize,_loc2_.invitationMode.mode,0);
         for each(_loc3_ in _loc2_.members)
         {
            HandlerLookup.execute(_loc3_);
         }
         groupProxy.handleLeaderChange(_loc2_.leaderId);
      }
   }
}

