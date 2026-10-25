package net.bigpoint.darkorbit.map.view2D.display.uber
{
   import com.bigpoint.utils.bindables.BindableString;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.common.animation.UberAnimationBase;
   import net.bigpoint.darkorbit.map.common.animation.UberAssetManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.view2D.debug.Trident2D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class UberAsset2D extends Sprite implements IUpdatable, IDisposable
   {
      
      public const ready:ISignal = new Signal();
      
      public var disposeFunction:Function = null;
      
      private var _viewRoot:Sprite;
      
      private var _descriptor:XML;
      
      private var _displayObjects:Vector.<UberDisplayObject2D> = new Vector.<UberDisplayObject2D>();
      
      private var _mapAssets:Vector.<UberMapAssetView2D> = new Vector.<UberMapAssetView2D>();
      
      private var _pendingContent:int = 0;
      
      private var _debug:Boolean;
      
      private var _viewLookup:Object = {};
      
      private var _finished:Boolean;
      
      protected var _manager:UberAssetManager;
      
      private var _pivotsProvider:MapEntity;
      
      private var _disposed:Boolean;
      
      private var _parsers:Object;
      
      public function UberAsset2D(param1:XML, param2:Boolean = true, param3:BindableString = null, param4:MapEntity = null, param5:Boolean = false)
      {
         super();
         this._descriptor = param1;
         this._debug = param5;
         this._pivotsProvider = param4;
         this._manager = new UberAssetManager(param3);
         if(param2)
         {
            this.init();
         }
      }
      
      private function init() : void
      {
         if(this._descriptor != null)
         {
            this.parseDisplayTree();
            if(this._debug)
            {
               scaleX = scaleY = Number(this._descriptor.@previewScale) || 1;
            }
            if(this._pendingContent == 0)
            {
               this.finish();
            }
         }
         else
         {
            this._viewRoot = new Sprite();
            this.finish();
         }
      }
      
      protected function finish() : void
      {
         if(this._finished)
         {
            return;
         }
         this._finished = true;
         addChildAt(this._viewRoot,0);
         this.updateViewLookup();
         this._manager.parseAnimations(this._descriptor,UberAnimation2D,this);
         setTimeout(this.ready.dispatch,1);
      }
      
      public function getViewElement(param1:String) : DisplayObject
      {
         return this._viewLookup[param1 || ""] as DisplayObject;
      }
      
      public function getAllDisplayObjects() : Vector.<UberDisplayObject2D>
      {
         return this._displayObjects;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this.disposeFunction != null)
         {
            this.disposeFunction();
         }
         else
         {
            MovieClipUtils.removeDisplayObject(this);
            this._manager.disposeView();
            this._disposed = true;
         }
      }
      
      private function parseDisplayTree() : void
      {
         var _loc1_:XML = null;
         var _loc2_:GlowFilter = null;
         if(Boolean(String(this._descriptor.@srcKey)) || Boolean(String(this._descriptor.@resKey)))
         {
            this._viewRoot = this.parseDisplayObject(this._descriptor,"");
            this.initViewElement(this._viewRoot,this._descriptor);
         }
         else
         {
            this._viewRoot = new Sprite();
            this.applyTransformations(this._viewRoot,this._descriptor);
         }
         if(this._descriptor.glow.length() > 0)
         {
            _loc1_ = this._descriptor.glow[0];
            _loc2_ = new GlowFilter();
            if(_loc1_.attribute("color") != null)
            {
               _loc2_.color = int(_loc1_.@color);
            }
            if(_loc1_.attribute("blurX") != null)
            {
               _loc2_.blurX = int(_loc1_.@blurX);
            }
            if(_loc1_.attribute("blurY") != null)
            {
               _loc2_.blurY = int(_loc1_.@blurY);
            }
            this._viewRoot.filters = [_loc2_];
         }
         this.parseDisplayChildren(this._viewRoot,this._descriptor,"");
      }
      
      private function updateViewLookup() : void
      {
         var _loc1_:UberDisplayObject2D = null;
         this._viewLookup[""] = this._viewRoot;
         for each(_loc1_ in this._displayObjects)
         {
            this.updateViewLookupForElement(_loc1_.asset,_loc1_.name + ".",2);
         }
      }
      
      private function updateViewLookupForElement(param1:DisplayObject, param2:String, param3:int = -1) : void
      {
         var _loc5_:int = 0;
         if(param1 == null)
         {
            return;
         }
         if(Boolean(param1.name) && Boolean(param1.name.length > 0) && param1.name != "null")
         {
            if(this._viewLookup[param2 + param1.name] == null)
            {
               this._viewLookup[param2 + param1.name] = param1;
            }
            else
            {
               this.log("WARNING, duplicating IDs: " + param1.name);
            }
         }
         var _loc4_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         if((Boolean(_loc4_)) && param3 != 0)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_.numChildren)
            {
               this.updateViewLookupForElement(_loc4_.getChildAt(_loc5_),param2 + param1.name + ".",param3 - 1);
               _loc5_++;
            }
         }
      }
      
      private function parseDisplayChildren(param1:DisplayObjectContainer, param2:XML, param3:String) : void
      {
         var _loc5_:XML = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Function = null;
         if(this._parsers == null)
         {
            this._parsers = {};
            this._parsers["container"] = this.parseContainer;
            this._parsers["displayObject"] = this.parseDisplayObject;
            this._parsers["shipClip"] = this.parseDisplayObject;
            this._parsers["mapAssetView"] = this.parseMapAssetView;
            this._parsers["pivot"] = this.parsePivot;
            this._parsers["display2D"] = this.parseDisplay2D;
         }
         var _loc4_:XMLList = param2.children();
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = null;
            _loc7_ = String(_loc5_.attribute("id")) || this._manager.nextViewId(_loc5_.name().toString());
            _loc8_ = param3.length > 0 ? param3 + "." + _loc7_ : _loc7_;
            _loc9_ = this._parsers[_loc5_.name().toString()] as Function;
            if(_loc9_ != null)
            {
               _loc6_ = _loc9_(_loc5_,_loc8_);
            }
            else
            {
               this.log("parseDisplayChildren: Unknown node type: " + _loc5_.toString());
            }
            if(_loc6_)
            {
               _loc6_.name = _loc7_;
               param1.addChild(_loc6_);
               this.initViewElement(_loc6_,_loc5_);
               this._viewLookup[_loc7_] = _loc6_;
            }
         }
      }
      
      private function handleChildReady() : void
      {
         if(this._disposed)
         {
            return;
         }
         if(--this._pendingContent == 0)
         {
            this.finish();
         }
      }
      
      private function initViewElement(param1:DisplayObject, param2:XML) : void
      {
         this.applyTransformations(param1,param2);
         this._manager.initViewElement(param1);
         if(String(param2.@debug) === "true" && param1 is DisplayObjectContainer)
         {
            DisplayObjectContainer(param1).addChild(new Trident2D(100));
         }
      }
      
      private function applyTransformations(param1:DisplayObject, param2:XML) : void
      {
         var _loc3_:Object = UberAnimationBase.parseProps(param2);
         if(_loc3_.x !== undefined)
         {
            param1.x = Number(_loc3_.x) || 0;
         }
         if(_loc3_.y !== undefined)
         {
            param1.y = Number(_loc3_.y) || 0;
         }
         if(_loc3_.visible !== undefined)
         {
            param1.visible = _loc3_.visible == "true";
         }
         if(_loc3_.alpha !== undefined)
         {
            param1.alpha = Number(_loc3_.alpha) || 0;
         }
         if(_loc3_.rotation !== undefined)
         {
            param1.rotation = Number(_loc3_.rotation);
         }
         if(_loc3_.scaleX !== undefined)
         {
            param1.scaleX = Number(_loc3_.scaleX);
         }
         if(_loc3_.scaleY !== undefined)
         {
            param1.scaleY = Number(_loc3_.scaleY);
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         this._manager.updateObj(param1);
      }
      
      public function playAnimation(param1:String, param2:Function = null) : void
      {
         this._manager.playAnimation(param1,param2);
      }
      
      protected function log(param1:String) : void
      {
      }
      
      private function parseContainer(param1:XML, param2:String) : DisplayObject
      {
         var _loc3_:Sprite = new Sprite();
         this.parseDisplayChildren(_loc3_ as Sprite,param1,param2);
         return _loc3_;
      }
      
      private function parseDisplayObject(param1:XML, param2:String) : UberDisplayObject2D
      {
         var _loc3_:UberDisplayObject2D = new UberDisplayObject2D(param1,this._debug);
         this._displayObjects.push(_loc3_);
         ++this._pendingContent;
         UberDisplayObject2D(_loc3_).ready.addOnce(this.handleChildReady);
         UberDisplayObject2D(_loc3_).init();
         return _loc3_;
      }
      
      private function parseMapAssetView(param1:XML, param2:String) : DisplayObject
      {
         var _loc3_:UberMapAssetView2D = new UberMapAssetView2D(param1);
         this._mapAssets.push(_loc3_);
         ++this._pendingContent;
         _loc3_.ready.addOnce(this.handleChildReady);
         _loc3_.init();
         return _loc3_;
      }
      
      private function parsePivot(param1:XML, param2:String) : DisplayObject
      {
         if(this._pivotsProvider)
         {
            return new UberPivot2D(this._pivotsProvider.getPivot(String(param1.@id)));
         }
         return null;
      }
      
      private function parseDisplay2D(param1:XML, param2:String) : DisplayObject
      {
         var _loc7_:UberAsset2D = null;
         var _loc3_:Array = String(param1.@templateId).split(":");
         var _loc4_:String = _loc3_.length > 0 ? _loc3_[0] : null;
         var _loc5_:String = _loc3_.length > 1 ? _loc3_[1] : UberAssetsLib.LIB_DEFAULT;
         var _loc6_:XML = UberAssetsLib.instance.getDescriptor(_loc4_,_loc5_);
         if(_loc6_ != null)
         {
            _loc7_ = new UberAsset2D(_loc6_.display2D[0],false,null,null,this._debug);
            ++this._pendingContent;
            _loc7_.ready.addOnce(this.handleChildReady);
            _loc7_.init();
            return _loc7_;
         }
         this.log(":parseDisplayChildren: Template id not found : " + param1.@templateId);
         return null;
      }
      
      public function get descriptor() : XML
      {
         return this._descriptor;
      }
   }
}

