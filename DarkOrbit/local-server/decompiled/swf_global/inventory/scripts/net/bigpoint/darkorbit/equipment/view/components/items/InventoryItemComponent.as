package net.bigpoint.darkorbit.equipment.view.components.items
{
   import com.adobe.utils.StringUtil;
   import com.bigpoint.filecollection.finish.FileCollectionFinisher;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.net.registerClassAlias;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.model.VO.Inventory;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.darkorbit.equipment.view.components.interfaces.IMenuComponent;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.ToolTipHook;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.TooltipControl;
   import net.bigpoint.dataInterchange.DataInterchange;
   import net.bigpoint.utils.DisplayObjectHelper;
   
   public class InventoryItemComponent extends Sprite
   {
      
      private static const notBuyableNames:Array = ["a-bl","pr-l","aurus","blacklight-trace","glacial-fragment","mindfire-cerebrum","rinusk","schism","permafrost-fissure-cpu","ucb-100","rcb-140","am-l"];
      
      public static const UNLOCKABLE:String = "UNLOCKABLE";
      
      private static const HEALTH_NORMAL:uint = 1;
      
      private static const HEALTH_CRITICAL:uint = 2;
      
      private static const HEALTH_DESTROYED:uint = 3;
      
      private static const UNDEFINED_GROUP_NAME:String = "undefinedGroupName";
      
      public var itemName:String;
      
      public var itemID:String;
      
      public var itemGraphic:MovieClip;
      
      public var itemBorder:MovieClip;
      
      public var itemSprite:Sprite = new Sprite();
      
      public var stackGraphic:MovieClip = new MovieClip();
      
      public var equippedSprite:MovieClip = new MovieClip();
      
      public var disabledSprite:MovieClip = new MovieClip();
      
      public var bitmapFont:BitmapFont;
      
      public var isDrone:Boolean = false;
      
      public var droneLevel:int;
      
      public var isLargeIcon:Boolean = false;
      
      private var _group:String;
      
      private var _emptySlotGroup:String;
      
      private var _emptyToolTipHook:ToolTipHook;
      
      public var col:int;
      
      public var row:int;
      
      public var equippedInConfigs:Array = [];
      
      public var menuSectionComponent:IMenuComponent;
      
      public var indexInGrid:int;
      
      public var canBeSelected:Boolean = true;
      
      public var selected:Boolean = false;
      
      public var quantity:Number = 1;
      
      public var quantityField:TextField;
      
      private var lowerCaseName:String;
      
      private var currentGraphicBitmap:Bitmap = new Bitmap();
      
      public var buyableExtraSlot:Boolean = false;
      
      private var itemHover:MovieClip;
      
      private var unlockableSlotIcon:MovieClip;
      
      private var greaterThanSymbol:Sprite;
      
      private var moduleInstalledIcon:MovieClip;
      
      private var moduleUnusableIcon:MovieClip;
      
      private var moduleRelatedOverlays:MovieClip;
      
      public var sellable:Boolean = true;
      
      public var repairPrice:int;
      
      public var currency:String;
      
      public var repairable:Boolean;
      
      public var equipped:Boolean = false;
      
      public var damageLevel:int = 1;
      
      public var shieldLevel:int = 1;
      
      private var levelFont:BitmapFont;
      
      private var levelValue:int;
      
      public var lootID:String;
      
      private var visualLetter:TextField = null;
      
      private var statsLetter:TextField = null;
      
      private var _multiSellItem:Boolean = false;
      
      private var _hasPetGearXModifier:Boolean = false;
      
      private var _setBonus:Boolean = false;
      
      private var _setBonusActive:Boolean;
      
      private var _setBonusAmt:int;
      
      private var _hideSetBonusTooltipText:Boolean = false;
      
      private var _eventListenerTracking:Dictionary = new Dictionary();
      
      public function InventoryItemComponent()
      {
         super();
      }
      
      public static function changeFilename(param1:String, param2:ItemInstanceVO) : String
      {
         if(param1 == DataInterchange.WORDPUZZLE_ID)
         {
            param1 = ActionIdentifiers.RESOURCE + "_" + param1;
            param1 += "_" + param2.wordpuzzleValue.toLowerCase();
         }
         if(param1.indexOf(DataInterchange.WORDPUZZLE_ID) != -1 && StringUtil.beginsWith(param2.wordpuzzleName,DataInterchange.WORDPUZZLE_NAME_PREFIX))
         {
            param1 = param2.wordpuzzleValue.toLowerCase();
         }
         return param1;
      }
      
      public function init() : void
      {
         this.itemGraphic = AssetProxy.getMovieClip("inventoryItems","emptySlot");
         this.itemHover = AssetProxy.getMovieClip("inventoryItems","hover");
         this.itemBorder = AssetProxy.getMovieClip("inventoryItems","emptySlot");
         this.equippedSprite = AssetProxy.getMovieClip("inventoryItems","equippedSlot");
         this.moduleRelatedOverlays = AssetProxy.getMovieClip("inventoryItems","moduleRelatedOverlays");
         this.greaterThanSymbol = AssetProxy.getMovieClip("scrollComponents","greaterThan");
         this.disabledSprite = AssetProxy.getMovieClip("inventoryItems","disabledSlot");
         addChild(this.itemBorder);
         addChild(this.itemSprite);
         this.itemHover.alpha = 0;
         addChild(this.itemHover);
         TweenMax.to(this.itemHover,0.5,{"colorMatrixFilter":{
            "amount":1,
            "brightness":2
         }});
         this.setChildIndex(this.itemHover,this.numChildren - 1);
         this.bitmapFont = new BitmapFont();
         this.bitmapFont.x = this.itemGraphic.height - this.bitmapFont.height;
         this.bitmapFont.y = this.itemGraphic.width - this.bitmapFont.width;
         this.levelFont = new BitmapFont();
         this.levelFont.changeFontColour(BitmapFont.BLUE);
         this.levelFont.x = this.itemGraphic.width - this.bitmapFont.width;
         this.levelFont.y = this.itemGraphic.height - this.bitmapFont.height;
         this.quantityField = new TextField();
         this.quantityField.height = 20;
         this.quantityField.width = 25;
         this.quantityField.selectable = false;
         this.quantityField.y = this.itemGraphic.height - this.quantityField.height;
         this.quantityField.x = this.itemGraphic.width - this.quantityField.width;
         this.quantityField.textColor = 16777215;
         this.quantityField.embedFonts = Styles.baseEmbed;
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.size = 10;
         _loc1_.align = TextFormatAlign.RIGHT;
         this.quantityField.setTextFormat(_loc1_);
         this.useHandCursor = true;
         this.buttonMode = true;
         this.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         this.setChildIndex(this.itemHover,this.numChildren - 1);
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         TweenMax.to(this.itemHover,0.4,{"alpha":1});
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         this.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         TweenMax.to(this.itemHover,0.4,{"alpha":0});
      }
      
      public function addUnlockableSlotIcon() : void
      {
         var _loc1_:TooltipControl = TooltipControl.getInstance();
         this.unlockableSlotIcon = AssetProxy.getMovieClip("scrollComponents","lockedSlot");
         this.unlockableSlotIcon.x = this.unlockableSlotIcon.y = 2;
         addChild(this.unlockableSlotIcon);
         this.buyableExtraSlot = true;
      }
      
      public function removeUnlockableSlotIcon() : void
      {
         var _loc1_:TooltipControl = TooltipControl.getInstance();
         if(contains(this.unlockableSlotIcon))
         {
            removeChild(this.unlockableSlotIcon);
            _loc1_.removeToolTip(this);
         }
         this.buyableExtraSlot = false;
      }
      
      public function checkEquippedStatus() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         while(_loc2_ < this.equippedInConfigs.length)
         {
            if(this.equippedInConfigs[_loc2_])
            {
               _loc1_ = true;
            }
            _loc2_++;
         }
         if(_loc1_)
         {
            this.setEquipped();
         }
         else
         {
            this.setUnEquipped();
         }
      }
      
      public function setEquipped() : void
      {
         addChild(this.equippedSprite);
      }
      
      public function setUnEquipped() : void
      {
         if(contains(this.equippedSprite))
         {
            removeChild(this.equippedSprite);
         }
      }
      
      public function toggleSelected() : void
      {
         if(this.isSelected())
         {
            this.setDeselected();
         }
         else
         {
            this.setSelected();
         }
      }
      
      public function isSelected() : Boolean
      {
         return this.selected;
      }
      
      public function setSelected() : void
      {
         this.selected = true;
         TweenMax.to(this.itemBorder,0.15,{"colorTransform":{
            "tint":16766515,
            "tintAmount":1
         }});
         this.equippedSprite.gotoAndStop(2);
      }
      
      public function setDeselected() : void
      {
         this.selected = false;
         TweenMax.to(this.itemBorder,0.15,{"colorTransform":{
            "tint":16766515,
            "tintAmount":0
         }});
         this.equippedSprite.gotoAndStop(1);
      }
      
      public function setQuantityValue(param1:Number) : void
      {
         var _loc2_:TooltipControl = null;
         var _loc3_:ToolTipHook = null;
         var _loc4_:int = 0;
         if(param1 != 0 && param1 > 1)
         {
            _loc2_ = TooltipControl.getInstance();
            _loc3_ = _loc2_.getInventoryItemToolTip(this);
            if(_loc3_ != null)
            {
               _loc3_.setQuantity(param1);
               _loc3_.updateText();
            }
            this.bitmapFont.setText(String(param1));
            this.bitmapFont.y = this.itemGraphic.height - this.bitmapFont.height - 3;
            this.bitmapFont.x = this.itemGraphic.width - this.bitmapFont.width - 3;
            this.quantity = param1;
            if(this.bitmapFont.useGreaterThanSymbol)
            {
               if(!this.contains(this.greaterThanSymbol))
               {
                  this.addChild(this.greaterThanSymbol);
                  this.greaterThanSymbol.x = this.bitmapFont.x - this.greaterThanSymbol.width;
                  this.greaterThanSymbol.y = this.bitmapFont.y;
               }
            }
            else if(contains(this.greaterThanSymbol))
            {
               removeChild(this.greaterThanSymbol);
            }
            if(!this.contains(this.bitmapFont))
            {
               this.addChild(this.bitmapFont);
            }
            this.setChildIndex(this.bitmapFont,this.numChildren - 1);
            _loc4_ = this.getChildIndex(this.itemSprite);
            if(this.contains(this.greaterThanSymbol))
            {
               this.setChildIndex(this.greaterThanSymbol,_loc4_ + 1);
            }
         }
      }
      
      public function getLevel() : int
      {
         return this.levelValue;
      }
      
      public function hasXModifier() : Boolean
      {
         return this._hasPetGearXModifier;
      }
      
      public function setLevelText(param1:int, param2:String = "") : void
      {
         this.levelValue = param1;
         if(param1 > 0)
         {
            this.levelFont.setText(String(param1),param2);
            this.levelFont.x = 3;
            this.levelFont.y = 3;
            if(!this.contains(this.levelFont))
            {
               this.addChild(this.levelFont);
            }
         }
         else
         {
            this.removeLevelText();
         }
      }
      
      public function setLevelTextWithModifier(param1:int) : void
      {
         this._hasPetGearXModifier = true;
         this.setLevelText(param1,"X");
      }
      
      public function removeLevelText() : void
      {
         if(this.contains(this.levelFont))
         {
            this.removeChild(this.levelFont);
         }
      }
      
      public function removeQuantityOverlay() : void
      {
         if(contains(this.bitmapFont))
         {
            removeChild(this.bitmapFont);
         }
         if(contains(this.greaterThanSymbol))
         {
            removeChild(this.greaterThanSymbol);
         }
      }
      
      public function changeGraphic(param1:String, param2:String = "_30x30") : void
      {
         if(param1 == null)
         {
            param1 = "empty";
         }
         this.itemName = param1;
         this.lowerCaseName = param1.toLowerCase() + param2;
         this.updateToolTipAndOverlay();
         if(param1 != "empty")
         {
            if(contains(this.itemGraphic))
            {
               removeChild(this.itemGraphic);
            }
            AssetProxy.lazyGetAsset(this.lowerCaseName,this.handleIconLoaded,this.handleIconLoadError);
         }
         else
         {
            if(contains(this.itemSprite))
            {
               removeChild(this.itemSprite);
            }
            this.setDeselected();
         }
         if(contains(this.bitmapFont))
         {
            this.setChildIndex(this.bitmapFont,this.numChildren - 1);
         }
      }
      
      private function handleIconLoaded(param1:FileCollectionFinisher = null) : void
      {
         if(this.itemSprite.contains(this.currentGraphicBitmap))
         {
            this.itemSprite.removeChild(this.currentGraphicBitmap);
         }
         var _loc2_:Bitmap = Bitmap(AssetProxy.getImage(this.lowerCaseName));
         var _loc3_:BitmapData = _loc2_.bitmapData;
         var _loc4_:BitmapData = _loc3_.clone();
         this.currentGraphicBitmap = new Bitmap(_loc4_);
         this.itemSprite.addChild(this.currentGraphicBitmap);
         addChild(this.itemSprite);
         if(contains(this.equippedSprite))
         {
            setChildIndex(this.equippedSprite,this.numChildren - 1);
         }
         this.itemSprite.x = this.itemSprite.y = 2;
         if(contains(this.bitmapFont))
         {
            this.setChildIndex(this.bitmapFont,this.numChildren - 1);
         }
         if(contains(this.greaterThanSymbol))
         {
            this.setChildIndex(this.greaterThanSymbol,this.numChildren - 1);
         }
         if(this.contains(this.levelFont))
         {
            this.setChildIndex(this.levelFont,this.numChildren - 1);
         }
         if(this.moduleInstalledIcon)
         {
            if(this.contains(this.moduleInstalledIcon))
            {
               this.setChildIndex(this.moduleInstalledIcon,this.numChildren - 1);
            }
         }
         if(this.moduleUnusableIcon)
         {
            if(this.contains(this.moduleUnusableIcon))
            {
               this.setChildIndex(this.moduleUnusableIcon,this.numChildren - 1);
            }
         }
         if(this.contains(this.moduleRelatedOverlays))
         {
            if(this.contains(this.moduleRelatedOverlays))
            {
               this.setChildIndex(this.moduleRelatedOverlays,this.numChildren - 1);
            }
         }
         this.updateToolTipAndOverlay();
      }
      
      private function handleIconLoadError() : void
      {
      }
      
      public function addStackUnderlay() : void
      {
         this.stackGraphic = AssetProxy.getMovieClip("inventoryItems","stack");
         addChild(this.stackGraphic);
         this.setChildIndex(this.stackGraphic,0);
      }
      
      public function removeStackUnderlay() : void
      {
         if(this.contains(this.stackGraphic))
         {
            removeChild(this.stackGraphic);
         }
      }
      
      public function setModuleInstalledState(param1:Boolean) : void
      {
         this.moduleInstalledIcon = AssetProxy.getMovieClip("inventoryItems","equippedSlot");
         if(param1)
         {
            if(this.contains(this.moduleInstalledIcon) == false)
            {
               addChild(this.moduleInstalledIcon);
            }
            this.setChildIndex(this.moduleInstalledIcon,this.numChildren - 1);
         }
         else if(this.contains(this.moduleInstalledIcon))
         {
            removeChild(this.moduleInstalledIcon);
         }
      }
      
      public function setUnstableModuleRestriction(param1:Boolean) : void
      {
         this.moduleUnusableIcon = AssetProxy.getMovieClip("inventoryItems","disabledSlot");
         if(param1)
         {
            if(this.contains(this.moduleUnusableIcon) == false)
            {
               addChild(this.moduleUnusableIcon);
            }
            this.setChildIndex(this.moduleUnusableIcon,this.numChildren - 1);
         }
         else if(this.contains(this.moduleUnusableIcon))
         {
            removeChild(this.moduleUnusableIcon);
         }
      }
      
      public function setContenActivation(param1:Boolean) : void
      {
         var _loc2_:Number = param1 ? 1 : 0;
         this.itemSprite.alpha = _loc2_;
         this.bitmapFont.alpha = _loc2_;
         this.greaterThanSymbol.alpha = _loc2_;
         this.levelFont.alpha = _loc2_;
         if(this.visualLetter)
         {
            this.visualLetter.alpha = _loc2_;
         }
         if(this.statsLetter)
         {
            this.statsLetter.alpha = _loc2_;
         }
         if(this.moduleRelatedOverlays)
         {
            this.moduleRelatedOverlays.alpha = _loc2_;
         }
         if(this.moduleInstalledIcon)
         {
            this.moduleInstalledIcon.alpha = _loc2_;
         }
         if(this.moduleUnusableIcon)
         {
            this.moduleUnusableIcon.alpha = _loc2_;
         }
         if(param1 && !this.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            this.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         }
         this.canBeSelected = param1;
      }
      
      public function setModuleHitpointState(param1:int) : void
      {
         var _loc2_:int = param1 >= 25 && param1 <= 100 ? int(HEALTH_NORMAL) : -1;
         _loc2_ = param1 >= 1 && param1 <= 24 ? int(HEALTH_CRITICAL) : _loc2_;
         _loc2_ = param1 == 0 ? int(HEALTH_DESTROYED) : _loc2_;
         switch(_loc2_)
         {
            case HEALTH_NORMAL:
               this.showHealthStateLayer(HEALTH_NORMAL);
               break;
            case HEALTH_CRITICAL:
               this.showHealthStateLayer(HEALTH_CRITICAL);
               break;
            case HEALTH_DESTROYED:
               this.showHealthStateLayer(HEALTH_DESTROYED);
               break;
            case -1:
               this.clearModuleHitpointState();
         }
      }
      
      public function clearModuleHitpointState() : void
      {
         if(this.contains(this.moduleRelatedOverlays))
         {
            this.removeChild(this.moduleRelatedOverlays);
         }
      }
      
      protected function showHealthStateLayer(param1:uint) : void
      {
         if(this.contains(this.moduleRelatedOverlays) == false)
         {
            this.addChild(this.moduleRelatedOverlays);
         }
         this.setChildIndex(this.moduleRelatedOverlays,this.numChildren - 1);
         switch(param1)
         {
            case HEALTH_CRITICAL:
               this.moduleRelatedOverlays.gotoAndStop(2);
               break;
            case HEALTH_DESTROYED:
               this.moduleRelatedOverlays.gotoAndStop(3);
               break;
            case HEALTH_NORMAL:
            default:
               this.moduleRelatedOverlays.gotoAndStop(1);
         }
      }
      
      protected function getGroupBaseName() : String
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         if(this.group)
         {
            _loc1_ = this.group.split("_");
            _loc2_ = _loc1_[0];
            if(_loc2_)
            {
               return _loc2_.toLowerCase();
            }
            return UNDEFINED_GROUP_NAME;
         }
         return UNDEFINED_GROUP_NAME;
      }
      
      public function isModule() : Boolean
      {
         var _loc1_:String = this.getGroupBaseName();
         return _loc1_ == ActionIdentifiers.MODULE ? true : false;
      }
      
      private function isModuleInstalled() : Boolean
      {
         var _loc2_:ItemInstanceVO = null;
         var _loc1_:Boolean = false;
         if(this.isModule())
         {
            _loc2_ = this.getItemInstanceData();
            if(_loc2_)
            {
               if(_loc2_.moduleInstalled)
               {
                  _loc1_ = true;
               }
            }
         }
         return _loc1_;
      }
      
      public function isBuyable() : Boolean
      {
         if(notBuyableNames.indexOf(this.itemName) != -1)
         {
            return false;
         }
         if(this.isResource())
         {
            return false;
         }
         if(Boolean(this.itemName) && this.itemName.indexOf(ActionIdentifiers.LF4) == 0)
         {
            return false;
         }
         if(this.group == DataInterchange.DRONE_DESIGN_STATS_TYPE_CLASS || this.group == DataInterchange.DRONE_DESIGN_VISUAL_TYPE_CLASS)
         {
            return false;
         }
         if(this.group == DataInterchange.PET_DESIGN_STATS_TYPE_CLASS || this.group == DataInterchange.PET_DESIGN_VISUAL_TYPE_CLASS)
         {
            return false;
         }
         if(this.isLotteryItem())
         {
            return false;
         }
         if(this.isWordPuzzleItem())
         {
            return false;
         }
         if(this.isResourceDronePart())
         {
            return false;
         }
         return true;
      }
      
      public function isSellable() : Boolean
      {
         if(this.isModuleInstalled())
         {
            return false;
         }
         return true;
      }
      
      public function isResource() : Boolean
      {
         var _loc1_:String = this.getGroupBaseName();
         return _loc1_ == ActionIdentifiers.RESOURCE ? true : false;
      }
      
      public function isLotteryItem() : Boolean
      {
         return Boolean(this.itemName) && this.itemName.indexOf("lottery") >= 0 ? true : false;
      }
      
      public function isWordPuzzleItem() : Boolean
      {
         return Boolean(this.lootID) && Boolean(this.lootID.indexOf("wordpuzzle") >= 0) || Boolean(this.itemName) && Boolean(this.itemName.indexOf("wordpuzzle") >= 0) ? true : false;
      }
      
      public function isResourceDronePart() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.itemName)
         {
            if(this.itemName.indexOf("apis-part") >= 0 || this.itemName.indexOf("zeus-part") >= 0)
            {
               _loc1_ = true;
            }
         }
         return _loc1_;
      }
      
      public function getItemInstanceData() : ItemInstanceVO
      {
         return Inventory.getInstance().getItem(this.itemID);
      }
      
      public function clone() : InventoryItemComponent
      {
         registerClassAlias("net.bigpoint.darkorbit.equipment.view.components.items",InventoryItemComponent);
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeObject(this);
         _loc1_.position = 0;
         return _loc1_.readObject() as InventoryItemComponent;
      }
      
      public function initEmptySlotData(param1:String, param2:String) : void
      {
         this._emptySlotGroup = param1;
         if(param2)
         {
            this._emptyToolTipHook = new ToolTipHook(this,BPLocale.getItem(param2));
         }
         this.updateToolTipAndOverlay();
      }
      
      private function updateToolTipAndOverlay() : void
      {
         var _loc1_:String = this._emptySlotGroup;
         if(Boolean(this._group) && this._group != ItemFilter.EMPTY_SPACE_FILTER)
         {
            _loc1_ = this._group;
            if(this._emptyToolTipHook)
            {
               this._emptyToolTipHook.hide2();
               this._emptyToolTipHook.removeListeners();
            }
         }
         else if(this._emptyToolTipHook)
         {
            this._emptyToolTipHook.setBounds(TooltipControl.getInstance().getBounds());
            this._emptyToolTipHook.addListeners();
         }
         if(_loc1_ == DataInterchange.DRONE_DESIGN_VISUAL_TYPE_CLASS || _loc1_ == DataInterchange.PET_DESIGN_VISUAL_TYPE_CLASS)
         {
            if(!this.visualLetter)
            {
               this.visualLetter = this.createLetterField("C",8978312);
            }
            this.addChild(this.visualLetter);
            this.visualLetter.alpha = this.itemSprite.alpha;
         }
         else if(Boolean(this.visualLetter) && this.visualLetter.parent == this)
         {
            this.removeChild(this.visualLetter);
            this.visualLetter = null;
         }
         if(_loc1_ == DataInterchange.DRONE_DESIGN_STATS_TYPE_CLASS || _loc1_ == DataInterchange.PET_DESIGN_STATS_TYPE_CLASS)
         {
            if(!this.statsLetter)
            {
               this.statsLetter = this.createLetterField("S",16746632);
            }
            this.addChild(this.statsLetter);
            this.statsLetter.alpha = this.itemSprite.alpha;
         }
         else if(Boolean(this.statsLetter) && this.statsLetter.parent == this)
         {
            this.removeChild(this.statsLetter);
            this.statsLetter = null;
         }
      }
      
      private function createLetterField(param1:String, param2:uint) : TextField
      {
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.size = 8;
         var _loc4_:TextField = new TextField();
         _loc4_.defaultTextFormat = _loc3_;
         _loc4_.textColor = param2;
         _loc4_.text = param1;
         _loc4_.mouseEnabled = false;
         _loc4_.filters = [new DropShadowFilter(1,45,0.75,1,1,1,2)];
         _loc4_.antiAliasType = AntiAliasType.NORMAL;
         _loc4_.width = 16;
         _loc4_.height = 12;
         _loc4_.x = 2;
         return _loc4_;
      }
      
      public function get group() : String
      {
         return this._group;
      }
      
      public function set group(param1:String) : void
      {
         if(this._group != param1)
         {
            this._group = param1;
            this.updateToolTipAndOverlay();
         }
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         super.addEventListener(param1,param2,param3,param4,true);
         this._eventListenerTracking[param2] = param1;
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         super.removeEventListener(param1,param2,param3);
         delete this._eventListenerTracking[param2];
      }
      
      public function dispose() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Function = null;
         DragComponent.getInstance().removeDraggableIcon(this);
         TooltipControl.getInstance().removeToolTip(this);
         DisplayObjectHelper.removeDisplayObject(this);
         this.menuSectionComponent = null;
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         for(_loc1_ in this._eventListenerTracking)
         {
            _loc2_ = _loc1_ as Function;
            if(Boolean(_loc2_))
            {
               this.removeEventListener(this._eventListenerTracking[_loc2_],_loc2_);
               delete this._eventListenerTracking[_loc2_];
            }
         }
      }
      
      public function get multiSellItem() : Boolean
      {
         return this._multiSellItem;
      }
      
      public function set multiSellItem(param1:Boolean) : void
      {
         this._multiSellItem = param1;
      }
      
      public function get setBonus() : Boolean
      {
         return this._setBonus;
      }
      
      public function get setBonusActive() : Boolean
      {
         return this._setBonusActive;
      }
      
      public function set setBonusActive(param1:Boolean) : void
      {
         this._setBonusActive = param1;
      }
      
      public function get setBonusAmt() : int
      {
         return this._setBonusAmt;
      }
      
      public function get hideSetBonusTooltipText() : Boolean
      {
         return this._hideSetBonusTooltipText;
      }
      
      public function set hideSetBonusTooltipText(param1:Boolean) : void
      {
         this._hideSetBonusTooltipText = param1;
      }
      
      public function updateSetBonus(param1:Boolean, param2:Boolean = false, param3:int = 0) : void
      {
         this._setBonus = param1;
         this._setBonusActive = param2;
         this._setBonusAmt = param3 > 0 ? param3 : 0;
         this._hideSetBonusTooltipText = false;
      }
   }
}

