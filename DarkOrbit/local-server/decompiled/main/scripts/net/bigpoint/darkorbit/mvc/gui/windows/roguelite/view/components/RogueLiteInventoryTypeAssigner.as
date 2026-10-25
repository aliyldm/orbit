package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class RogueLiteInventoryTypeAssigner extends DefaultItemDataAssigner
   {
      
      private var _icon:Coreponent;
      
      private var _state:Coreponent;
      
      public function RogueLiteInventoryTypeAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         this._state = FuiComponentSelectorUtil.selectComponent("state",this) as Coreponent;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:ItemVO = param1 as ItemVO;
         if(!_loc2_)
         {
            return;
         }
         this.removeListeners();
         super.data = _loc2_;
         this.addListeners();
         loadResource(_loc2_.getLoot30x30(),this.handleItemIconLoaded,this.handleItemIconLoadError,AssetsProxy.ITEMS);
         tooltipData = this.getInventoryTabLocale(_loc2_.getItemType());
      }
      
      private function addListeners() : void
      {
      }
      
      private function removeListeners() : void
      {
      }
      
      private function handleItemIconLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
         this._icon.addChild(new Bitmap(param1.getBitmap().bitmapData));
      }
      
      private function handleItemIconLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
      }
      
      public function get VO() : ItemVO
      {
         return data as ItemVO;
      }
      
      override protected function drawSelection() : void
      {
         this._state.setSkinState(_selected ? "selected" : "unselected");
      }
      
      private function getInventoryTabLocale(param1:String) : String
      {
         var _loc2_:String = param1.toLowerCase();
         if(_loc2_.indexOf("generator") >= 0)
         {
            return BPLocale.getItem("ttip_tab_astralascension_manage_generator");
         }
         if(_loc2_.indexOf("laser") >= 0)
         {
            return BPLocale.getItem("ttip_tab_astralascension_manage_laser");
         }
         if(_loc2_.indexOf("launcher") >= 0)
         {
            return BPLocale.getItem("ttip_tab_astralascension_manage_rocketlauncher");
         }
         if(_loc2_.indexOf("shipupgrade") >= 0)
         {
            return BPLocale.getItem("ttip_tab_astralascension_manage_upgrademodule");
         }
         return BPLocale.getItem("ttip_tab_astralascension_manage_booster");
      }
   }
}

