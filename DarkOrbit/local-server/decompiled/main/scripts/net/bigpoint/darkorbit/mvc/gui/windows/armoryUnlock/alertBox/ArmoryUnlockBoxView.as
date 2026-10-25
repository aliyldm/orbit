package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.alertBox
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class ArmoryUnlockBoxView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public var _items:Vector.<Coreponent> = new Vector.<Coreponent>(10);
      
      public var _labels:Vector.<Label> = new Vector.<Label>(10);
      
      public function ArmoryUnlockBoxView(param1:SimpleWindow)
      {
         var _loc5_:String = null;
         var _loc6_:Coreponent = null;
         var _loc7_:Coreponent = null;
         super();
         var _loc2_:SimpleWindow = param1;
         var _loc3_:Sprite = _loc2_.getUIContainer();
         this._fuiCache = new FuiComponentSelectorCache(_loc3_);
         this._items.length = 0;
         this._labels.length = 0;
         var _loc4_:int = 1;
         while(_loc4_ <= 10)
         {
            _loc5_ = "root.body.itemBox.item" + (_loc4_ < 10 ? "0" : "") + _loc4_;
            _loc6_ = this._fuiCache.selectComponent(_loc5_) as Coreponent;
            this._items.push(_loc6_);
            _loc6_.visible = false;
            _loc6_.graphics.clear();
            _loc6_.graphics.beginFill(0,0.5);
            _loc6_.graphics.drawRect(0,0,40,40);
            _loc6_.graphics.endFill();
            _loc5_ += "_label";
            _loc7_ = this._fuiCache.selectComponent(_loc5_) as Label;
            this._labels.push(_loc7_);
            _loc4_++;
         }
      }
      
      public function hiddenAllItems() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].visible = false;
            this._labels[_loc1_].visible = false;
            _loc1_++;
         }
      }
      
      public function get ok_btn() : Button
      {
         return this._fuiCache.selectComponent("root.body.ok_btn") as Button;
      }
   }
}

