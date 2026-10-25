package net.bigpoint.darkorbit.fui.components.list.combobox
{
   import com.greensock.TweenLite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.xml.XMLBasedUIBuilder;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBox;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.ICollection;
   import net.bigpoint.darkorbit.fui.components.list.IList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.system.manager.IPopUpManager;
   
   public class ComboBox extends CheckBox implements IList
   {
      
      private static const ITEMLIST_INSTANCE_NAME:String = "itemlist";
      
      private static const SCROLLBAR_INSTANCE_NAME:String = "scrollbar";
      
      private var _popupManager:IPopUpManager;
      
      private var _popupContainer:Container;
      
      private var _popupOffsetX:Number = 0;
      
      private var _popupOffsetY:Number = 0;
      
      private var _popupContainerCreated:Boolean = false;
      
      private var _itemList:ItemList;
      
      private var _scrollbar:Scrollbar;
      
      private var _popupTemplateID:String;
      
      private var _showPopupTweenParams:Object;
      
      private var _showPopupTweenDuration:Number;
      
      private var _hidePopupTweenParams:Object;
      
      private var _hidePopupTweenDuration:Number;
      
      private var _closeListOnSelection:Boolean;
      
      public function ComboBox()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this._popupContainer = new Container();
         this._popupManager = UISystem.getInstance().popupManager;
         this.setShowPopupTweenParams(0.3,{"alpha":1});
         this.setHidePopupTweenParams(0.3,{"alpha":0});
         this.closeListOnSelection = false;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._popupContainer)
         {
            this._popupContainer.dispose();
            this._popupContainer = null;
         }
         if(this._itemList)
         {
            this._itemList.dispose();
            this._itemList = null;
         }
         if(this._scrollbar)
         {
            this._scrollbar.dispose();
            this._scrollbar = null;
         }
         this._popupManager = null;
      }
      
      override protected function drawSelectionState() : void
      {
         if(_skin)
         {
            setSkinState(_currentSkinState);
         }
         if(_selectionState == SELECTED)
         {
            if(!this._popupContainerCreated)
            {
               this.createPopup();
               this._popupContainerCreated = true;
            }
            this.showPopupContainer();
            UISystem.getInstance().stage.addEventListener(MouseEvent.CLICK,this.handleStageClickEvent);
         }
         else
         {
            UISystem.getInstance().stage.removeEventListener(MouseEvent.CLICK,this.handleStageClickEvent);
            this.hidePopContainer();
         }
      }
      
      protected function handleStageClickEvent(param1:MouseEvent) : void
      {
         selection = false;
      }
      
      protected function showPopupContainer() : void
      {
         this.updatePopupPosition();
         this._popupManager.add(this._popupContainer);
         this._popupContainer.forceRedraw(InvalidationType.POSITION);
         dispatchEvent(new ComboBoxEvent(ComboBoxEvent.POPUP_SHOW));
         TweenLite.to(this.popupContainer,this._showPopupTweenDuration,this._showPopupTweenParams);
      }
      
      public function setShowPopupTweenParams(param1:Number, param2:Object) : void
      {
         this._showPopupTweenDuration = param1;
         this._showPopupTweenParams = param2;
         this._showPopupTweenParams.onComplete = this.showPopContainerFinished;
      }
      
      protected function showPopContainerFinished() : void
      {
      }
      
      public function setHidePopupTweenParams(param1:Number, param2:Object) : void
      {
         this._hidePopupTweenDuration = param1;
         this._hidePopupTweenParams = param2;
         this._hidePopupTweenParams.onComplete = this.hidePopContainerFinished;
      }
      
      protected function hidePopContainer() : void
      {
         dispatchEvent(new ComboBoxEvent(ComboBoxEvent.POPUP_HIDE));
         TweenLite.to(this.popupContainer,this._hidePopupTweenDuration,this._hidePopupTweenParams);
      }
      
      protected function hidePopContainerFinished() : void
      {
         this._popupManager.remove(this._popupContainer);
      }
      
      override public function get globalPosition() : Point
      {
         var _loc1_:Point = super.globalPosition;
         _loc1_.x += this._popupOffsetX;
         _loc1_.y += this._popupOffsetY;
         return _loc1_;
      }
      
      public function set closeListOnSelection(param1:Boolean) : void
      {
         this._closeListOnSelection = param1;
         if(!this._closeListOnSelection)
         {
            this._popupContainer.addEventListener(MouseEvent.CLICK,this.killMouseEventPropagation);
         }
         else
         {
            this._popupContainer.removeEventListener(MouseEvent.CLICK,this.killMouseEventPropagation);
         }
      }
      
      protected function killMouseEventPropagation(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      public function get closeListOnSelection() : Boolean
      {
         return this._closeListOnSelection;
      }
      
      public function set list(param1:ICollection) : void
      {
         if(this._itemList)
         {
            this._itemList.list = param1;
         }
      }
      
      public function get list() : ICollection
      {
         if(this._itemList == null)
         {
            return null;
         }
         return this._itemList.list;
      }
      
      public function set popupTemplate(param1:String) : void
      {
         this._popupTemplateID = param1;
      }
      
      protected function createPopup() : void
      {
         UISystem.getInstance().buildByTemplate(this._popupTemplateID,this._popupContainer,XMLBasedUIBuilder.TYPE,true);
         TweenLite.to(this.popupContainer,0,this._hidePopupTweenParams);
         this.prepareItemList();
         this.prepareScrollbar();
         dispatchEvent(new ComboBoxEvent(ComboBoxEvent.POPUP_CREATED));
      }
      
      protected function prepareItemList() : void
      {
         this._itemList = this._popupContainer.getChildByName(ITEMLIST_INSTANCE_NAME) as ItemList;
      }
      
      protected function prepareScrollbar() : void
      {
         this._scrollbar = this._popupContainer.getChildByName(SCROLLBAR_INSTANCE_NAME) as Scrollbar;
      }
      
      public function get popupContainer() : Container
      {
         return this._popupContainer;
      }
      
      public function updatePopupPosition() : void
      {
         this._popupContainer.x = this.globalPosition.x;
         this._popupContainer.y = this.globalPosition.y;
      }
      
      public function set popupOffsetX(param1:Number) : void
      {
         this._popupOffsetX = param1;
      }
      
      public function set popupOffsetY(param1:Number) : void
      {
         this._popupOffsetY = param1;
      }
      
      public function get popupOffsetX() : Number
      {
         return this._popupOffsetX;
      }
      
      public function get popupOffsetY() : Number
      {
         return this._popupOffsetY;
      }
   }
}

