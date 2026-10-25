package net.bigpoint.darkorbit.mvc.battlestationswindow.view.installationStatus.components
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
   import mx.controls.ProgressBar;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.events.BattleStationWindowEvent;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.installationStatus.skins.DOProgressBarSkin;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.installationStatus.skins.DOProgressTrackSkin;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOButtonBaseSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOViewContainerSkin;
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   
   use namespace mx_internal;
   
   public class InstallationStatusView extends InstallationStatusBase implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _315970861groupDepth1:VGroup;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function InstallationStatusView()
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
         bindings = this._InstallationStatusView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_battlestationswindow_view_installationStatus_components_InstallationStatusViewWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return InstallationStatusView[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._InstallationStatusView_Array1_c);
         this.addEventListener("creationComplete",this.___InstallationStatusView_InstallationStatusBase1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         InstallationStatusView._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      private function handleBuildButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new BattleStationWindowEvent(BattleStationWindowEvent.SHOW_BUILD_TIME_SELECTION_POPUP));
      }
      
      private function _InstallationStatusView_Array1_c() : Array
      {
         return [this._InstallationStatusView_VGroup1_i()];
      }
      
      private function _InstallationStatusView_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._InstallationStatusView_Label1_i(),this._InstallationStatusView_SkinnableContainer1_c()];
         _loc1_.id = "groupDepth1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.groupDepth1 = _loc1_;
         BindingManager.executeBindings(this,"groupDepth1",this.groupDepth1);
         return _loc1_;
      }
      
      private function _InstallationStatusView_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("fontSize",13);
         _loc1_.setStyle("fontFamily","EurostileTHea");
         _loc1_.setStyle("color",16763904);
         _loc1_.setStyle("paddingBottom",-4);
         _loc1_.id = "titleLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         titleLabel = _loc1_;
         BindingManager.executeBindings(this,"titleLabel",titleLabel);
         return _loc1_;
      }
      
      private function _InstallationStatusView_SkinnableContainer1_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._InstallationStatusView_Array3_c);
         _loc1_.setStyle("skinClass",DOViewContainerSkin);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _InstallationStatusView_Array3_c() : Array
      {
         return [this._InstallationStatusView_VGroup2_c()];
      }
      
      private function _InstallationStatusView_VGroup2_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.gap = -5;
         _loc1_.top = 3;
         _loc1_.mxmlContent = [this._InstallationStatusView_HGroup1_c(),this._InstallationStatusView_ProgressBar1_i(),this._InstallationStatusView_HGroup2_c(),this._InstallationStatusView_ProgressBar2_i(),this._InstallationStatusView_Group1_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _InstallationStatusView_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.paddingBottom = 6;
         _loc1_.verticalAlign = "bottom";
         _loc1_.mxmlContent = [this._InstallationStatusView_Label2_i(),this._InstallationStatusView_Label3_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _InstallationStatusView_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 80;
         _loc1_.setStyle("paddingLeft",4);
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",15327423);
         _loc1_.id = "yourClanProgressLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         yourClanProgressLabel = _loc1_;
         BindingManager.executeBindings(this,"yourClanProgressLabel",yourClanProgressLabel);
         return _loc1_;
      }
      
      private function _InstallationStatusView_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 20;
         _loc1_.setStyle("paddingRight",4);
         _loc1_.setStyle("textAlign","right");
         _loc1_.setStyle("fontSize",10);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",16777215);
         _loc1_.id = "yourClanProgressValue";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         yourClanProgressValue = _loc1_;
         BindingManager.executeBindings(this,"yourClanProgressValue",yourClanProgressValue);
         return _loc1_;
      }
      
      private function _InstallationStatusView_ProgressBar1_i() : ProgressBar
      {
         var _loc1_:ProgressBar = new ProgressBar();
         _loc1_.label = "";
         _loc1_.horizontalCenter = 0;
         _loc1_.mode = "manual";
         _loc1_.percentWidth = 100;
         _loc1_.height = 16;
         _loc1_.setStyle("barSkin",DOProgressBarSkin);
         _loc1_.setStyle("trackSkin",DOProgressTrackSkin);
         _loc1_.id = "yourClanProgress";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         yourClanProgress = _loc1_;
         BindingManager.executeBindings(this,"yourClanProgress",yourClanProgress);
         return _loc1_;
      }
      
      private function _InstallationStatusView_HGroup2_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.paddingBottom = 6;
         _loc1_.verticalAlign = "bottom";
         _loc1_.mxmlContent = [this._InstallationStatusView_Label4_i(),this._InstallationStatusView_Label5_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _InstallationStatusView_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 80;
         _loc1_.setStyle("paddingLeft",4);
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",15327423);
         _loc1_.id = "leadingClanProgressLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         leadingClanProgressLabel = _loc1_;
         BindingManager.executeBindings(this,"leadingClanProgressLabel",leadingClanProgressLabel);
         return _loc1_;
      }
      
      private function _InstallationStatusView_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 20;
         _loc1_.setStyle("paddingRight",4);
         _loc1_.setStyle("textAlign","right");
         _loc1_.setStyle("fontSize",10);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",16777215);
         _loc1_.id = "leadingClanProgressValue";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         leadingClanProgressValue = _loc1_;
         BindingManager.executeBindings(this,"leadingClanProgressValue",leadingClanProgressValue);
         return _loc1_;
      }
      
      private function _InstallationStatusView_ProgressBar2_i() : ProgressBar
      {
         var _loc1_:ProgressBar = new ProgressBar();
         _loc1_.label = "";
         _loc1_.horizontalCenter = 0;
         _loc1_.mode = "manual";
         _loc1_.percentWidth = 100;
         _loc1_.height = 16;
         _loc1_.setStyle("barSkin",DOProgressBarSkin);
         _loc1_.setStyle("trackSkin",DOProgressTrackSkin);
         _loc1_.id = "leadingClanProgress";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         leadingClanProgress = _loc1_;
         BindingManager.executeBindings(this,"leadingClanProgress",leadingClanProgress);
         return _loc1_;
      }
      
      private function _InstallationStatusView_Group1_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.mxmlContent = [this._InstallationStatusView_DOButtonBase1_i(),this._InstallationStatusView_DOButtonBase2_i(),this._InstallationStatusView_Button1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _InstallationStatusView_DOButtonBase1_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.width = 215;
         _loc1_.top = 4;
         _loc1_.enabled = false;
         _loc1_.visible = true;
         _loc1_.styleName = "questWindowAcceptQuest";
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = false;
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.id = "buildButtonDisabled";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         buildButtonDisabled = _loc1_;
         BindingManager.executeBindings(this,"buildButtonDisabled",buildButtonDisabled);
         return _loc1_;
      }
      
      private function _InstallationStatusView_DOButtonBase2_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.width = 215;
         _loc1_.top = 4;
         _loc1_.enabled = true;
         _loc1_.visible = false;
         _loc1_.styleName = "questWindowAcceptQuest";
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.__buildButton_click);
         _loc1_.id = "buildButton";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         buildButton = _loc1_;
         BindingManager.executeBindings(this,"buildButton",buildButton);
         return _loc1_;
      }
      
      public function __buildButton_click(param1:MouseEvent) : void
      {
         this.handleBuildButtonClicked(param1);
      }
      
      private function _InstallationStatusView_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.visible = false;
         _loc1_.percentWidth = 100;
         _loc1_.height = 25;
         _loc1_.top = 4;
         _loc1_.id = "tipButton";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         tipButton = _loc1_;
         BindingManager.executeBindings(this,"tipButton",tipButton);
         return _loc1_;
      }
      
      public function ___InstallationStatusView_InstallationStatusBase1_creationComplete(param1:FlexEvent) : void
      {
         creationCompleteHandler(param1);
      }
      
      private function _InstallationStatusView_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = _yourClanModulesTipText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"yourClanProgressLabel.toolTip");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = _yourClanModulesTipText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"yourClanProgressValue.toolTip");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = _yourClanModulesTipText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"yourClanProgress.toolTip");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = _leadingClanModulesTipText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"leadingClanProgressLabel.toolTip");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = _leadingClanModulesTipText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"leadingClanProgressValue.toolTip");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = _leadingClanModulesTipText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"leadingClanProgress.toolTip");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get groupDepth1() : VGroup
      {
         return this._315970861groupDepth1;
      }
      
      public function set groupDepth1(param1:VGroup) : void
      {
         var _loc2_:Object = this._315970861groupDepth1;
         if(_loc2_ !== param1)
         {
            this._315970861groupDepth1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"groupDepth1",_loc2_,param1));
            }
         }
      }
   }
}

