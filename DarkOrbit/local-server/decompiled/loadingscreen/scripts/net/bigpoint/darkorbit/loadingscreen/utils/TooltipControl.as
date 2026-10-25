package net.bigpoint.darkorbit.loadingscreen.utils
{
   import flash.display.InteractiveObject;
   
   public class TooltipControl
   {
      
      private static var _instance:TooltipControl;
      
      private var toolTipsList:Array;
      
      public function TooltipControl(param1:Function)
      {
         var _loc2_:String = null;
         super();
         if(param1 !== hidden)
         {
            _loc2_ = "TooltipControl is a Singleton and can only be accessed through TooltipControl.getInstance()";
            throw new Error(_loc2_);
         }
         this.init();
      }
      
      private static function hidden() : void
      {
      }
      
      public static function getInstance() : TooltipControl
      {
         if(_instance == null)
         {
            _instance = new TooltipControl(hidden);
         }
         return _instance;
      }
      
      private function init() : void
      {
         this.toolTipsList = new Array();
      }
      
      public function addToolTip(param1:InteractiveObject, param2:String) : void
      {
         if(param2.length < 1)
         {
            return;
         }
         var _loc3_:ToolTipHook = new ToolTipHook(param1,param2);
         this.toolTipsList.push(_loc3_);
      }
      
      public function removeToolTip(param1:InteractiveObject) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.toolTipsList.length)
         {
            if(ToolTipHook(this.toolTipsList[_loc2_]).getTargetObject() == param1)
            {
               ToolTipHook(this.toolTipsList[_loc2_]).suicide();
               this.toolTipsList.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function removeAllToolTips() : void
      {
         var _loc1_:uint = this.toolTipsList.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            ToolTipHook(this.toolTipsList[_loc2_]).suicide();
            _loc2_++;
         }
         this.toolTipsList = null;
      }
   }
}

