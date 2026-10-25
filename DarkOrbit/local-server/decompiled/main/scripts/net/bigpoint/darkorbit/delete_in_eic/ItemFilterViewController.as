package net.bigpoint.darkorbit.delete_in_eic
{
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBox;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBoxEvent;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.combobox.ComboBox;
   import net.bigpoint.darkorbit.fui.components.list.combobox.ComboBoxEvent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   
   public class ItemFilterViewController extends EventDispatcher
   {
      
      public static const SETTINGS_CHANGED_EVENT:String = "ItemFilterViewController.settingsChanged";
      
      private static const TEMPLATE_INVENTORY_FILTER_POPUP:String = "equipment_template_inventory_filter_popup";
      
      private static const TEMPLATE_INVENTORY_FILTER_ROW:String = "equipment_template_inventory.filterset.row";
      
      protected static const CONTAINER_ROW:String = "row";
      
      protected static const POP_X:int = 2;
      
      protected static const POP_Y:int = -3;
      
      private static const FILTERCOMBOBOX_ARROW_ROTATION_CLOSE_STATE:uint = 180;
      
      private static const FILTERCOMBOBOX_ARROW_ROTATION_OPEN_STATE:uint = 0;
      
      protected const PREFIX_BPLOCAL:String = "equipment_inventory_popup.filtering_label_";
      
      private var inventoryControlContainer:DisplayObjectContainer;
      
      private var popupRoot:Container;
      
      private var _filterCombobox:ComboBox;
      
      private var _filterComboxArrowContainer:Container;
      
      private var _selectAllCheckBox:CheckBox;
      
      private var _selectAllCheckBoxLED_on:Bitmap;
      
      private var _selectAllCheckBoxLabel:Label;
      
      private var _selectEventCheckBox:CheckBox;
      
      private var _selectEventCheckBoxLED_on:Bitmap;
      
      private var _selectEventCheckBoxLED_off:Bitmap;
      
      private var _selectEventCheckBoxLabel:Label;
      
      private var _closeButton:Button;
      
      protected var filterSetOptions:Vector.<RowSetting>;
      
      private var _maxLeftRowLabelWidth:uint = 0;
      
      private var _maxRightRowLabelWidth:uint = 0;
      
      private var _itemFilterSettings:ItemFilterSettingsVO;
      
      public function ItemFilterViewController(param1:DisplayObjectContainer)
      {
         super();
         this.inventoryControlContainer = param1;
         this._filterCombobox = this.inventoryControlContainer.getChildByName("combobox.filters") as ComboBox;
         this._filterCombobox.popupTemplate = this.filterPopupTemplateName;
         this.addPopupEventListeners();
      }
      
      protected function buildUI() : void
      {
         this.popupRoot = this._filterCombobox.popupContainer.getChildByName("inventory.filter") as Container;
         this._filterCombobox.popupContainer.filters = [new DropShadowFilter(7,90,0,0.5,5,5,1,2)];
         var _loc1_:uint = this.filterSetOptions.length;
         var _loc2_:Function = UISystem.getInstance().buildByTemplate;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_(this.filterRowTemplateName,this.popupRoot,null,true);
            _loc3_++;
         }
      }
      
      protected function assignChildren() : void
      {
         var _loc3_:Container = null;
         var _loc1_:Container = this._filterCombobox.popupContainer;
         this._selectAllCheckBox = _loc1_.getChildByName("inventory.selectAllCheckbox") as CheckBox;
         this._selectAllCheckBoxLabel = _loc1_.getChildByName("inventory.selectAllLabel") as Label;
         this._selectAllCheckBoxLED_on = _loc1_.getChildByName("led.on") as Bitmap;
         this._selectEventCheckBox = _loc1_.getChildByName("inventory.selectEventCheckbox") as CheckBox;
         this._selectEventCheckBoxLabel = _loc1_.getChildByName("inventory.selectEventLabel") as Label;
         this._selectEventCheckBoxLED_on = _loc1_.getChildByName("ledEvent.on") as Bitmap;
         this._selectEventCheckBoxLED_off = _loc1_.getChildByName("ledEvent.off") as Bitmap;
         this._closeButton = this._filterCombobox.popupContainer.getChildByName("inventory.closeButton") as Button;
         this._filterComboxArrowContainer = this.inventoryControlContainer.getChildByName("arrowContainer") as Container;
         this.addComponentListeners();
         this._selectAllCheckBox.width = this._selectAllCheckBoxLabel.width + this._selectAllCheckBoxLabel.x + this._selectAllCheckBoxLED_on.x;
         this._selectAllCheckBox.forceRedraw();
         if(this._selectEventCheckBox)
         {
            this._selectEventCheckBox.width = this._selectEventCheckBoxLabel.width + this._selectAllCheckBoxLabel.x + this._selectAllCheckBoxLED_on.x;
            this._selectEventCheckBox.forceRedraw();
         }
         this._maxLeftRowLabelWidth = 0;
         this._maxRightRowLabelWidth = 0;
         var _loc2_:uint = this._selectAllCheckBox.y + this._selectAllCheckBox.height;
         var _loc4_:uint = 0;
         var _loc5_:uint = uint(this.popupRoot.numChildren);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = this.popupRoot.getChildAt(_loc6_) as Container;
            if(_loc3_)
            {
               if(_loc3_.name == CONTAINER_ROW)
               {
                  this.assignRowSettingChildren(this.filterSetOptions[_loc4_],_loc3_);
                  _loc4_++;
               }
            }
            _loc6_++;
         }
         var _loc7_:uint = _loc3_.marginRight;
         _loc4_ = 0;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         while(_loc9_ < this.popupRoot.numChildren)
         {
            _loc3_ = this.popupRoot.getChildAt(_loc9_) as Container;
            if(_loc3_)
            {
               if(_loc3_.name == CONTAINER_ROW)
               {
                  _loc8_ = this.updateRowComponentSizes(_loc3_);
                  _loc4_++;
               }
            }
            _loc9_++;
         }
         this.popupRoot.width = _loc8_;
         this.popupRoot.forceRedraw();
         _loc2_ += this.popupRoot.height + this.popupRoot.y;
         this._filterCombobox.popupContainer.width = _loc8_ + _loc7_;
         this._filterCombobox.popupContainer.height = _loc2_;
         this._filterCombobox.popupContainer.forceRedraw();
         this._filterCombobox.popupOffsetX = this.popupOffsetX;
         this._filterCombobox.popupOffsetY = this.popupOffsetY;
         this._filterCombobox.updatePopupPosition();
      }
      
      protected function assignRowSettingChildren(param1:RowSetting, param2:Container) : void
      {
         var _loc3_:Label = null;
         var _loc4_:CheckBox = null;
         _loc3_ = param2.getChildByName("label.filter.left") as Label;
         _loc4_ = param2.getChildByName("cb.filter.left") as CheckBox;
         if(param1.leftVO)
         {
            _loc3_.text = this.bplocal_prefix(param1.leftVO.category);
            _loc3_.forceRedraw();
            this._maxLeftRowLabelWidth = this._maxLeftRowLabelWidth > _loc3_.width ? this._maxLeftRowLabelWidth : uint(_loc3_.width);
            _loc4_.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleFilterCheckBoxSettingChanged);
            param1.leftVO.checkbox = _loc4_;
         }
         else
         {
            _loc3_.visible = false;
            _loc4_.visible = false;
         }
         _loc3_ = param2.getChildByName("label.filter.right") as Label;
         _loc4_ = param2.getChildByName("cb.filter.right") as CheckBox;
         if(param1.rightVO)
         {
            _loc3_.text = this.bplocal_prefix(param1.rightVO.category);
            _loc3_.forceRedraw();
            this._maxRightRowLabelWidth = this._maxRightRowLabelWidth > _loc3_.width ? this._maxRightRowLabelWidth : uint(_loc3_.width);
            _loc4_.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleFilterCheckBoxSettingChanged);
            param1.rightVO.checkbox = _loc4_;
         }
         else
         {
            _loc3_.visible = false;
            _loc4_.visible = false;
         }
      }
      
      protected function updateRowComponentSizes(param1:Container) : Number
      {
         var _loc2_:Label = null;
         var _loc3_:CheckBox = null;
         var _loc4_:Number = 4;
         var _loc5_:Number = 5;
         _loc3_ = param1.getChildByName("cb.filter.left") as CheckBox;
         _loc3_.x = _loc5_;
         _loc3_.forceRedraw();
         _loc5_ += _loc3_.width + _loc4_;
         _loc2_ = param1.getChildByName("label.filter.left") as Label;
         _loc2_.x = _loc5_;
         _loc2_.forceRedraw();
         _loc5_ += this._maxLeftRowLabelWidth + _loc4_;
         _loc3_ = param1.getChildByName("cb.filter.right") as CheckBox;
         _loc3_.x = _loc5_;
         _loc3_.forceRedraw();
         _loc5_ += _loc3_.width + _loc4_;
         _loc2_ = param1.getChildByName("label.filter.right") as Label;
         _loc2_.x = _loc5_;
         _loc2_.forceRedraw();
         return _loc5_ + (this._maxRightRowLabelWidth + _loc4_ + _loc4_);
      }
      
      public function dispose() : void
      {
         this.removePopupEventListeners();
         this.removeComponentListeners();
         this.removeChildren();
      }
      
      protected function removeChildren() : void
      {
         TweenLite.killTweensOf(this._selectAllCheckBoxLED_on);
         TweenLite.killTweensOf(this._filterComboxArrowContainer);
         TweenLite.killTweensOf(this._filterCombobox.popupContainer);
         this._selectAllCheckBoxLED_on = null;
         this._selectAllCheckBox = null;
         this._selectAllCheckBoxLabel = null;
         if(this._selectEventCheckBox)
         {
            TweenLite.killTweensOf(this._selectEventCheckBoxLED_on);
            this._selectEventCheckBoxLED_on = null;
            this._selectEventCheckBox = null;
            this._selectEventCheckBoxLabel = null;
         }
         this._filterCombobox = null;
         this._closeButton = null;
         this._filterComboxArrowContainer = null;
         var _loc1_:Coreponent = this._filterCombobox.popupContainer as Coreponent;
         _loc1_.dispose();
      }
      
      private function addPopupEventListeners() : void
      {
         if(this._filterCombobox)
         {
            this._filterCombobox.addEventListener(ComboBoxEvent.POPUP_CREATED,this.handlePopupCreated);
            this._filterCombobox.addEventListener(ComboBoxEvent.POPUP_SHOW,this.handlePopupShowEvent);
            this._filterCombobox.addEventListener(ComboBoxEvent.POPUP_HIDE,this.handlePopupHideEvent);
         }
      }
      
      private function removePopupEventListeners() : void
      {
         if(this._filterCombobox)
         {
            this._filterCombobox.removeEventListener(ComboBoxEvent.POPUP_CREATED,this.handlePopupCreated);
            this._filterCombobox.removeEventListener(ComboBoxEvent.POPUP_SHOW,this.handlePopupShowEvent);
            this._filterCombobox.removeEventListener(ComboBoxEvent.POPUP_HIDE,this.handlePopupHideEvent);
         }
      }
      
      private function addComponentListeners() : void
      {
         if(this._selectAllCheckBox)
         {
            this._selectAllCheckBox.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleAllFiltersSelectionChanged);
            this._selectAllCheckBox.addEventListener(MouseEvent.MOUSE_OVER,this.handleAllFiltersRolloverEvent);
            this._selectAllCheckBox.addEventListener(MouseEvent.MOUSE_OUT,this.handleAllFiltersRolloutEvent);
         }
         if(this._selectEventCheckBox)
         {
            this._selectEventCheckBox.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleEventFiltersSelectionChanged);
            this._selectEventCheckBox.addEventListener(MouseEvent.MOUSE_OVER,this.handleEventFiltersRolloverEvent);
            this._selectEventCheckBox.addEventListener(MouseEvent.MOUSE_OUT,this.handleEventFiltersRolloutEvent);
         }
         if(this._closeButton)
         {
            this._closeButton.addEventListener(MouseEvent.CLICK,this.handleCloseButtonClicked);
         }
      }
      
      private function removeComponentListeners() : void
      {
         if(this._selectAllCheckBox)
         {
            this._selectAllCheckBox.removeEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleAllFiltersSelectionChanged);
            this._selectAllCheckBox.removeEventListener(MouseEvent.MOUSE_OVER,this.handleAllFiltersRolloverEvent);
            this._selectAllCheckBox.removeEventListener(MouseEvent.MOUSE_OUT,this.handleAllFiltersRolloutEvent);
         }
         if(this._selectEventCheckBox)
         {
            this._selectEventCheckBox.removeEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleEventFiltersSelectionChanged);
            this._selectEventCheckBox.removeEventListener(MouseEvent.MOUSE_OVER,this.handleEventFiltersRolloverEvent);
            this._selectEventCheckBox.removeEventListener(MouseEvent.MOUSE_OUT,this.handleEventFiltersRolloutEvent);
         }
         if(this._closeButton)
         {
            this._closeButton.removeEventListener(MouseEvent.CLICK,this.handleCloseButtonClicked);
         }
      }
      
      private function handlePopupHideEvent(param1:ComboBoxEvent) : void
      {
         TweenLite.to(this._filterComboxArrowContainer,0.2,{"rotation":FILTERCOMBOBOX_ARROW_ROTATION_CLOSE_STATE});
         if(this._itemFilterSettings.isInvalidate())
         {
            this._itemFilterSettings.validate();
            dispatchEvent(new Event(ItemFilterViewController.SETTINGS_CHANGED_EVENT));
         }
      }
      
      private function handlePopupShowEvent(param1:ComboBoxEvent) : void
      {
         TweenLite.to(this._filterComboxArrowContainer,0.2,{"rotation":FILTERCOMBOBOX_ARROW_ROTATION_OPEN_STATE});
         this.assignChildren();
         this.updateComponentStates();
      }
      
      private function handlePopupCreated(param1:ComboBoxEvent) : void
      {
         this.buildUI();
         this.assignChildren();
      }
      
      private function handleFilterCheckBoxSettingChanged(param1:CheckBoxEvent) : void
      {
         var _loc2_:CheckBox = param1.target as CheckBox;
         var _loc3_:String = _loc2_.data as String;
         this._itemFilterSettings.selectFilterByCategory(_loc3_,param1.selected);
         dispatchEvent(new Event(ItemFilterViewController.SETTINGS_CHANGED_EVENT));
      }
      
      private function handleAllFiltersSelectionChanged(param1:CheckBoxEvent) : void
      {
         this._itemFilterSettings.selectAll = param1.selected;
         this.updateComponentStates();
      }
      
      private function handleAllFiltersRolloverEvent(param1:MouseEvent) : void
      {
         if(!this._selectAllCheckBox.isSelected())
         {
            TweenLite.to(this._selectAllCheckBoxLED_on,0.3,{"alpha":1});
         }
      }
      
      private function handleAllFiltersRolloutEvent(param1:MouseEvent) : void
      {
         if(!this._selectAllCheckBox.isSelected())
         {
            TweenLite.to(this._selectAllCheckBoxLED_on,0.3,{"alpha":0});
         }
      }
      
      private function handleEventFiltersSelectionChanged(param1:CheckBoxEvent) : void
      {
         this._itemFilterSettings.selectEvent = param1.selected;
         this.updateComponentStates();
         TweenLite.to(this._selectEventCheckBoxLED_on,0.3,{"alpha":(param1.selected ? 1 : 0)});
         dispatchEvent(new Event(ItemFilterViewController.SETTINGS_CHANGED_EVENT));
      }
      
      private function handleEventFiltersRolloverEvent(param1:MouseEvent) : void
      {
         if(!this._selectEventCheckBox.isSelected())
         {
            TweenLite.to(this._selectEventCheckBoxLED_on,0.3,{"alpha":1});
         }
      }
      
      private function handleEventFiltersRolloutEvent(param1:MouseEvent) : void
      {
         if(!this._selectEventCheckBox.isSelected())
         {
            TweenLite.to(this._selectEventCheckBoxLED_on,0.3,{"alpha":0});
         }
      }
      
      private function handleCloseButtonClicked(param1:Event) : void
      {
         this._filterCombobox.unselect();
      }
      
      public function set itemFilterSettings(param1:ItemFilterSettingsVO) : void
      {
         var _loc3_:RowSetting = null;
         var _loc5_:Object = null;
         if(this._itemFilterSettings)
         {
            this._itemFilterSettings.removeEventListener(Event.CHANGE,this.handleItemSettingsChanged);
            this._itemFilterSettings = null;
         }
         this._itemFilterSettings = param1;
         this.filterSetOptions = new Vector.<RowSetting>();
         var _loc2_:Vector.<Object> = this._itemFilterSettings.getFilterCategoriesAsSortedVector();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc4_];
            if(_loc4_ % 2 == 0)
            {
               _loc3_ = new RowSetting();
               _loc3_.leftVO = new RowEntryVO(_loc5_.category);
               this.filterSetOptions.push(_loc3_);
            }
            else
            {
               _loc3_.rightVO = new RowEntryVO(_loc5_.category);
            }
            _loc4_++;
         }
         this._itemFilterSettings.addEventListener(Event.CHANGE,this.handleItemSettingsChanged);
      }
      
      public function showEventItemsOnlyFilter(param1:Boolean) : void
      {
         this._selectEventCheckBox.visible = this._selectEventCheckBoxLabel.visible = this._selectEventCheckBoxLED_on.visible = this._selectEventCheckBoxLED_off.visible = param1;
      }
      
      public function get itemFilterSettings() : ItemFilterSettingsVO
      {
         return this._itemFilterSettings;
      }
      
      private function handleItemSettingsChanged(param1:Event) : void
      {
         this.updateAllCheckboxesSelectedState();
      }
      
      private function updateAllCheckboxesSelectedState() : void
      {
         this.removeComponentListeners();
         var _loc1_:Boolean = this._itemFilterSettings.areAllItemsSelected();
         if(this._selectAllCheckBox)
         {
            this._selectAllCheckBox.selection = _loc1_;
         }
         if(this._selectEventCheckBox)
         {
            this._selectEventCheckBox.visible = this._selectEventCheckBoxLabel.visible = this._selectEventCheckBoxLED_on.visible = this._selectEventCheckBoxLED_off.visible = this._itemFilterSettings.isEventFilterEnabled();
         }
         TweenLite.to(this._selectAllCheckBoxLED_on,0.3,{"alpha":(_loc1_ ? 1 : 0)});
         this.addComponentListeners();
      }
      
      private function updateComponentStates() : void
      {
         var _loc2_:String = null;
         var _loc5_:RowSetting = null;
         var _loc1_:uint = this.filterSetOptions.length;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc5_ = this.filterSetOptions[_loc4_];
            if(_loc5_.leftVO)
            {
               _loc2_ = _loc5_.leftVO.checkbox.data as String;
               _loc3_ = this._itemFilterSettings.getFilterSelectionByCategory(_loc2_);
               _loc5_.leftVO.checkbox.selection = _loc3_;
            }
            if(_loc5_.rightVO)
            {
               _loc2_ = _loc5_.rightVO.checkbox.data as String;
               _loc3_ = this._itemFilterSettings.getFilterSelectionByCategory(_loc2_);
               _loc5_.rightVO.checkbox.selection = _loc3_;
            }
            _loc4_++;
         }
         this.updateAllCheckboxesSelectedState();
      }
      
      public function get root() : DisplayObjectContainer
      {
         return this.inventoryControlContainer;
      }
      
      protected function get popupOffsetX() : Number
      {
         var _loc1_:Number = this._filterCombobox.popupContainer.width;
         var _loc2_:Number = this._filterCombobox.width;
         return POP_X - (_loc1_ - _loc2_);
      }
      
      protected function get popupOffsetY() : Number
      {
         return -(this._filterCombobox.popupContainer.height + POP_Y);
      }
      
      protected function get filterPopupTemplateName() : String
      {
         return TEMPLATE_INVENTORY_FILTER_POPUP;
      }
      
      protected function get filterRowTemplateName() : String
      {
         return TEMPLATE_INVENTORY_FILTER_ROW;
      }
      
      protected function bplocal_prefix(param1:String) : String
      {
         return UISystem.localize(this.PREFIX_BPLOCAL + param1,Constants.BPLOCAL_CATEGORY__EIC);
      }
   }
}

import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBox;

class RowSetting
{
   
   private var _leftVO:RowEntryVO;
   
   private var _rightVO:RowEntryVO;
   
   public function RowSetting(param1:RowEntryVO = null, param2:RowEntryVO = null)
   {
      super();
      this._leftVO = param1;
      this._rightVO = param2;
   }
   
   public function set leftVO(param1:RowEntryVO) : void
   {
      this._leftVO = param1;
   }
   
   public function set rightVO(param1:RowEntryVO) : void
   {
      this._rightVO = param1;
   }
   
   public function get leftVO() : RowEntryVO
   {
      return this._leftVO;
   }
   
   public function get rightVO() : RowEntryVO
   {
      return this._rightVO;
   }
}

class RowEntryVO
{
   
   private var _category:String;
   
   private var _component:CheckBox;
   
   public function RowEntryVO(param1:String)
   {
      super();
      this._category = param1;
   }
   
   public function get checkbox() : CheckBox
   {
      return this._component;
   }
   
   public function set checkbox(param1:CheckBox) : void
   {
      this._component = param1;
      this._component.data = this.category;
   }
   
   public function get category() : String
   {
      return this._category;
   }
}
