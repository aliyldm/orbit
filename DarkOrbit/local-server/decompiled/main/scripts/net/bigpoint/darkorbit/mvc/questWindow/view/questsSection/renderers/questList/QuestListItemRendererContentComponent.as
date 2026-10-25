package net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.renderers.questList
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.states.SetStyle;
   import mx.states.State;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.guicomponents.components.Scale9GridImage;
   import spark.components.Image;
   import spark.components.RichText;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   import spark.layouts.VerticalAlign;
   
   use namespace mx_internal;
   
   public class QuestListItemRendererContentComponent extends SkinnableContainer implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _1292595405backgroundImage:Scale9GridImage;
      
      private var _1543240144completedImage:Scale9GridImage;
      
      private var _394351553disabledImage:Scale9GridImage;
      
      private var _533088900inProgressGlowImage:Scale9GridImage;
      
      private var _665283556lockedGlowImage:Scale9GridImage;
      
      private var _135075575questAdditionalInfo:RichText;
      
      private var _298506343questNameLabel:RichText;
      
      private var _1371966933questTypeIcon:Image;
      
      private var _1247537117rollOverGlowImage:Scale9GridImage;
      
      private var _1436036992selectedImage:Scale9GridImage;
      
      private var _1593266629textsContainer:VGroup;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function QuestListItemRendererContentComponent()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._QuestListItemRendererContentComponent_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_questWindow_view_questsSection_renderers_questList_QuestListItemRendererContentComponentWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return QuestListItemRendererContentComponent[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._QuestListItemRendererContentComponent_Array2_c);
         this.currentState = "normal";
         this.addEventListener("creationComplete",this.___QuestListItemRendererContentComponent_SkinnableContainer1_creationComplete);
         this.addEventListener("stateChangeComplete",this.___QuestListItemRendererContentComponent_SkinnableContainer1_stateChangeComplete);
         this.addEventListener("rollOut",this.___QuestListItemRendererContentComponent_SkinnableContainer1_rollOut);
         this.addEventListener("rollOver",this.___QuestListItemRendererContentComponent_SkinnableContainer1_rollOver);
         this.addEventListener("click",this.___QuestListItemRendererContentComponent_SkinnableContainer1_click);
         states = [new State({
            "name":"normal",
            "overrides":[]
         }),new State({
            "name":"disabled",
            "overrides":[new SetStyle().initializeFromObject({
               "target":"questNameLabel",
               "name":"color",
               "value":12632256
            }),new SetStyle().initializeFromObject({
               "target":"questAdditionalInfo",
               "name":"color",
               "value":12632256
            })]
         }),new State({
            "name":"selected",
            "overrides":[]
         })];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         QuestListItemRendererContentComponent._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         var factory:IFlexModuleFactory = param1;
         super.moduleFactory = factory;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration(null,styleManager);
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.backgroundColor = 1844009;
         };
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      protected function creationCompleteHandler() : void
      {
      }
      
      protected function stateChangeCompleteHandler() : void
      {
      }
      
      protected function rollHandler(param1:MouseEvent) : void
      {
      }
      
      protected function clickHandler(param1:MouseEvent) : void
      {
      }
      
      private function _QuestListItemRendererContentComponent_Array2_c() : Array
      {
         return [this._QuestListItemRendererContentComponent_Scale9GridImage1_i(),this._QuestListItemRendererContentComponent_Scale9GridImage2_i(),this._QuestListItemRendererContentComponent_Scale9GridImage3_i(),this._QuestListItemRendererContentComponent_Scale9GridImage4_i(),this._QuestListItemRendererContentComponent_Scale9GridImage5_i(),this._QuestListItemRendererContentComponent_Scale9GridImage6_i(),this._QuestListItemRendererContentComponent_Scale9GridImage7_i(),this._QuestListItemRendererContentComponent_VGroup1_i(),this._QuestListItemRendererContentComponent_Image1_i()];
      }
      
      private function _QuestListItemRendererContentComponent_Scale9GridImage1_i() : Scale9GridImage
      {
         var _loc1_:Scale9GridImage = new Scale9GridImage();
         _loc1_.percentWidth = 100;
         _loc1_.height = 35;
         _loc1_.id = "backgroundImage";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.backgroundImage = _loc1_;
         BindingManager.executeBindings(this,"backgroundImage",this.backgroundImage);
         return _loc1_;
      }
      
      private function _QuestListItemRendererContentComponent_Scale9GridImage2_i() : Scale9GridImage
      {
         var _loc1_:Scale9GridImage = new Scale9GridImage();
         _loc1_.percentWidth = 100;
         _loc1_.height = 35;
         _loc1_.alpha = 0;
         _loc1_.id = "disabledImage";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.disabledImage = _loc1_;
         BindingManager.executeBindings(this,"disabledImage",this.disabledImage);
         return _loc1_;
      }
      
      private function _QuestListItemRendererContentComponent_Scale9GridImage3_i() : Scale9GridImage
      {
         var _loc1_:Scale9GridImage = new Scale9GridImage();
         _loc1_.percentWidth = 100;
         _loc1_.height = 35;
         _loc1_.alpha = 0;
         _loc1_.id = "completedImage";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.completedImage = _loc1_;
         BindingManager.executeBindings(this,"completedImage",this.completedImage);
         return _loc1_;
      }
      
      private function _QuestListItemRendererContentComponent_Scale9GridImage4_i() : Scale9GridImage
      {
         var _loc1_:Scale9GridImage = new Scale9GridImage();
         _loc1_.percentWidth = 100;
         _loc1_.height = 35;
         _loc1_.alpha = 0;
         _loc1_.id = "selectedImage";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.selectedImage = _loc1_;
         BindingManager.executeBindings(this,"selectedImage",this.selectedImage);
         return _loc1_;
      }
      
      private function _QuestListItemRendererContentComponent_Scale9GridImage5_i() : Scale9GridImage
      {
         var _loc1_:Scale9GridImage = new Scale9GridImage();
         _loc1_.percentWidth = 100;
         _loc1_.height = 35;
         _loc1_.alpha = 0;
         _loc1_.id = "lockedGlowImage";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.lockedGlowImage = _loc1_;
         BindingManager.executeBindings(this,"lockedGlowImage",this.lockedGlowImage);
         return _loc1_;
      }
      
      private function _QuestListItemRendererContentComponent_Scale9GridImage6_i() : Scale9GridImage
      {
         var _loc1_:Scale9GridImage = new Scale9GridImage();
         _loc1_.percentWidth = 100;
         _loc1_.height = 35;
         _loc1_.alpha = 0;
         _loc1_.id = "inProgressGlowImage";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.inProgressGlowImage = _loc1_;
         BindingManager.executeBindings(this,"inProgressGlowImage",this.inProgressGlowImage);
         return _loc1_;
      }
      
      private function _QuestListItemRendererContentComponent_Scale9GridImage7_i() : Scale9GridImage
      {
         var _loc1_:Scale9GridImage = new Scale9GridImage();
         _loc1_.percentWidth = 100;
         _loc1_.height = 35;
         _loc1_.alpha = 0;
         _loc1_.id = "rollOverGlowImage";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rollOverGlowImage = _loc1_;
         BindingManager.executeBindings(this,"rollOverGlowImage",this.rollOverGlowImage);
         return _loc1_;
      }
      
      private function _QuestListItemRendererContentComponent_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.left = 35;
         _loc1_.top = 4;
         _loc1_.verticalCenter = 0;
         _loc1_.gap = 0;
         _loc1_.mxmlContent = [this._QuestListItemRendererContentComponent_RichText1_i(),this._QuestListItemRendererContentComponent_RichText2_i()];
         _loc1_.id = "textsContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.textsContainer = _loc1_;
         BindingManager.executeBindings(this,"textsContainer",this.textsContainer);
         return _loc1_;
      }
      
      private function _QuestListItemRendererContentComponent_RichText1_i() : RichText
      {
         var _loc1_:RichText = new RichText();
         _loc1_.text = "-";
         _loc1_.maxWidth = 170;
         _loc1_.maxDisplayedLines = 1;
         _loc1_.setStyle("fontSize",12);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.id = "questNameLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.questNameLabel = _loc1_;
         BindingManager.executeBindings(this,"questNameLabel",this.questNameLabel);
         return _loc1_;
      }
      
      private function _QuestListItemRendererContentComponent_RichText2_i() : RichText
      {
         var _loc1_:RichText = new RichText();
         _loc1_.text = "-";
         _loc1_.maxWidth = 170;
         _loc1_.maxDisplayedLines = 1;
         _loc1_.setStyle("fontSize",10);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.id = "questAdditionalInfo";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.questAdditionalInfo = _loc1_;
         BindingManager.executeBindings(this,"questAdditionalInfo",this.questAdditionalInfo);
         return _loc1_;
      }
      
      private function _QuestListItemRendererContentComponent_Image1_i() : Image
      {
         var _loc1_:Image = new Image();
         _loc1_.left = 5;
         _loc1_.verticalCenter = 0;
         _loc1_.id = "questTypeIcon";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.questTypeIcon = _loc1_;
         BindingManager.executeBindings(this,"questTypeIcon",this.questTypeIcon);
         return _loc1_;
      }
      
      public function ___QuestListItemRendererContentComponent_SkinnableContainer1_creationComplete(param1:FlexEvent) : void
      {
         this.creationCompleteHandler();
      }
      
      public function ___QuestListItemRendererContentComponent_SkinnableContainer1_stateChangeComplete(param1:FlexEvent) : void
      {
         this.stateChangeCompleteHandler();
      }
      
      public function ___QuestListItemRendererContentComponent_SkinnableContainer1_rollOut(param1:MouseEvent) : void
      {
         this.rollHandler(param1);
      }
      
      public function ___QuestListItemRendererContentComponent_SkinnableContainer1_rollOver(param1:MouseEvent) : void
      {
         this.rollHandler(param1);
      }
      
      public function ___QuestListItemRendererContentComponent_SkinnableContainer1_click(param1:MouseEvent) : void
      {
         this.clickHandler(param1);
      }
      
      private function _QuestListItemRendererContentComponent_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = VerticalAlign.MIDDLE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"textsContainer.verticalAlign");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get backgroundImage() : Scale9GridImage
      {
         return this._1292595405backgroundImage;
      }
      
      public function set backgroundImage(param1:Scale9GridImage) : void
      {
         var _loc2_:Object = this._1292595405backgroundImage;
         if(_loc2_ !== param1)
         {
            this._1292595405backgroundImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"backgroundImage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get completedImage() : Scale9GridImage
      {
         return this._1543240144completedImage;
      }
      
      public function set completedImage(param1:Scale9GridImage) : void
      {
         var _loc2_:Object = this._1543240144completedImage;
         if(_loc2_ !== param1)
         {
            this._1543240144completedImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"completedImage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get disabledImage() : Scale9GridImage
      {
         return this._394351553disabledImage;
      }
      
      public function set disabledImage(param1:Scale9GridImage) : void
      {
         var _loc2_:Object = this._394351553disabledImage;
         if(_loc2_ !== param1)
         {
            this._394351553disabledImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"disabledImage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inProgressGlowImage() : Scale9GridImage
      {
         return this._533088900inProgressGlowImage;
      }
      
      public function set inProgressGlowImage(param1:Scale9GridImage) : void
      {
         var _loc2_:Object = this._533088900inProgressGlowImage;
         if(_loc2_ !== param1)
         {
            this._533088900inProgressGlowImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inProgressGlowImage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lockedGlowImage() : Scale9GridImage
      {
         return this._665283556lockedGlowImage;
      }
      
      public function set lockedGlowImage(param1:Scale9GridImage) : void
      {
         var _loc2_:Object = this._665283556lockedGlowImage;
         if(_loc2_ !== param1)
         {
            this._665283556lockedGlowImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lockedGlowImage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questAdditionalInfo() : RichText
      {
         return this._135075575questAdditionalInfo;
      }
      
      public function set questAdditionalInfo(param1:RichText) : void
      {
         var _loc2_:Object = this._135075575questAdditionalInfo;
         if(_loc2_ !== param1)
         {
            this._135075575questAdditionalInfo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questAdditionalInfo",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questNameLabel() : RichText
      {
         return this._298506343questNameLabel;
      }
      
      public function set questNameLabel(param1:RichText) : void
      {
         var _loc2_:Object = this._298506343questNameLabel;
         if(_loc2_ !== param1)
         {
            this._298506343questNameLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questNameLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questTypeIcon() : Image
      {
         return this._1371966933questTypeIcon;
      }
      
      public function set questTypeIcon(param1:Image) : void
      {
         var _loc2_:Object = this._1371966933questTypeIcon;
         if(_loc2_ !== param1)
         {
            this._1371966933questTypeIcon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questTypeIcon",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rollOverGlowImage() : Scale9GridImage
      {
         return this._1247537117rollOverGlowImage;
      }
      
      public function set rollOverGlowImage(param1:Scale9GridImage) : void
      {
         var _loc2_:Object = this._1247537117rollOverGlowImage;
         if(_loc2_ !== param1)
         {
            this._1247537117rollOverGlowImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rollOverGlowImage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedImage() : Scale9GridImage
      {
         return this._1436036992selectedImage;
      }
      
      public function set selectedImage(param1:Scale9GridImage) : void
      {
         var _loc2_:Object = this._1436036992selectedImage;
         if(_loc2_ !== param1)
         {
            this._1436036992selectedImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedImage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get textsContainer() : VGroup
      {
         return this._1593266629textsContainer;
      }
      
      public function set textsContainer(param1:VGroup) : void
      {
         var _loc2_:Object = this._1593266629textsContainer;
         if(_loc2_ !== param1)
         {
            this._1593266629textsContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textsContainer",_loc2_,param1));
            }
         }
      }
   }
}

