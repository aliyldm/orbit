package net.bigpoint.darkorbit.map.view3D.display3D.uber
{
   import away3d.containers.ObjectContainer3D;
   import away3d.materials.methods.EffectMethodBase;
   import com.bigpoint.utils.bindables.BindableString;
   import flash.geom.Vector3D;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.common.animation.UberAnimationBase;
   import net.bigpoint.darkorbit.map.common.animation.UberAssetManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.background.DustTileMap3D;
   import net.bigpoint.darkorbit.map.view3D.utils.FloatingData;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class UberAsset3D extends ObjectContainer3D implements IUpdatable, IDisposable
   {
      
      public const ready:ISignal = new Signal();
      
      public var disposeAnimation:String = null;
      
      protected var _manager:UberAssetManager;
      
      protected var _disposed:Boolean;
      
      private var _descriptor:XML;
      
      private var _t:Number = 0;
      
      private var _viewRoot:ObjectContainer3D;
      
      private var _viewLookup:Object = {};
      
      private var _pendingContent:int = 0;
      
      private var _uberMeshes:Vector.<UberMesh3D> = new Vector.<UberMesh3D>();
      
      private var _debug:Boolean;
      
      private var _finished:Boolean = false;
      
      private var _pivotsProvider:MapEntity;
      
      private var _alpha:Number = 1;
      
      private var _parsers:Object;
      
      private var _floatingEnabled:Boolean = true;
      
      private var _floatingTarget:ObjectContainer3D;
      
      private var _positionFloating:FloatingData;
      
      private var _rotationFloating:FloatingData;
      
      public const floatingRotationSrength:Vector3D = new Vector3D();
      
      public const floatingMoveSrength:Vector3D = new Vector3D();
      
      private var _floatingCycleLength:Number = 2;
      
      private var _methods:Vector.<Vector.<EffectMethodBase>> = new Vector.<Vector.<EffectMethodBase>>();
      
      public const effectMethodsChanged:ISignal = new Signal();
      
      private var _shaderClass:Class;
      
      public function UberAsset3D(param1:XML, param2:BindableString = null, param3:MapEntity = null, param4:Boolean = false, param5:String = null)
      {
         super();
         this._descriptor = param1;
         this._pivotsProvider = param3;
         this._debug = param4;
         this._manager = new UberAssetManager(param2);
         this._t = Math.random() * Math.PI * 2;
         if(param1)
         {
            this._floatingEnabled = param1.floating.length() > 0;
            this.floatingMoveSrength.x = param1.floating.@moveX.length() > 0 ? Number(param1.floating.@moveX) : 0;
            this.floatingMoveSrength.y = param1.floating.@moveY.length() > 0 ? Number(param1.floating.@moveY) : 0;
            this.floatingMoveSrength.z = param1.floating.@moveZ.length() > 0 ? Number(param1.floating.@moveZ) : 0;
            this.floatingRotationSrength.x = param1.floating.@rotationX.length() > 0 ? Number(param1.floating.@rotationX) : 0;
            this.floatingRotationSrength.y = param1.floating.@rotationY.length() > 0 ? Number(param1.floating.@rotationY) : 0;
            this.floatingRotationSrength.z = param1.floating.@rotationZ.length() > 0 ? Number(param1.floating.@rotationZ) : 0;
            this._floatingCycleLength = param1.floating.@cycleLength.length() > 0 ? Number(param1.floating.@cycleLength) : 2;
            if(param1.@disposeAnimation.length > 0)
            {
               this.disposeAnimation = String(param1.@disposeAnimation);
            }
         }
         this.init();
      }
      
      private function addFloatingTarget() : void
      {
         this._positionFloating = new FloatingData(this._floatingCycleLength);
         this._rotationFloating = new FloatingData(this._floatingCycleLength);
         this._floatingTarget = new ObjectContainer3D();
         this._floatingTarget.addChild(this._viewRoot);
         addChild(this._floatingTarget);
      }
      
      public function enableFloating() : void
      {
         if(this._floatingTarget == null)
         {
            this.addFloatingTarget();
         }
         this._floatingEnabled = true;
      }
      
      public function disableFloating() : void
      {
         this._floatingEnabled = false;
         if(this._positionFloating)
         {
            this._positionFloating.stop();
         }
         if(this._rotationFloating)
         {
            this._rotationFloating.stop();
         }
      }
      
      public function set shader(param1:Class) : void
      {
         var _loc2_:UberMesh3D = null;
         this._shaderClass = param1;
         for each(_loc2_ in this._uberMeshes)
         {
            if(_loc2_.mesh)
            {
               _loc2_.mesh.shaderClass = param1;
            }
         }
         this.effectMethodsChanged.dispatch();
      }
      
      public function overrideSpecificShader(param1:Class, param2:Class) : void
      {
         var _loc3_:UberMesh3D = null;
         for each(_loc3_ in this._uberMeshes)
         {
            if(Boolean(_loc3_.mesh) && _loc3_.mesh.materials.shaderClass == param1)
            {
               _loc3_.mesh.shaderClass = param2;
            }
         }
         this.effectMethodsChanged.dispatch();
      }
      
      public function get shader() : Class
      {
         return this._shaderClass;
      }
      
      public function addMethods(param1:Vector.<EffectMethodBase>) : void
      {
         var _loc2_:int = this._methods.indexOf(param1);
         if(_loc2_ != -1)
         {
            return;
         }
         this._methods.push(param1);
         this.updateMeshesMethods();
         this.effectMethodsChanged.dispatch();
      }
      
      public function removeMethods(param1:Vector.<EffectMethodBase>) : void
      {
         var _loc2_:int = this._methods.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._methods.splice(_loc2_,1);
            this.updateMeshesMethods();
            this.effectMethodsChanged.dispatch();
         }
      }
      
      private function updateMeshesMethods() : void
      {
         var _loc2_:UberMesh3D = null;
         var _loc3_:EffectMethodBase = null;
         var _loc1_:Vector.<EffectMethodBase> = this._methods.length > 0 ? this._methods[this._methods.length - 1] : null;
         for each(_loc2_ in this._uberMeshes)
         {
            _loc2_.removeAllMethods();
            for each(_loc3_ in _loc1_)
            {
               _loc2_.addMethod(_loc3_);
            }
         }
      }
      
      public function removeAllMethods() : void
      {
         if(this._methods.length)
         {
            this._methods.length = 0;
            this.updateMeshesMethods();
            this.effectMethodsChanged.dispatch();
         }
      }
      
      public function getViewElement(param1:String) : ObjectContainer3D
      {
         return this._viewLookup[param1 || ""] as ObjectContainer3D;
      }
      
      public function updateObj(param1:Number) : void
      {
         this._manager.updateObj(param1);
         if(this._floatingTarget)
         {
            if(this._floatingEnabled)
            {
               this._positionFloating.updateObj(param1);
               this._rotationFloating.updateObj(param1);
            }
            this._floatingTarget.moveTo(this._positionFloating.x * this.floatingMoveSrength.x,this._positionFloating.y * this.floatingMoveSrength.y,this._positionFloating.z * this.floatingMoveSrength.z);
            this._floatingTarget.rotateTo(this._rotationFloating.x * this.floatingRotationSrength.x,this._rotationFloating.y * this.floatingRotationSrength.y,this._rotationFloating.z * this.floatingRotationSrength.z);
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(param1 || this.disposeAnimation == null)
         {
            this._manager.disposeView(param1);
            if(parent)
            {
               parent.removeChild(this);
            }
            World3D.instance.mapView.removeUpdatable(this);
         }
         else
         {
            this.playAnimation(this.disposeAnimation,this.handleDisposeAnimationComplete,true);
         }
         this._disposed = true;
      }
      
      public function playAnimation(param1:String, param2:Function = null, param3:Boolean = false) : void
      {
         this._manager.playAnimation(param1,param2,param3);
      }
      
      public function stopCurrentAnimation() : void
      {
         this._manager.stopCurrentAnimation();
      }
      
      protected function finish() : void
      {
         if(this._finished || this._disposed)
         {
            return;
         }
         this._finished = true;
         if(this._floatingEnabled)
         {
            this.addFloatingTarget();
         }
         else
         {
            addChild(this._viewRoot);
         }
         this.updateViewLookup();
         this._manager.parseAnimations(this._descriptor,UberAnimation3D,this);
         this.log("ready!");
         setTimeout(this.ready.dispatch,1);
      }
      
      protected function log(param1:String) : void
      {
      }
      
      private function init() : void
      {
         if(this._descriptor != null)
         {
            this.log("init");
            World3D.instance.mapView.addUpdatable(this);
            this.parseDisplayTree();
            if(this._debug)
            {
               scale(Number(this._descriptor.@previewScale) || 1);
            }
            if(this._pendingContent == 0)
            {
               this.log("no content to wait for");
               this.finish();
            }
         }
         else
         {
            this._viewRoot = new ObjectContainer3D();
            this.finish();
         }
      }
      
      private function handleDisposeAnimationComplete() : void
      {
         this.disposeView(true);
      }
      
      private function parseDisplayTree() : void
      {
         this._pendingContent = 0;
         this._uberMeshes.length = 0;
         if(String(this._descriptor.@geometry))
         {
            this._viewRoot = this.parseMesh(this._descriptor,"");
            this._manager.initViewElement(this._viewRoot);
         }
         else
         {
            this._viewRoot = new ObjectContainer3D();
            this.parseDisplayChildren(this._viewRoot,this._descriptor,"");
         }
         this.applyTransformations(this._viewRoot,this._descriptor);
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
      
      private function updateViewLookup() : void
      {
         var _loc1_:UberMesh3D = null;
         this._viewLookup[""] = this._viewRoot;
         for each(_loc1_ in this._uberMeshes)
         {
            if(_loc1_.mesh)
            {
               this.updateViewLookupForContainer(_loc1_.mesh,_loc1_.name + ".");
            }
         }
      }
      
      private function updateViewLookupForContainer(param1:ObjectContainer3D, param2:String) : void
      {
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
            param2 += param1.name + ".";
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            this.updateViewLookupForContainer(param1.getChildAt(_loc3_),param2);
            _loc3_++;
         }
      }
      
      private function parseDisplayChildren(param1:ObjectContainer3D, param2:XML, param3:String) : void
      {
         var _loc5_:XML = null;
         var _loc6_:ObjectContainer3D = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Function = null;
         if(this._parsers == null)
         {
            this._parsers = {};
            this._parsers["container"] = this.parseContainer;
            this._parsers["mesh"] = this.parseMesh;
            this._parsers["plane"] = this.parsePlane;
            this._parsers["particles"] = this.parseParticles;
            this._parsers["pivot"] = this.parsePivot;
            this._parsers["display3D"] = this.parseDisplay3D;
            this._parsers["tilemap"] = this.parseTilemap;
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
               this.applyTransformations(_loc6_,_loc5_);
               this._manager.initViewElement(_loc6_);
               this._viewLookup[_loc7_] = _loc6_;
            }
         }
      }
      
      private function applyTransformations(param1:ObjectContainer3D, param2:XML) : void
      {
         var _loc3_:Object = UberAnimationBase.parseProps(param2);
         if(_loc3_.x !== undefined)
         {
            param1.x = Number(_loc3_.x);
         }
         if(_loc3_.y !== undefined)
         {
            param1.y = Number(_loc3_.y);
         }
         if(_loc3_.z !== undefined)
         {
            param1.z = Number(_loc3_.z);
         }
         if(_loc3_.sphericalPhi !== undefined && _loc3_.sphericalTheta !== undefined && _loc3_.sphericalR !== undefined)
         {
            param1.x += _loc3_.sphericalR * Math.sin(_loc3_.sphericalTheta * Math.PI / 180) * Math.cos(_loc3_.sphericalPhi * Math.PI / 180);
            param1.y -= _loc3_.sphericalR * Math.cos(_loc3_.sphericalTheta * Math.PI / 180);
            param1.z -= _loc3_.sphericalR * Math.sin(_loc3_.sphericalTheta * Math.PI / 180) * Math.sin(_loc3_.sphericalPhi * Math.PI / 180);
         }
         if(_loc3_.rotationX !== undefined)
         {
            param1.rotationX = Number(_loc3_.rotationX);
         }
         if(_loc3_.rotationY !== undefined)
         {
            param1.rotationY = Number(_loc3_.rotationY);
         }
         if(_loc3_.rotationZ !== undefined)
         {
            param1.rotationZ = Number(_loc3_.rotationZ);
         }
         if(_loc3_.scaleX !== undefined)
         {
            param1.scaleX = Number(_loc3_.scaleX);
         }
         if(_loc3_.scaleY !== undefined)
         {
            param1.scaleY = Number(_loc3_.scaleY);
         }
         if(_loc3_.scaleZ !== undefined)
         {
            param1.scaleZ = Number(_loc3_.scaleZ);
         }
      }
      
      private function parseContainer(param1:XML, param2:String) : ObjectContainer3D
      {
         var _loc3_:ObjectContainer3D = new UberContainer3D(param1,this._manager.state);
         this.parseDisplayChildren(_loc3_,param1,param2);
         return _loc3_;
      }
      
      private function parseMesh(param1:XML, param2:String) : ObjectContainer3D
      {
         var _loc3_:UberMesh3D = new UberMesh3D(param1,this._manager.state);
         _loc3_.alpha = this._alpha;
         this._uberMeshes.push(_loc3_);
         ++this._pendingContent;
         UberMesh3D(_loc3_).ready.addOnce(this.handleChildReady);
         return _loc3_;
      }
      
      private function parsePlane(param1:XML, param2:String) : ObjectContainer3D
      {
         var _loc3_:UberPlane3D = new UberPlane3D(param1,this._manager.state);
         ++this._pendingContent;
         UberPlane3D(_loc3_).ready.addOnce(this.handleChildReady);
         return _loc3_;
      }
      
      private function parseTilemap(param1:XML, param2:String) : ObjectContainer3D
      {
         return new DustTileMap3D(param1,this._manager.state);
      }
      
      private function parseParticles(param1:XML, param2:String) : ObjectContainer3D
      {
         var _loc3_:UberParticles3D = new UberParticles3D(param1,this._manager.state);
         ++this._pendingContent;
         UberParticles3D(_loc3_).ready.addOnce(this.handleChildReady);
         return _loc3_;
      }
      
      private function parsePivot(param1:XML, param2:String) : ObjectContainer3D
      {
         if(this._pivotsProvider)
         {
            return new UberPivot3D(this._pivotsProvider.getPivot(String(param1.@id)),this);
         }
         return null;
      }
      
      private function parseDisplay3D(param1:XML, param2:String) : ObjectContainer3D
      {
         var _loc4_:String = null;
         var _loc7_:UberAsset3D = null;
         var _loc3_:Array = String(param1.@templateId).split(":");
         var _loc5_:String = UberAssetsLib.LIB_DEFAULT;
         if(_loc3_.length == 2)
         {
            _loc5_ = _loc3_[0];
            _loc4_ = _loc3_[1];
         }
         else if(_loc3_.length == 1)
         {
            _loc4_ = _loc3_[0];
         }
         var _loc6_:XML = UberAssetsLib.instance.getDescriptor(_loc4_,_loc5_);
         if(_loc6_ != null)
         {
            _loc7_ = new UberAsset3D(_loc6_.display3D[0],this._manager.state,null,this._debug,"child of UberAsset3D");
            ++this._pendingContent;
            UberAsset3D(_loc7_).ready.addOnce(this.handleChildReady);
            return _loc7_;
         }
         this.log(":parseDisplayChildren: Template id not found : " + param1.@templateId);
         return null;
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         var _loc2_:UberMesh3D = null;
         this._alpha = param1;
         for each(_loc2_ in this._uberMeshes)
         {
            _loc2_.alpha = param1;
         }
      }
      
      public function get uberMeshes() : Vector.<UberMesh3D>
      {
         return this._uberMeshes;
      }
      
      public function get positionFloating() : FloatingData
      {
         return this._positionFloating;
      }
      
      public function get methods() : Vector.<EffectMethodBase>
      {
         return this._methods.length > 0 ? this._methods[this._methods.length - 1] : null;
      }
      
      public function get descriptor() : XML
      {
         return this._descriptor;
      }
      
      public function get floatingTarget() : ObjectContainer3D
      {
         return this._floatingTarget;
      }
      
      public function get viewRoot() : ObjectContainer3D
      {
         return this._viewRoot;
      }
      
      public function get finishedLoading() : Boolean
      {
         return this._finished;
      }
      
      public function setDefaultShaderClass(param1:Class) : void
      {
         var _loc2_:UberMesh3D = null;
         for each(_loc2_ in this._uberMeshes)
         {
            if(_loc2_.mesh)
            {
               _loc2_.mesh.defaultShaderClass = param1;
            }
         }
      }
   }
}

