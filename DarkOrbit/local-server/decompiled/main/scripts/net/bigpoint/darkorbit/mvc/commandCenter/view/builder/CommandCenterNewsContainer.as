package net.bigpoint.darkorbit.mvc.commandCenter.view.builder
{
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   
   public class CommandCenterNewsContainer extends Container
   {
      
      private var _timer:Vector.<Label> = new Vector.<Label>(0);
      
      public function CommandCenterNewsContainer()
      {
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._timer.length = 0;
      }
      
      public function addTimer(param1:Label) : void
      {
         addChild(param1);
         this._timer.push(param1);
      }
      
      public function updateTime(param1:String) : void
      {
         var _loc4_:Label = null;
         var _loc2_:int = int(this._timer.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._timer[_loc3_];
            _loc4_.text = param1;
            _loc3_++;
         }
      }
   }
}

