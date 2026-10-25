package net.bigpoint.darkorbit.mvc.abstract.view.components
{
   import com.bigpoint.utils.drag.IDragablePreview;
   import com.bigpoint.utils.drag.IDraggable;
   import com.bigpoint.utils.ui.buttons.StatesButtonDecorator;
   import com.bigpoint.utils.ui.lists.layoutedList.IListLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.LayoutedListDecorator;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo.slotBar.SlotBarVO;
   
   public class DOAbstractLayoutedListBar extends DOAbstractComponentDecorator implements IDraggable
   {
      
      public static const BAR_DRAG_START:String = "barDragStart";
      
      public static const BAR_DRAG_STOP:String = "barDragStop";
      
      public static const BAR_CHANGE_LAYOUT:String = "barChangeLayout";
      
      public static const SLOTS_GAP:int = 1;
      
      private static const ARROW_LIST:String = "arrowList";
      
      private static const ROTATE_BUTTON:String = "rotateButton";
      
      private static const DRAG_BUTTON:String = "dragButton";
      
      protected static const RIGHT_CATEGORY_BTN_OFFSET:Point = new Point(13,21);
      
      protected static const RIGHT_CONFIG_BTNS_OFFSET:Point = new Point(13,12);
      
      public static const RIGHT_BUTTONS_ALIGMENT:String = "rightButtonsAligment";
      
      public static const LEFT_BUTTONS_ALIGMENT:String = "leftButtonsAligment";
      
      public var layoutedList:LayoutedListDecorator;
      
      public var rotateButton:StatesButtonDecorator;
      
      public var dragButton:StatesButtonDecorator;
      
      private var _isPremium:Boolean = false;
      
      public function DOAbstractLayoutedListBar(param1:DisplayObjectContainer, param2:Boolean)
      {
         super(param1);
         this._isPremium = param2;
         setVisibility(false,this.rotateButton,0);
         setVisibility(false,this.dragButton,0);
         this.addListeners();
         this.mouseEnabled = false;
      }
      
      override public function decorate() : void
      {
         addViewChild(this.layoutedList = new LayoutedListDecorator(getSpriteChild(ARROW_LIST)));
         addViewChild(this.rotateButton = new StatesButtonDecorator(getSpriteChild(ROTATE_BUTTON)));
         addViewChild(this.dragButton = new StatesButtonDecorator(getSpriteChild(DRAG_BUTTON)));
      }
      
      private function addListeners() : void
      {
         this.dragButton.addEventListener(MouseEvent.MOUSE_DOWN,this.dragButtonMouseDownHandler);
         this.dragButton.addEventListener(MouseEvent.MOUSE_UP,this.dragButtonMouseUpHandler);
         this.rotateButton.addEventListener(MouseEvent.CLICK,this.rotateButtonClickHandler);
      }
      
      private function rotateButtonClickHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(BAR_CHANGE_LAYOUT,true));
      }
      
      private function dragButtonMouseDownHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(BAR_DRAG_START,true));
      }
      
      private function dragButtonMouseUpHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(BAR_DRAG_STOP,true));
      }
      
      public function showItems(param1:Array, param2:int, param3:int = 50, param4:Boolean = false, param5:SlotBarVO = null, param6:IListLayout = null, param7:int = 0) : void
      {
         this.layoutedList.showItems(param1,param2,param3,param6,param4,param7);
         updateLayout();
      }
      
      public function updateDragButtonPos() : void
      {
         this.dragButton.y = this.layoutedList.height / 2;
      }
      
      public function updateOnListLayoutChange(param1:Point, param2:Boolean = true) : void
      {
      }
      
      public function get dragOffset() : Point
      {
         return null;
      }
      
      public function get preview() : IDragablePreview
      {
         return null;
      }
      
      public function get data() : Object
      {
         return null;
      }
      
      public function get asDisplayObject() : DisplayObject
      {
         return null;
      }
      
      public function get realBounds() : Rectangle
      {
         return new Rectangle(x - this.leftOffset,y - this.topOffset,this.boundsWidth,this.boundsHeight);
      }
      
      public function get boundsWidth() : int
      {
         return 0;
      }
      
      public function get realWidthForPosCalculation() : int
      {
         return 0;
      }
      
      public function get boundsHeight() : int
      {
         return height;
      }
      
      public function get leftOffset() : int
      {
         return 0;
      }
      
      public function get topOffset() : int
      {
         return 0;
      }
      
      public function get rightOffset() : int
      {
         return 0;
      }
      
      public function get bottomOffset() : int
      {
         return 0;
      }
      
      public function get realWidth() : int
      {
         return 0;
      }
      
      public function get realHeight() : int
      {
         return height;
      }
      
      public function get listLayoutId() : String
      {
         if(this.layoutedList)
         {
            return this.layoutedList.layout.id;
         }
         return null;
      }
      
      override public function set mouseEnabled(param1:Boolean) : void
      {
         super.mouseEnabled = param1;
         this.layoutedList.mouseEnabled = param1;
         this.layoutedList.listContainer.mouseEnabled = param1;
      }
      
      public function get isPremium() : Boolean
      {
         return this._isPremium;
      }
   }
}

