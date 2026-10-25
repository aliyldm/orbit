package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import com.bigpoint.utils.TextFormatter;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteInventoryItemVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items.StarLevelDisplayHelper;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class RogueLiteRewardAssigner extends DefaultItemDataAssigner
   {
      
      private var _bg:Coreponent;
      
      private var _icon:Coreponent;
      
      private var _name:Label;
      
      private var _level:Label;
      
      private var _starLayer:Sprite;
      
      public function RogueLiteRewardAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this._icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         this._name = FuiComponentSelectorUtil.selectComponent("name",this) as Label;
         this._level = FuiComponentSelectorUtil.selectComponent("level",this) as Label;
         this._starLayer = new Sprite();
         this._starLayer.name = "starLayer";
         this._starLayer.mouseEnabled = false;
         this._starLayer.mouseChildren = false;
         this._starLayer.x = this._icon.x;
         this._starLayer.y = this._icon.y;
         this._starLayer.graphics.beginFill(0,0);
         this._starLayer.graphics.drawRect(0,0,this._icon.width,this._icon.height);
         this._starLayer.graphics.endFill();
         addChild(this._starLayer);
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:RogueLiteInventoryItemVO = null;
         _loc2_ = param1 as RogueLiteInventoryItemVO;
         if(!_loc2_ || !_loc2_.itemVO)
         {
            StarLevelDisplayHelper.render(this._starLayer,null);
            return;
         }
         this.removeListeners();
         super.data = _loc2_;
         this.addListeners();
         StarLevelDisplayHelper.render(this._starLayer,_loc2_.itemVO);
         loadResource(_loc2_.itemVO.getLoot100x100(),this.handleItemIconLoaded,this.handleItemIconLoadError,AssetsProxy.ITEMS);
         this._name.text = _loc2_.itemVO.codeName;
         if(_loc2_.itemVO.upgradeLevel > 0)
         {
            this._level.text = BPLocale.getItemInCategory("inventory","label_drone_info_level").replace("%VALUE%",this.displayLevel);
            this._level.visible = true;
         }
         else
         {
            this._level.visible = false;
         }
         tooltipData = _loc2_.isUnstableModule ? _loc2_.unstableStats : _loc2_.itemVO.descriptionName;
         selected = false;
         alpha = 1;
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
      
      override protected function drawSelection() : void
      {
         this._bg.setSkinState(_selected ? "selected" : "normal");
      }
      
      public function get VO() : RogueLiteInventoryItemVO
      {
         return data as RogueLiteInventoryItemVO;
      }
      
      private function get displayLevel() : String
      {
         if(!this.VO)
         {
            return "";
         }
         return this.VO.itemVO.upgradeLevel > 0 ? TextFormatter.roundInteger(this.VO.itemVO.upgradeLevel + 1) : "";
      }
   }
}

