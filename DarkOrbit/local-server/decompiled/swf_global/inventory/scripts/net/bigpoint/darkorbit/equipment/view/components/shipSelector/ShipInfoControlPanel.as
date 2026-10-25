package net.bigpoint.darkorbit.equipment.view.components.shipSelector
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.model.VO.HangarSlotEntity;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.darkorbit.equipment.view.components.events.GenericDataEvent;
   import net.bigpoint.darkorbit.equipment.view.components.ghosttyper.GhostTyperEffect;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons.AbstractShipSelectorButton;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons.ShipSelectorBlueButton;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons.ShipSelectorGreenButton;
   
   public class ShipInfoControlPanel extends Sprite
   {
      
      public static const EVENT_BUY_BUTTON_CLICKED:String = "EVENT_BUY_BUTTON_CLICKED";
      
      public static const EVENT_ACTIVATE_BUTTON_CLICKED:String = "EVENT_ACTIVATE_BUTTON_CLICKED";
      
      public static const EVENT_MANAGE_BUTTON_CLICKED:String = "EVENT_MANAGE_BUTTON_CLICKED";
      
      public static const SHIP_INFOCONTROLPANEL_WIDTH:uint = 330;
      
      public static const SHIP_INFOCONTROLPANEL_HEIGHT:uint = 320;
      
      private static const YS:uint = 3;
      
      private var _activateButton:AbstractShipSelectorButton;
      
      private var _buyButton:AbstractShipSelectorButton;
      
      private var _manageButton:AbstractShipSelectorButton;
      
      private var _shipActiveLabel:TextField;
      
      private var _shipActiveGhostTyper:GhostTyperEffect;
      
      private var _shipUpgradeRecipeLabel:TextField;
      
      public function ShipInfoControlPanel()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.createBuyButton();
         this.createActivateButton();
         this.createManageButton();
         this.createActiveLabel();
         this.fillBackground();
         this.createRecipeUnlockText();
      }
      
      private function fillBackground() : void
      {
         var _loc1_:Graphics = this.graphics;
         _loc1_.beginFill(0,0.75);
         _loc1_.drawRect(0,0,SHIP_INFOCONTROLPANEL_WIDTH,SHIP_INFOCONTROLPANEL_HEIGHT);
         _loc1_.endFill();
      }
      
      private function createManageButton() : void
      {
         var _loc1_:TextFormat = null;
         _loc1_ = new TextFormat(Styles.defaultFont);
         _loc1_.align = "center";
         _loc1_.size = 10;
         _loc1_.color = 16711678;
         this._manageButton = new ShipSelectorBlueButton();
         this.centerManageButtonHorizontally();
         this._manageButton.y = YS + (this._buyButton.y + this._buyButton.height);
         this._manageButton.resizedWidthCallback = this.resizedManageWidthCallback;
         this._manageButton.setSize(152,28);
         this._manageButton.addEventListener(MouseEvent.CLICK,this.handleManageEquipmentButtonClicked);
         this._manageButton.setEnable(false);
         this._manageButton.setText(BPLocale.getItem("label_button_manage_equipment_name"),_loc1_);
         this.addChild(this._manageButton);
      }
      
      private function createBuyButton() : void
      {
         var _loc1_:TextFormat = null;
         _loc1_ = new TextFormat(Styles.boldFontName);
         _loc1_.align = "center";
         _loc1_.size = 18;
         _loc1_.color = 16711678;
         this._buyButton = new ShipSelectorGreenButton();
         this.centerBuyButtonHorizontally();
         this._buyButton.y = YS;
         this._buyButton.resizedWidthCallback = this.resizedBuyButtonWidthCallback;
         this._buyButton.setSize(152,42);
         this._buyButton.setText(BPLocale.getItem("label_button_buy_ship_name"),_loc1_);
         this._buyButton.addEventListener(MouseEvent.CLICK,this.handleBuyButtonClicked);
         this._buyButton.setEnable(false);
         this.addChild(this._buyButton);
      }
      
      private function createActivateButton() : void
      {
         var _loc1_:TextFormat = null;
         _loc1_ = new TextFormat(Styles.boldFontName);
         _loc1_.align = "center";
         _loc1_.size = 18;
         _loc1_.color = 16711678;
         this._activateButton = new ShipSelectorGreenButton();
         this.centerActivateButtonHorizontally();
         this._activateButton.y = YS;
         this._activateButton.resizedWidthCallback = this.resizedActivateButtonWidthCallback;
         this._activateButton.setSize(152,42);
         this._activateButton.setText(BPLocale.getItem("label_button_activate_ship_name"),_loc1_);
         this._activateButton.addEventListener(MouseEvent.CLICK,this.handleActivateButtonClicked);
         this._activateButton.setEnable(false);
         this.addChild(this._activateButton);
      }
      
      private function createRecipeUnlockText() : void
      {
         var _loc1_:TextFormat = null;
         _loc1_ = new TextFormat(Styles.boldFontName);
         _loc1_.align = "center";
         _loc1_.size = 12;
         _loc1_.color = 16711678;
         this._shipUpgradeRecipeLabel = new TextField();
         this._shipUpgradeRecipeLabel.width = 270;
         this._shipUpgradeRecipeLabel.height = 30;
         this._shipUpgradeRecipeLabel.y = YS + 10;
         this._shipUpgradeRecipeLabel.x = ShipSelectorView.SHIP_INFOPANEL_WIDTH - this._shipActiveLabel.width >> 1;
         this._shipUpgradeRecipeLabel.antiAliasType = AntiAliasType.ADVANCED;
         this._shipUpgradeRecipeLabel.embedFonts = Styles.baseEmbed;
         this._shipUpgradeRecipeLabel.mouseEnabled = false;
         this._shipUpgradeRecipeLabel.selectable = false;
         this._shipUpgradeRecipeLabel.border = true;
         this._shipUpgradeRecipeLabel.defaultTextFormat = _loc1_;
         this.addChild(this._shipUpgradeRecipeLabel);
      }
      
      private function createActiveLabel() : void
      {
         var _loc1_:TextFormat = null;
         _loc1_ = new TextFormat(Styles.boldFontName);
         _loc1_.align = "center";
         _loc1_.size = 28;
         _loc1_.color = 16448250;
         this._shipActiveLabel = new TextField();
         this._shipActiveLabel.width = 270;
         this._shipActiveLabel.height = 30;
         this._shipActiveLabel.y = YS + 3;
         this._shipActiveLabel.x = ShipSelectorView.SHIP_INFOPANEL_WIDTH - this._shipActiveLabel.width >> 1;
         this._shipActiveLabel.antiAliasType = AntiAliasType.ADVANCED;
         this._shipActiveLabel.embedFonts = Styles.baseEmbed;
         this._shipActiveLabel.mouseEnabled = false;
         this._shipActiveLabel.selectable = false;
         this._shipActiveLabel.border = true;
         this._shipActiveLabel.defaultTextFormat = _loc1_;
         this._shipActiveGhostTyper = new GhostTyperEffect();
         this._shipActiveGhostTyper.updateInterval = 40;
         this._shipActiveGhostTyper.updateTargets = [{
            "target":this._shipActiveLabel,
            "property":"text"
         }];
         this.addChild(this._shipActiveLabel);
      }
      
      private function resizedBuyButtonWidthCallback(param1:DisplayObject) : void
      {
         this.centerBuyButtonHorizontally();
      }
      
      private function resizedManageWidthCallback(param1:DisplayObject) : void
      {
         this.centerManageButtonHorizontally();
      }
      
      private function resizedActivateButtonWidthCallback(param1:DisplayObject) : void
      {
         this.centerActivateButtonHorizontally();
      }
      
      private function centerBuyButtonHorizontally() : void
      {
         this._buyButton.x = ShipSelectorView.SHIP_INFOPANEL_WIDTH - this._buyButton.width >> 1;
      }
      
      private function centerActivateButtonHorizontally() : void
      {
         this._activateButton.x = ShipSelectorView.SHIP_INFOPANEL_WIDTH - this._activateButton.width >> 1;
      }
      
      private function centerManageButtonHorizontally() : void
      {
         this._manageButton.x = ShipSelectorView.SHIP_INFOPANEL_WIDTH - this._manageButton.width >> 1;
      }
      
      private function handleManageEquipmentButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new GenericDataEvent(EVENT_MANAGE_BUTTON_CLICKED));
      }
      
      private function handleBuyButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new GenericDataEvent(EVENT_BUY_BUTTON_CLICKED));
      }
      
      private function handleActivateButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new GenericDataEvent(EVENT_ACTIVATE_BUTTON_CLICKED));
      }
      
      public function updateUIControls(param1:HangarSlotEntity) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1)
         {
            if(param1.isActive())
            {
               this._activateButton.visible = false;
               this._buyButton.visible = false;
            }
            else
            {
               this._activateButton.setEnable(param1.isOwned());
               this._activateButton.visible = param1.isOwned();
               _loc2_ = !param1.isOwned() && (!param1.isEventItem() || param1.isEventItem() && param1.isEventActive()) && !param1.isUpgradedShip;
               this._buyButton.setEnable(_loc2_);
               this._buyButton.visible = _loc2_;
            }
            if(!param1.isOwned() && param1.isUpgradedShip && (param1.getShip().selectedDesign == null || param1.getShip().selectedDesign == param1.getShip().lootID))
            {
               _loc3_ = param1.getShip().selectedDesign || param1.getShip().lootID;
               _loc4_ = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,"items_" + _loc3_ + "_sources");
               this._shipUpgradeRecipeLabel.text = _loc4_;
               TweenLite.to(this._shipUpgradeRecipeLabel,0.5,{"autoAlpha":1});
            }
            else
            {
               this._shipUpgradeRecipeLabel.text = "";
               TweenLite.to(this._shipUpgradeRecipeLabel,0.5,{"autoAlpha":0});
            }
            if(param1.isActive())
            {
               this._shipActiveLabel.text = "";
               TweenLite.to(this._shipActiveLabel,0.7,{"autoAlpha":1});
               this._shipActiveGhostTyper.text = BPLocale.getItem("label_active_ship");
               this._shipActiveGhostTyper.start();
            }
            else
            {
               TweenLite.to(this._shipActiveLabel,0.5,{"autoAlpha":0});
            }
            this._manageButton.setEnable(param1.isOwned());
         }
         else
         {
            this._activateButton.setEnable(false);
            this._buyButton.setEnable(false);
            this._manageButton.setEnable(false);
         }
      }
   }
}

