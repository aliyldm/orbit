package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements
{
   import com.bigpoint.utils.drag.IDraggable;
   import com.bigpoint.utils.drag.IDropable;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.gui.BitmapFont;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractComponentInstance;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.ItemVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.SlotAndItemBarElement;
   
   public class Slot extends DOAbstractComponentInstance implements IDropable
   {
      
      public static const MARGIN:int = 2;
      
      private static const LINKAGE:String = "slot";
      
      private static const EMPTY:String = "empty";
      
      private static const EQUIPPED:String = "equipped";
      
      private static const BACKGROUND:String = "background";
      
      private static const BRIGHT_BACKGROUND:String = "brightBackground";
      
      private static const ITEM_CONTAINER:String = "itemContainer";
      
      private static const DRAG_ACCEPT_STATE:String = "dragAcceptState";
      
      private static const SLOT_NR_FONT_CONTAINER:String = "slotNrFontContainer";
      
      public var background:Sprite;
      
      public var brightBackground:Sprite;
      
      public var itemContainer:Sprite;
      
      public var dragAcceptState:Sprite;
      
      public var slotNrFont:BitmapFont;
      
      public var slotNrFontContainer:Sprite;
      
      private var _state:String = "empty";
      
      public function Slot(param1:SWFFinisher, param2:int)
      {
         super(param1,this.symbolLinkage);
         this.updateLayout();
         alpha = 0.3;
         setVisibility(false,this.dragAcceptState,0);
         setVisibility(false,this.brightBackground,0);
         this.slotNrFont.setText(String(param2));
         TweenMax.to(this.slotNrFont,0,{"colorMatrixFilter":{"colorize":ItemsControlMenuConstants.STYLE_BLUE_BRIGHT}});
         alpha = 0.5;
         this.background.mouseEnabled = this.background.mouseChildren = false;
         mouseEnabled = false;
      }
      
      override public function decorate() : void
      {
         addViewChild(this.background = getSpriteChild(BACKGROUND));
         addViewChild(this.brightBackground = getSpriteChild(BRIGHT_BACKGROUND));
         addViewChild(this.itemContainer = getSpriteChild(ITEM_CONTAINER));
         addViewChild(this.dragAcceptState = getSpriteChild(DRAG_ACCEPT_STATE));
         addViewChild(this.slotNrFontContainer = getSpriteChild(SLOT_NR_FONT_CONTAINER));
         this.slotNrFontContainer.addChild(this.slotNrFont = new BitmapFont());
      }
      
      public function set itemElement(param1:SlotAndItemBarElement) : void
      {
         clear(this.itemContainer);
         this.itemContainer.addChild(param1);
         alpha = 1;
         this._state = EQUIPPED;
      }
      
      public function isDraggingItemAcceptable(param1:IDraggable) : Boolean
      {
         return param1.data is ItemVO;
      }
      
      public function setAcceptedDragItem(param1:IDraggable) : void
      {
      }
      
      public function showAcceptableState(param1:IDraggable) : void
      {
         setVisibility(true,this.dragAcceptState);
      }
      
      public function hideAcceptableState(param1:IDraggable) : void
      {
         setVisibility(false,this.dragAcceptState);
      }
      
      override public function updateLayout() : void
      {
      }
      
      override public function get symbolLinkage() : String
      {
         return LINKAGE;
      }
      
      public function set highlighted(param1:Boolean) : void
      {
         setVisibility(param1,this.brightBackground);
         if(this._state == EMPTY)
         {
            TweenLite.to(this,0.3,{"alpha":(param1 ? 1 : 0.3)});
         }
      }
      
      public function get asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

