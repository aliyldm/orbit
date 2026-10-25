package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteShipVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class RogueLiteShipDataAssigner extends DefaultItemDataAssigner
   {
      
      private var _sprite:Coreponent;
      
      private var _label:Label;
      
      private var _checkbox:Coreponent;
      
      public function RogueLiteShipDataAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._sprite = FuiComponentSelectorUtil.selectComponent("ship_sprite",this) as Coreponent;
         this._label = FuiComponentSelectorUtil.selectComponent("ship_name",this) as Label;
         this._checkbox = FuiComponentSelectorUtil.selectComponent("check",this) as Coreponent;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:RogueLiteShipVO = param1 as RogueLiteShipVO;
         if(!_loc2_)
         {
            return;
         }
         this.removeListeners();
         super.data = _loc2_;
         this.addListeners();
         this._label.text = _loc2_.shipName;
         loadResource(_loc2_.shipVO.getLoot100x100(Hero.factionName),this.handleShipSpriteLoaded,this.handleShipSpriteLoadError,AssetsProxy.ITEMS);
      }
      
      override protected function drawSelection() : void
      {
         this._checkbox.visible = _selected;
         this.VO.selected.value = _selected;
         super.drawSelection();
      }
      
      private function get VO() : RogueLiteShipVO
      {
         return data as RogueLiteShipVO;
      }
      
      private function addListeners() : void
      {
      }
      
      private function removeListeners() : void
      {
      }
      
      private function handleShipSpriteLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._sprite);
         this._sprite.addChild(new Bitmap(param1.getBitmap().bitmapData));
      }
      
      private function handleShipSpriteLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._sprite);
      }
   }
}

