package net.bigpoint.darkorbit.mvc.groupsystem.control
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.InvitationDeleteVo;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.proxy.GroupProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class RemoveInvitationByMemberIdCommand extends SimpleCommand
   {
      
      public function RemoveInvitationByMemberIdCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:GroupProxy = facade.retrieveProxy(GroupProxy.NAME) as GroupProxy;
         var _loc3_:InvitationDeleteVo = param1.getBody() as InvitationDeleteVo;
         if(_loc3_.type == InvitationDeleteVo.INCOMMING)
         {
            _loc2_.deleteInvitation(_loc3_.userId,Hero.userID);
         }
         else
         {
            _loc2_.deleteInvitation(Hero.userID,_loc3_.userId);
         }
      }
   }
}

