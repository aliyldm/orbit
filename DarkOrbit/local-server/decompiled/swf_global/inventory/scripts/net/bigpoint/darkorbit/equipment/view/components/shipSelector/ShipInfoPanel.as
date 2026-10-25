package net.bigpoint.darkorbit.equipment.view.components.shipSelector
{
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.model.VO.HangarSlotEntity;
   import net.bigpoint.darkorbit.equipment.model.VO.ShipDetailsViewData;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.darkorbit.equipment.view.components.events.GenericDataEvent;
   import net.bigpoint.darkorbit.equipment.view.components.ghosttyper.GhostTyperEffect;
   import net.bigpoint.darkorbit.equipment.view.components.scroller.ScrollBar;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.ShipSelectorVideoPlayer;
   
   public class ShipInfoPanel extends Sprite
   {
      
      private static const VIDEOPLAYER_YPOS:uint = 67;
      
      private static const LABEL_TITLE_YPOS:uint = 8;
      
      private static const LABEL_DESCRIPTION_YPOS:uint = 50;
      
      private static const LABEL_MESSAGE_WIDTH:uint = 280;
      
      private var _videoPlayer:ShipSelectorVideoPlayer;
      
      private var _shipNamelabel:TextField;
      
      private var _shipNameSizeMeasuringLabel:TextField;
      
      private var _shipDescriptionLabel:TextField;
      
      private var _shipDescriptionSizeMeasuringLabel:TextField;
      
      private var _shipNameGhostTyper:GhostTyperEffect;
      
      private var _shipTypeGhostTyper:GhostTyperEffect;
      
      private var _shipTypelabel_XS:uint;
      
      private var _shipNamelabel_XS:uint;
      
      private var _createNotOwnedInformationLayer:ShipInfoNotOwnedShipLayer;
      
      private const SHIP_NAME_LABEL_WIDTH:Number = 600;
      
      public function ShipInfoPanel()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.createVideoPlayer();
         this.createLabels();
         this.createNotOwnedInformationLayer();
      }
      
      private function createNotOwnedInformationLayer() : void
      {
         this._createNotOwnedInformationLayer = new ShipInfoNotOwnedShipLayer();
         this._createNotOwnedInformationLayer.addEventListener(ShipInfoNotOwnedShipLayer.SCROLLBAR_POSITION_CHANGED,this.handleNotOwnedShipLayerScrollbarPositionChanged);
         this.addChild(this._createNotOwnedInformationLayer);
      }
      
      private function handleNotOwnedShipLayerScrollbarPositionChanged(param1:GenericDataEvent) : void
      {
         var _loc2_:ScrollBar = param1.data as ScrollBar;
         var _loc3_:Number = _loc2_.movementPercentage;
         var _loc4_:Number = _loc2_.movement;
         this.calculateNotOwnedVisualState(_loc3_,_loc4_);
      }
      
      private function calculateNotOwnedVisualState(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = Math.sin(param1 * (Math.PI / 2));
         this._videoPlayer.y = VIDEOPLAYER_YPOS - param2;
         var _loc4_:int = LABEL_TITLE_YPOS - _loc3_ * 80;
         this._shipNamelabel.y = _loc4_ <= -5 ? -5 : _loc4_;
         this._shipDescriptionLabel.y = LABEL_DESCRIPTION_YPOS - _loc3_ * 100;
         this._shipDescriptionLabel.alpha = 1 - _loc3_ * 4;
      }
      
      private function createVideoPlayer() : void
      {
         this._videoPlayer = new ShipSelectorVideoPlayer();
         this._videoPlayer.x = ShipSelectorView.SHIP_INFOPANEL_WIDTH - this._videoPlayer.width >> 1;
         this._videoPlayer.y = VIDEOPLAYER_YPOS;
         this._videoPlayer.visible = false;
         this.addChild(this._videoPlayer);
      }
      
      private function createLabels() : void
      {
         this.createShipDescriptionLabel();
         this.createShipNameLabel();
         this.setShipNameText("");
         this.setShipDescriptionText("");
      }
      
      private function createShipDescriptionLabel() : void
      {
         var _loc1_:TextFormat = null;
         _loc1_ = new TextFormat(Styles.standardFontName);
         _loc1_.align = "right";
         _loc1_.size = 16;
         _loc1_.color = 14540253;
         this._shipDescriptionLabel = new TextField();
         this._shipDescriptionLabel.width = LABEL_MESSAGE_WIDTH;
         this._shipDescriptionLabel.height = 60;
         this._shipDescriptionLabel.y = LABEL_DESCRIPTION_YPOS;
         this._shipDescriptionLabel.x = this._shipTypelabel_XS = ShipSelectorView.SHIP_INFOPANEL_WIDTH - this._shipDescriptionLabel.width - 14;
         this._shipDescriptionLabel.antiAliasType = AntiAliasType.ADVANCED;
         this._shipDescriptionLabel.embedFonts = Styles.baseEmbed;
         this._shipDescriptionLabel.autoSize = TextFieldAutoSize.LEFT;
         this._shipDescriptionLabel.wordWrap = true;
         this._shipDescriptionLabel.multiline = true;
         this._shipDescriptionLabel.mouseEnabled = false;
         this._shipDescriptionLabel.selectable = false;
         this._shipDescriptionLabel.filters = [new DropShadowFilter(2,90,0,1,2,2,1,2)];
         this._shipDescriptionLabel.defaultTextFormat = _loc1_;
         this._shipTypeGhostTyper = new GhostTyperEffect();
         this._shipTypeGhostTyper.updateInterval = 12;
         this._shipTypeGhostTyper.randomizeTimeframePercentage = 0.1;
         this._shipTypeGhostTyper.updateTargets = [{
            "target":this._shipDescriptionLabel,
            "property":"text"
         }];
         this._shipDescriptionSizeMeasuringLabel = new TextField();
         this._shipDescriptionSizeMeasuringLabel.width = LABEL_MESSAGE_WIDTH;
         this._shipDescriptionSizeMeasuringLabel.height = 60;
         this._shipDescriptionSizeMeasuringLabel.y = LABEL_DESCRIPTION_YPOS;
         this._shipDescriptionSizeMeasuringLabel.antiAliasType = AntiAliasType.ADVANCED;
         this._shipDescriptionSizeMeasuringLabel.embedFonts = Styles.baseEmbed;
         this._shipDescriptionSizeMeasuringLabel.autoSize = TextFieldAutoSize.LEFT;
         this._shipDescriptionSizeMeasuringLabel.wordWrap = true;
         this._shipDescriptionSizeMeasuringLabel.multiline = true;
         this._shipDescriptionSizeMeasuringLabel.mouseEnabled = false;
         this._shipDescriptionSizeMeasuringLabel.selectable = false;
         this._shipDescriptionSizeMeasuringLabel.defaultTextFormat = _loc1_;
         this.addChild(this._shipDescriptionLabel);
      }
      
      private function createShipNameLabel() : void
      {
         var _loc1_:TextFormat = null;
         _loc1_ = new TextFormat(Styles.boldFontName);
         _loc1_.align = "right";
         _loc1_.size = 28;
         _loc1_.color = 16448250;
         this._shipNamelabel = new TextField();
         this._shipNamelabel.width = this.SHIP_NAME_LABEL_WIDTH;
         this._shipNamelabel.height = 40;
         this._shipNamelabel.y = LABEL_TITLE_YPOS;
         this._shipNamelabel.x = this._shipNamelabel_XS = ShipSelectorView.SHIP_INFOPANEL_WIDTH - this._shipNamelabel.width - 10;
         this._shipNamelabel.antiAliasType = AntiAliasType.ADVANCED;
         this._shipNamelabel.embedFonts = Styles.baseEmbed;
         this._shipNamelabel.mouseEnabled = false;
         this._shipNamelabel.selectable = false;
         this._shipNamelabel.defaultTextFormat = _loc1_;
         this._shipNamelabel.filters = [new DropShadowFilter(2,90,0,1,1,1,1,2)];
         this._shipNameGhostTyper = new GhostTyperEffect();
         this._shipNameGhostTyper.updateInterval = 46;
         this._shipNameGhostTyper.updateTargets = [{
            "target":this._shipNamelabel,
            "property":"text"
         }];
         this._shipNameSizeMeasuringLabel = new TextField();
         this._shipNameSizeMeasuringLabel.width = this.SHIP_NAME_LABEL_WIDTH;
         this._shipNameSizeMeasuringLabel.height = 40;
         this._shipNameSizeMeasuringLabel.y = LABEL_TITLE_YPOS + 24;
         this._shipNameSizeMeasuringLabel.antiAliasType = AntiAliasType.ADVANCED;
         this._shipNameSizeMeasuringLabel.embedFonts = Styles.baseEmbed;
         this._shipNameSizeMeasuringLabel.mouseEnabled = false;
         this._shipNameSizeMeasuringLabel.selectable = false;
         this._shipNameSizeMeasuringLabel.defaultTextFormat = _loc1_;
         this.addChild(this._shipNamelabel);
      }
      
      public function updateUIControls(param1:HangarSlotEntity) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1)
         {
            _loc2_ = param1.getShip().selectedDesign || param1.getShip().lootID;
            _loc3_ = "items_" + _loc2_ + "_fullname";
            _loc4_ = "items_" + _loc2_ + "_description";
            this.setShipNameText(BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc3_));
            this.setShipDescriptionText(BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc4_));
            if(param1.isOwned())
            {
               this.calculateNotOwnedVisualState(0,0);
            }
         }
         else
         {
            this.setShipDescriptionText("");
            this.setShipNameText("");
         }
      }
      
      public function setShipNameText(param1:String) : void
      {
         this._shipNameSizeMeasuringLabel.scaleX = 1;
         this._shipNameSizeMeasuringLabel.scaleY = 1;
         this._shipNameSizeMeasuringLabel.autoSize = TextFieldAutoSize.LEFT;
         this._shipNameSizeMeasuringLabel.text = param1 + " ";
         var _loc2_:Number = 300 / this._shipNameSizeMeasuringLabel.width;
         var _loc3_:Number = 0;
         if(_loc2_ < 1)
         {
            this._shipNamelabel.scaleX = _loc2_;
            this._shipNamelabel.scaleY = _loc2_;
            _loc3_ = Math.abs(this._shipNamelabel.width - this.SHIP_NAME_LABEL_WIDTH);
         }
         else
         {
            this._shipNamelabel.scaleX = 1;
            this._shipNamelabel.scaleY = 1;
         }
         var _loc4_:Number = -this.SHIP_NAME_LABEL_WIDTH + ShipSelectorView.SHIP_INFOPANEL_WIDTH - 10 + _loc3_;
         this._shipNamelabel.alpha = 0;
         this._shipNamelabel.x = _loc4_ - 100;
         this._shipNamelabel.text = "";
         this._shipNameGhostTyper.text = param1 + " ";
         this._shipNameGhostTyper.start();
         TweenLite.to(this._shipNamelabel,1,{
            "alpha":1,
            "x":_loc4_
         });
      }
      
      public function setShipDescriptionText(param1:String) : void
      {
         var _loc6_:Number = NaN;
         this._shipDescriptionLabel.alpha = 0;
         this._shipDescriptionLabel.x = -150;
         this._shipDescriptionLabel.text = "";
         this._shipDescriptionLabel.width = LABEL_MESSAGE_WIDTH;
         this._shipDescriptionLabel.scaleX = this._shipDescriptionLabel.scaleY = 1;
         var _loc2_:Number = this._shipDescriptionLabel.width;
         this._shipDescriptionSizeMeasuringLabel.x = this._shipTypelabel_XS;
         this._shipDescriptionSizeMeasuringLabel.text = param1;
         var _loc3_:Number = this._shipDescriptionSizeMeasuringLabel.width;
         var _loc4_:Number = 138;
         var _loc5_:Number = this._shipTypelabel_XS;
         if(this._shipDescriptionSizeMeasuringLabel.height > _loc4_)
         {
            _loc6_ = _loc4_ / this._shipDescriptionSizeMeasuringLabel.height;
            _loc6_ = _loc6_ < 0.8 ? 0.8 : _loc6_;
            this._shipDescriptionLabel.scaleX = this._shipDescriptionLabel.scaleY = _loc6_;
            this._shipDescriptionLabel.width = LABEL_MESSAGE_WIDTH * (1 / _loc6_);
            _loc5_ = this._shipTypelabel_XS;
         }
         this._shipTypeGhostTyper.text = param1 + " ";
         this._shipTypeGhostTyper.start();
         TweenLite.to(this._shipDescriptionLabel,1.3,{
            "delay":0.2,
            "alpha":1,
            "x":_loc5_
         });
      }
      
      public function loadVideo(param1:String) : void
      {
         if(param1)
         {
            this._videoPlayer.visible = true;
            this._videoPlayer.playURL(param1);
         }
         else
         {
            this._videoPlayer.visible = false;
         }
      }
      
      public function show() : void
      {
         TweenLite.to(this,0.3,{"autoAlpha":1});
      }
      
      public function hide() : void
      {
         TweenLite.to(this,0.3,{"autoAlpha":0});
      }
      
      public function hideNotOwnedLayer() : void
      {
         this._createNotOwnedInformationLayer.hide();
      }
      
      public function showNotOwnedLayer() : void
      {
         this._createNotOwnedInformationLayer.show();
      }
      
      public function floodWithNotOwnedData(param1:ShipDetailsViewData) : void
      {
         this._createNotOwnedInformationLayer.setData(param1);
      }
   }
}

