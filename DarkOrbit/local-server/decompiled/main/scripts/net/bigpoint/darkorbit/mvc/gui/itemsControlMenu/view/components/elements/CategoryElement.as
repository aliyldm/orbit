package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements
{
   import com.bigpoint.utils.ui.buttons.ImagesStatesButton;
   import com.bigpoint.utils.ui.buttons.StatesButtonDecorator;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.SlotAndItemBarElement;
   
   public class CategoryElement extends StatesButtonDecorator
   {
      
      private static const LINKAGE:String = "categoryElement";
      
      public static const MARGIN:int = 2;
      
      public static const CATEGORY_CLICKED:String = "categoryClicked";
      
      private static const ICONS_STATES:String = "iconsStates";
      
      protected var _normalIconBitmapData:BitmapData;
      
      protected var _hoverIconBitmapData:BitmapData;
      
      protected var _selectIconBitmapData:BitmapData;
      
      public var iconsStates:ImagesStatesButton;
      
      public function CategoryElement(param1:SWFFinisher, param2:String, param3:BitmapData, param4:BitmapData, param5:BitmapData)
      {
         this._normalIconBitmapData = param3;
         this._hoverIconBitmapData = param4;
         this._selectIconBitmapData = param5;
         super(param1.getEmbeddedObject(this.symbolLinkage) as DisplayObjectContainer);
         if(param2)
         {
            tooltipManager.addToolTip(this,param2,true);
         }
         this.updateLayout();
      }
      
      override public function decorate() : void
      {
         super.decorate();
         addViewChild(this.iconsStates = new ImagesStatesButton(getSpriteChild(ICONS_STATES),this._normalIconBitmapData,this._hoverIconBitmapData,this._selectIconBitmapData));
      }
      
      override public function rollHandler(param1:MouseEvent) : void
      {
         super.rollHandler(param1);
         this.iconsStates.rollHandler(param1);
      }
      
      override public function mouseUpDownHandler(param1:MouseEvent) : void
      {
         super.mouseUpDownHandler(param1);
         this.iconsStates.mouseUpDownHandler(param1);
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
         this.iconsStates.selected = param1;
      }
      
      override public function updateLayout() : void
      {
         this.iconsStates.x = SlotAndItemBarElement.DEFAULT_SIZE - this.iconsStates.width >> 1;
         this.iconsStates.y = SlotAndItemBarElement.DEFAULT_SIZE - this.iconsStates.height >> 1;
      }
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(CATEGORY_CLICKED,true));
      }
      
      override public function get symbolLinkage() : String
      {
         return LINKAGE;
      }
   }
}

