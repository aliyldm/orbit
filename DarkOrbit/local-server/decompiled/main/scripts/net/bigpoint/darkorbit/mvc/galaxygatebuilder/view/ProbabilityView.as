package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.IGalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core.CompositeView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   
   public class ProbabilityView extends CompositeView
   {
      
      private var probabilityList:MovieClip;
      
      private var commonLib:SWFFinisher;
      
      public function ProbabilityView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function update(param1:Event = null) : void
      {
         var _loc3_:AssetsProxy = null;
         var _loc2_:String = param1.type;
         switch(_loc2_)
         {
            case ApplicationEvent.INIT_COMPLETE:
               _loc3_ = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
               this.commonLib = SWFFinisher(_loc3_.getLib("common"));
               this.init();
               break;
            case ApplicationEvent.STATE_EPSILON:
            case ApplicationEvent.STATE_ZETA:
            case ApplicationEvent.STATE_ALPHA:
            case ApplicationEvent.STATE_BETA:
            case ApplicationEvent.STATE_GAMMA:
            case ApplicationEvent.STATE_DELTA:
            case ApplicationEvent.STATE_KRONOS:
         }
      }
      
      private function init() : void
      {
         this.probabilityList = new MovieClip();
         addChild(this.probabilityList);
         this.invalidateProbabilityDiagram();
      }
      
      private function invalidateProbabilityDiagram() : void
      {
         var _loc1_:Array = null;
         var _loc2_:TextField = null;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         if((model as IGalaxyGateBuilderModel).getProbability() == null)
         {
            return;
         }
         _loc1_ = (model as IGalaxyGateBuilderModel).getProbability().data;
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc4_ = int(_loc1_[_loc3_]["pct"]);
            if(_loc4_ > 0)
            {
               _loc5_ = this.commonLib.getEmbeddedMovieClip("prob_line");
               _loc6_ = _loc5_["bg"];
               _loc6_.gotoAndStop(_loc1_[_loc3_]["bg"]);
               _loc2_ = _loc5_["txtLabel"] as TextField;
               _loc2_.defaultTextFormat = Styles.strongStdFmt;
               _loc2_.embedFonts = Styles.strongStdEmbed;
               _loc2_.antiAliasType = AntiAliasType.ADVANCED;
               _loc2_.textColor = 13421772;
               _loc2_.text = _loc4_ + "%";
               _loc7_ = _loc5_["pct_bar"] as MovieClip;
               _loc7_.scaleX = _loc4_ * 0.01;
               this.probabilityList.addChild(_loc5_);
               _loc8_ = _loc5_["icon"] as MovieClip;
               _loc8_.gotoAndStop(_loc1_[_loc3_]["icon"]);
               _loc5_.y = _loc3_ * _loc5_.height + 3;
               TooltipControl.getInstance().addToolTip(_loc5_,BPLocale.getItemInCategory("galaxyGates",_loc1_[_loc3_]["trans_key"]));
            }
            _loc3_++;
         }
      }
   }
}

