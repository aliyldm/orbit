package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.menuBar.actionButtons
{
   import com.bigpoint.utils.ui.buttons.ToggleButtonDecorator;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BuyButton extends ToggleButtonDecorator
   {
      
      public static const BUY_MODE_TOOGLE:String = "buyModeToogle";
      
      public function BuyButton(param1:DisplayObjectContainer)
      {
         super(param1);
         this.decorate();
      }
      
      override public function decorate() : void
      {
         super.decorate();
      }
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         toggle();
         dispatchEvent(new Event(BUY_MODE_TOOGLE,true));
      }
      
      override public function set selected(param1:Boolean) : void
      {
         setVisibility(_checked,selectedState);
         setVisibility(!_checked,background);
      }
   }
}

