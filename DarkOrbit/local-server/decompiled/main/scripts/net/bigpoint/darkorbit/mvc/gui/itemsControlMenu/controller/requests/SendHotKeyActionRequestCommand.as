package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.controller.requests
{
   import net.bigpoint.darkorbit.com.module.MenuActionRequest;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.ItemsControlMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.ItemVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.ItemsControlMenuMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SendHotKeyActionRequestCommand extends DOAbstractSimpleCommand
   {
      
      public function SendHotKeyActionRequestCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc5_:int = 0;
         var _loc6_:MenuActionRequest = null;
         var _loc2_:int = int(param1.getBody());
         var _loc3_:String = param1.getType();
         var _loc4_:ItemVO = this.menuMediator.getItemVOBySlotId(_loc2_,_loc3_);
         if(_loc4_)
         {
            switch(_loc4_.actionStyle)
            {
               case ItemsControlMenuConstants.ACTION_SELECTION:
                  _loc5_ = MenuActionRequest.ACTIONTYPE_ACTIVATE;
                  break;
               case ItemsControlMenuConstants.ACTION_TOOGLE:
                  _loc5_ = MenuActionRequest.ACTIONTYPE_SELECT;
                  break;
               case ItemsControlMenuConstants.ACTION_ONE_SHOT:
                  _loc5_ = MenuActionRequest.ACTIONTYPE_ACTIVATE;
            }
            _loc6_ = new MenuActionRequest(_loc4_.id,_loc5_,MenuActionRequest.SOURCETYPE_SLOT_BAR);
            connectionProxy.connectionManager.sendRequest(_loc6_);
         }
      }
      
      private function get menuMediator() : ItemsControlMenuMediator
      {
         return facade.retrieveMediator(ItemsControlMenuMediator.NAME) as ItemsControlMenuMediator;
      }
      
      private function get menuProxy() : ItemsControlMenuProxy
      {
         return facade.retrieveProxy(ItemsControlMenuProxy.NAME) as ItemsControlMenuProxy;
      }
   }
}

