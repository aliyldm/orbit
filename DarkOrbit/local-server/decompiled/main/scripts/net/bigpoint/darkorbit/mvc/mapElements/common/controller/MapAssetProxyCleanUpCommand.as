package net.bigpoint.darkorbit.mvc.mapElements.common.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.proxy.GroupProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MapAssetProxyCleanUpCommand extends DOAbstractSimpleCommand
   {
      
      public function MapAssetProxyCleanUpCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:GroupProxy = facade.retrieveProxy(GroupProxy.NAME) as GroupProxy;
         if(_loc2_)
         {
            _loc2_.selectUser(-1,"");
         }
      }
   }
}

