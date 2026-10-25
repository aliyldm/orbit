package net.bigpoint.darkorbit.mvc.commandCenter.view.builder
{
   import flash.display.Bitmap;
   import flash.geom.Rectangle;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.repository.SkinRepository;
   import net.bigpoint.darkorbit.fui.builder.repository.TextStyleRepository;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.layout.Alignment;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.commandCenter.constants.CommandCenterConsts;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.repo.CommandCenterNewsDefinition;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.utils.BPLocaleUtils;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import org.osflash.signals.Signal;
   
   public class CommandCenterNewBuilder
   {
      
      public static const instance:CommandCenterNewBuilder = new CommandCenterNewBuilder();
      
      private const ready:Signal = new Signal();
      
      private const STYLE_PREFIX_LABEL:String = "command_center_label_";
      
      private const STYLE_PREFIX_BUTTON:String = "command_center_button_";
      
      private var _positionLookup:Object = {};
      
      public function CommandCenterNewBuilder()
      {
         super();
         if(instance)
         {
            throw new Error("CommandCenterNewBuilder is a Singleton");
         }
      }
      
      public function build(param1:CommandCenterNewsDefinition) : CommandCenterNewsContainer
      {
         var _loc2_:CommandCenterNewsContainer = new CommandCenterNewsContainer();
         _loc2_.registeredSkinName = "command_center_grey_bg";
         _loc2_.width = CommandCenterConsts.CONTENT_WIDTH;
         _loc2_.height = CommandCenterConsts.CONTENT_HEIGHT;
         this.buildAssignments(_loc2_,param1);
         this.buildActions(_loc2_,param1);
         return _loc2_;
      }
      
      private function addInfoLabel(param1:CommandCenterNewsContainer, param2:CommandCenterNewsDefinition) : void
      {
         var _loc3_:Label = new Label();
         _loc3_.text = "INFO: name: " + param2.name;
         _loc3_.registeredTextStyleName = "commonui_tooltip_textstyle";
         _loc3_.width = 300;
         _loc3_.height = 30;
         _loc3_.x = _loc3_.y = 2;
         param1.addChild(_loc3_);
      }
      
      public function load() : Signal
      {
         (GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy).load("positions",this.handleXMLLoaded,null,AssetsProxy.NEWS);
         return this.ready;
      }
      
      private function buildActions(param1:Coreponent, param2:CommandCenterNewsDefinition) : void
      {
         var _loc4_:CommandCenterActionButton = null;
         var _loc5_:XML = null;
         var _loc3_:XMLList = param2.actionsXML.child("button");
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = new CommandCenterActionButton(_loc5_,param2.name);
            _loc4_.text = UISystem.localize(_loc5_.attribute("text"),"bn");
            _loc4_.alignX = Alignment.CENTER_X;
            this.assignBTNPosition(_loc4_,_loc5_.attribute("position"));
            this.assignButtonStyle(_loc4_,_loc5_.attribute("style"));
            _loc4_.registeredTextStyleName = "commonui_smallbutton_green_normal";
            param1.addChild(_loc4_);
         }
      }
      
      private function buildAssignments(param1:CommandCenterNewsContainer, param2:CommandCenterNewsDefinition) : void
      {
         var backgroundList:XMLList;
         var overlayList:XMLList;
         var labels:XMLList;
         var label:Label = null;
         var labelXML:XML = null;
         var child:XML = null;
         var bgCoreponent:Coreponent = null;
         var assetResKey:String = null;
         var overLay:Coreponent = null;
         var timerXML:XML = null;
         var timer:Label = null;
         var content:CommandCenterNewsContainer = param1;
         var definition:CommandCenterNewsDefinition = param2;
         var assignmentsXML:XML = definition.assignmentsXML;
         if(!assignmentsXML)
         {
            return;
         }
         backgroundList = assignmentsXML.child("background");
         if(backgroundList.length() > 0)
         {
            for each(child in backgroundList)
            {
               bgCoreponent = new Coreponent();
               assetResKey = child.attribute("assetID");
               assetResKey = assetResKey.substr(0,assetResKey.lastIndexOf(".")) || assetResKey;
               bgCoreponent.loadResource(assetResKey,function(param1:ImageFinisher):void
               {
                  var _loc2_:Bitmap = param1.getBitmap();
                  bgCoreponent.addChild(_loc2_);
               },null,AssetsProxy.NEWS);
               content.addChild(bgCoreponent);
            }
         }
         overlayList = assignmentsXML.child("overlay");
         if(overlayList.length() > 0)
         {
            for each(child in overlayList)
            {
               overLay = new Coreponent();
               assetResKey = child.attribute("assetID");
               assetResKey = assetResKey.substr(0,assetResKey.lastIndexOf(".")) || assetResKey;
               overLay.loadResource(assetResKey,function(param1:ImageFinisher):void
               {
                  var _loc2_:Bitmap = param1.getBitmap();
                  _loc2_.x = CommandCenterConsts.CONTENT_WIDTH - _loc2_.width;
                  overLay.addChild(_loc2_);
               },null,AssetsProxy.NEWS);
               content.addChild(overLay);
            }
         }
         labels = assignmentsXML.child("label");
         for each(labelXML in labels)
         {
            label = new Label();
            this.assignPosition(label,labelXML.attribute("position"));
            this.assignLabelStyle(label,labelXML.attribute("style"));
            this.setLabelText(label,labelXML);
            content.addChild(label);
         }
         if(definition.showCountDown)
         {
            timerXML = CommandCenterConsts.TIMER_XML;
            timer = new Label();
            this.assignPosition(timer,timerXML.attribute("position"));
            this.assignLabelStyle(timer,timerXML.attribute("style"));
            timer.text = "-";
            content.addTimer(timer);
         }
      }
      
      private function setLabelText(param1:Label, param2:XML) : void
      {
         var _loc3_:String = String(param2.attribute("text"));
         var _loc4_:Boolean = BPLocaleUtils.hasTranslation(_loc3_,"bn");
         var _loc5_:String = _loc4_ ? BPLocale.getItemInCategory("bn",_loc3_) : _loc3_;
         param1.text = HtmlTextUtils.removeTags(_loc5_);
      }
      
      private function assignLabelStyle(param1:Label, param2:String) : void
      {
         if(param2)
         {
            if(!TextStyleRepository.getInstance().getByName(this.STYLE_PREFIX_LABEL + param2))
            {
               return;
            }
            param1.registeredTextStyleName = this.STYLE_PREFIX_LABEL + param2;
         }
      }
      
      private function assignButtonStyle(param1:Button, param2:String) : void
      {
         if(param2)
         {
            if(!SkinRepository.getInstance().getSkin(this.STYLE_PREFIX_BUTTON + param2))
            {
               return;
            }
            param1.registeredSkinName = this.STYLE_PREFIX_BUTTON + param2;
         }
      }
      
      private function assignPosition(param1:Coreponent, param2:String) : void
      {
         var _loc3_:Rectangle = this._positionLookup[param2];
         if(_loc3_)
         {
            param1.x = _loc3_.x;
            param1.y = _loc3_.y;
            param1.width = _loc3_.width;
            param1.height = _loc3_.height;
         }
      }
      
      private function assignBTNPosition(param1:Coreponent, param2:String) : void
      {
         var _loc3_:Rectangle = this._positionLookup[param2];
         if(_loc3_)
         {
            if(param2 == "full_size")
            {
               param1.y = _loc3_.y;
               param1.x = _loc3_.x;
               param1.width = _loc3_.width;
               param1.height = _loc3_.height;
            }
            else
            {
               param1.y = _loc3_.y;
               param1.width = 182;
               param1.height = 27;
            }
         }
      }
      
      private function handleXMLLoaded(param1:XMLFinisher) : void
      {
         var _loc3_:XML = null;
         var _loc2_:XMLList = param1.getXML().child("position");
         for each(_loc3_ in _loc2_)
         {
            this._positionLookup[String(_loc3_.attribute("id"))] = new Rectangle(int(_loc3_.attribute("x")),int(_loc3_.attribute("y")),int(_loc3_.attribute("width")),int(_loc3_.attribute("height")));
         }
         param1.dispose();
         this.ready.dispatch();
      }
   }
}

