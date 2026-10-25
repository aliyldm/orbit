package net.bigpoint.darkorbit.mvc.gui.windows.warp.view.ui
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.ShipWarpModule;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.map.view2D.display.ship.Ship2D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class WarpShipsAssigner extends DefaultItemDataAssigner
   {
      
      private static const WIDTH:int = 85;
      
      private static const HEIGHT:int = 75;
      
      private var _img:Coreponent;
      
      private var _hover:Button;
      
      private var _warpShipLabel:Label;
      
      private var shipBitmap:DisplayObject;
      
      public function WarpShipsAssigner()
      {
         super();
      }
      
      public static function shipImage_(param1:String, param2:Sprite, param3:DisplayObject) : void
      {
         var _loc5_:XML = null;
         var _loc6_:XML = null;
         var _loc7_:String = null;
         var _loc8_:SWFFinisher = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         MovieClipUtils.cleanupDisplayObjectContainer(param2);
         var _loc4_:ShipPattern = PatternManager.shipPatterns[param1] as ShipPattern;
         if(_loc4_)
         {
            _loc5_ = UberAssetsLib.instance.getDescriptor(_loc4_.assetId + "_" + Hero.factionID.value,UberAssetsLib.LIB_SHIPS,false) || UberAssetsLib.instance.getDescriptor(_loc4_.assetId,UberAssetsLib.LIB_SHIPS) || UberAssetsLib.instance.getDebugDescription();
            _loc6_ = _loc5_.display2D[0];
            _loc7_ = String(_loc6_.@replacement) || String(_loc6_.@srcKey);
            _loc8_ = ResourceManager.fileCollection.getFinisher("replacementShips") as SWFFinisher;
            if(!_loc8_.hasEmbeddedObject(_loc7_))
            {
               return;
            }
            param3 = getShipClip(_loc8_,_loc7_);
            param3.filters = Ship2D.get2DFiltersByDescriptor(_loc6_);
            param3.rotation = 90;
            if(param3.width > WIDTH || param3.height > HEIGHT)
            {
               _loc9_ = WIDTH / param3.width;
               _loc10_ = HEIGHT / param3.height;
               _loc11_ = Math.min(_loc9_,_loc10_);
               param3.scaleX = param3.scaleY = _loc11_;
            }
            param3.x = param2.width / 2;
            param3.y = param2.height / 2;
            param2.addChild(param3);
         }
      }
      
      private static function getShipClip(param1:SWFFinisher, param2:String) : DisplayObject
      {
         var _loc4_:DisplayObject = null;
         var _loc3_:DisplayObjectContainer = param1.getEmbeddedObject(param2) as DisplayObjectContainer;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.numChildren)
         {
            _loc4_ = _loc3_.getChildAt(_loc5_);
            if(_loc4_ != null && (_loc4_.name.search("engine") != -1 || _loc4_.name.search("laser") != -1))
            {
               _loc4_.visible = false;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         var _loc2_:ShipWarpModule = param1 as ShipWarpModule;
         if(!_loc2_)
         {
            return;
         }
         this._warpShipLabel.text = _loc2_.shipDesignName;
         this._warpShipLabel.invalidate(InvalidationType.SIZE);
         this._warpShipLabel.invalidate(InvalidationType.POSITION);
         this.shipImage(param1.typeId);
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._hover = FuiComponentSelectorUtil.selectComponent("hover",this) as Button;
         this._warpShipLabel = FuiComponentSelectorUtil.selectComponent("warpShipLabelContainer.warpShipLabel",this) as Label;
      }
      
      override protected function drawSelection() : void
      {
         super.drawSelection();
         this._hover.enabled = !_selected;
      }
      
      private function shipImage(param1:String) : void
      {
         WarpShipsAssigner.shipImage_(param1,this._img,this.shipBitmap);
      }
   }
}

