package net.bigpoint.darkorbit.map.view3D.display3D.ship
{
   import away3d.core.base.Geometry;
   import away3d.core.math.MathConsts;
   import away3d.core.math.Matrix3DUtils;
   import away3d.entities.Mesh;
   import away3d.primitives.PlaneGeometry;
   import away3d.tools.helpers.MeshHelper;
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.ship.RelationShipColorUtil;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.decorators.IMapUberAssetDecorator3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.EntityBasicMaterial;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.EntityXRayMaterial;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.engine.Engines3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.utils.ExtMath;
   import net.bigpoint.darkorbit.map.view3D.utils.Helper;
   import net.bigpoint.darkorbit.settings.CrowdedCombatPreset;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class Ship3D implements IMapUberAssetDecorator3D, IDisposable, IUpdatable
   {
      
      private static var _singlePlaneGeo:Geometry;
      
      private static const _m:Matrix3D = new Matrix3D();
      
      private var _lasers:Lasers3D;
      
      private var _engines:Engines3D;
      
      private var _viewOwner:UberAsset3D;
      
      private var _trait:UberDisplayTrait;
      
      private var _rotationEnabled:Boolean = true;
      
      private var _tiltingEnabled:Boolean = true;
      
      private var _floatingEnabled:Boolean = true;
      
      protected var _ship:Ship;
      
      private var _placeholder:Mesh;
      
      private var _showPlaceholderTimeout:uint;
      
      private var _rotationY:Number = 0;
      
      private var _rotationZ:Number = 0;
      
      public function Ship3D()
      {
         super();
      }
      
      public function get ship() : Ship
      {
         return this._ship;
      }
      
      public function get view() : UberAsset3D
      {
         return this._viewOwner;
      }
      
      public function initialize(param1:UberDisplayTrait, param2:UberAsset3D, param3:Object) : void
      {
         this._trait = param1;
         this._ship = param1.owner as Ship;
         this._viewOwner = param2;
         this._showPlaceholderTimeout = setTimeout(this.loadPlaceholder,this._ship.isHeroShip() ? 2500 : 1000);
         Settings.hoverShips.changed.add(this.updateFloating);
         this.updateXrayMaterial();
      }
      
      private function updateXrayMaterial() : void
      {
         if(!this.ship.isNPC && !CrowdedCombatPreset.enabled)
         {
            this.view.setDefaultShaderClass(EntityXRayMaterial);
            this.view.overrideSpecificShader(EntityBasicMaterial,EntityXRayMaterial);
            this.updateXRayColor();
         }
      }
      
      private function updateXRayColor() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._viewOwner.uberMeshes.length)
         {
            this._viewOwner.uberMeshes[_loc1_].mesh.shaderParams.xRayColor = RelationShipColorUtil.getColorRelatedToHero(this.ship);
            _loc1_++;
         }
      }
      
      private function loadPlaceholder() : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Mesh = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:* = 0;
         var _loc1_:UberDisplayTrait = this._trait.owner.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
         if(Boolean(_loc1_) && Boolean(_loc1_.descriptor))
         {
            if(_singlePlaneGeo == null || _singlePlaneGeo.subGeometries.length == 0)
            {
               _loc5_ = new Mesh(new PlaneGeometry(1,1,1,1,true,true));
               _loc5_.rotationY = 90;
               MeshHelper.applyRotations(_loc5_);
               _singlePlaneGeo = _loc5_.geometry;
            }
            _loc2_ = _loc1_.descriptor.display2D[0];
            if(_loc2_ == null)
            {
               return;
            }
            _loc3_ = String(_loc2_.@replacement) || String(_loc2_.@srcKey);
            _loc4_ = ResourceManager.getMovieClip("replacementShips",_loc3_);
            if(_loc4_)
            {
               _loc7_ = int(_loc4_.numChildren - 1);
               while(_loc7_ >= 0)
               {
                  _loc6_ = _loc4_.getChildAt(_loc7_);
                  if(_loc6_.name.search("laser") != -1 || _loc6_.name.search("engine") != -1)
                  {
                     _loc6_.visible = false;
                  }
                  _loc7_--;
               }
               this._placeholder = Helper.movieclip2mesh("replacementShips_" + _loc3_,_loc4_,_singlePlaneGeo);
               this._placeholder.scaleX = _loc4_.height;
               this._placeholder.scaleZ = _loc4_.width;
               this._viewOwner.addChild(this._placeholder);
               this.updateRotation(0);
            }
         }
      }
      
      public function decorate() : void
      {
         this.disposePlaceholder();
         var _loc1_:Boolean = CrowdedCombatPreset.enabled && !this._ship.isHeroShip();
         if(!_loc1_)
         {
            this._viewOwner.playAnimation("spawn");
         }
         this._lasers = new Lasers3D(this._trait.owner.getFirstTrait(AttackerTrait) as AttackerTrait,this);
         if(!_loc1_)
         {
            this._engines = new Engines3D(this);
         }
         this._rotationEnabled = String(this._trait.descriptor.display3D.@rotatable) != "false";
         this._floatingEnabled = String(this._trait.descriptor.display3D.@floating) != "false";
         this._tiltingEnabled = String(this._trait.descriptor.display3D.@tilting) != "false";
         this.ship.cloaked.changed.add(this.handleCloakedChanged);
         this.handleCloakedChanged();
         this._viewOwner.floatingMoveSrength.setTo(5,5,5);
         this._viewOwner.floatingRotationSrength.setTo(5,5,5);
         this._ship.moveTrait.moveStopped.add(this.enableFloating);
         this._ship.moveTrait.moveStarted.add(this.disableFloating);
         if(this._ship.moveTrait.isMoving)
         {
            this.disableFloating();
         }
         else
         {
            this.enableFloating();
         }
         this.updateRotation(0);
      }
      
      private function updateFloating() : void
      {
         if(this._ship.moveTrait.isMoving == false)
         {
            if(Settings.hoverShips.value == false)
            {
               this.disableFloating();
            }
            else if(Settings.hoverShips.value == true)
            {
               this.enableFloating();
            }
         }
      }
      
      private function enableFloating() : void
      {
         if(Settings.hoverShips.value && this._floatingEnabled)
         {
            this._viewOwner.enableFloating();
         }
      }
      
      private function disableFloating() : void
      {
         this._viewOwner.disableFloating();
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this.disposePlaceholder();
         Settings.hoverShips.changed.remove(this.updateFloating);
         this.ship.cloaked.changed.remove(this.handleCloakedChanged);
         this._ship.moveTrait.moveStopped.remove(this.enableFloating);
         this._ship.moveTrait.moveStarted.remove(this.disableFloating);
         if(this._engines)
         {
            this._engines.disposeView();
         }
         if(this._lasers)
         {
            this._lasers.dispose();
         }
         TweenLite.killTweensOf(this._viewOwner);
      }
      
      private function disposePlaceholder() : void
      {
         clearTimeout(this._showPlaceholderTimeout);
         if(this._placeholder)
         {
            this._placeholder.parent.removeChild(this._placeholder);
            this._placeholder.dispose();
            this._placeholder = null;
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         this.updateRotation(param1);
         if(this._engines)
         {
            this._engines.updateObj(param1);
         }
      }
      
      private function handleCloakedChanged() : void
      {
         if(this.ship.cloaked.value)
         {
            TweenLite.to(this._viewOwner,0.2,{"alpha":0.5});
         }
         else
         {
            TweenLite.to(this._viewOwner,0.2,{"alpha":1});
         }
      }
      
      private function updateRotation(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Vector3D = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(this._rotationEnabled || this._tiltingEnabled)
         {
            _loc2_ = this._ship.rotation.degrees - 90;
            _loc3_ = 0;
            if(param1 > 0)
            {
               _loc5_ = ExtMath.getShortAngleDegrees(this._rotationY,_loc2_);
               this._rotationY = Quad.easeOut(param1,this._rotationY,_loc5_,0.2);
               _loc7_ = 20;
               _loc8_ = 0.2;
               if(this._ship.moveTrait.isMoving && this._ship.attackTrait.target != null)
               {
                  _loc8_ = 0.08;
                  _loc7_ = 10;
                  _loc6_ = ExtMath.getShortAngleDegrees(this._rotationZ,-_loc5_ * 2);
               }
               else
               {
                  _loc6_ = ExtMath.getShortAngleDegrees(this._rotationZ,_loc5_ * 1);
               }
               this._rotationZ = Math.max(-_loc7_,Math.min(Quad.easeOut(param1,this._rotationZ,_loc6_,_loc8_),_loc7_));
            }
            else
            {
               this._rotationY = _loc2_;
               this._rotationZ = _loc3_;
            }
            _m.identity();
            if(this._rotationEnabled)
            {
               if(this._tiltingEnabled)
               {
                  _m.appendRotation(-this._rotationZ,Vector3D.Z_AXIS);
               }
               _m.appendRotation(this._rotationY,Vector3D.Y_AXIS);
            }
            _loc4_ = Matrix3DUtils.decompose(_m)[1];
            this._viewOwner.rotateTo(_loc4_.x * MathConsts.RADIANS_TO_DEGREES,_loc4_.y * MathConsts.RADIANS_TO_DEGREES,_loc4_.z * MathConsts.RADIANS_TO_DEGREES);
            if(this._engines)
            {
               this._engines.tilt = -this._rotationZ;
            }
         }
         else
         {
            this._viewOwner.rotationX = this._viewOwner.rotationY = this._viewOwner.rotationZ = 0;
         }
      }
      
      public function get rotationY() : Number
      {
         return this._rotationY;
      }
   }
}

