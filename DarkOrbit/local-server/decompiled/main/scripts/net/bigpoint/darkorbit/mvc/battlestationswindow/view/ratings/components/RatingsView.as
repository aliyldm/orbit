package net.bigpoint.darkorbit.mvc.battlestationswindow.view.ratings.components
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
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.installationStatus.skins.DOProgressBarSkin;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.installationStatus.skins.DOProgressTrackSkin;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOButtonBaseSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOViewContainerSkin;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   
   use namespace mx_internal;
   
   public class RatingsView extends RatingsBase implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function RatingsView()
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
         bindings = this._RatingsView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_battlestationswindow_view_ratings_components_RatingsViewWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return RatingsView[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._RatingsView_Array1_c);
         this.addEventListener("creationComplete",this.___RatingsView_RatingsBase1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         RatingsView._watcherSetupUtil = param1;
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
      
      private function _RatingsView_Array1_c() : Array
      {
         return [this._RatingsView_Group1_c()];
      }
      
      private function _RatingsView_Group1_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalCenter = 0;
         _loc1_.verticalCenter = 0;
         _loc1_.mxmlContent = [this._RatingsView_VGroup1_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RatingsView_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalCenter = 0;
         _loc1_.mxmlContent = [this._RatingsView_Label1_i(),this._RatingsView_SkinnableContainer1_c(),this._RatingsView_Label2_i(),this._RatingsView_SkinnableContainer2_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RatingsView_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("fontSize",13);
         _loc1_.setStyle("fontFamily","EurostileTHea");
         _loc1_.setStyle("color",16763904);
         _loc1_.setStyle("paddingBottom",-10);
         _loc1_.id = "ratingsTitleLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         ratingsTitleLabel = _loc1_;
         BindingManager.executeBindings(this,"ratingsTitleLabel",ratingsTitleLabel);
         return _loc1_;
      }
      
      private function _RatingsView_SkinnableContainer1_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.styleName = "ratingsBackground";
         _loc1_.width = 221;
         _loc1_.height = 81;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._RatingsView_Array4_c);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RatingsView_Array4_c() : Array
      {
         return [this._RatingsView_HGroup1_c()];
      }
      
      private function _RatingsView_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 0;
         _loc1_.horizontalCenter = 0;
         _loc1_.left = 4;
         _loc1_.mxmlContent = [this._RatingsView_StatItem1_i(),this._RatingsView_StatItem2_i(),this._RatingsView_StatItem3_i(),this._RatingsView_StatItem4_i(),this._RatingsView_StatItem5_i(),this._RatingsView_StatItem6_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RatingsView_StatItem1_i() : StatItem
      {
         var _loc1_:StatItem = new StatItem();
         _loc1_.id = "attackRating";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         attackRating = _loc1_;
         BindingManager.executeBindings(this,"attackRating",attackRating);
         return _loc1_;
      }
      
      private function _RatingsView_StatItem2_i() : StatItem
      {
         var _loc1_:StatItem = new StatItem();
         _loc1_.id = "defenceRating";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         defenceRating = _loc1_;
         BindingManager.executeBindings(this,"defenceRating",defenceRating);
         return _loc1_;
      }
      
      private function _RatingsView_StatItem3_i() : StatItem
      {
         var _loc1_:StatItem = new StatItem();
         _loc1_.id = "repairRating";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         repairRating = _loc1_;
         BindingManager.executeBindings(this,"repairRating",repairRating);
         return _loc1_;
      }
      
      private function _RatingsView_StatItem4_i() : StatItem
      {
         var _loc1_:StatItem = new StatItem();
         _loc1_.id = "honourRating";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         honourRating = _loc1_;
         BindingManager.executeBindings(this,"honourRating",honourRating);
         return _loc1_;
      }
      
      private function _RatingsView_StatItem5_i() : StatItem
      {
         var _loc1_:StatItem = new StatItem();
         _loc1_.id = "epRating";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         epRating = _loc1_;
         BindingManager.executeBindings(this,"epRating",epRating);
         return _loc1_;
      }
      
      private function _RatingsView_StatItem6_i() : StatItem
      {
         var _loc1_:StatItem = new StatItem();
         _loc1_.id = "damageBoosterRating";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         damageBoosterRating = _loc1_;
         BindingManager.executeBindings(this,"damageBoosterRating",damageBoosterRating);
         return _loc1_;
      }
      
      private function _RatingsView_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("fontSize",13);
         _loc1_.setStyle("fontFamily","EurostileTHea");
         _loc1_.setStyle("color",16763904);
         _loc1_.setStyle("paddingBottom",-4);
         _loc1_.id = "deflectorStatusTitle";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         deflectorStatusTitle = _loc1_;
         BindingManager.executeBindings(this,"deflectorStatusTitle",deflectorStatusTitle);
         return _loc1_;
      }
      
      private function _RatingsView_SkinnableContainer2_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._RatingsView_Array6_c);
         _loc1_.setStyle("skinClass",DOViewContainerSkin);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RatingsView_Array6_c() : Array
      {
         return [this._RatingsView_VGroup2_c()];
      }
      
      private function _RatingsView_VGroup2_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.gap = -5;
         _loc1_.top = 3;
         _loc1_.mxmlContent = [this._RatingsView_HGroup2_c(),this._RatingsView_ProgressBar1_i(),this._RatingsView_HGroup3_c(),this._RatingsView_DOButtonBase1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RatingsView_HGroup2_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.paddingBottom = 6;
         _loc1_.verticalAlign = "bottom";
         _loc1_.mxmlContent = [this._RatingsView_Label3_i(),this._RatingsView_Label4_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RatingsView_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 70;
         _loc1_.setStyle("paddingLeft",4);
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",15327423);
         _loc1_.id = "deflectorTimeLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         deflectorTimeLabel = _loc1_;
         BindingManager.executeBindings(this,"deflectorTimeLabel",deflectorTimeLabel);
         return _loc1_;
      }
      
      private function _RatingsView_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 30;
         _loc1_.setStyle("paddingRight",4);
         _loc1_.setStyle("textAlign","right");
         _loc1_.setStyle("fontSize",10);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",16777215);
         _loc1_.id = "deflectorTimeValue";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         deflectorTimeValue = _loc1_;
         BindingManager.executeBindings(this,"deflectorTimeValue",deflectorTimeValue);
         return _loc1_;
      }
      
      private function _RatingsView_ProgressBar1_i() : ProgressBar
      {
         var _loc1_:ProgressBar = new ProgressBar();
         _loc1_.label = "";
         _loc1_.horizontalCenter = 0;
         _loc1_.mode = "manual";
         _loc1_.percentWidth = 100;
         _loc1_.height = 16;
         _loc1_.setStyle("barSkin",DOProgressBarSkin);
         _loc1_.setStyle("trackSkin",DOProgressTrackSkin);
         _loc1_.id = "deflectorTimeProgressBar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         deflectorTimeProgressBar = _loc1_;
         BindingManager.executeBindings(this,"deflectorTimeProgressBar",deflectorTimeProgressBar);
         return _loc1_;
      }
      
      private function _RatingsView_HGroup3_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.paddingBottom = 12;
         _loc1_.verticalAlign = "bottom";
         _loc1_.mxmlContent = [this._RatingsView_Label5_i(),this._RatingsView_Label6_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RatingsView_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 60;
         _loc1_.setStyle("paddingLeft",4);
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",15327423);
         _loc1_.id = "deflectorTimeRegRateLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         deflectorTimeRegRateLabel = _loc1_;
         BindingManager.executeBindings(this,"deflectorTimeRegRateLabel",deflectorTimeRegRateLabel);
         return _loc1_;
      }
      
      private function _RatingsView_Label6_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 40;
         _loc1_.setStyle("paddingRight",4);
         _loc1_.setStyle("textAlign","right");
         _loc1_.setStyle("fontSize",10);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",16777215);
         _loc1_.id = "deflectorTimeRegRateValue";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         deflectorTimeRegRateValue = _loc1_;
         BindingManager.executeBindings(this,"deflectorTimeRegRateValue",deflectorTimeRegRateValue);
         return _loc1_;
      }
      
      private function _RatingsView_DOButtonBase1_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.percentWidth = 100;
         _loc1_.enabled = true;
         _loc1_.styleName = "scalableGreenConfirmButton";
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.__deflectorToggleButton_click);
         _loc1_.id = "deflectorToggleButton";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         deflectorToggleButton = _loc1_;
         BindingManager.executeBindings(this,"deflectorToggleButton",deflectorToggleButton);
         return _loc1_;
      }
      
      public function __deflectorToggleButton_click(param1:MouseEvent) : void
      {
         handleDeflectorShieldToggle(param1);
      }
      
      public function ___RatingsView_RatingsBase1_creationComplete(param1:FlexEvent) : void
      {
         handleCreationComplete();
      }
      
      private function _RatingsView_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = _regenerationTooltipText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"deflectorTimeRegRateLabel.toolTip");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = _regenerationTooltipText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"deflectorTimeRegRateValue.toolTip");
         return result;
      }
   }
}

