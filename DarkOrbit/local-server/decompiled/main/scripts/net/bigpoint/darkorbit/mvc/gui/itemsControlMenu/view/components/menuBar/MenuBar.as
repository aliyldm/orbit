package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.menuBar
{
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.HorizontalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.HorizontalListLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.ProActionHorizontalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.ProActionVerticalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.VerticalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.VerticallListLayout;
   import com.greensock.TweenMax;
   import com.greensock.easing.Expo;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractLayoutedListBar;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.SlotAndItemBarElement;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.menuBar.actionButtons.CategoryButton;
   
   public class MenuBar extends DOAbstractLayoutedListBar
   {
      
      private static const LINKAGE:String = "menuBar";
      
      public static const DEFAULT_BAR_WIDTH:int = 390;
      
      private static const CATEGORY_BTN:String = "categoryBtn";
      
      public var categoryBtn:CategoryButton;
      
      public function MenuBar(param1:SWFFinisher, param2:Boolean)
      {
         _swfFinisher = param1;
         super(_swfFinisher.getEmbeddedObject(this.symbolLinkage) as DisplayObjectContainer,param2);
         this.categoryBtn.visible = false;
      }
      
      override public function decorate() : void
      {
         super.decorate();
         addViewChild(this.categoryBtn = new CategoryButton(getSpriteChild(CATEGORY_BTN)));
      }
      
      override public function updateLayout() : void
      {
         layoutedList.leftArrow.visible = layoutedList.rightArrow.visible = layoutedList.items.length > ItemsControlMenuConstants.MAX_ITEMS_ON_LIST;
      }
      
      override public function updateOnListLayoutChange(param1:Point, param2:Boolean = true) : void
      {
         if(this.categoryBtn)
         {
            TweenMax.to(this.categoryBtn,param2 ? 1 : 0,{
               "x":param1.x + RIGHT_CATEGORY_BTN_OFFSET.x,
               "y":param1.y + RIGHT_CATEGORY_BTN_OFFSET.y,
               "ease":Expo.easeOut
            });
         }
      }
      
      override public function get boundsWidth() : int
      {
         var _loc1_:int = 0;
         if(layoutedList.layout)
         {
            switch(layoutedList.layout.id)
            {
               case HorizontalListLayout.ID:
                  _loc1_ = this.leftOffset + DEFAULT_BAR_WIDTH + this.rightOffset;
                  break;
               case HorizontalGridLayout.ID:
                  _loc1_ = this.leftOffset + 4 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
                  break;
               case VerticallListLayout.ID:
                  _loc1_ = this.leftOffset + SlotAndItemBarElement.DEFAULT_SIZE;
                  break;
               case VerticalGridLayout.ID:
                  _loc1_ = this.leftOffset + 2 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
                  break;
               case ProActionHorizontalGridLayout.ID:
                  _loc1_ = this.leftOffset + 5 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
                  break;
               case ProActionVerticalGridLayout.ID:
                  _loc1_ = this.leftOffset + 3 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
            }
         }
         return _loc1_;
      }
      
      override public function get boundsHeight() : int
      {
         var _loc1_:int = 0;
         switch(layoutedList.layout.id)
         {
            case HorizontalListLayout.ID:
               _loc1_ = SlotAndItemBarElement.DEFAULT_SIZE;
               break;
            case HorizontalGridLayout.ID:
               _loc1_ = 3 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
               break;
            case VerticallListLayout.ID:
               _loc1_ = DEFAULT_BAR_WIDTH + this.bottomOffset;
               break;
            case VerticalGridLayout.ID:
               _loc1_ = 4 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP) + this.bottomOffset;
               break;
            case ProActionHorizontalGridLayout.ID:
               _loc1_ = 3 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
               break;
            case ProActionVerticalGridLayout.ID:
               _loc1_ = 5 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP) + this.bottomOffset;
         }
         return _loc1_;
      }
      
      override public function get realWidth() : int
      {
         var _loc1_:int = 0;
         if(layoutedList.layout)
         {
            switch(layoutedList.layout.id)
            {
               case HorizontalListLayout.ID:
                  _loc1_ = DEFAULT_BAR_WIDTH;
                  break;
               case HorizontalGridLayout.ID:
                  _loc1_ = this.leftOffset + 4 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
                  break;
               case VerticallListLayout.ID:
                  _loc1_ = this.leftOffset + SlotAndItemBarElement.DEFAULT_SIZE;
                  break;
               case VerticalGridLayout.ID:
                  _loc1_ = this.leftOffset + 2 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
                  break;
               case ProActionHorizontalGridLayout.ID:
                  _loc1_ = this.leftOffset + 5 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
                  break;
               case ProActionVerticalGridLayout.ID:
                  _loc1_ = this.leftOffset + 3 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
            }
         }
         return _loc1_;
      }
      
      override public function get realHeight() : int
      {
         var _loc1_:int = 0;
         switch(layoutedList.layout.id)
         {
            case HorizontalListLayout.ID:
               _loc1_ = SlotAndItemBarElement.DEFAULT_SIZE;
               break;
            case HorizontalGridLayout.ID:
               _loc1_ = 3 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
               break;
            case VerticallListLayout.ID:
               _loc1_ = DEFAULT_BAR_WIDTH;
               break;
            case VerticalGridLayout.ID:
               _loc1_ = 4 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
               break;
            case ProActionHorizontalGridLayout.ID:
               _loc1_ = 3 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
               break;
            case ProActionVerticalGridLayout.ID:
               _loc1_ = 5 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP);
         }
         return _loc1_;
      }
      
      override public function get symbolLinkage() : String
      {
         return LINKAGE;
      }
      
      override public function get height() : Number
      {
         return SlotAndItemBarElement.DEFAULT_SIZE;
      }
      
      override public function get leftOffset() : int
      {
         return (dragButton.x - dragButton.width / 2) * -1;
      }
      
      override public function get topOffset() : int
      {
         return layoutedList.layout.id == HorizontalGridLayout.ID ? SlotAndItemBarElement.DEFAULT_SIZE : 0;
      }
      
      override public function get rightOffset() : int
      {
         return this.categoryBtn.visible ? int(this.categoryBtn.width + 5) : 5;
      }
      
      override public function get bottomOffset() : int
      {
         var _loc1_:int = 0;
         switch(layoutedList.layout.id)
         {
            case VerticallListLayout.ID:
               _loc1_ = this.categoryBtn.visible ? int(this.categoryBtn.height) : 0;
               break;
            case VerticalGridLayout.ID:
               _loc1_ = this.categoryBtn.visible ? int(this.categoryBtn.height / 2) : 0;
         }
         return _loc1_;
      }
      
      override public function get asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      override public function get dragOffset() : Point
      {
         return new Point(-dragButton.x,-dragButton.y);
      }
      
      public function get isAvailable() : Boolean
      {
         return isPremium ? Hero.premium.value : true;
      }
   }
}

