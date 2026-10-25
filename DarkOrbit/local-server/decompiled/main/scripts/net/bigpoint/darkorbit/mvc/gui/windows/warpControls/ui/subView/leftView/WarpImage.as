package net.bigpoint.darkorbit.mvc.gui.windows.warpControls.ui.subView.leftView
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.map.view2D.display.ship.Ship2D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class WarpImage
   {
      
      private static const WIDTH:int = 128;
      
      private static const HEIGHT:int = 113;
      
      private var _uiContainer:Sprite;
      
      private var _simpleWindow:SimpleWindow;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _img:Coreponent;
      
      private var _hover:Button;
      
      private var _warpShipLabel:Label;
      
      private var shipBitmap:DisplayObject;
      
      public function WarpImage(param1:Sprite)
      {
         super();
         this._fuiCache = new FuiComponentSelectorCache(param1);
         this._img = this.getCoreponent("pic") as Coreponent;
         this._warpShipLabel = this.getCoreponent("warpShipLabel") as Label;
      }
      
      private function getCoreponent(param1:String) : *
      {
         return this._fuiCache.selectComponent(param1);
      }
      
      public function set data(param1:ItemVO) : void
      {
         if(!param1)
         {
            return;
         }
         this._warpShipLabel.text = param1.fullname;
         this._warpShipLabel.invalidate(InvalidationType.SIZE);
         this._warpShipLabel.invalidate(InvalidationType.POSITION);
         this.shipImage(param1.lootID);
      }
      
      private function getShipClip(param1:SWFFinisher, param2:String) : DisplayObject
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
      
      private function shipImage(param1:String) : void
      {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:String = null;
         var _loc6_:SWFFinisher = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         var _loc2_:ShipPattern = PatternManager.shipPatterns[param1] as ShipPattern;
         if(_loc2_)
         {
            _loc3_ = UberAssetsLib.instance.getDescriptor(_loc2_.assetId + "_" + Hero.factionID.value,UberAssetsLib.LIB_SHIPS,false) || UberAssetsLib.instance.getDescriptor(_loc2_.assetId,UberAssetsLib.LIB_SHIPS) || UberAssetsLib.instance.getDebugDescription();
            _loc4_ = _loc3_.display2D[0];
            _loc5_ = String(_loc4_.@replacement) || String(_loc4_.@srcKey);
            _loc6_ = ResourceManager.fileCollection.getFinisher("replacementShips") as SWFFinisher;
            if(!_loc6_.hasEmbeddedObject(_loc5_))
            {
               return;
            }
            this.shipBitmap = this.getShipClip(_loc6_,_loc5_);
            this.shipBitmap.filters = Ship2D.get2DFiltersByDescriptor(_loc4_);
            this.shipBitmap.rotation = 90;
            if(this.shipBitmap.width > WIDTH || this.shipBitmap.height > HEIGHT)
            {
               _loc7_ = WIDTH / this.shipBitmap.width;
               _loc8_ = HEIGHT / this.shipBitmap.height;
               _loc9_ = Math.min(_loc7_,_loc8_);
               this.shipBitmap.scaleX = this.shipBitmap.scaleY = _loc9_;
            }
            this.shipBitmap.x = this._img.width / 2;
            this.shipBitmap.y = this._img.height / 2;
            this._img.addChild(this.shipBitmap);
         }
      }
   }
}

