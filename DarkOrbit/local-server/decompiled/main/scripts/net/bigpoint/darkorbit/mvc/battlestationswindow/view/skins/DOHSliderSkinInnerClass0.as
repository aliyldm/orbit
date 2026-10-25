package net.bigpoint.darkorbit.mvc.battlestationswindow.view.skins
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
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.guicomponents.components.Scale9GridImage;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import spark.components.DataRenderer;
   import spark.components.Group;
   import spark.components.Label;
   import spark.primitives.BitmapImage;
   
   use namespace mx_internal;
   
   public class DOHSliderSkinInnerClass0 extends DataRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _43470689dataTipBackground:Scale9GridImage;
      
      private var _1184053038labelDisplay:Label;
      
      private var _88844982outerDocument:DOHSliderSkin;
      
      private var _85561432sliderArrow:BitmapImage;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _1932235515_tipBgWidth:int;
      
      private var _561432661_sliderArrowPos:int;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function DOHSliderSkinInnerClass0()
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
         bindings = this._DOHSliderSkinInnerClass0_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_battlestationswindow_view_skins_DOHSliderSkinInnerClass0WatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return DOHSliderSkinInnerClass0[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.minHeight = 24;
         this.minWidth = 40;
         this.y = -34;
         this.mxmlContent = [this._DOHSliderSkinInnerClass0_Group1_c(),this._DOHSliderSkinInnerClass0_BitmapImage1_i(),this._DOHSliderSkinInnerClass0_Label1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         DOHSliderSkinInnerClass0._watcherSetupUtil = param1;
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
      
      private function creationCompleteHandler() : void
      {
         this.dataTipBackground.source = ResourceManager.getBitmap("battleStationsUI","slider_handle_display");
         this.dataTipBackground.scale9Grid = new Rectangle(15,1,1,1);
         this.updateLayoutValues();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.updateLayoutValues();
      }
      
      private function updateLayoutValues() : void
      {
         this._tipBgWidth = Math.max(42,this.labelDisplay.width + 13);
         this._sliderArrowPos = this.dataTipBackground.x + this._tipBgWidth / 2;
      }
      
      private function _DOHSliderSkinInnerClass0_Group1_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.top = 12;
         _loc1_.mxmlContent = [this._DOHSliderSkinInnerClass0_Scale9GridImage1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DOHSliderSkinInnerClass0_Scale9GridImage1_i() : Scale9GridImage
      {
         var _loc1_:Scale9GridImage = new Scale9GridImage();
         _loc1_.id = "dataTipBackground";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.dataTipBackground = _loc1_;
         BindingManager.executeBindings(this,"dataTipBackground",this.dataTipBackground);
         return _loc1_;
      }
      
      private function _DOHSliderSkinInnerClass0_BitmapImage1_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.top = 28;
         _loc1_.initialized(this,"sliderArrow");
         this.sliderArrow = _loc1_;
         BindingManager.executeBindings(this,"sliderArrow",this.sliderArrow);
         return _loc1_;
      }
      
      private function _DOHSliderSkinInnerClass0_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.horizontalCenter = 0;
         _loc1_.verticalCenter = 1;
         _loc1_.top = 21;
         _loc1_.bottom = 5;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.setStyle("fontWeight","normal");
         _loc1_.setStyle("color",15262400);
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.addEventListener("creationComplete",this.__labelDisplay_creationComplete);
         _loc1_.id = "labelDisplay";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelDisplay = _loc1_;
         BindingManager.executeBindings(this,"labelDisplay",this.labelDisplay);
         return _loc1_;
      }
      
      public function __labelDisplay_creationComplete(param1:FlexEvent) : void
      {
         this.creationCompleteHandler();
      }
      
      private function _DOHSliderSkinInnerClass0_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Number
         {
            return _tipBgWidth;
         },null,"dataTipBackground.width");
         result[1] = new Binding(this,function():Number
         {
            return _sliderArrowPos;
         },null,"sliderArrow.x");
         result[2] = new Binding(this,function():Object
         {
            return ResourceManager.getBitmap("battleStationsUI","slider_arrow");
         },null,"sliderArrow.source");
         result[3] = new Binding(this,null,null,"labelDisplay.text","data");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get dataTipBackground() : Scale9GridImage
      {
         return this._43470689dataTipBackground;
      }
      
      public function set dataTipBackground(param1:Scale9GridImage) : void
      {
         var _loc2_:Object = this._43470689dataTipBackground;
         if(_loc2_ !== param1)
         {
            this._43470689dataTipBackground = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dataTipBackground",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get labelDisplay() : Label
      {
         return this._1184053038labelDisplay;
      }
      
      public function set labelDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._1184053038labelDisplay;
         if(_loc2_ !== param1)
         {
            this._1184053038labelDisplay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelDisplay",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get outerDocument() : DOHSliderSkin
      {
         return this._88844982outerDocument;
      }
      
      public function set outerDocument(param1:DOHSliderSkin) : void
      {
         var _loc2_:Object = this._88844982outerDocument;
         if(_loc2_ !== param1)
         {
            this._88844982outerDocument = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"outerDocument",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sliderArrow() : BitmapImage
      {
         return this._85561432sliderArrow;
      }
      
      public function set sliderArrow(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._85561432sliderArrow;
         if(_loc2_ !== param1)
         {
            this._85561432sliderArrow = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sliderArrow",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _tipBgWidth() : int
      {
         return this._1932235515_tipBgWidth;
      }
      
      private function set _tipBgWidth(param1:int) : void
      {
         var _loc2_:Object = this._1932235515_tipBgWidth;
         if(_loc2_ !== param1)
         {
            this._1932235515_tipBgWidth = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_tipBgWidth",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _sliderArrowPos() : int
      {
         return this._561432661_sliderArrowPos;
      }
      
      private function set _sliderArrowPos(param1:int) : void
      {
         var _loc2_:Object = this._561432661_sliderArrowPos;
         if(_loc2_ !== param1)
         {
            this._561432661_sliderArrowPos = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_sliderArrowPos",_loc2_,param1));
            }
         }
      }
   }
}

