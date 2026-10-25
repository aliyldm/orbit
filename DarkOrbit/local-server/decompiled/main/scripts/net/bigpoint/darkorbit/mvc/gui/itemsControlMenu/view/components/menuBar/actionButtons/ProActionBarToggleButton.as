package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.menuBar.actionButtons
{
   import com.bigpoint.utils.ui.buttons.StatesButtonDecorator;
   import com.bigpoint.utils.ui.buttons.ToggleButtonDecorator;
   import com.greensock.TweenMax;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   
   public class ProActionBarToggleButton extends ToggleButtonDecorator
   {
      
      public static const PRO_ACTION_BAR_TOGGLE:String = "proActionBarToggle";
      
      private static const CATEGORY_LINKAGE:String = "categoryElement";
      
      private static const MENU_BAR_LINKAGE:String = "menuBar";
      
      private static const CATEGORY_BTN_LINKAGE:String = "categoryBtn";
      
      private static const EXPAND_ICONS:String = "expandIcons";
      
      private static const COLLAPSE_ICONS:String = "collapseIcons";
      
      private static const EXPAND_ICONS_MASK:String = "expandIconsMask";
      
      private static const COLLAPSE_ICONS_MASK:String = "collapseIconsMask";
      
      public var expandIcons:StatesButtonDecorator;
      
      public var collapseIcons:StatesButtonDecorator;
      
      public var expandIconsMask:Sprite;
      
      public var collapseIconsMask:Sprite;
      
      protected var _activeIconsSet:StatesButtonDecorator;
      
      private var _finisher:SWFFinisher;
      
      private var _backgroundButton:StatesButtonDecorator;
      
      public function ProActionBarToggleButton(param1:SWFFinisher)
      {
         this._finisher = param1;
         var _loc2_:DisplayObjectContainer = (param1.getEmbeddedObject(MENU_BAR_LINKAGE) as DisplayObjectContainer).getChildByName(CATEGORY_BTN_LINKAGE) as DisplayObjectContainer;
         super(_loc2_);
      }
      
      override public function decorate() : void
      {
         super.decorate();
         addViewChild(this._backgroundButton = new StatesButtonDecorator(this._finisher.getEmbeddedObject(CATEGORY_LINKAGE) as DisplayObjectContainer));
         this._backgroundButton.width *= 0.8;
         this._backgroundButton.height *= 0.8;
         this._backgroundButton.x = -this._backgroundButton.width / 2;
         this._backgroundButton.y = -this._backgroundButton.height / 2;
         addViewChild(this.expandIcons = new StatesButtonDecorator(getSpriteChild(EXPAND_ICONS)));
         addViewChild(this.collapseIcons = new StatesButtonDecorator(getSpriteChild(COLLAPSE_ICONS)));
         addViewChild(this.expandIconsMask = getSpriteChild(EXPAND_ICONS_MASK));
         addViewChild(this.collapseIconsMask = getSpriteChild(COLLAPSE_ICONS_MASK));
         this.expandIcons.mask = this.expandIconsMask;
         this.collapseIcons.mask = this.collapseIconsMask;
         this.updateIcons();
         super.toggle();
      }
      
      override public function set selected(param1:Boolean) : void
      {
         this.updateIcons();
         this._backgroundButton.selected = param1;
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
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         super.clickHandler(param1);
      }
      
      override public function rollHandler(param1:MouseEvent) : void
      {
         super.rollHandler(param1);
         this._backgroundButton.rollHandler(param1);
         this._activeIconsSet.rollHandler(param1);
      }
      
      override public function mouseUpDownHandler(param1:MouseEvent) : void
      {
         super.mouseUpDownHandler(param1);
         this._backgroundButton.mouseUpDownHandler(param1);
         this._activeIconsSet.mouseUpDownHandler(param1);
      }
      
      override public function toggle() : void
      {
         super.toggle();
         setVisibility(false,mouseDownState,0.1);
         setVisibility(false,rollOverState,0.5);
         setVisibility(false,this._activeIconsSet.mouseDownState,0);
         dispatchEvent(new Event(PRO_ACTION_BAR_TOGGLE,true));
      }
   }
}

