package net.bigpoint.darkorbit.fui.system.manager
{
   import net.bigpoint.darkorbit.fui.components.core.interfaces.IFocusable;
   import net.bigpoint.darkorbit.fui.components.window.IWindow;
   
   public class FocusManager implements IFocusManager
   {
      
      private var _currentFocusedWindow:IWindow;
      
      private var _currentFocusedComponent:Object;
      
      public function FocusManager()
      {
         super();
      }
      
      public function setWindowFocus(param1:IWindow) : void
      {
         if(param1 != this._currentFocusedWindow)
         {
            this._unfocusInstance(this._currentFocusedWindow);
            this._currentFocusedWindow = param1;
            this._focusInstance(this._currentFocusedWindow);
         }
      }
      
      public function getFocusedWindow() : IWindow
      {
         return this._currentFocusedWindow;
      }
      
      public function setComponentFocus(param1:Object) : void
      {
         if(param1 != this._currentFocusedComponent)
         {
            this._unfocusInstance(this._currentFocusedComponent);
            this._currentFocusedComponent = param1;
            this._focusInstance(this._currentFocusedComponent);
         }
      }
      
      public function getFocusedComponent() : Object
      {
         return this._currentFocusedComponent;
      }
      
      protected function _focusInstance(param1:Object) : void
      {
         var _loc2_:IFocusable = param1 as IFocusable;
         if(_loc2_)
         {
            _loc2_.setFocus();
         }
      }
      
      protected function _unfocusInstance(param1:Object) : void
      {
         var _loc2_:IFocusable = param1 as IFocusable;
         if(_loc2_)
         {
            _loc2_.unfocus();
         }
      }
   }
}

