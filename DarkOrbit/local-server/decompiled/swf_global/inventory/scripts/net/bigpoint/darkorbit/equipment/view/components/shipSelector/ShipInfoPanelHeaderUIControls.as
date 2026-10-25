package net.bigpoint.darkorbit.equipment.view.components.shipSelector
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import mx.core.BitmapAsset;
   import mx.core.SpriteAsset;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.model.VO.HangarSlotEntity;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.DropDownButton;
   import net.bigpoint.darkorbit.equipment.view.components.events.GenericDataEvent;
   import net.bigpoint.darkorbit.equipment.view.components.menus.DropDownMenu;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons.ShipSelectorFavouriteButton;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons.ShipSelectorInfoButton;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.TooltipControl;
   import net.bigpoint.darkorbit.equipment.view.managers.FocusManager;
   
   public class ShipInfoPanelHeaderUIControls extends Sprite
   {
      
      public static const EVENT_SHOW_SHIP_DETAILS_BUTTON_CLICKED:String = "EVENT_SHOW_SHIP_DETAILS_BUTTON_CLICKED";
      
      public static const EVENT_FAVOURITE_BUTTON_CLICKED:String = "EVENT_FAVOURITE_BUTTON_CLICKED";
      
      public static const EVENT_SHIPDESIGN_SELECTION_CHANGED:String = "EVENT_SHIPDESIGN_SELECTION_CHANGED";
      
      private static const DESIGN_SELECTION_COMBOBOX:String = "DESIGN_SELECTION_COMBOBOX";
      
      private var skinBackground:Class = ShipInfoPanelHeaderUIControls_skinBackground;
      
      private var _background:SpriteAsset;
      
      private var _backgroundWidth:uint;
      
      private var _showShipDetailsButton:ShipSelectorInfoButton;
      
      private var _favouriteButton:ShipSelectorFavouriteButton;
      
      private var _designSelectionMenu:DropDownMenu;
      
      public function ShipInfoPanelHeaderUIControls()
      {
         super();
         this.create();
      }
      
      protected function create() : void
      {
         this.createBackground();
         this.createIconFavouriteButton();
         this.createIconOpenShipDetailsPanelButton();
      }
      
      private function createShipDesignComboBox() : void
      {
         var _loc1_:DisplayObject = null;
         _loc1_ = this._background.getChildByName(DESIGN_SELECTION_COMBOBOX);
         if(_loc1_ != null)
         {
            FocusManager.getInstance().remove(this._designSelectionMenu);
            this._designSelectionMenu.removeButtonCallbackFunction();
            this._designSelectionMenu = null;
            this._background.removeChild(_loc1_);
         }
         this._designSelectionMenu = new DropDownMenu();
         this._designSelectionMenu.name = DESIGN_SELECTION_COMBOBOX;
         this._designSelectionMenu.addButtonCallbackFunction(this.handleSipDesignItemSelectedCallback);
         this._designSelectionMenu.x = 10;
         this._designSelectionMenu.y = 4;
         TooltipControl.getInstance().addToolTip(this._designSelectionMenu,BPLocale.getItem("tooltip_ship_design_menu"));
         this._background.addChild(this._designSelectionMenu);
         TooltipControl.getInstance().addToolTip(this._designSelectionMenu,BPLocale.getItem("tooltip_ship_design_menu"));
         FocusManager.getInstance().add(this._designSelectionMenu);
      }
      
      private function createBackground() : void
      {
         this._background = new SpriteAsset();
         this._background.addChild(new this.skinBackground() as BitmapAsset);
         this._background.x = -23;
         this._background.y = -36;
         this._backgroundWidth = this._background.width;
         this.addChild(this._background);
      }
      
      private function createIconFavouriteButton() : void
      {
         this._favouriteButton = new ShipSelectorFavouriteButton();
         this._favouriteButton.x = this._backgroundWidth - 29;
         this._favouriteButton.y = 7;
         this._favouriteButton.addEventListener(MouseEvent.CLICK,this.handleFavouriteButtonClicked);
         this._favouriteButton.setEnable(false);
         this._background.addChild(this._favouriteButton);
      }
      
      private function createIconOpenShipDetailsPanelButton() : void
      {
         this._showShipDetailsButton = new ShipSelectorInfoButton();
         this._showShipDetailsButton.x = this._backgroundWidth - 49;
         this._showShipDetailsButton.y = 7;
         this._showShipDetailsButton.addEventListener(MouseEvent.CLICK,this.handleShowShipDetailsButtonClicked);
         this._background.addChild(this._showShipDetailsButton);
      }
      
      private function handleShowShipDetailsButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new GenericDataEvent(EVENT_SHOW_SHIP_DETAILS_BUTTON_CLICKED,this._showShipDetailsButton.isContentVisible()));
      }
      
      private function handleSipDesignItemSelectedCallback(param1:MouseEvent = null) : void
      {
         TooltipControl.getInstance().removeFromStageOnly(this._designSelectionMenu);
         var _loc2_:DropDownButton = DropDownButton(param1.currentTarget);
         var _loc3_:String = _loc2_.buttonKey;
         dispatchEvent(new GenericDataEvent(EVENT_SHIPDESIGN_SELECTION_CHANGED,_loc3_));
      }
      
      private function handleFavouriteButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new GenericDataEvent(EVENT_FAVOURITE_BUTTON_CLICKED,!this._favouriteButton.isFavourite()));
         this._favouriteButton.setFavourite(!this._favouriteButton.isFavourite());
      }
      
      public function updateUIControls(param1:HangarSlotEntity) : void
      {
         var _loc2_:Boolean = false;
         if(param1.isOwned())
         {
            _loc2_ = true;
         }
         this._showShipDetailsButton.setEnable(_loc2_);
         this._favouriteButton.setEnable(_loc2_);
         this._favouriteButton.setFavourite(param1.isFavourite());
      }
      
      public function updateShipdesignList(param1:String, param2:Dictionary) : void
      {
         var _loc5_:String = null;
         this.createShipDesignComboBox();
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         for(_loc5_ in param2)
         {
            if(++_loc3_ > 1)
            {
               _loc4_ = true;
               break;
            }
         }
         this._designSelectionMenu.createDropDownFromDictionary(param2,param1,false,param1);
         this._designSelectionMenu.addButtonCallbackFunction(this.handleSipDesignItemSelectedCallback);
         this._designSelectionMenu.visible = _loc4_;
         this._designSelectionMenu.createPopUpDisplay();
         this._designSelectionMenu.addRollOverFunction();
      }
      
      public function updateShowInfoState(param1:Boolean) : void
      {
         this._showShipDetailsButton.showContent = param1;
      }
   }
}

