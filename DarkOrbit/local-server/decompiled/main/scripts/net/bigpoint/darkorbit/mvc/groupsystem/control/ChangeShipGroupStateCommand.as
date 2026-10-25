package net.bigpoint.darkorbit.mvc.groupsystem.control
{
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.proxy.GroupProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ChangeShipGroupStateCommand extends DOAbstractSimpleCommand
   {
      
      public function ChangeShipGroupStateCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Ship = null;
         var _loc2_:GroupProxy = facade.retrieveProxy(GroupProxy.NAME) as GroupProxy;
         if(_loc2_)
         {
            _loc3_ = int(param1.getBody());
            _loc4_ = map.getEntityById(_loc3_) as Ship;
            if(_loc4_)
            {
               _loc4_.isGroupMember.value = _loc2_.isGroupMember(_loc3_);
               if(_loc4_.pet != null)
               {
                  _loc4_.pet.isGroupMember.value = _loc4_.isGroupMember.value;
               }
            }
         }
      }
   }
}

