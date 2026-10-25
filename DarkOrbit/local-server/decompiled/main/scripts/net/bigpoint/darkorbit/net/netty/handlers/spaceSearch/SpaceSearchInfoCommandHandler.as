package net.bigpoint.darkorbit.net.netty.handlers.spaceSearch
{
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchInfoCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model.SpaceSearchUIProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SpaceSearchInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function SpaceSearchInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SpaceSearchInfoCommand = param1.getBody() as SpaceSearchInfoCommand;
         var _loc3_:int = _loc2_.planetIndex;
         var _loc4_:int = _loc2_.planetPct;
         var _loc5_:String = _loc2_.lootId;
         var _loc6_:int = _loc2_.quantity;
         var _loc7_:int = _loc2_.cost;
         var _loc8_:SpaceSearchUIProxy = SpaceSearchUIProxy.getOrCreateProxy(this.facade);
         _loc8_.viewData.update(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
      }
   }
}

