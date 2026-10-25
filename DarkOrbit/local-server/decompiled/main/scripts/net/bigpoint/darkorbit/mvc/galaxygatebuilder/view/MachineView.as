package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.IGalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.OutputVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core.CompositeView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.elements.SpinAmountComboBox;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.MaterializeEvent;
   
   public class MachineView extends CompositeView
   {
      
      private const caseMinimizedPosY:int = 0;
      
      private const caseMaximizedPosY:int = 130;
      
      private var bg:Bitmap;
      
      private var materializerContainer:Sprite;
      
      private var materializerMask:Sprite;
      
      private var caseContainer:Sprite;
      
      private var minimizeBtn:MovieClip;
      
      private var maximizeBtn:MovieClip;
      
      private var stdEnergyBtn:MovieClip;
      
      private var energyBtn:MovieClip;
      
      private var spinOnSaleIcon:Bitmap;
      
      private var bonusSaleIcon:Bitmap;
      
      private var spinAmountCbo:SpinAmountComboBox;
      
      private var stdBackground:Bitmap;
      
      private var background:Bitmap;
      
      private var materializerEffect:MovieClip;
      
      private var ammunition:MovieClip;
      
      private var repairVoucher:MovieClip;
      
      private var resource:MovieClip;
      
      private var part:MovieClip;
      
      private var special:MovieClip;
      
      private var logfiles:MovieClip;
      
      private var _mode:int;
      
      private var energyCostVerbose:String;
      
      private var stdEnergyBtnLabel:TextField;
      
      private var _beamIsActivated:Boolean;
      
      public function MachineView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function update(param1:Event = null) : void
      {
         var _loc2_:String = param1.type;
         switch(_loc2_)
         {
            case ApplicationEvent.NUMBERS_UPDATE:
               this.updateEnergyCost();
               break;
            case MaterializeEvent.MATERIALIZE_NEW_OUTPUT:
               if((param1 as MaterializeEvent).fromCache)
               {
                  return;
               }
               this.updateOutput((param1 as MaterializeEvent).output);
               break;
            case ApplicationEvent.RUN:
            case MaterializeEvent.MATERIALIZE_ENABLE_ENERGY_BUTTON:
            case MaterializeEvent.MATERIALIZE_DUPLICATE_PART:
               this.enableEnergyBtn();
               break;
            case ApplicationEvent.INIT_COMPLETE:
               this.init();
               break;
            case ApplicationEvent.STATE_ALPHA:
            case ApplicationEvent.STATE_BETA:
            case ApplicationEvent.STATE_GAMMA:
            case ApplicationEvent.STATE_DELTA:
            case ApplicationEvent.STATE_EPSILON:
            case ApplicationEvent.STATE_ZETA:
            case ApplicationEvent.STATE_KAPPA:
            case ApplicationEvent.STATE_LAMBDA:
            case ApplicationEvent.STATE_HADES:
            case ApplicationEvent.STATE_STREUNER:
               fadeIn();
               this.setMode(parseMode(_loc2_));
               break;
            case ApplicationEvent.STATE_KRONOS:
               fadeOut();
               this.setMode(parseMode(_loc2_));
               break;
            case ApplicationEvent.SPIN_AMOUNT_UPDATE:
               this.updateSpinAmount();
               this.updateEnergyCost();
         }
      }
      
      private function setMode(param1:int) : void
      {
         this.stdEnergyBtn.visible = false;
         this.materializerEffect.visible = false;
         this.materializerEffect.stop();
         this.materializerEffect.enabled = false;
         this.stdBackground.visible = false;
         if(param1 != this._mode)
         {
            this._mode = param1;
         }
         this.energyBtn = this.stdEnergyBtn;
         this.background = this.stdBackground;
         this.materializerEffect.visible = true;
         this.materializerEffect.enabled = true;
         this.materializerEffect.play();
         this.energyBtn.visible = true;
         this.background.visible = true;
      }
      
      public function activateBeam(param1:Event = null) : void
      {
         if(this.isBeamActivated())
         {
            return;
         }
         this._beamIsActivated = true;
         if(this.materializerEffect)
         {
            this.materializerEffect.enabled = true;
            this.materializerEffect.play();
            TweenMax.killDelayedCallsTo(this.deactivateBeam);
            TweenMax.killDelayedCallsTo(this.stopBeamClipPlay);
         }
      }
      
      public function deactivateBeam(param1:Event = null) : void
      {
         if(!this.isBeamActivated())
         {
            return;
         }
         this._beamIsActivated = false;
         if(this.materializerEffect)
         {
            this.materializerEffect.enabled = false;
            TweenMax.killDelayedCallsTo(this.stopBeamClipPlay);
            TweenMax.delayedCall(2,this.stopBeamClipPlay);
         }
      }
      
      private function stopBeamClipPlay() : void
      {
         this.materializerEffect.gotoAndStop("loop");
      }
      
      private function updateOutput(param1:OutputVO) : void
      {
         var _loc2_:int = param1.category;
         switch(_loc2_)
         {
            case OutputVO.CAT_AMMUNITION:
               this.ammunition.gotoAndPlay("init");
               break;
            case OutputVO.CAT_RESOURCE:
               this.resource.gotoAndPlay("init");
               break;
            case OutputVO.CAT_VOUCHER:
               this.repairVoucher.gotoAndPlay("init");
               break;
            case OutputVO.CAT_PART:
               this.part.gotoAndPlay("init");
               break;
            case OutputVO.CAT_SPECIAL:
               this.special.gotoAndPlay("init");
               break;
            case OutputVO.CAT_LOGFILES:
               this.logfiles.gotoAndPlay("init");
         }
      }
      
      private function updateEnergyCost() : void
      {
         if(!this.stdEnergyBtnLabel || !this.stdEnergyBtn)
         {
            return;
         }
         var _loc1_:IGalaxyGateBuilderModel = this.model as IGalaxyGateBuilderModel;
         var _loc2_:int = _loc1_.getEnergyCost();
         var _loc3_:int = _loc1_.getExtraEnergy();
         var _loc4_:int = _loc1_.getSpinAmount();
         var _loc5_:int = _loc4_ - _loc3_;
         var _loc6_:int = _loc5_ > 0 ? int(_loc5_ * _loc2_) : 0;
         this.energyCostVerbose = BPLocale.getItemInCategory("galaxyGates","label_produce") + " (" + BPLocale.getItemInCategory("galaxyGates","pricetag_uridium_compact").replace(/%VALUE%/,BPLocale.formatNumber(_loc6_)) + ")";
         this.stdEnergyBtnLabel.text = this.energyCostVerbose;
         this.stdEnergyBtnLabel.autoSize = TextFieldAutoSize.NONE;
         this.stdEnergyBtnLabel.x = 0;
         this.stdEnergyBtnLabel.width = 156;
         TooltipControl.getInstance().removeToolTip(this.stdEnergyBtn);
         if(Styles.distillAndWrite(this.energyCostVerbose,this.stdEnergyBtnLabel,TextFieldAutoSize.CENTER))
         {
            TooltipControl.getInstance().addToolTip(this.stdEnergyBtn,this.energyCostVerbose);
         }
      }
      
      private function updateSpinAmount() : void
      {
         var _loc1_:int = (model as IGalaxyGateBuilderModel).getSpinAmount();
         if(this.spinAmountCbo.selectedItem == null || this.spinAmountCbo.selectedItem.value != _loc1_)
         {
            this.spinAmountCbo.setSelectedValue(_loc1_);
         }
      }
      
      private function init() : void
      {
         var _loc1_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         var _loc2_:SWFFinisher = SWFFinisher(_loc1_.getLib("common"));
         this.materializerContainer = new Sprite();
         this.materializerContainer.x = 4;
         addChild(this.materializerContainer);
         this.caseContainer = new Sprite();
         this.caseContainer.mouseEnabled = false;
         addChild(this.caseContainer);
         this.stdBackground = _loc2_.getEmbeddedBitmap("materializer_bg");
         this.stdBackground.y = 0;
         this.materializerContainer.addChild(this.stdBackground);
         this.materializerMask = new Sprite();
         this.materializerMask.graphics.beginFill(16711680);
         this.materializerMask.graphics.drawRect(0,0,this.stdBackground.width,this.stdBackground.height);
         this.materializerMask.graphics.endFill();
         this.materializerMask.scaleY = 0;
         addChild(this.materializerMask);
         this.materializerContainer.mask = this.materializerMask;
         this.materializerEffect = _loc2_.getEmbeddedMovieClip("materializer_effect");
         this.materializerEffect.y = 0;
         this.materializerContainer.addChild(this.materializerEffect);
         this.materializerEffect.gotoAndPlay("loop");
         this.ammunition = _loc2_.getEmbeddedMovieClip("output_ammo");
         this.ammunition.y = 0;
         this.ammunition.gotoAndStop("complete");
         this.materializerContainer.addChild(this.ammunition);
         this.resource = _loc2_.getEmbeddedMovieClip("output_resource");
         this.resource.y = 0;
         this.resource.gotoAndStop("complete");
         this.materializerContainer.addChild(this.resource);
         this.repairVoucher = _loc2_.getEmbeddedMovieClip("output_repair");
         this.repairVoucher.y = 0;
         this.repairVoucher.gotoAndStop("complete");
         this.materializerContainer.addChild(this.repairVoucher);
         this.part = _loc2_.getEmbeddedMovieClip("output_part");
         this.part.y = 0;
         this.part.gotoAndStop("complete");
         this.materializerContainer.addChild(this.part);
         this.special = _loc2_.getEmbeddedMovieClip("output_extra");
         this.special.y = 0;
         this.special.gotoAndStop("complete");
         this.materializerContainer.addChild(this.special);
         this.logfiles = _loc2_.getEmbeddedMovieClip("output_logfile");
         this.logfiles.y = 0;
         this.logfiles.gotoAndStop("complete");
         this.materializerContainer.addChild(this.logfiles);
         this.maximizeBtn = _loc2_.getEmbeddedMovieClip("machine_maximize_btn");
         this.maximizeBtn.buttonMode = true;
         this.maximizeBtn.x = 230;
         this.maximizeBtn.y = 0;
         this.caseContainer.addChild(this.maximizeBtn);
         this.minimizeBtn = _loc2_.getEmbeddedMovieClip("machine_minimize_btn");
         this.minimizeBtn.buttonMode = true;
         this.minimizeBtn.x = 230;
         this.minimizeBtn.y = 0;
         this.caseContainer.addChild(this.minimizeBtn);
         this.bg = _loc2_.getEmbeddedBitmap("machine_bg");
         this.caseContainer.addChild(this.bg);
         this.spinAmountCbo = new SpinAmountComboBox();
         this.spinAmountCbo.addEventListener(Event.CHANGE,this.handleSpinAmountSelection);
         this.spinAmountCbo.x = 15;
         this.spinAmountCbo.y = 40;
         this.caseContainer.addChild(this.spinAmountCbo);
         this.stdEnergyBtn = _loc2_.getEmbeddedMovieClip("energy_std_btn");
         this.stdEnergyBtn.buttonMode = true;
         this.stdEnergyBtn.gotoAndStop("std");
         this.stdEnergyBtnLabel = (this.stdEnergyBtn.getChildByName("mcLabelContainer") as MovieClip).getChildByName("txtLabel") as TextField;
         this.stdEnergyBtnLabel.defaultTextFormat = Styles.h1Fmt;
         this.stdEnergyBtnLabel.embedFonts = Styles.h1Embed;
         this.stdEnergyBtnLabel.height = Styles.h1FontHeight + 8;
         this.stdEnergyBtnLabel.mouseEnabled = false;
         this.stdEnergyBtn.mouseChildren = false;
         this.stdEnergyBtn.x = 37;
         this.stdEnergyBtn.y = 9;
         this.caseContainer.addChild(this.stdEnergyBtn);
         this.spinOnSaleIcon = _loc2_.getEmbeddedBitmap("sale_indicator");
         this.spinOnSaleIcon.x = 8;
         this.spinOnSaleIcon.y = 6;
         this.caseContainer.addChild(this.spinOnSaleIcon);
         this.bonusSaleIcon = _loc2_.getEmbeddedBitmap("bonus_sale_indicator");
         this.bonusSaleIcon.x = this.stdEnergyBtn.width + 3;
         this.bonusSaleIcon.y = 6;
         this.caseContainer.addChild(this.bonusSaleIcon);
         this.bonusSaleIcon.visible = GalaxyGateBuilderModel.bonusRewardsDay;
         this.setMode(GalaxyGateBuilderModel.STATE_ALPHA);
         this.enableEnergyBtn();
         this.enableMaximizeAndMinimizeBtn();
         this.updateSpinAmount();
         this.updateEnergyCost();
         this.updateSpinOnSaleIcon();
      }
      
      private function updateSpinOnSaleIcon() : void
      {
         this.spinOnSaleIcon.visible = GalaxyGateBuilderModel.spinOnSale;
      }
      
      private function handleSpinAmountSelection(param1:Event) : void
      {
         getProxy().setSpinAmountHandler(SpinAmountComboBox(param1.target).selectedItem.value);
      }
      
      public function enableEnergyBtn() : void
      {
         if(this.stdEnergyBtn)
         {
            this.stdEnergyBtn.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
            this.stdEnergyBtn.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
            this.stdEnergyBtn.addEventListener(MouseEvent.CLICK,this.handleEnergyBtnClick);
            this.stdEnergyBtn.gotoAndStop("std");
         }
      }
      
      public function disableEnergyBtn(param1:String = "disabled") : void
      {
         this.stdEnergyBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.stdEnergyBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.stdEnergyBtn.removeEventListener(MouseEvent.CLICK,this.handleEnergyBtnClick);
         this.stdEnergyBtn.gotoAndStop(param1);
      }
      
      public function enableMaximizeAndMinimizeBtn() : void
      {
         this.maximizeBtn.visible = true;
         this.minimizeBtn.visible = false;
         this.maximizeBtn.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.maximizeBtn.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.minimizeBtn.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.minimizeBtn.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.maximizeBtn.addEventListener(MouseEvent.CLICK,this.handleMaximizeBtnClick);
         this.minimizeBtn.addEventListener(MouseEvent.CLICK,this.handleMinimizeBtnClick);
         this.maximizeBtn.gotoAndStop("std");
         this.minimizeBtn.gotoAndStop("std");
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         (param1.target as MovieClip).gotoAndStop("hover");
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         (param1.target as MovieClip).gotoAndStop("std");
      }
      
      private function handleEnergyBtnClick(param1:MouseEvent) : void
      {
         this.disableEnergyBtn("toggle");
         getProxy().investEnergy();
      }
      
      private function handleMaximizeBtnClick(param1:MouseEvent) : void
      {
         this.maximizeBtn.visible = false;
         this.minimizeBtn.visible = true;
         TweenLite.to(this.caseContainer,1,{
            "y":this.caseMaximizedPosY,
            "onUpdate":this.handleResizeUpdate
         });
         this.activateBeam();
      }
      
      private function handleMinimizeBtnClick(param1:MouseEvent) : void
      {
         TweenMax.killDelayedCallsTo(this.deactivateBeam);
         this.maximizeBtn.visible = true;
         this.minimizeBtn.visible = false;
         TweenLite.to(this.caseContainer,1,{
            "y":this.caseMinimizedPosY,
            "onUpdate":this.handleResizeUpdate
         });
         TweenMax.delayedCall(0.2,this.deactivateBeam);
      }
      
      private function handleResizeUpdate() : void
      {
         var _loc1_:Number = this.caseContainer.y / this.caseMaximizedPosY;
         this.materializerMask.scaleY = _loc1_;
         getProxy().resizeMachineHandler(this.caseContainer.y);
      }
      
      private function isBeamActivated() : Boolean
      {
         return this._beamIsActivated;
      }
   }
}

