package net.bigpoint.darkorbit.mvc.battlestationswindow.view.components
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
   import mx.events.ToolTipEvent;
   import mx.filters.*;
   import mx.graphics.SolidColor;
   import mx.styles.*;
   import spark.components.Group;
   import spark.components.Image;
   import spark.components.Label;
   import spark.primitives.BitmapImage;
   import spark.primitives.Rect;
   
   use namespace mx_internal;
   
   public class ModuleItem extends ModuleItemBase implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _ModuleItem_Rect1:Rect;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ModuleItem()
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
         bindings = this._ModuleItem_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_battlestationswindow_view_components_ModuleItemWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return ModuleItem[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 32;
         this.mxmlContent = [this._ModuleItem_Rect1_i(),this._ModuleItem_BitmapImage1_i(),this._ModuleItem_Group1_i(),this._ModuleItem_Rect2_i(),this._ModuleItem_BitmapImage2_i(),this._ModuleItem_BitmapImage3_i(),this._ModuleItem_Label1_i(),this._ModuleItem_Image1_i(),this._ModuleItem_Group2_i(),this._ModuleItem_BitmapImage4_i()];
         this.addEventListener("creationComplete",this.___ModuleItem_ModuleItemBase1_creationComplete);
         this.addEventListener("rollOver",this.___ModuleItem_ModuleItemBase1_rollOver);
         this.addEventListener("rollOut",this.___ModuleItem_ModuleItemBase1_rollOut);
         this.addEventListener("toolTipCreate",this.___ModuleItem_ModuleItemBase1_toolTipCreate);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ModuleItem._watcherSetupUtil = param1;
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
      
      private function _ModuleItem_Rect1_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.alpha = 0;
         _loc1_.fill = this._ModuleItem_SolidColor1_c();
         _loc1_.initialized(this,"_ModuleItem_Rect1");
         this._ModuleItem_Rect1 = _loc1_;
         BindingManager.executeBindings(this,"_ModuleItem_Rect1",this._ModuleItem_Rect1);
         return _loc1_;
      }
      
      private function _ModuleItem_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         return _loc1_;
      }
      
      private function _ModuleItem_BitmapImage1_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.verticalCenter = 0;
         _loc1_.horizontalCenter = 0;
         _loc1_.visible = false;
         _loc1_.initialized(this,"backgroundImage");
         backgroundImage = _loc1_;
         BindingManager.executeBindings(this,"backgroundImage",backgroundImage);
         return _loc1_;
      }
      
      private function _ModuleItem_Group1_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.visible = false;
         _loc1_.id = "iconContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         iconContainer = _loc1_;
         BindingManager.executeBindings(this,"iconContainer",iconContainer);
         return _loc1_;
      }
      
      private function _ModuleItem_Rect2_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.verticalCenter = 0;
         _loc1_.horizontalCenter = 0;
         _loc1_.width = 30;
         _loc1_.height = 30;
         _loc1_.alpha = 0;
         _loc1_.visible = false;
         _loc1_.fill = this._ModuleItem_SolidColor2_c();
         _loc1_.initialized(this,"backgroundFlash");
         backgroundFlash = _loc1_;
         BindingManager.executeBindings(this,"backgroundFlash",backgroundFlash);
         return _loc1_;
      }
      
      private function _ModuleItem_SolidColor2_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777088;
         return _loc1_;
      }
      
      private function _ModuleItem_BitmapImage2_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.visible = false;
         _loc1_.initialized(this,"hoverIcon");
         hoverIcon = _loc1_;
         BindingManager.executeBindings(this,"hoverIcon",hoverIcon);
         return _loc1_;
      }
      
      private function _ModuleItem_BitmapImage3_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.visible = false;
         _loc1_.initialized(this,"selectedIcon");
         selectedIcon = _loc1_;
         BindingManager.executeBindings(this,"selectedIcon",selectedIcon);
         return _loc1_;
      }
      
      private function _ModuleItem_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.visible = false;
         _loc1_.percentWidth = 100;
         _loc1_.top = 19;
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.id = "installationProgressTimer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         installationProgressTimer = _loc1_;
         BindingManager.executeBindings(this,"installationProgressTimer",installationProgressTimer);
         return _loc1_;
      }
      
      private function _ModuleItem_Image1_i() : Image
      {
         var _loc1_:Image = new Image();
         _loc1_.alpha = 0;
         _loc1_.id = "repairIcon";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         repairIcon = _loc1_;
         BindingManager.executeBindings(this,"repairIcon",repairIcon);
         return _loc1_;
      }
      
      private function _ModuleItem_Group2_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.visible = false;
         _loc1_.id = "repairAnimContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         repairAnimContainer = _loc1_;
         BindingManager.executeBindings(this,"repairAnimContainer",repairAnimContainer);
         return _loc1_;
      }
      
      private function _ModuleItem_BitmapImage4_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.visible = false;
         _loc1_.alpha = 0;
         _loc1_.initialized(this,"destroyedIcon");
         destroyedIcon = _loc1_;
         BindingManager.executeBindings(this,"destroyedIcon",destroyedIcon);
         return _loc1_;
      }
      
      public function ___ModuleItem_ModuleItemBase1_creationComplete(param1:FlexEvent) : void
      {
         handleCreationComplete();
      }
      
      public function ___ModuleItem_ModuleItemBase1_rollOver(param1:MouseEvent) : void
      {
         mouseRollHandler(param1);
      }
      
      public function ___ModuleItem_ModuleItemBase1_rollOut(param1:MouseEvent) : void
      {
         mouseRollHandler(param1);
      }
      
      public function ___ModuleItem_ModuleItemBase1_toolTipCreate(param1:ToolTipEvent) : void
      {
         toolTipCreateHandler(param1);
      }
      
      private function _ModuleItem_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Number
         {
            return ITEM_WIDTH;
         },null,"_ModuleItem_Rect1.width");
         result[1] = new Binding(this,function():Number
         {
            return ITEM_HEIGHT;
         },null,"_ModuleItem_Rect1.height");
         return result;
      }
   }
}

