package net.bigpoint.darkorbit.gui.windows.simpleWindow.animate
{
   public class SimpleWindowAbstractAnimator
   {
      
      protected var _UIElements:SimpleWindowUIElementsAccessor;
      
      public function SimpleWindowAbstractAnimator()
      {
         super();
      }
      
      public function set UIElementAccesor(param1:SimpleWindowUIElementsAccessor) : void
      {
         this._UIElements = param1;
      }
      
      protected function get UIElements() : SimpleWindowUIElementsAccessor
      {
         return this._UIElements;
      }
   }
}

