package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core.CompositeView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   
   public class IconsView extends CompositeView
   {
      
      private const DISABLED_ALPHA:Number = 0.7;
      
      private const ENABLED_ALPHA:Number = 1;
      
      private var helpBtn:MovieClip;
      
      private var probabilityBtn:MovieClip;
      
      private var additionalInformationBtn:MovieClip;
      
      private var rewardBtn:MovieClip;
      
      public function IconsView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function update(param1:Event = null) : void
      {
         var _loc2_:String = param1.type;
         switch(_loc2_)
         {
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
               this.enableRewardBtn();
               this.enableProbabilityBtn();
               this.disableAdditionalInformationBtn();
               break;
            case ApplicationEvent.STATE_HADES:
            case ApplicationEvent.STATE_STREUNER:
               this.enableRewardBtn();
               this.enableProbabilityBtn();
               this.enableAdditionalInformationBtn();
               break;
            case ApplicationEvent.STATE_KRONOS:
               this.disableRewardBtn();
               this.disableProbabilityBtn();
               this.disableAdditionalInformationBtn();
         }
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:AssetsProxy = null;
         _loc1_ = 0;
         _loc2_ = 12;
         _loc3_ = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         this.additionalInformationBtn = _loc3_.getMovieClip("common","icon_info");
         this.additionalInformationBtn.x = _loc1_;
         this.additionalInformationBtn.y = _loc2_;
         this.additionalInformationBtn.alpha = 0.3;
         _loc1_ += this.additionalInformationBtn.width;
         this.probabilityBtn = _loc3_.getMovieClip("common","icon_chance");
         this.probabilityBtn.x = _loc1_;
         this.probabilityBtn.y = _loc2_;
         _loc1_ += this.probabilityBtn.width;
         this.helpBtn = _loc3_.getMovieClip("common","icon_help");
         this.helpBtn.x = _loc1_;
         this.helpBtn.y = _loc2_;
         addChild(this.probabilityBtn);
         addChild(this.helpBtn);
         addChild(this.additionalInformationBtn);
         this.enableProbabilityBtn();
         this.enableHelpBtn();
         this.enableAdditionalInformationBtn();
         this.disableAdditionalInformationBtn();
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("hover");
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("std");
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:GalaxyGateBuilderProxy = getProxy();
         var _loc3_:MovieClip = param1.currentTarget as MovieClip;
         switch(_loc3_)
         {
            case this.helpBtn:
               _loc2_.showHelpHandler();
               break;
            case this.probabilityBtn:
               _loc2_.showProbabilityHandler();
               break;
            case this.rewardBtn:
               _loc2_.showRewardHandler();
               break;
            case this.additionalInformationBtn:
               _loc2_.showAdditionalInformationDialog();
         }
      }
      
      public function enableHelpBtn() : void
      {
         this.helpBtn.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.helpBtn.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.helpBtn.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.helpBtn.buttonMode = true;
         this.helpBtn.gotoAndStop("std");
         TooltipControl.getInstance().addToolTip(this.helpBtn,BPLocale.getItemInCategory("galaxyGates","label_help"));
      }
      
      public function enableProbabilityBtn() : void
      {
         this.probabilityBtn.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.probabilityBtn.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.probabilityBtn.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.probabilityBtn.buttonMode = true;
         this.probabilityBtn.gotoAndStop("std");
         this.probabilityBtn.alpha = this.ENABLED_ALPHA;
         TooltipControl.getInstance().addToolTip(this.probabilityBtn,BPLocale.getItemInCategory("galaxyGates","label_probabilities"));
      }
      
      private function disableProbabilityBtn() : void
      {
         this.probabilityBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.probabilityBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.probabilityBtn.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.probabilityBtn.alpha = this.DISABLED_ALPHA;
         this.probabilityBtn.buttonMode = false;
         TooltipControl.getInstance().removeToolTip(this.probabilityBtn);
      }
      
      public function enableRewardBtn() : void
      {
      }
      
      private function disableRewardBtn() : void
      {
      }
      
      public function enableAdditionalInformationBtn() : void
      {
         this.additionalInformationBtn.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.additionalInformationBtn.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.additionalInformationBtn.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.additionalInformationBtn.buttonMode = true;
         this.additionalInformationBtn.gotoAndStop("std");
         this.additionalInformationBtn.alpha = this.ENABLED_ALPHA;
         TooltipControl.getInstance().addToolTip(this.additionalInformationBtn,BPLocale.getItemInCategory("galaxyGates","label_additional_gate_Information"));
      }
      
      public function disableAdditionalInformationBtn() : void
      {
         this.additionalInformationBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.additionalInformationBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.additionalInformationBtn.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.additionalInformationBtn.alpha = this.DISABLED_ALPHA;
         this.additionalInformationBtn.buttonMode = false;
         TooltipControl.getInstance().removeToolTip(this.additionalInformationBtn);
      }
   }
}

