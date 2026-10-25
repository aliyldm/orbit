package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view
{
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   
   public class ProgressBar extends Sprite
   {
      
      private var _bar:Sprite;
      
      public function ProgressBar(param1:int, param2:int, param3:int)
      {
         var _loc4_:Sprite = null;
         super();
         _loc4_ = new Sprite();
         _loc4_.filters = [this.getShadow(2,true)];
         addChild(_loc4_);
         _loc4_.graphics.clear();
         _loc4_.graphics.beginFill(4473924);
         _loc4_.graphics.drawRect(0,0,param1,param2);
         _loc4_.graphics.endFill();
         this._bar = new Sprite();
         this._bar.x = 1;
         this._bar.y = 1;
         this._bar.filters = [this.getShadow(1)];
         addChild(this._bar);
         this._bar.graphics.clear();
         this._bar.graphics.beginFill(param3);
         this._bar.graphics.drawRect(0,0,param1 - 2,param2 - 2);
         this._bar.graphics.endFill();
      }
      
      private function getShadow(param1:Number, param2:Boolean = false) : DropShadowFilter
      {
         return new DropShadowFilter(param1,45,0,1,param1,param1,0.3,1,param2);
      }
      
      public function update(param1:Number, param2:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         param1 = Math.min(param1,param2);
         this._bar.scaleX = param1 / param2;
      }
   }
}

