package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.AntiAliasType;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flashx.textLayout.formats.TextAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core.ComponentView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.GateEvent;
   
   public class KronosGateProgressionView extends ComponentView
   {
      
      private var contentContainer:Sprite;
      
      private var contentProgressTextArea:TextField;
      
      private var contentGatesTextArea:TextField;
      
      private var contentInfoTextArea:TextField;
      
      private var cachedCssStyle:StyleSheet;
      
      public function KronosGateProgressionView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function update(param1:Event = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:String = param1.type;
         switch(_loc2_)
         {
            case ApplicationEvent.INIT_COMPLETE:
               this.initialize();
               break;
            case ApplicationEvent.STATE_KRONOS:
               this.updateTextFieldsContent();
               fadeIn();
               break;
            case ApplicationEvent.STATE_DELTA:
            case ApplicationEvent.STATE_EPSILON:
            case ApplicationEvent.STATE_ZETA:
            case ApplicationEvent.STATE_KAPPA:
            case ApplicationEvent.STATE_LAMBDA:
            case ApplicationEvent.STATE_ALPHA:
            case ApplicationEvent.STATE_BETA:
            case ApplicationEvent.STATE_GAMMA:
            case ApplicationEvent.STATE_HADES:
            case ApplicationEvent.STATE_STREUNER:
               fadeOut();
               break;
            case GateEvent.GATE_DETAILS:
               break;
            case GateEvent.GATE_PROGRESS:
               this.updateTextFieldsContent();
               break;
            case GateEvent.GATE_COMPLETE:
         }
      }
      
      private function initialize() : void
      {
         this.alpha = 0;
         deactivate();
         var _loc1_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         var _loc2_:Bitmap = _loc1_.getBitmap("common","kronosgate_progress_layer_bg");
         addChild(_loc2_);
         this.createTextFields();
      }
      
      private function updateTextFieldsContent() : void
      {
         var _loc1_:String = null;
         var _loc2_:GalaxyGateBuilderModel = null;
         var _loc3_:int = 0;
         _loc2_ = model as GalaxyGateBuilderModel;
         _loc1_ = BPLocale.getItemInCategory("galaxyGates","msg_kronos_gate_info");
         this.contentInfoTextArea.htmlText = _loc1_;
         _loc3_ = this.contentInfoTextArea.y + this.contentInfoTextArea.height + 10;
         _loc1_ = _loc2_.getKronosGatenames();
         this.contentGatesTextArea.htmlText = _loc1_;
         this.contentGatesTextArea.y = _loc3_;
         _loc1_ = _loc2_.getKronosGateProgress();
         this.contentProgressTextArea.htmlText = _loc1_;
         this.contentProgressTextArea.y = _loc3_;
      }
      
      private function createTextFields() : void
      {
         var _loc1_:TextFormat = null;
         _loc1_ = Styles.h1Fmt;
         _loc1_.align = TextAlign.LEFT;
         var _loc2_:TextField = new TextField();
         var _loc3_:String = BPLocale.getItemInCategory("galaxyGates","gate_title_kronos_long");
         _loc2_.defaultTextFormat = _loc1_;
         _loc2_.embedFonts = Styles.h1Embed;
         _loc2_.height = Styles.h1FontHeight + 4;
         _loc2_.x = 26;
         _loc2_.y = 10;
         _loc2_.text = _loc3_;
         _loc2_.antiAliasType = AntiAliasType.ADVANCED;
         _loc2_.textColor = 16777215;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.selectable = false;
         this.addChild(_loc2_);
         this.contentContainer = new Sprite();
         this.contentContainer.x = 26;
         this.contentContainer.y = 40;
         this.addChild(this.contentContainer);
         this.contentProgressTextArea = new TextField();
         this.contentContainer.addChild(this.contentProgressTextArea);
         this.contentProgressTextArea.x = 100;
         this.contentProgressTextArea.width = 80;
         _loc1_ = Styles.strongStdFmt;
         this.contentProgressTextArea.autoSize = TextFieldAutoSize.LEFT;
         this.contentProgressTextArea.defaultTextFormat = _loc1_;
         this.contentProgressTextArea.embedFonts = Styles.strongStdEmbed;
         this.contentProgressTextArea.textColor = 16777215;
         this.contentProgressTextArea.multiline = true;
         this.contentProgressTextArea.wordWrap = true;
         this.contentProgressTextArea.selectable = false;
         this.contentGatesTextArea = new TextField();
         this.contentContainer.addChild(this.contentGatesTextArea);
         this.contentGatesTextArea.width = 100;
         _loc1_ = Styles.strongStdFmt;
         this.contentGatesTextArea.autoSize = TextFieldAutoSize.LEFT;
         this.contentGatesTextArea.defaultTextFormat = _loc1_;
         this.contentGatesTextArea.embedFonts = Styles.strongStdEmbed;
         this.contentGatesTextArea.textColor = 16777215;
         this.contentGatesTextArea.multiline = true;
         this.contentGatesTextArea.wordWrap = true;
         this.contentGatesTextArea.selectable = false;
         this.contentInfoTextArea = new TextField();
         this.contentContainer.addChild(this.contentInfoTextArea);
         this.contentInfoTextArea.width = 200;
         _loc1_ = Styles.helpTextFmt;
         this.contentInfoTextArea.autoSize = TextFieldAutoSize.LEFT;
         this.contentInfoTextArea.defaultTextFormat = _loc1_;
         this.contentInfoTextArea.embedFonts = Styles.helpTextEmbed;
         this.contentInfoTextArea.textColor = 16777215;
         this.contentInfoTextArea.multiline = true;
         this.contentInfoTextArea.wordWrap = true;
         this.contentInfoTextArea.selectable = false;
         var _loc4_:StyleSheet = this.createCSS();
         this.contentProgressTextArea.styleSheet = _loc4_;
         this.contentGatesTextArea.styleSheet = _loc4_;
         this.contentInfoTextArea.styleSheet = _loc4_;
      }
      
      private function createCSS() : StyleSheet
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:StyleSheet = null;
         if(this.cachedCssStyle == null)
         {
            _loc1_ = {
               "fontSize":14,
               "color":"#FFFFFF",
               "leading":"4px"
            };
            _loc2_ = {
               "fontSize":14,
               "color":"#F5DE00",
               "leading":"4px"
            };
            _loc3_ = {
               "fontSize":14,
               "color":"#7DC9FF",
               "leading":"4px"
            };
            _loc4_ = new StyleSheet();
            _loc4_.setStyle("h1",_loc1_);
            _loc4_.setStyle("h2",_loc2_);
            _loc4_.setStyle("h3",_loc3_);
            this.cachedCssStyle = _loc4_;
         }
         return this.cachedCssStyle;
      }
   }
}

