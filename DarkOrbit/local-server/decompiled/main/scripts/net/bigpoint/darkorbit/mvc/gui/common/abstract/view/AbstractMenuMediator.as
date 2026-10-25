package net.bigpoint.darkorbit.mvc.gui.common.abstract.view
{
   import com.bigpoint.utils.drag.DragEvent;
   import com.bigpoint.utils.drag.DragManager;
   import com.bigpoint.utils.ui.lists.layoutedList.IListLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.ListLayoutFactory;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.HorizontalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.HorizontalListLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.VerticalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.VerticallListLayout;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractLayoutedListBar;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.vo.AbstractMenuBarVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.SlotAndItemBarElement;
   
   public class AbstractMenuMediator extends DOAbstractMediator
   {
      
      protected var _menuBars:Vector.<DOAbstractLayoutedListBar>;
      
      protected var _menuBarsMap:Dictionary;
      
      protected var _swfFinisher:SWFFinisher;
      
      protected var _barsDragManager:DragManager;
      
      public function AbstractMenuMediator(param1:String, param2:Object)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         this._barsDragManager = new DragManager(viewComponent as DisplayObjectContainer);
         this.addListeners();
      }
      
      protected function initBarsMap() : void
      {
         throw new Error("invoke initBarsMap in AbstractMenuMediator");
      }
      
      protected function addListeners() : void
      {
         this.displayViewComponent.addEventListener(DOAbstractLayoutedListBar.BAR_DRAG_START,this.barDragStartHandler);
         this.displayViewComponent.addEventListener(DOAbstractLayoutedListBar.BAR_CHANGE_LAYOUT,this.barChangeLayout);
      }
      
      protected function barChangeLayout(param1:Event) : void
      {
         var _loc2_:DOAbstractLayoutedListBar = param1.target as DOAbstractLayoutedListBar;
         var _loc3_:AbstractMenuBarVO = this._menuBarsMap[_loc2_] as AbstractMenuBarVO;
         _loc3_.layoutId = this.getNextLayoutId(_loc3_.layoutId,_loc3_.id);
         var _loc4_:IListLayout = ListLayoutFactory.getLayout(_loc3_.layoutId);
         if(_loc4_.id == VerticalGridLayout.ID)
         {
            _loc4_.yOffset = 2;
         }
         _loc2_.layoutedList.setLayout(_loc4_,false,true,InGameCatalog.SOUND_ID_UI_SLOT_MOVE);
         var _loc5_:Number = _loc2_.layoutedList.items.length * 50 + 250;
         setTimeout(this.delaySetPos,_loc5_,_loc2_,_loc4_);
      }
      
      private function delaySetPos(param1:DOAbstractLayoutedListBar, param2:IListLayout) : void
      {
         var _loc3_:Point = param2.getItemPosition(SlotAndItemBarElement.DEFAULT_SIZE,param1.layoutedList.items.length);
         if(param2 is HorizontalListLayout || param2 is HorizontalGridLayout)
         {
            if(_loc3_.x > param1.layoutedList.listContainer.width)
            {
               _loc3_.x = param1.layoutedList.listContainer.width;
            }
         }
         if(param2 is VerticallListLayout)
         {
            _loc3_.x = param1.layoutedList.listContainer.width;
            _loc3_.y = 0;
         }
         param1.updateOnListLayoutChange(_loc3_);
      }
      
      protected function barDragStartHandler(param1:Event) : void
      {
         var _loc2_:DOAbstractLayoutedListBar = param1.target as DOAbstractLayoutedListBar;
         this._barsDragManager.startDrag(_loc2_,false);
         this._barsDragManager.addEventListener(DragEvent.DRAG_OVER,this.barDragOverHandler);
      }
      
      protected function barDragOverHandler(param1:DragEvent) : void
      {
         this._barsDragManager.removeEventListener(DragEvent.DRAG_OVER,this.barDragOverHandler);
      }
      
      protected function manageConfigMode(param1:Boolean) : void
      {
         this.updateLayoutButtonsVisibility(param1);
      }
      
      protected function updateLayoutButtonsVisibility(param1:Boolean) : void
      {
         var _loc2_:DOAbstractLayoutedListBar = null;
         for each(_loc2_ in this._menuBars)
         {
            setComponentVisibility(param1,_loc2_.dragButton);
            setComponentVisibility(param1,_loc2_.rotateButton);
         }
      }
      
      public function getMenuBarById(param1:String) : DOAbstractLayoutedListBar
      {
         var _loc2_:Object = null;
         var _loc3_:AbstractMenuBarVO = null;
         for(_loc2_ in this._menuBarsMap)
         {
            _loc3_ = this._menuBarsMap[_loc2_] as AbstractMenuBarVO;
            if(Boolean(_loc3_) && _loc3_.id == param1)
            {
               return _loc2_ as DOAbstractLayoutedListBar;
            }
         }
         return null;
      }
      
      protected function getNextLayoutId(param1:String, param2:String) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param2 == ItemsControlMenuConstants.PRO_ACTION_BAR)
         {
            _loc3_ = ItemsControlMenuConstants.LAYOUTS_QUEUE_PRO_ACTION.indexOf(param1);
            _loc4_ = _loc3_ < ItemsControlMenuConstants.LAYOUTS_QUEUE_PRO_ACTION.length - 1 ? int(_loc3_ + 1) : 0;
            return ItemsControlMenuConstants.LAYOUTS_QUEUE_PRO_ACTION[_loc4_];
         }
         _loc3_ = ItemsControlMenuConstants.LAYOUTS_QUEUE.indexOf(param1);
         _loc4_ = _loc3_ < ItemsControlMenuConstants.LAYOUTS_QUEUE.length - 1 ? int(_loc3_ + 1) : 0;
         return ItemsControlMenuConstants.LAYOUTS_QUEUE[_loc4_];
      }
      
      public function get menuBars() : Vector.<DOAbstractLayoutedListBar>
      {
         return this._menuBars;
      }
      
      public function get menuBarsMap() : Dictionary
      {
         return this._menuBarsMap;
      }
      
      private function get displayViewComponent() : DisplayObjectContainer
      {
         return viewComponent as DisplayObjectContainer;
      }
   }
}

