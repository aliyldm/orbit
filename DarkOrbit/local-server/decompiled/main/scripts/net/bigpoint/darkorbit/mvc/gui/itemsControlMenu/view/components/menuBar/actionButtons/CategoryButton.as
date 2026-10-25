package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.menuBar.actionButtons
{
   import com.bigpoint.utils.ui.buttons.StatesButtonDecorator;
   import com.bigpoint.utils.ui.buttons.ToggleButtonDecorator;
   import com.greensock.TweenMax;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CategoryButton extends ToggleButtonDecorator
   {
      
      public static const CATEGORY_TOOGLE:String = "categoryToogle";
      
      private static const EXPAND_ICONS:String = "expandIcons";
      
      private static const COLLAPSE_ICONS:String = "collapseIcons";
      
      private static const EXPAND_ICONS_MASK:String = "expandIconsMask";
      
      private static const COLLAPSE_ICONS_MASK:String = "collapseIconsMask";
      
      public var expandIcons:StatesButtonDecorator;
      
      public var collapseIcons:StatesButtonDecorator;
      
      public var expandIconsMask:Sprite;
      
      public var collapseIconsMask:Sprite;
      
      protected var _activeIconsSet:StatesButtonDecorator;
      
      public function CategoryButton(param1:DisplayObjectContainer)
      {
         super(param1);
      }
      
      override public function decorate() : void
      {
         super.decorate();
         addViewChild(this.expandIcons = new StatesButtonDecorator(getSpriteChild(EXPAND_ICONS)));
         addViewChild(this.collapseIcons = new StatesButtonDecorator(getSpriteChild(COLLAPSE_ICONS)));
         addViewChild(this.expandIconsMask = getSpriteChild(EXPAND_ICONS_MASK));
         addViewChild(this.collapseIconsMask = getSpriteChild(COLLAPSE_ICONS_MASK));
         this.expandIcons.mask = this.expandIconsMask;
         this.collapseIcons.mask = this.collapseIconsMask;
         this.updateIcons();
      }
      
      override public function set selected(param1:Boolean) : void
      {
         this.updateIcons();
         if(param1)
         {
            setVisibility(false,rollOverState,0);
            setVisibility(true,mouseDownState,0);
            setVisibility(!_checked,this._activeIconsSet.rollOverState,0);
         }
      }
      
      private function updateIcons() : void
      {
         this._activeIconsSet = _checked ? this.collapseIcons : this.expandIcons;
         setVisibility(_checked,this._activeIconsSet.mouseDownState,0);
         if(_checked)
         {
            TweenMax.to(this.collapseIcons,0.5,{
               "y":-11,
               "alpha":1
            });
            TweenMax.to(this.expandIcons,0.5,{
               "y":0,
               "alpha":0
            });
         }
         else
         {
            TweenMax.to(this.collapseIcons,0.5,{
               "y":-22,
               "alpha":0
            });
            TweenMax.to(this.expandIcons,0.5,{
               "y":-11,
               "alpha":1
            });
         }
      }
      
      override public function rollHandler(param1:MouseEvent) : void
      {
         super.rollHandler(param1);
         this._activeIconsSet.rollHandler(param1);
      }
      
      override public function mouseUpDownHandler(param1:MouseEvent) : void
      {
         super.mouseUpDownHandler(param1);
         this._activeIconsSet.mouseUpDownHandler(param1);
      }
      
      override public function toggle() : void
      {
         super.toggle();
         setVisibility(false,mouseDownState,0.1);
         setVisibility(false,rollOverState,0.5);
         setVisibility(false,this._activeIconsSet.mouseDownState,0);
         dispatchEvent(new Event(CATEGORY_TOOGLE,true));
      }
   }
}

