package net.bigpoint.darkorbit.mvc.common.view.skins
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
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.states.SetProperty;
   import mx.states.State;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.guicomponents.components.Scale9GridImage;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import spark.components.Group;
   import spark.components.SkinnableContainer;
   import spark.components.supportClasses.Skin;
   import spark.layouts.BasicLayout;
   
   use namespace mx_internal;
   
   public class DOCustomScaleBgContainerSkin extends Skin implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _809612678contentGroup:spark.components.Group;
      
      private var _973934150scale9GridImage:Scale9GridImage;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _1033751043_skinBimapData:BitmapData;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _213507019hostComponent:SkinnableContainer;
      
      public function DOCustomScaleBgContainerSkin()
      {
         var watchers:Array;
         var i:uint;
         var bindings:Array = null;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._DOCustomScaleBgContainerSkin_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_common_view_skins_DOCustomScaleBgContainerSkinWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return DOCustomScaleBgContainerSkin[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._DOCustomScaleBgContainerSkin_Group1_c(),this._DOCustomScaleBgContainerSkin_Group2_i()];
         this.currentState = "normal";
         states = [new State({
            "name":"normal",
            "overrides":[]
         }),new State({
            "name":"disabled",
            "overrides":[new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            })]
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
         DOCustomScaleBgContainerSkin._watcherSetupUtil = param1;
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
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:String = getStyle("libID");
         var _loc4_:String = getStyle("backgroundBitmap");
         this._skinBimapData = ResourceManager.getBitmapData(_loc3_,_loc4_);
         this.scale9GridImage.scale9Grid = new Rectangle(10,10,1,1);
         super.updateDisplayList(param1,param2);
      }
      
      private function _DOCustomScaleBgContainerSkin_Group1_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._DOCustomScaleBgContainerSkin_Scale9GridImage1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DOCustomScaleBgContainerSkin_Scale9GridImage1_i() : Scale9GridImage
      {
         var _loc1_:Scale9GridImage = new Scale9GridImage();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.id = "scale9GridImage";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.scale9GridImage = _loc1_;
         BindingManager.executeBindings(this,"scale9GridImage",this.scale9GridImage);
         return _loc1_;
      }
      
      private function _DOCustomScaleBgContainerSkin_Group2_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.minWidth = 0;
         _loc1_.minHeight = 0;
         _loc1_.layout = this._DOCustomScaleBgContainerSkin_BasicLayout1_c();
         _loc1_.id = "contentGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.contentGroup = _loc1_;
         BindingManager.executeBindings(this,"contentGroup",this.contentGroup);
         return _loc1_;
      }
      
      private function _DOCustomScaleBgContainerSkin_BasicLayout1_c() : BasicLayout
      {
         return new BasicLayout();
      }
      
      private function _DOCustomScaleBgContainerSkin_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():*
         {
            return _skinBimapData;
         },null,"scale9GridImage.source");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get contentGroup() : spark.components.Group
      {
         return this._809612678contentGroup;
      }
      
      public function set contentGroup(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._809612678contentGroup;
         if(_loc2_ !== param1)
         {
            this._809612678contentGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get scale9GridImage() : Scale9GridImage
      {
         return this._973934150scale9GridImage;
      }
      
      public function set scale9GridImage(param1:Scale9GridImage) : void
      {
         var _loc2_:Object = this._973934150scale9GridImage;
         if(_loc2_ !== param1)
         {
            this._973934150scale9GridImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"scale9GridImage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _skinBimapData() : BitmapData
      {
         return this._1033751043_skinBimapData;
      }
      
      private function set _skinBimapData(param1:BitmapData) : void
      {
         var _loc2_:Object = this._1033751043_skinBimapData;
         if(_loc2_ !== param1)
         {
            this._1033751043_skinBimapData = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_skinBimapData",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hostComponent() : SkinnableContainer
      {
         return this._213507019hostComponent;
      }
      
      public function set hostComponent(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._213507019hostComponent;
         if(_loc2_ !== param1)
         {
            this._213507019hostComponent = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hostComponent",_loc2_,param1));
            }
         }
      }
   }
}

