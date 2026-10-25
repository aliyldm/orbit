package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.IGalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core.CompositeView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.elements.MultiplierProgress;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.MultiplierEvent;
   
   public class MultiplierView extends CompositeView
   {
      
      private var bg:Bitmap;
      
      private var xOffset:int = 0;
      
      private var yOffset:int = 0;
      
      private var state:Boolean;
      
      private var checkBoxClip:MovieClip;
      
      private var multiplierMax:int = 5;
      
      private var _multiplierBtnsCurrent:Vector.<MovieClip> = new Vector.<MovieClip>(this.multiplierMax + 1,true);
      
      private var _multiplierBtnsStandard:Vector.<MovieClip> = new Vector.<MovieClip>(this.multiplierMax + 1,true);
      
      private var _multiplierBtnsDelta:Vector.<MovieClip> = new Vector.<MovieClip>(this.multiplierMax + 1,true);
      
      private var _multiplierBtnsEpsilon:Vector.<MovieClip> = new Vector.<MovieClip>(this.multiplierMax + 1,true);
      
      private var _multiplierBtnsZeta:Vector.<MovieClip> = new Vector.<MovieClip>(this.multiplierMax + 1,true);
      
      private var multiplierCurrent:int;
      
      private var _mode:int;
      
      private var inited:Boolean;
      
      private var progress:MultiplierProgress;
      
      public function MultiplierView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function update(param1:Event = null) : void
      {
         var _loc2_:String = param1.type;
         switch(_loc2_)
         {
            case MultiplierEvent.CHANGE:
               this.invalidate();
               break;
            case ApplicationEvent.INIT_COMPLETE:
               this.multiplierCurrent = (model as IGalaxyGateBuilderModel).getMultiplierValue();
               this.state = (model as IGalaxyGateBuilderModel).getMultiplierState();
               this.init();
               break;
            case ApplicationEvent.HOLD:
            case ApplicationEvent.RUN:
               break;
            case ApplicationEvent.STATE_EPSILON:
            case ApplicationEvent.STATE_ZETA:
            case ApplicationEvent.STATE_KAPPA:
            case ApplicationEvent.STATE_LAMBDA:
            case ApplicationEvent.STATE_ALPHA:
            case ApplicationEvent.STATE_BETA:
            case ApplicationEvent.STATE_GAMMA:
            case ApplicationEvent.STATE_DELTA:
            case ApplicationEvent.STATE_HADES:
            case ApplicationEvent.STATE_STREUNER:
               fadeIn();
               this.updateGate(_loc2_);
               break;
            case ApplicationEvent.STATE_KRONOS:
               fadeOut();
               this.updateGate(_loc2_);
         }
      }
      
      private function updateGate(param1:String) : void
      {
         this.setMode(parseMode(param1));
         this.invalidate();
      }
      
      private function setMode(param1:int) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = 0;
         while(_loc2_ <= this.multiplierMax)
         {
            this._multiplierBtnsStandard[_loc2_].visible = false;
            this._multiplierBtnsDelta[_loc2_].visible = false;
            this._multiplierBtnsEpsilon[_loc2_].visible = false;
            this._multiplierBtnsZeta[_loc2_].visible = false;
            _loc2_++;
         }
         if(param1 != this._mode)
         {
            this._mode = param1;
         }
         if(this._mode == GalaxyGateBuilderModel.STATE_ALPHA)
         {
            this._multiplierBtnsCurrent = this._multiplierBtnsStandard;
         }
         else if(this._mode == GalaxyGateBuilderModel.STATE_BETA)
         {
            this._multiplierBtnsCurrent = this._multiplierBtnsStandard;
         }
         else if(this._mode == GalaxyGateBuilderModel.STATE_GAMMA)
         {
            this._multiplierBtnsCurrent = this._multiplierBtnsStandard;
         }
         else if(this._mode == GalaxyGateBuilderModel.STATE_DELTA)
         {
            this._multiplierBtnsCurrent = this._multiplierBtnsDelta;
         }
         else if(this._mode == GalaxyGateBuilderModel.STATE_EPSILON)
         {
            this._multiplierBtnsCurrent = this._multiplierBtnsEpsilon;
         }
         else if(this._mode == GalaxyGateBuilderModel.STATE_ZETA)
         {
            this._multiplierBtnsCurrent = this._multiplierBtnsZeta;
         }
         _loc2_ = 0;
         while(_loc2_ <= this.multiplierMax)
         {
            this._multiplierBtnsCurrent[_loc2_].visible = true;
            _loc2_++;
         }
      }
      
      public function init() : void
      {
         var _loc2_:SWFFinisher = null;
         var _loc7_:MovieClip = null;
         var _loc1_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         _loc2_ = SWFFinisher(_loc1_.getLib("common"));
         this.bg = _loc2_.getEmbeddedBitmap("multiplier_bg");
         addChild(this.bg);
         this.checkBoxClip = _loc2_.getEmbeddedMovieClip("CheckBox");
         var _loc3_:TextField = this.checkBoxClip.getChildByName("txtLabel") as TextField;
         _loc3_.mouseEnabled = false;
         _loc3_.autoSize = TextFieldAutoSize.RIGHT;
         var _loc4_:TextFormat = Styles.ggBuilderPlainStdFmt;
         _loc4_.align = TextFormatAlign.RIGHT;
         _loc3_.defaultTextFormat = _loc4_;
         _loc3_.embedFonts = Styles.ggBuilderPlainStdEmbed;
         _loc3_.text = BPLocale.getItemInCategory("galaxyGates","label_activate_multiplier");
         var _loc5_:int = _loc3_.height;
         if(_loc5_ > 18)
         {
            _loc3_.y -= 8;
         }
         if(_loc5_ > 36)
         {
            _loc3_.y -= 8;
         }
         var _loc6_:MovieClip = this.checkBoxClip.getChildByName("checkbox") as MovieClip;
         _loc6_.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         _loc6_.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         _loc6_.addEventListener(MouseEvent.CLICK,this.handleMouseClick);
         _loc6_.buttonMode = true;
         _loc6_.gotoAndStop("std");
         _loc6_.getChildByName("checked").visible = this.state;
         this.checkBoxClip.x = this.xOffset + 60;
         this.checkBoxClip.y = this.yOffset + 17;
         addChild(this.checkBoxClip);
         var _loc8_:int = 0;
         while(_loc8_ <= this.multiplierMax)
         {
            _loc7_ = this.getMultiplierLight(_loc2_,"multiplier_std_btn",_loc8_);
            this._multiplierBtnsStandard[_loc8_] = _loc7_;
            addChild(_loc7_);
            _loc8_++;
         }
         _loc8_ = 0;
         while(_loc8_ <= this.multiplierMax)
         {
            _loc7_ = this.getMultiplierLight(_loc2_,"multiplier_std_btn",_loc8_);
            this._multiplierBtnsDelta[_loc8_] = _loc7_;
            addChild(_loc7_);
            _loc7_.visible = false;
            _loc8_++;
         }
         _loc8_ = 0;
         while(_loc8_ <= this.multiplierMax)
         {
            _loc7_ = this.getMultiplierLight(_loc2_,"multiplier_std_btn",_loc8_);
            this._multiplierBtnsEpsilon[_loc8_] = _loc7_;
            addChild(_loc7_);
            _loc7_.visible = false;
            _loc8_++;
         }
         _loc8_ = 0;
         while(_loc8_ <= this.multiplierMax)
         {
            _loc7_ = this.getMultiplierLight(_loc2_,"multiplier_std_btn",_loc8_);
            this._multiplierBtnsZeta[_loc8_] = _loc7_;
            addChild(_loc7_);
            _loc7_.visible = false;
            _loc8_++;
         }
         this._multiplierBtnsCurrent = this._multiplierBtnsStandard;
         var _loc9_:TextField = new TextField();
         _loc9_.defaultTextFormat = Styles.ggBuilderH2Fmt;
         _loc9_.text = BPLocale.getItemInCategory("galaxyGates","label_multiplier");
         _loc9_.embedFonts = Styles.ggBuilderH2Embed;
         _loc9_.height = Styles.ggBuilderH2FontHeight + 6;
         _loc9_.width = 262;
         _loc9_.selectable = false;
         _loc9_.x = this.xOffset;
         _loc9_.y = this.yOffset + 8;
         _loc9_.autoSize = TextFieldAutoSize.CENTER;
         _loc9_.cacheAsBitmap = true;
         addChild(_loc9_);
         var _loc10_:MovieClip = _loc2_.getEmbeddedMovieClip("headline_bg");
         var _loc11_:Sprite = new Sprite();
         _loc11_.graphics.beginFill(4278190080);
         _loc11_.graphics.drawRect(0,0,_loc10_.width,_loc10_.height);
         _loc11_.graphics.endFill();
         _loc11_.alpha = 0;
         _loc10_.addChild(_loc11_);
         _loc10_.width = _loc9_.width + 16;
         if(_loc10_.width < 130)
         {
            _loc10_.width = 130;
         }
         _loc10_.x = _loc9_.x - (_loc10_.width - _loc9_.width) * 0.5;
         _loc10_.y = _loc9_.y - 2;
         addChild(_loc10_);
         TooltipControl.getInstance().addToolTip(_loc10_,BPLocale.getItemInCategory("galaxyGates","label_multiplier_long"));
         this.progress = new MultiplierProgress();
         this.progress.init(this.multiplierMax);
         this.progress.x = 53;
         this.progress.y = 59;
         addChild(this.progress);
         this.inited = true;
         this.setValue();
      }
      
      private function getMultiplierLight(param1:SWFFinisher, param2:String, param3:int) : MovieClip
      {
         var _loc4_:MovieClip = param1.getEmbeddedMovieClip(param2);
         _loc4_.gotoAndStop("off");
         _loc4_.name = "multiplier" + (param3 + 1);
         _loc4_.x = this.xOffset + 20;
         _loc4_.y = this.yOffset + 30;
         var _loc5_:TextField = new TextField();
         _loc5_.defaultTextFormat = Styles.multiplierLightFmt;
         _loc5_.text = param3 > 0 ? "x" + String(param3 + 1) : "";
         _loc5_.embedFonts = Styles.multiplierLightEmbed;
         _loc5_.textColor = 10802175;
         _loc5_.width = 29;
         _loc5_.height = 21;
         _loc5_.antiAliasType = AntiAliasType.ADVANCED;
         var _loc6_:Bitmap = new Bitmap(new BitmapData(35,28,true,0));
         _loc6_.y = 0;
         _loc6_.bitmapData.draw(_loc5_);
         _loc4_.addChild(_loc6_);
         return _loc4_;
      }
      
      private function setValue() : void
      {
         var _loc1_:Number = 0;
         while(_loc1_ <= this.multiplierMax)
         {
            if(this.multiplierCurrent >= 0 && _loc1_ == this.multiplierCurrent)
            {
               this._multiplierBtnsCurrent[_loc1_].gotoAndStop("on");
               this._multiplierBtnsCurrent[_loc1_].visible = true;
            }
            else
            {
               this._multiplierBtnsCurrent[_loc1_].gotoAndStop("off");
               this._multiplierBtnsCurrent[_loc1_].visible = false;
            }
            _loc1_++;
         }
         this.progress.setValue(this.multiplierCurrent);
      }
      
      private function invalidate() : void
      {
         this.multiplierCurrent = (model as IGalaxyGateBuilderModel).getMultiplierValue();
         var _loc1_:Boolean = (model as IGalaxyGateBuilderModel).getMultiplierState();
         if(_loc1_ != this.state)
         {
            this.state = _loc1_;
         }
         if(this.inited)
         {
            this.setValue();
            (this.checkBoxClip.getChildByName("checkbox") as MovieClip).getChildByName("checked").visible = this.state;
         }
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         if(this.state == false && this.multiplierCurrent > 0)
         {
            this.state = true;
            (this.checkBoxClip.getChildByName("checkbox") as MovieClip).getChildByName("checked").visible = false;
         }
         else if(this.state && this.multiplierCurrent < 5)
         {
            this.state = false;
            (this.checkBoxClip.getChildByName("checkbox") as MovieClip).getChildByName("checked").visible = true;
         }
         getProxy().setMultiplierStateHandler(this.state);
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         (this.checkBoxClip.getChildByName("checkbox") as MovieClip).gotoAndStop("hover");
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         (this.checkBoxClip.getChildByName("checkbox") as MovieClip).gotoAndStop("std");
      }
   }
}

