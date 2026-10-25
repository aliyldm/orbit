package net.bigpoint.darkorbit.mvc.gui.featuresMenu.controller.updates
{
   import net.bigpoint.darkorbit.com.module.WindowItemCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.FeaturesMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureItemVO;
   import net.bigpoint.darkorbit.mvc.gui.highlights.HighLightItemNotification;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UpdateMenuItemsVisibilityCommand extends DOAbstractSimpleCommand
   {
      
      public function UpdateMenuItemsVisibilityCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:WindowItemCommand = param1.getBody() as WindowItemCommand;
         var _loc3_:FeatureItemVO = this.menuProxy.getFeatureItemVOById(_loc2_.itemId);
         if(Boolean(_loc3_) && _loc3_.visible != _loc2_.visible)
         {
            _loc3_.visible = _loc2_.visible;
            if(!_loc2_.visible)
            {
               sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT_BY_ITEM_ID,_loc2_.itemId);
            }
            sendNotification(FeaturesMenuNotifications.DATA_READY);
         }
         else if(!_loc3_)
         {
         }
      }
      
      protected function get menuProxy() : FeaturesMenuProxy
      {
         return retrieveProxy(FeaturesMenuProxy.NAME) as FeaturesMenuProxy;
      }
   }
}

