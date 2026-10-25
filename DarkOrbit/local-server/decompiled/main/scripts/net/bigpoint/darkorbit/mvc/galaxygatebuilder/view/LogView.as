package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.AmmoOutputVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.CleanedOutputVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.LogLineInfoVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.OutputVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.PartOutputVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.SpecialOutputVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.components.scrollbar.ScrollController;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.components.scrollbar.Scrollbar;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core.CompositeView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.MachineEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.MaterializeEvent;
   
   public class LogView extends CompositeView
   {
      
      private var headlineContainer:Sprite;
      
      private var listContainer:Sprite;
      
      private var visibleScrollContent:Rectangle;
      
      private var scrollbar:Scrollbar;
      
      private var historyListMaxHeight:Number = 148;
      
      private var _cleanedOutput:Array = [];
      
      private var historyList:Sprite = new Sprite();
      
      private var historyBars:Array = [];
      
      private var historyInfos:Array = [];
      
      private var historyScrollCursor:uint = 0;
      
      private var commonLib:SWFFinisher;
      
      private var scrollController:ScrollController;
      
      private var minimizedOffsetY:int = 130;
      
      private var listMinimizedPosY:int = 0;
      
      private var listMaximizedPosY:int = 56;
      
      private var lastPartWasSplitter:Boolean = false;
      
      private var videoSpinButton:MovieClip;
      
      private var videoSpinButtonLabel:TextField;
      
      public function LogView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function update(param1:Event = null) : void
      {
         var _loc3_:AssetsProxy = null;
         var _loc4_:int = 0;
         var _loc2_:String = param1.type;
         switch(_loc2_)
         {
            case MaterializeEvent.MATERIALIZE_NEW_OUTPUT:
               this.unshiftOutput((param1 as MaterializeEvent).output);
               break;
            case ApplicationEvent.INIT_COMPLETE:
               _loc3_ = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
               this.commonLib = SWFFinisher(_loc3_.getLib("common"));
               this.init();
               break;
            case ApplicationEvent.STATE_DELTA:
            case ApplicationEvent.STATE_EPSILON:
            case ApplicationEvent.STATE_ZETA:
            case ApplicationEvent.STATE_KAPPA:
            case ApplicationEvent.STATE_LAMBDA:
            case ApplicationEvent.STATE_ALPHA:
            case ApplicationEvent.STATE_BETA:
            case ApplicationEvent.STATE_GAMMA:
            case ApplicationEvent.STATE_KRONOS:
            case ApplicationEvent.STATE_HADES:
            case ApplicationEvent.STATE_STREUNER:
               break;
            case MachineEvent.ON_RESIZE:
               _loc4_ = (param1 as MachineEvent).offsetY;
               this.updateAlignment(_loc4_);
         }
      }
      
      private function init() : void
      {
         var _loc1_:TextField = null;
         this.headlineContainer = new Sprite();
         this.listContainer = new Sprite();
         _loc1_ = new TextField();
         _loc1_.defaultTextFormat = Styles.ggBuilderH2Fmt;
         _loc1_.text = BPLocale.getItemInCategory("galaxyGates","label_log");
         _loc1_.embedFonts = Styles.ggBuilderH2Embed;
         _loc1_.height = Styles.ggBuilderH2FontHeight + 6;
         _loc1_.width = 262;
         _loc1_.selectable = false;
         _loc1_.x = 0;
         _loc1_.y = 32;
         _loc1_.autoSize = TextFieldAutoSize.CENTER;
         _loc1_.cacheAsBitmap = true;
         this.headlineContainer.addChild(_loc1_);
         var _loc2_:MovieClip = this.commonLib.getEmbeddedMovieClip("headline_bg");
         var _loc3_:Sprite = new Sprite();
         _loc3_.graphics.beginFill(4278190080);
         _loc3_.graphics.drawRect(0,0,_loc2_.width,_loc2_.height);
         _loc3_.graphics.endFill();
         _loc3_.alpha = 0;
         _loc2_.addChild(_loc3_);
         _loc2_.width = _loc1_.width + 16;
         if(_loc2_.width < 130)
         {
            _loc2_.width = 130;
         }
         _loc2_.x = _loc1_.x - (_loc2_.width - _loc1_.width) * 0.5;
         _loc2_.y = _loc1_.y - 2;
         this.headlineContainer.addChild(_loc2_);
         TooltipControl.getInstance().addToolTip(_loc2_,BPLocale.getItemInCategory("galaxyGates","label_log_long"));
         addChild(this.headlineContainer);
         this.historyList.x = 4;
         this.historyList.y = 0;
         this.listContainer.addChild(this.historyList);
         this.visibleScrollContent = new Rectangle(0,0,239,this.historyListMaxHeight);
         this.scrollController = new ScrollController(this.historyList,this.visibleScrollContent,this);
         this.scrollbar = this.scrollController.getScrollbar();
         this.scrollbar.x = 227;
         this.scrollbar.y = 0;
         this.listContainer.addChild(this.scrollbar);
         this.listContainer.y = this.listMaximizedPosY;
         addChild(this.listContainer);
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("hover");
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("std");
      }
      
      private function unshiftOutput(param1:OutputVO) : void
      {
         var _loc5_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc2_:String = "special";
         var _loc3_:String = "special";
         var _loc4_:Boolean = param1.multiplierUsed > 0;
         _loc5_ = param1.category;
         var _loc6_:String = "Undefined Result";
         var _loc7_:String = String(_loc5_);
         switch(_loc5_)
         {
            case OutputVO.CAT_AMMUNITION:
               _loc6_ = AmmoOutputVO(param1).toString();
               _loc2_ = "ammo";
               _loc11_ = AmmoOutputVO(param1).type;
               _loc7_ += "_" + _loc11_ + "_" + param1.amount;
               switch(_loc11_)
               {
                  case AmmoOutputVO.TYPE_MCB_25:
                     _loc3_ = "x2";
                     break;
                  case AmmoOutputVO.TYPE_MCB_50:
                     _loc3_ = "x3";
                     break;
                  case AmmoOutputVO.TYPE_UCB_100:
                     _loc3_ = "x4";
                     break;
                  case AmmoOutputVO.TYPE_ABS:
                     _loc3_ = "abs";
                     break;
                  case AmmoOutputVO.TYPE_ROCKET_PLT_2121:
                     _loc3_ = "rocket";
                     break;
                  case AmmoOutputVO.TYPE_MINE_ACM_1:
                     _loc3_ = "mine";
               }
               break;
            case OutputVO.CAT_RESOURCE:
               _loc6_ = param1.toString();
               _loc7_ += "_" + param1.amount;
               _loc2_ = "resource";
               _loc3_ = "xenomit";
               break;
            case OutputVO.CAT_VOUCHER:
               _loc6_ = param1.toString();
               _loc7_ += "_" + param1.amount;
               _loc2_ = "voucher";
               _loc3_ = "voucher";
               break;
            case OutputVO.CAT_PART:
               _loc6_ = PartOutputVO(param1).toString();
               _loc7_ += "_" + PartOutputVO(param1).gate_id + "_" + PartOutputVO(param1).part_id;
               _loc2_ = "part";
               _loc3_ = "part";
               break;
            case OutputVO.CAT_SPECIAL:
               _loc6_ = SpecialOutputVO(param1).toString();
               _loc2_ = "special";
               _loc12_ = SpecialOutputVO(param1).type;
               _loc7_ += "_" + _loc12_ + "_" + param1.amount;
               switch(_loc12_)
               {
                  case SpecialOutputVO.TYPE_HYPER_HITPOINT:
                     _loc3_ = "hyperhitpoint";
                     break;
                  case SpecialOutputVO.TYPE_NANOHULL:
                     _loc3_ = "nanohull";
                     break;
                  default:
                     _loc3_ = "special";
               }
               break;
            case OutputVO.CAT_LOGFILES:
               _loc6_ = param1.toString();
               _loc7_ += "_" + param1.amount;
               _loc2_ = "logfiles";
               _loc3_ = "logfiles";
               break;
            case OutputVO.CAT_MULTIPLIER:
               _loc6_ = param1.toString();
               _loc7_ += "_" + param1.amount;
               _loc2_ = "multiplier";
               _loc3_ = "multiplier";
               break;
            case OutputVO.CAT_SPLITTER:
               if(this.historyList.numChildren < 1 || this.lastPartWasSplitter)
               {
                  return;
               }
               _loc6_ = "";
               _loc2_ = "splitter";
               _loc3_ = "splitter";
               break;
            default:
               throw Error("unknown item type : " + _loc5_);
         }
         var _loc8_:MovieClip = this.commonLib.getEmbeddedMovieClip("log_line");
         var _loc9_:TextField = _loc8_["txtLabel"] as TextField;
         _loc9_.defaultTextFormat = Styles.ggBuilderPlainStdFmt;
         _loc9_.antiAliasType = AntiAliasType.ADVANCED;
         _loc9_.embedFonts = Styles.plainStdEmbed;
         _loc9_.height = Styles.plainStdFontHeight + 5;
         _loc9_.mouseEnabled = false;
         _loc9_.autoSize = TextFieldAutoSize.LEFT;
         _loc9_.multiline = false;
         _loc9_.y = Math.floor(_loc9_.y) - 1;
         this.shiftAllMessagesDownBy(16);
         this.historyList.addChild(_loc8_);
         this.historyBars.push(_loc8_);
         this.historyInfos.push(new LogLineInfoVO(_loc6_,_loc7_,_loc2_,_loc3_,_loc4_));
         this.updateHistoryList();
         if(_loc6_ != "" && _loc5_ != OutputVO.CAT_MULTIPLIER)
         {
            _loc13_ = BPLocale.getItemInCategory("galaxyGates","ttip_label_spinamount").replace("%COUNT%",param1.spins);
            if(param1.multiplierUsed > 0)
            {
               _loc13_ += "\n" + BPLocale.getItemInCategory("galaxyGates","ttip_label_multiplier_used").replace("%COUNT%",param1.multiplierUsed);
            }
            if(param1.multiplierAmount > 0)
            {
               _loc13_ += "\n" + BPLocale.getItemInCategory("galaxyGates","ttip_label_multiplier_amount").replace("%COUNT%",param1.multiplierAmount);
            }
            TooltipControl.getInstance().addToolTip(_loc8_,_loc13_);
         }
         var _loc10_:int = this.returnLowestLogMessagePosition();
         this.scrollController.updateScrollbarSizing(_loc10_);
         this.scrollController.setContentPosition(ScrollController.TOP);
         this.lastPartWasSplitter = _loc3_ == "splitter";
      }
      
      private function shiftAllMessagesDownBy(param1:int) : void
      {
         var _loc4_:Object = null;
         var _loc2_:int = this.historyList.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.historyList.getChildAt(_loc3_);
            _loc4_.y += param1;
            _loc3_++;
         }
      }
      
      private function returnLowestLogMessagePosition() : int
      {
         var _loc4_:Object = null;
         var _loc1_:Number = 0;
         var _loc2_:int = this.historyList.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.historyList.getChildAt(_loc3_);
            if(_loc4_.y > _loc1_)
            {
               _loc1_ = Number(_loc4_.y);
            }
            _loc3_++;
         }
         return _loc4_ == null ? int(_loc1_) : int(_loc1_ + _loc4_.height);
      }
      
      private function updateHistoryList() : void
      {
         var _loc3_:LogLineInfoVO = null;
         var _loc4_:MovieClip = null;
         var _loc1_:int = int(this.historyBars.length);
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.historyInfos[_loc2_ + this.historyScrollCursor];
            _loc4_ = this.historyBars[_loc2_];
            this.writeOutputLabel(_loc4_["txtLabel"] as TextField,_loc3_.text,_loc3_.hash);
            (_loc4_["bg"] as MovieClip).gotoAndStop(_loc3_.bgId);
            (_loc4_["icon"] as MovieClip).gotoAndStop(_loc3_.iconFrame);
            (_loc4_["multiplier"] as MovieClip).visible = _loc3_.showMultiplier;
            _loc2_++;
         }
      }
      
      private function updateAlignment(param1:int) : void
      {
         var _loc2_:Number = 1 - param1 / this.minimizedOffsetY;
         this.headlineContainer.y = param1;
         this.headlineContainer.scaleY = _loc2_;
         var _loc3_:int = _loc2_ * this.listMaximizedPosY > this.listMinimizedPosY ? int(_loc2_ * this.listMaximizedPosY) : this.listMinimizedPosY;
         this.listContainer.y = param1 + _loc3_;
         var _loc4_:Number = this.historyListMaxHeight - param1 + (this.listMaximizedPosY - _loc3_);
         this.scrollController.updateHeight(_loc4_);
         this.scrollController.setContentPosition(ScrollController.TOP);
      }
      
      private function writeOutputLabel(param1:TextField, param2:String, param3:String) : void
      {
         var _loc5_:CleanedOutputVO = null;
         var _loc6_:* = 0;
         var _loc4_:Number = 200;
         if(this._cleanedOutput[param3] != undefined)
         {
            _loc5_ = CleanedOutputVO(this._cleanedOutput[param3]);
            param1.text = _loc5_.distilledLabel;
         }
         else
         {
            param1.text = param2;
            if(param1.width <= _loc4_)
            {
               this._cleanedOutput[param3] = new CleanedOutputVO(param2,false,"");
            }
            else
            {
               _loc6_ = param2.length;
               while(param1.width > _loc4_)
               {
                  param1.text = param2.substring(0,_loc6_ - 2) + "…";
                  _loc6_--;
               }
               this._cleanedOutput[param3] = new CleanedOutputVO(param1.text,true,param2);
            }
         }
      }
   }
}

