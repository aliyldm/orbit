package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core.CompositeView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.GateEvent;
   
   public class GateSelectorView extends CompositeView
   {
      
      private var currentGateID:int = 1;
      
      private var _groupBgs:Array;
      
      private var _buttonBarSingleButtons:Array;
      
      private var commonLib:SWFFinisher;
      
      public function GateSelectorView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
         this._groupBgs = [];
         this._buttonBarSingleButtons = [];
      }
      
      override public function update(param1:Event = null) : void
      {
         var _loc3_:int = 0;
         var _loc2_:String = param1.type;
         switch(_loc2_)
         {
            case GateEvent.GATE_DETAILS:
               _loc3_ = (param1 as GateEvent).gateID;
               this.currentGateID = _loc3_;
               this.updateButtonBar();
               break;
            case ApplicationEvent.INIT_COMPLETE:
               this.init();
               _loc3_ = 1;
               this.updateButtonBar();
         }
      }
      
      private function updateButtonBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:TextField = null;
         var _loc4_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this._groupBgs.length)
         {
            if(this._groupBgs[_loc1_] != null)
            {
               (this._groupBgs[_loc1_] as MovieClip).gotoAndStop("std");
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < GalaxyGateBuilderModel.MODE_GATES.length)
         {
            for each(_loc4_ in GalaxyGateBuilderModel.MODE_GATES[_loc1_] as Array)
            {
               _loc2_ = this._buttonBarSingleButtons[_loc4_];
               if(this.currentGateID == _loc4_)
               {
                  _loc2_.gotoAndStop("active");
                  this.disableGateBtn(_loc2_);
                  _loc3_ = _loc2_.getChildByName("txtLabel") as TextField;
                  _loc3_.textColor = 0;
                  if(this._groupBgs[_loc1_] != null)
                  {
                     (this._groupBgs[_loc1_] as MovieClip).gotoAndStop("active");
                  }
               }
               else
               {
                  _loc2_.gotoAndStop("std");
                  this.enableGateBtn(_loc2_);
                  _loc3_ = _loc2_.getChildByName("txtLabel") as TextField;
                  _loc3_.textColor = 16777215;
               }
            }
            _loc1_++;
         }
      }
      
      private function init() : void
      {
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:Bitmap = null;
         var _loc1_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         this.commonLib = SWFFinisher(_loc1_.getLib("common"));
         var _loc2_:int = 0;
         var _loc3_:int = 8;
         _loc4_ = 0;
         while(_loc4_ < GalaxyGateBuilderModel.MODE_GATES.length)
         {
            _loc9_ = this.commonLib.getEmbeddedBitmap("gateSelector_separator");
            _loc9_.height = 3;
            if((GalaxyGateBuilderModel.MODE_GATES[_loc4_] as Array).length > 1)
            {
               _loc5_ = this.commonLib.getEmbeddedMovieClip("gateSelector_groupBg" + (GalaxyGateBuilderModel.MODE_GATES[_loc4_] as Array).length);
               this._groupBgs[_loc4_] = _loc5_;
               _loc5_.x = _loc2_;
               _loc5_.y = _loc3_;
               _loc5_.gotoAndStop("std");
               addChild(_loc5_);
               _loc3_ += 8;
               for each(_loc7_ in GalaxyGateBuilderModel.MODE_GATES[_loc4_] as Array)
               {
                  _loc6_ = this.commonLib.getEmbeddedMovieClip("gateSelector_groupBtn");
                  _loc8_ = "gate_title_" + _loc7_.toString();
                  try
                  {
                     this.setSingleButton(_loc7_,_loc6_,BPLocale.getItemInCategory("galaxyGates",_loc8_));
                  }
                  catch(e:Error)
                  {
                  }
                  this._buttonBarSingleButtons[_loc7_] = _loc6_;
                  _loc6_.x = _loc2_;
                  _loc6_.y = _loc3_;
                  _loc3_ += _loc6_.height + 1;
                  this.addBonusGGRewardIcon(_loc7_,_loc6_.width - 45,_loc6_.y - 6,1);
               }
               _loc3_ += 10;
               _loc9_.x = _loc2_;
               _loc9_.y = _loc3_;
               addChild(_loc9_);
               _loc3_ += _loc9_.height - 5;
            }
            else
            {
               this._groupBgs[_loc4_] = null;
               _loc7_ = int(GalaxyGateBuilderModel.MODE_GATES[_loc4_][0]);
               _loc6_ = this.commonLib.getEmbeddedMovieClip("gateSelector_btn");
               _loc8_ = "gate_title_" + _loc7_.toString();
               try
               {
                  this.setSingleButton(_loc7_,_loc6_,BPLocale.getItemInCategory("galaxyGates",_loc8_));
               }
               catch(e:Error)
               {
               }
               this._buttonBarSingleButtons[_loc7_] = _loc6_;
               _loc6_.x = _loc2_;
               _loc6_.y = _loc3_;
               _loc3_ += _loc6_.height;
               _loc9_.x = _loc2_;
               _loc9_.y = _loc3_;
               addChild(_loc9_);
               _loc3_ += _loc9_.height - 5;
               this.addBonusGGRewardIcon(_loc7_,_loc6_.width - 45,_loc6_.y + 2,1);
            }
            _loc9_ = null;
            _loc4_++;
         }
      }
      
      private function setSingleButton(param1:Number, param2:MovieClip, param3:String) : void
      {
         param2.name = "gateBtn" + param1;
         param2.buttonMode = true;
         param2.gotoAndStop("std");
         var _loc4_:TextField = param2.getChildByName("txtLabel") as TextField;
         _loc4_.defaultTextFormat = Styles.gateSelectorFmt;
         _loc4_.embedFonts = Styles.gateSelectorEmbed;
         _loc4_.height = Styles.gateSelectorFontHeight + 6;
         _loc4_.antiAliasType = AntiAliasType.ADVANCED;
         var _loc5_:Boolean = this.distillAndWrite(param3,_loc4_);
         if(_loc5_)
         {
            TooltipControl.getInstance().addToolTip(param2,param3);
         }
         _loc4_.mouseEnabled = false;
         addChild(param2);
      }
      
      private function addBonusGGRewardIcon(param1:int, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Bitmap = null;
         if(getModel().getGateVO(param1).bonusGGReward != null)
         {
            _loc5_ = this.commonLib.getEmbeddedBitmap("bonus_gg_reward");
            _loc5_.scaleX = param4;
            _loc5_.scaleY = param4;
            _loc5_.x = param2;
            _loc5_.y = param3;
            addChild(_loc5_);
         }
      }
      
      private function distillAndWrite(param1:String, param2:TextField) : Boolean
      {
         var _loc8_:int = 0;
         var _loc3_:Number = param2.width;
         param2.autoSize = TextFieldAutoSize.LEFT;
         param2.text = param1;
         if(param2.width <= _loc3_)
         {
            return false;
         }
         var _loc4_:String = "";
         var _loc5_:Array = param1.split(" ");
         var _loc6_:String = _loc5_[_loc5_.length - 1];
         _loc5_.pop();
         var _loc7_:String = _loc5_.join(" ");
         while(param2.width > _loc3_)
         {
            _loc8_ = _loc7_.length;
            _loc7_ = _loc7_.substring(0,_loc8_ - 1);
            _loc4_ = _loc7_ + "… " + _loc6_;
            param2.text = _loc4_;
         }
         return true;
      }
      
      private function enableGateBtn(param1:MovieClip) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         param1.addEventListener(MouseEvent.CLICK,this.handleMouseClick);
      }
      
      private function disableGateBtn(param1:MovieClip) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         param1.removeEventListener(MouseEvent.CLICK,this.handleMouseClick);
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.gotoAndStop("hover");
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         _loc2_.gotoAndStop("std");
         var _loc3_:TextField = _loc2_.getChildByName("txtLabel") as TextField;
         _loc3_.textColor = 16777215;
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:GalaxyGateBuilderProxy = getProxy();
         var _loc3_:String = (param1.currentTarget as MovieClip).name;
         var _loc4_:int = _loc3_.length - 1;
         var _loc5_:int = parseInt(_loc3_.charAt(_loc4_));
         if(_loc5_ == 0)
         {
            _loc2_.prepareJumpHandler();
         }
         else
         {
            _loc7_ = parseInt(_loc3_.charAt(_loc4_ - 1));
            _loc6_ = _loc7_ * 10 + _loc5_;
            _loc2_.setGateHandler(_loc6_);
         }
      }
   }
}

