package net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.components
{
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.HorizontalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.HorizontalListLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.VerticalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.VerticallListLayout;
   import com.greensock.TweenMax;
   import com.greensock.easing.Expo;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractLayoutedListBar;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.SlotAndItemBarElement;
   
   public class FeatureBar extends DOAbstractLayoutedListBar
   {
      
      private static const LINKAGE:String = "menuBar";
      
      public static const DEFAULT_WIDTH:int = 390;
      
      private var _layoutType:String;
      
      public function FeatureBar(param1:DisplayObjectContainer, param2:String, param3:Boolean)
      {
         super(param1,param3);
         this._layoutType = param2;
      }
      
      override public function decorate() : void
      {
         super.decorate();
      }
      
      override public function updateLayout() : void
      {
         layoutedList.leftArrow.x = layoutedList.leftArrow.y = 0;
         layoutedList.leftArrow.visible = layoutedList.rightArrow.visible = false;
         if(this._layoutType == RIGHT_BUTTONS_ALIGMENT)
         {
            this.updateOnListLayoutChange(new Point(layoutedList.listContainer.width,0),false);
         }
      }
      
      override public function updateOnListLayoutChange(param1:Point, param2:Boolean = true) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this._layoutType == RIGHT_BUTTONS_ALIGMENT)
         {
            _loc3_ = param1.x + RIGHT_CONFIG_BTNS_OFFSET.x;
            _loc4_ = param1.y + RIGHT_CONFIG_BTNS_OFFSET.y;
            TweenMax.to(dragButton,param2 ? 1 : 0,{
               "x":_loc3_,
               "y":_loc4_,
               "ease":Expo.easeOut,
               "onUpdate":this.updateChangeLayoutBtnPos
            });
         }
      }
      
      private function updateChangeLayoutBtnPos() : void
      {
         rotateButton.x = dragButton.x + dragButton.width + 1;
         rotateButton.y = dragButton.y;
      }
      
      override public function get realWidth() : int
      {
         var _loc1_:int = 0;
         switch(layoutedList.layout.id)
         {
            case HorizontalListLayout.ID:
               _loc1_ = this._layoutType == RIGHT_BUTTONS_ALIGMENT ? int(rotateButton.x + rotateButton.width / 2) : layoutedList.listWidth;
               break;
            case HorizontalGridLayout.ID:
               _loc1_ = layoutedList.listWidth + SLOTS_GAP;
               break;
            case VerticallListLayout.ID:
               _loc1_ = SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP;
               break;
            case VerticalGridLayout.ID:
               _loc1_ = 2 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
         }
         return _loc1_;
      }
      
      override public function get realHeight() : int
      {
         return layoutedList.height;
      }
      
      override public function get boundsWidth() : int
      {
         var _loc1_:int = 0;
         switch(layoutedList.layout.id)
         {
            case HorizontalGridLayout.ID:
               _loc1_ = this._layoutType == RIGHT_BUTTONS_ALIGMENT ? int(rotateButton.x + rotateButton.width / 2 + SLOTS_GAP) : int(layoutedList.listWidth + this.leftOffset + SLOTS_GAP);
               break;
            case HorizontalListLayout.ID:
            case VerticallListLayout.ID:
               _loc1_ = this._layoutType == RIGHT_BUTTONS_ALIGMENT ? int(rotateButton.x + rotateButton.width / 2) : int(layoutedList.listWidth + this.leftOffset + SLOTS_GAP);
               break;
            case VerticalGridLayout.ID:
               _loc1_ = 3 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP) + SLOTS_GAP;
         }
         return _loc1_;
      }
      
      override public function get boundsHeight() : int
      {
         var _loc1_:int = 0;
         switch(layoutedList.layout.id)
         {
            case HorizontalListLayout.ID:
               _loc1_ = SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP;
               break;
            case HorizontalGridLayout.ID:
               _loc1_ = 3 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
               break;
            case VerticallListLayout.ID:
               _loc1_ = this._layoutType == RIGHT_BUTTONS_ALIGMENT ? int(rotateButton.y + rotateButton.height / 2) : int(layoutedList.height);
               break;
            case VerticalGridLayout.ID:
               _loc1_ = layoutedList.listContainer.height;
         }
         return _loc1_;
      }
      
      override public function get leftOffset() : int
      {
         var _loc1_:Number = NaN;
         switch(layoutedList.layout.id)
         {
            case HorizontalListLayout.ID:
            case HorizontalGridLayout.ID:
            case VerticallListLayout.ID:
               _loc1_ = this._layoutType == RIGHT_BUTTONS_ALIGMENT ? SLOTS_GAP : (dragButton.x - dragButton.width / 2) * -1;
               break;
            case VerticalGridLayout.ID:
               _loc1_ = SlotAndItemBarElement.DEFAULT_SIZE;
         }
         return _loc1_;
      }
      
      override public function get topOffset() : int
      {
         return layoutedList.layout.id == HorizontalGridLayout.ID ? SlotAndItemBarElement.DEFAULT_SIZE : -1;
      }
      
      override public function get rightOffset() : int
      {
         return SLOTS_GAP;
      }
      
      override public function get bottomOffset() : int
      {
         return SLOTS_GAP;
      }
      
      override public function get asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      override public function get dragOffset() : Point
      {
         return new Point(-dragButton.x,-dragButton.y);
      }
      
      override public function get symbolLinkage() : String
      {
         return LINKAGE;
      }
      
      override public function get height() : Number
      {
         return SlotAndItemBarElement.DEFAULT_SIZE;
      }
   }
}

