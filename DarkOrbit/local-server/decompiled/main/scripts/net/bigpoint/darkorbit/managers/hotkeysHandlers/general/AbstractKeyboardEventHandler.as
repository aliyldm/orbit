package net.bigpoint.darkorbit.managers.hotkeysHandlers.general
{
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.utils.describeType;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   
   public class AbstractKeyboardEventHandler implements IKeyboardEventHandler
   {
      
      protected const gameFacade:GameFacade = GameFacade.getInstance();
      
      private var _describeType:XML;
      
      public function AbstractKeyboardEventHandler()
      {
         super();
      }
      
      protected function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
      
      protected function handleShiftKeyRelated(param1:uint) : void
      {
      }
      
      protected function handleControlShiftKeyRelated(param1:uint) : void
      {
      }
      
      protected function handleControlKeyRelated(param1:uint) : void
      {
      }
      
      protected function handleControlAndShiftKeyRelated(param1:uint) : void
      {
         switch(param1)
         {
            case Keyboard.SPACE:
               UISystem.VISUAL_DEBUG = !UISystem.VISUAL_DEBUG;
               break;
            case Keyboard.F1:
               this.traceOutAllRegisteredTemplateStructures();
         }
      }
      
      public function handle(param1:KeyboardEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = String.fromCharCode(param1.charCode).toUpperCase();
         if(param1.shiftKey)
         {
            _loc3_ = "shift" + _loc2_;
            if(this.methodExists(_loc3_))
            {
               this[_loc3_]();
            }
            else
            {
               this.handleShiftKeyRelated(param1.keyCode);
            }
         }
         if(param1.ctrlKey)
         {
            _loc3_ = "ctrl" + _loc2_;
            if(this.methodExists(_loc3_))
            {
               this[_loc3_]();
            }
            else
            {
               this.handleControlKeyRelated(param1.keyCode);
            }
         }
         if(param1.shiftKey && param1.ctrlKey)
         {
            this.handleControlShiftKeyRelated(param1.keyCode);
         }
      }
      
      private function traceOutAllRegisteredTemplateStructures() : void
      {
      }
      
      protected function methodExists(param1:String) : Boolean
      {
         var methodName:String = param1;
         this._describeType = this._describeType || describeType(this);
         return this._describeType.method.(@name == methodName).length() > 0;
      }
   }
}

