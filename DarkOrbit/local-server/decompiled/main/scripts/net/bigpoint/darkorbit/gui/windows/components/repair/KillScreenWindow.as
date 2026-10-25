package net.bigpoint.darkorbit.gui.windows.components.repair
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.com.module.KillScreenOptionTypeModule;
   import net.bigpoint.darkorbit.com.module.PriceModule;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.ButtonElementTypes;
   import net.bigpoint.darkorbit.gui.elements.TextAreaElement;
   import net.bigpoint.darkorbit.gui.killscreen.vos.KillscreenOptionVO;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.net.netty.handlers.KillScreenOptionHandler;
   
   public class KillScreenWindow extends Sprite
   {
      
      private var repairWindow:MovieClip;
      
      private var optionContainer:Sprite;
      
      private var repairBtn:ButtonElement;
      
      private var logoutBtn:ButtonElement;
      
      private var title:TextField;
      
      private var detail:TextAreaElement;
      
      private var description:TextField;
      
      public var killerName:TextField;
      
      private var destruction:TextField;
      
      private var _options:Array;
      
      private var clickLayer:Sprite;
      
      private var _optionVOs:Vector.<KillscreenOptionVO> = new Vector.<KillscreenOptionVO>();
      
      public function KillScreenWindow(param1:Vector.<KillscreenOptionVO>)
      {
         super();
         this._optionVOs = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._options = [];
         this.repairWindow = new MovieClip();
         var _loc1_:Bitmap = ResourceManager.getBitmap("ui","repairBG");
         this.repairWindow.addChild(_loc1_);
         this.repairBtn = new ButtonElement(ButtonElementTypes.TYPE_REPAIR_BUTTON,"",ResourceManager.getMovieClip("ui","repairButtons"),Styles.repairWindowButtonFmt);
         this.logoutBtn = new ButtonElement(ButtonElementTypes.TYPE_LOGOUT_BUTTON,"",ResourceManager.getMovieClip("ui","repairLogoutButtons"));
         this.repairBtn.width = 229;
         this.repairBtn.height = 32;
         this.repairBtn.x = this.centerObject(this.repairBtn);
         this.repairBtn.y = 410;
         this.repairBtn.addEventListener(MouseEvent.CLICK,this.handleRepair);
         this.repairBtn.setButtonMode(true);
         this.repairBtn.alpha = 1;
         this.repairBtn.addButtonListeners();
         this.logoutBtn.width = 26;
         this.logoutBtn.height = 27;
         this.logoutBtn.x = 490;
         this.logoutBtn.y = 5;
         this.description = new TextField();
         this.description.selectable = false;
         this.description.defaultTextFormat = Styles.repairWindowDescFmt;
         this.description.embedFonts = Styles.repairWindowEmbed;
         this.description.autoSize = TextFieldAutoSize.CENTER;
         this.description.antiAliasType = AntiAliasType.ADVANCED;
         this.description.width = 300;
         this.description.x = this.centerObject(this.description);
         this.description.y = 115;
         this.detail = new TextAreaElement(400,100,TextFormatAlign.CENTER,false);
         this.detail.textArea.setStyle("textFormat",Styles.repairWindowDetailFmt);
         this.detail.textArea.setStyle("embedFonts",Styles.repairWindowEmbed);
         this.detail.textArea.setStyle("textPadding",0);
         this.detail.x = this.centerObject(this.detail.textArea);
         this.detail.y = 304;
         this.killerName = new TextField();
         this.killerName.defaultTextFormat = Styles.repairWindowKillerFmt;
         this.killerName.embedFonts = Styles.repairWindowEmbed;
         this.killerName.autoSize = TextFieldAutoSize.CENTER;
         this.killerName.x = this.centerObject(this.killerName);
         this.killerName.y = 90;
         this.title = new TextField();
         this.title.defaultTextFormat = Styles.repairWindowTitleFmt;
         this.title.embedFonts = Styles.repairWindowEmbed;
         this.title.selectable = false;
         this.title.autoSize = TextFieldAutoSize.CENTER;
         this.title.x = this.centerObject(this.title);
         this.title.y = 48;
         this.destruction = new TextField();
         this.optionContainer = new Sprite();
         this.repairWindow.addChild(this.repairBtn);
         this.repairWindow.addChild(this.logoutBtn);
         this.repairWindow.addChild(this.killerName);
         this.repairWindow.addChild(this.title);
         this.repairWindow.addChild(this.description);
         this.repairWindow.addChild(this.detail);
         this.repairWindow.addChild(this.destruction);
         this.repairWindow.addChild(this.optionContainer);
         addChild(this.repairWindow);
      }
      
      public function initListeners() : void
      {
         this.logoutBtn.addEventListener(MouseEvent.CLICK,this.handleLogout);
         this.logoutBtn.setButtonMode(true);
      }
      
      public function removeListeners() : void
      {
         var _loc1_:ButtonElement = null;
         this.logoutBtn.removeEventListener(MouseEvent.CLICK,this.handleLogout);
         for each(_loc1_ in this._options)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.handleOptionClicked);
            _loc1_.removeButtonListeners();
         }
      }
      
      private function handleOptionClicked(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._options.length)
         {
            if(param1.currentTarget == this._options[_loc2_])
            {
               this.selectOption(this._options[_loc2_] as ButtonElement);
            }
            else
            {
               (this._options[_loc2_] as ButtonElement).selected = false;
            }
            _loc2_++;
         }
      }
      
      private function selectOption(param1:ButtonElement) : void
      {
         param1.selected = true;
         dispatchEvent(new RepairEvent(RepairEvent.SET_SELECTED,param1.getType()));
      }
      
      private function handleRepair(param1:MouseEvent) : void
      {
         this.repairBtn.removeEventListener(MouseEvent.CLICK,this.handleRepair);
         this.repairBtn.removeButtonListeners();
         this.repairBtn.setButtonMode(false);
         dispatchEvent(new RepairEvent(RepairEvent.REPAIR));
      }
      
      private function centerObject(param1:Object) : Number
      {
         return this.repairWindow.width - param1["width"] >> 1;
      }
      
      private function centerTextFieldVertically(param1:TextField, param2:int, param3:int) : void
      {
         param1.y = param2 + (param3 - param1.height >> 1);
      }
      
      private function handleLogout(param1:MouseEvent = null) : void
      {
         dispatchEvent(new RepairEvent(RepairEvent.LOGOUT));
      }
      
      private function handleKillerNameClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new RepairEvent(RepairEvent.OPEN_PROFILE_PAGE));
      }
      
      private function removeCooldown(param1:ButtonElement) : void
      {
         param1.removeChild(param1.getChildByName("rect"));
         param1.removeChild(param1.getChildByName("mask"));
         param1.addEventListener(MouseEvent.CLICK,this.handleOptionClicked);
         param1.addButtonListeners();
         param1.setButtonMode(true);
         this._optionVOs[param1.getType()].cooldown = 0;
         var _loc2_:TweenLite = this._optionVOs[param1.getType()].cooldownTween;
         _loc2_.kill();
      }
      
      private function addCooldown(param1:ButtonElement) : void
      {
         var _loc2_:Bitmap = null;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         if(!(param1.getType() == KillScreenOptionTypeModule.OPTIONTYPE_AT_SECTOR_CONTROL_SPAWNPOINT || param1.getType() == KillScreenOptionTypeModule.OPTIONTYPE_RAID_GATE_REPAIR || param1.getType() == KillScreenOptionTypeModule.OPTIONTYPE_TDM_REPAIR || param1.getType() == KillScreenOptionTypeModule.OPTIONTYPE_STRIKE_AND_EXIT))
         {
            _loc2_ = ResourceManager.getBitmap("ui","icon_payment");
            _loc2_.name = "mask";
            _loc2_.x = _loc2_.y = 8;
            param1.addChild(_loc2_);
            _loc3_ = new Sprite();
            _loc3_.graphics.beginFill(296397482);
            _loc3_.graphics.drawRect(0,0,100,100);
            _loc3_.graphics.endFill();
            _loc4_ = new MovieClip();
            _loc4_.name = "rect";
            _loc4_.addChild(_loc3_);
            _loc4_.x = _loc4_.y = 8;
            _loc4_.cacheAsBitmap = true;
            _loc2_.cacheAsBitmap = true;
            param1.addChild(_loc4_);
            _loc4_.mask = _loc2_;
            param1.removeEventListener(MouseEvent.CLICK,this.handleOptionClicked);
            param1.removeButtonListeners();
            param1.setButtonMode(false);
            _loc5_ = this._optionVOs[param1.getType()].cooldown;
            this._optionVOs[param1.getType()].cooldownTween = TweenLite.to(_loc4_,_loc5_,{
               "y":104,
               "alpha":0.53,
               "onComplete":this.removeCooldown,
               "onCompleteParams":[param1],
               "ease":Linear.easeNone(_loc5_,8,96,_loc5_ + 4)
            });
         }
      }
      
      private function disableOption(param1:ButtonElement, param2:KillscreenOptionVO) : void
      {
         var _loc4_:Bitmap = null;
         var _loc3_:Boolean = param2.currency == KillScreenOptionHandler.getCurrencyByPriceModule(PriceModule.CURRENCYTYPE_CREDITS);
         if(_loc3_)
         {
            this._optionVOs[5].detailText = BPLocale.getItem("desc_killscreen_repair_credits_impossible");
         }
         else
         {
            _loc4_ = ResourceManager.getBitmap("ui","icon_payment");
            param1.addChild(_loc4_);
            _loc4_.x = 8;
            _loc4_.y = 8;
            param1.setChildIndex(_loc4_,param1.numChildren - 2);
            this._optionVOs[5].detailText = BPLocale.getItem("desc_killscreen_repair_impossible");
         }
         this._optionVOs[5].buttonKey = param2.buttonKey;
         this._optionVOs[5].tooltip = param2.tooltip;
         this._optionVOs[5].currency = param2.currency;
         param1.setType(5);
      }
      
      public function setOptionTypes(param1:Array) : void
      {
         var _loc4_:ButtonElement = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new ButtonElement(param1[_loc3_],"",ResourceManager.getMovieClip("ui","repairOptions"),Styles.repairWindowPriceFmt);
            _loc4_.addEventListener(MouseEvent.CLICK,this.handleOptionClicked);
            _loc4_.icon = ResourceManager.getBitmap("ui",this._optionVOs[param1[_loc3_]].graphic);
            _loc4_.x = 150 * _loc3_;
            _loc4_.y = 150;
            if(this._optionVOs[param1[_loc3_]].repairCost > 0)
            {
               switch(this._optionVOs[param1[_loc3_]].priceType)
               {
                  case PriceModule.CURRENCYTYPE_CREDITS:
                     _loc4_.labelText = BPLocale.getItem("pricetag_credits_compact").replace(/%VALUE%/,TextFormatter.roundInteger(this._optionVOs[param1[_loc3_]].repairCost));
                     break;
                  case PriceModule.CURRENCYTYPE_URIDIUM:
                  default:
                     _loc4_.labelText = BPLocale.getItem("pricetag_uridium_compact").replace(/%VALUE%/,TextFormatter.roundInteger(this._optionVOs[param1[_loc3_]].repairCost));
               }
            }
            else
            {
               _loc4_.labelText = BPLocale.getItem("pricetag_killscreen_free");
            }
            _loc4_.changeTextColour(this._optionVOs[param1[_loc3_]].priceColor);
            _loc4_.setTextPosY(118);
            _loc4_.width = 116;
            _loc4_.height = 150;
            this._options.push(_loc4_);
            TooltipControl.getInstance().addToolTip(_loc4_,BPLocale.getItem(this._optionVOs[param1[_loc3_]].tooltip));
            this.optionContainer.addChild(_loc4_);
            if(this._optionVOs[param1[_loc3_]].affordable == false)
            {
               this.disableOption(_loc4_,this._optionVOs[param1[_loc3_]]);
            }
            else if(this._optionVOs[param1[_loc3_]].cooldown > 0)
            {
               this.addCooldown(_loc4_);
            }
            _loc3_++;
         }
         if(this._options.length > 0)
         {
            this.selectOption(this._options[0]);
         }
         this.optionContainer.x = this.centerObject(this.optionContainer);
         this.setLogoutTooltipText();
         this.setDefaultSelected();
      }
      
      private function setLogoutTooltipText() : void
      {
         if(this.hasOptionType(KillScreenOptionTypeModule.OPTIONTYPE_AT_SECTOR_CONTROL_SPAWNPOINT))
         {
            TooltipControl.getInstance().addToolTip(this.logoutBtn,BPLocale.getItem("ttip_killscreen_logout_spawnpoint"));
         }
         else if(this.hasOptionType(KillScreenOptionTypeModule.OPTIONTYPE_RAID_GATE_REPAIR))
         {
            TooltipControl.getInstance().addToolTip(this.logoutBtn,BPLocale.getItem("ttip_killscreen_logout_hadesgate"));
         }
         else if(this.hasOptionType(KillScreenOptionTypeModule.OPTIONTYPE_TDM_REPAIR))
         {
            TooltipControl.getInstance().addToolTip(this.logoutBtn,BPLocale.getItem("ttip_killscreen_logout_tdm"));
         }
         else if(this.hasOptionType(KillScreenOptionTypeModule.OPTIONTYPE_STRIKE_AND_EXIT))
         {
            TooltipControl.getInstance().addToolTip(this.logoutBtn,BPLocale.getItem("ttip_killscreen_logout_sae"));
         }
         else if(this.hasOptionType(KillScreenOptionTypeModule.OPTIONTYPE_AT_JUMPGATE_REPAIR) && this.hasOptionType(KillScreenOptionTypeModule.OPTIONTYPE_AT_DEATHLOCATION_REPAIR))
         {
            TooltipControl.getInstance().addToolTip(this.logoutBtn,BPLocale.getItem("ttip_killscreen_logout_1"));
         }
         else
         {
            TooltipControl.getInstance().addToolTip(this.logoutBtn,BPLocale.getItem("ttip_logout"));
         }
      }
      
      private function setDefaultSelected() : void
      {
         var _loc1_:ButtonElement = null;
         if(this.hasOptionType(KillScreenOptionTypeModule.OPTIONTYPE_AT_SECTOR_CONTROL_SPAWNPOINT))
         {
            _loc1_ = this.getOptionByType(KillScreenOptionTypeModule.OPTIONTYPE_AT_SECTOR_CONTROL_SPAWNPOINT);
         }
         else if(this.hasOptionType(KillScreenOptionTypeModule.OPTIONTYPE_RAID_GATE_REPAIR))
         {
            _loc1_ = this.getOptionByType(KillScreenOptionTypeModule.OPTIONTYPE_RAID_GATE_REPAIR);
         }
         else if(this.hasOptionType(KillScreenOptionTypeModule.OPTIONTYPE_TDM_REPAIR))
         {
            _loc1_ = this.getOptionByType(KillScreenOptionTypeModule.OPTIONTYPE_TDM_REPAIR);
         }
         else if(this.hasOptionType(KillScreenOptionTypeModule.OPTIONTYPE_WAR_GAME_REPAIR))
         {
            _loc1_ = this.getOptionByType(KillScreenOptionTypeModule.OPTIONTYPE_WAR_GAME_REPAIR);
         }
         else if(this.hasOptionType(KillScreenOptionTypeModule.OPTIONTYPE_BASIC_REPAIR))
         {
            _loc1_ = this.getOptionByType(KillScreenOptionTypeModule.OPTIONTYPE_BASIC_REPAIR);
         }
         else if(this.hasOptionType(KillScreenOptionTypeModule.OPTIONTYPE_FREE_PHOENIX))
         {
            _loc1_ = this.getOptionByType(KillScreenOptionTypeModule.OPTIONTYPE_FREE_PHOENIX);
         }
         else
         {
            if(!this.hasOptionType(KillScreenOptionTypeModule.OPTIONTYPE_STRIKE_AND_EXIT))
            {
               return;
            }
            _loc1_ = this.getOptionByType(KillScreenOptionTypeModule.OPTIONTYPE_STRIKE_AND_EXIT);
         }
         _loc1_.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function hasOptionType(param1:int) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:ButtonElement = null;
         for each(_loc3_ in this._options)
         {
            if(_loc3_.getType() == param1)
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }
      
      private function getOptionByType(param1:int) : ButtonElement
      {
         var _loc2_:ButtonElement = null;
         for each(_loc2_ in this._options)
         {
            if(_loc2_.getType() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function removeOptionTypes() : void
      {
         var _loc1_:ButtonElement = null;
         this.removeListeners();
         this.removeTooltips();
         this.initListeners();
         for each(_loc1_ in this._options)
         {
            this.optionContainer.removeChild(_loc1_);
         }
         this._options = [];
      }
      
      public function setTitle(param1:String) : void
      {
         this.title.text = param1;
      }
      
      public function setDescription(param1:String) : void
      {
         this.description.text = param1;
      }
      
      public function setDetailText(param1:String) : void
      {
         this.detail.textArea.htmlText = param1;
         this.detail.textArea.verticalScrollPosition = this.detail.textArea.maxVerticalScrollPosition;
      }
      
      public function setRepairButtonText(param1:String, param2:String) : void
      {
         this.enableRepairButton();
         this.repairBtn.labelText = param1;
         this.repairBtn.setTextPosY(5);
         this.repairBtn.width = 229;
         this.repairBtn.height = 32;
         this.repairBtn.x = this.centerObject(this.repairBtn);
         TooltipControl.getInstance().addToolTip(this.repairBtn,param2);
      }
      
      public function setDestructionText(param1:String, param2:String, param3:Boolean) : void
      {
         this.destruction.defaultTextFormat = Styles.repairWindowDescFmt;
         this.destruction.embedFonts = Styles.repairWindowEmbed;
         this.destruction.text = param1;
         this.killerName.text = param2;
         if(param3)
         {
            this.clickLayer = new Sprite();
            this.clickLayer.graphics.beginFill(16711680);
            this.clickLayer.graphics.drawRect(0,0,this.killerName.width,this.killerName.height);
            this.clickLayer.alpha = 0;
            this.clickLayer.addEventListener(MouseEvent.CLICK,this.handleKillerNameClicked);
            this.clickLayer.buttonMode = true;
            this.clickLayer.x = this.killerName.x;
            this.clickLayer.y = this.killerName.y;
            this.repairWindow.addChild(this.clickLayer);
         }
         this.killerName.selectable = param3;
         this.destruction.selectable = false;
         this.destruction.autoSize = TextFieldAutoSize.CENTER;
         this.destruction.x = this.centerObject(this.destruction);
         this.destruction.y = 70;
      }
      
      public function removeTooltips() : void
      {
         TooltipControl.getInstance().removeToolTip(this.repairBtn);
         TooltipControl.getInstance().removeToolTip(this.logoutBtn);
         var _loc1_:int = 0;
         while(_loc1_ < this._options.length)
         {
            TooltipControl.getInstance().removeToolTip(this._options[_loc1_]);
            _loc1_++;
         }
      }
      
      public function disableRepairButton() : void
      {
         this.repairBtn.visible = false;
      }
      
      public function enableRepairButton() : void
      {
         this.repairBtn.visible = true;
      }
      
      public function cleanup() : void
      {
         this.removeListeners();
         this.setDetailText("");
         this.disableRepairButton();
      }
   }
}

