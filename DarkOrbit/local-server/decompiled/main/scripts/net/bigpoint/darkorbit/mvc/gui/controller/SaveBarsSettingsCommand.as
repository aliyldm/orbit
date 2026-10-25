package net.bigpoint.darkorbit.mvc.gui.controller
{
   import net.bigpoint.darkorbit.com.module.WindowSettingsRequest;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.vo.AbstractMenuBarVO;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.FeaturesMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.ItemsControlMenuProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SaveBarsSettingsCommand extends DOAbstractSimpleCommand
   {
      
      public static const PROPERTY_SEPARTOR:String = ",";
      
      public function SaveBarsSettingsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:AbstractMenuBarVO = null;
         var _loc3_:AbstractMenuBarVO = null;
         var _loc4_:AbstractMenuBarVO = null;
         var _loc5_:AbstractMenuBarVO = null;
         var _loc6_:AbstractMenuBarVO = null;
         var _loc7_:AbstractMenuBarVO = null;
         var _loc8_:WindowSettingsRequest = null;
         if(Boolean(this.itemsControlMenuProxy && this.itemsControlMenuProxy.menuBars && this.featuresMenuProxy) && Boolean(this.featuresMenuProxy.menuBars) && !screenManager.duringRrsize)
         {
            _loc2_ = this.itemsControlMenuProxy.getMenuBarVOById(ItemsControlMenuConstants.CATEGORY_BAR);
            _loc3_ = this.itemsControlMenuProxy.getMenuBarVOById(ItemsControlMenuConstants.STANDARD_SLOT_BAR);
            _loc4_ = this.itemsControlMenuProxy.getMenuBarVOById(ItemsControlMenuConstants.PREMIUM_SLOT_BAR);
            _loc5_ = this.itemsControlMenuProxy.getMenuBarVOById(ItemsControlMenuConstants.PRO_ACTION_BAR);
            _loc6_ = this.featuresMenuProxy.getMenuBarVOById(FeaturesMenuConstants.GAME_FEATURE_BAR);
            _loc7_ = this.featuresMenuProxy.getMenuBarVOById(FeaturesMenuConstants.GENERIC_FEATURE_BAR);
            if(Boolean(_loc2_) && Boolean(_loc3_) && Boolean(_loc6_) && Boolean(_loc7_))
            {
               _loc8_ = new WindowSettingsRequest();
               _loc8_.minimapScale = screenManager.minimap.scaleFactor;
               _loc8_.mainmenuPosition = _loc2_.positionCords;
               _loc8_.slotmenuPosition = _loc3_.positionCords;
               _loc8_.slotMenuOrder = _loc3_.layoutType;
               if(_loc4_)
               {
                  _loc8_.slotmenuPremiumPosition = _loc4_.positionCords;
                  _loc8_.slotMenuPremiumOrder = _loc4_.layoutType;
               }
               if(_loc5_)
               {
                  _loc8_.slotmenuProActionPosition = _loc5_.positionCords;
                  _loc8_.slotMenuProActionOrder = _loc5_.layoutType;
               }
               _loc8_.gameFeatureMenuPosition = _loc6_.positionCords;
               _loc8_.gameFeatureMenuOrder = _loc6_.layoutType;
               _loc8_.genericFeatureMenuPosition = _loc7_.positionCords;
               _loc8_.genericFeatureMenuOrder = _loc7_.layoutType;
               _loc8_.barStatus = guiProxy.getBarStatesAsString();
               connectionProxy.sendNettyRequest(_loc8_);
            }
         }
      }
      
      protected function get itemsControlMenuProxy() : ItemsControlMenuProxy
      {
         return facade.retrieveProxy(ItemsControlMenuProxy.NAME) as ItemsControlMenuProxy;
      }
      
      protected function get featuresMenuProxy() : FeaturesMenuProxy
      {
         return facade.retrieveProxy(FeaturesMenuProxy.NAME) as FeaturesMenuProxy;
      }
   }
}

