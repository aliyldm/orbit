package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.containers.ObjectContainer3D;
   import away3d.entities.Mesh;
   import away3d.materials.ColorMaterial;
   import away3d.primitives.CylinderGeometry;
   import com.greensock.TweenLite;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SphereShieldEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import org.osflash.signals.ISignal;
   
   public class SphereShieldEffect3D implements IDisposable, IUpdatable
   {
      
      private var _mapView:MapView3D;
      
      private var _target:MapEntity;
      
      private var _shieldPercentageEffect:BowShieldEffect;
      
      private var _shieldRange:Mesh;
      
      private var _particleContainer:ObjectContainer3D;
      
      private var _particles1:ParticleFX;
      
      private var _particles2:ParticleFX;
      
      private var _particles3:ParticleFX;
      
      private var _particles4:ParticleFX;
      
      public var _currentPercentageValue:Number = 0;
      
      private var _percentageSignal:ISignal;
      
      private var _isRotationActivated:Boolean = true;
      
      private var _rotationSpeed:Number = -0.05;
      
      private var _rotateFXinDegree:Number = 0;
      
      private const particleContainerRotationAngle:Number = 90;
      
      public function SphereShieldEffect3D(param1:MapView3D, param2:SphereShieldEffect)
      {
         super();
         this._mapView = param1;
         this._target = MapObjectEffect(param2).source;
         var _loc3_:uint = param2.radius;
         var _loc4_:uint = 6;
         var _loc5_:CylinderGeometry = new CylinderGeometry(_loc3_,_loc3_,1,64,1);
         _loc5_.topClosed = false;
         _loc5_.bottomClosed = false;
         _loc5_.bottomRadius = _loc3_ + _loc4_ / 2;
         this._shieldRange = new Mesh(_loc5_,new ColorMaterial(param2.OUTER_RING_COLOR,param2.OUTER_RING_ALPHA));
         this._shieldPercentageEffect = new BowShieldEffect();
         this._shieldPercentageEffect.color = 1002088;
         this._shieldPercentageEffect.alpha = param2.INNER_PERCENTAGE_RING_ALPHA;
         this._shieldPercentageEffect.radius = _loc3_ - _loc4_ * 2;
         this._shieldPercentageEffect.linestroke = _loc4_;
         this._shieldPercentageEffect.rotationX = 90;
         this._shieldPercentageEffect.bowSegmentCount = 4;
         this._shieldPercentageEffect.initialize();
         this._target.position.changed.add(this.handlePositionChange);
         var _loc6_:Number = 90;
         var _loc7_:Number = 680;
         var _loc8_:Number = 0.013;
         var _loc9_:Number = 5815287;
         this._particleContainer = new ObjectContainer3D();
         this._particles1 = new ParticleFX(this._particleContainer);
         this._particles1.color = _loc9_;
         this._particles1.speed = _loc8_;
         this._particles1.innerRadius = _loc6_;
         this._particles1.outerRadius = _loc7_;
         this._particles1.K = 0;
         this._particles1.initialize();
         this._particles2 = new ParticleFX(this._particleContainer);
         this._particles2.color = _loc9_;
         this._particles2.speed = _loc8_;
         this._particles2.innerRadius = _loc6_;
         this._particles2.outerRadius = _loc7_;
         this._particles2.K = Math.PI / 2;
         this._particles2.initialize();
         this._particles3 = new ParticleFX(this._particleContainer);
         this._particles3.color = _loc9_;
         this._particles3.speed = _loc8_;
         this._particles3.innerRadius = _loc6_;
         this._particles3.outerRadius = _loc7_;
         this._particles3.K = Math.PI;
         this._particles3.initialize();
         this._particles4 = new ParticleFX(this._particleContainer);
         this._particles4.color = _loc9_;
         this._particles4.speed = _loc8_;
         this._particles4.innerRadius = _loc6_;
         this._particles4.outerRadius = _loc7_;
         this._particles4.K = Math.PI + Math.PI / 2;
         this._particles4.initialize();
         World3D.instance.mapView.gameWorld.addChild(this._shieldPercentageEffect);
         World3D.instance.mapView.gameWorld.addChild(this._shieldRange);
         World3D.instance.mapView.gameWorld.addChild(this._particleContainer);
         World3D.instance.mapView.addUpdatable(this);
         this.handlePositionChange();
         this._percentageSignal = param2.percentageSignal;
         this._percentageSignal.add(this.updatePercentage);
      }
      
      public function updateObj(param1:Number) : void
      {
         if(this._isRotationActivated)
         {
            this._shieldPercentageEffect.updateRotation(this._rotateFXinDegree);
            this._rotateFXinDegree += this._rotationSpeed;
         }
         this._particleContainer.rotationY = this._rotateFXinDegree - this.particleContainerRotationAngle / 2 * this._currentPercentageValue / 100;
         var _loc2_:Number = this._currentPercentageValue / 100;
         this._particles1.updatePercentageValue(_loc2_);
         this._particles2.updatePercentageValue(_loc2_);
         this._particles3.updatePercentageValue(_loc2_);
         this._particles4.updatePercentageValue(_loc2_);
      }
      
      private function updatePercentage(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         if(this._currentPercentageValue != param1)
         {
            _loc2_ = Number(param1);
            TweenLite.to(this,1,{
               "_currentPercentageValue":_loc2_,
               "onUpdate":this.updateFoo
            });
            this._particles1.updatePercentageValue(param1);
            this._particles2.updatePercentageValue(param1);
            this._particles3.updatePercentageValue(param1);
            this._particles4.updatePercentageValue(param1);
         }
      }
      
      private function updateFoo() : void
      {
         this._shieldPercentageEffect.updatePercentageValue(this._currentPercentageValue / 100);
      }
      
      private function handlePositionChange() : void
      {
         this._shieldPercentageEffect.x = this._target.x3D;
         this._shieldPercentageEffect.y = this._target.y3D;
         this._shieldPercentageEffect.z = this._target.z3D;
         this._shieldRange.x = this._target.x3D;
         this._shieldRange.y = this._target.y3D;
         this._shieldRange.z = this._target.z3D;
         this._particleContainer.x = this._target.x3D;
         this._particleContainer.y = this._target.y3D;
         this._particleContainer.z = this._target.z3D;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         TweenLite.killTweensOf(this);
         if(this._particles1)
         {
            this._particles1.destroy();
            this._particles1 = null;
         }
         if(this._particles2)
         {
            this._particles2.destroy();
            this._particles2 = null;
         }
         if(this._particles3)
         {
            this._particles3.destroy();
            this._particles3 = null;
         }
         if(this._particles4)
         {
            this._particles4.destroy();
            this._particles4 = null;
         }
         this._percentageSignal.removeAll();
         this._percentageSignal = null;
         World3D.instance.mapView.removeUpdatable(this);
         this._target.position.changed.remove(this.handlePositionChange);
         if(this._shieldPercentageEffect)
         {
            this._mapView.gameWorld.removeChild(this._shieldPercentageEffect);
         }
         this._shieldPercentageEffect = null;
         if(this._shieldRange)
         {
            this._mapView.gameWorld.removeChild(this._shieldRange);
         }
         this._shieldRange = null;
         if(this._particleContainer)
         {
            this._mapView.gameWorld.removeChild(this._particleContainer);
         }
         this._particleContainer = null;
         this._mapView = null;
      }
   }
}

import away3d.containers.ObjectContainer3D;
import away3d.core.base.CompactSubGeometry;
import away3d.entities.Entity;
import away3d.entities.Mesh;
import away3d.entities.Sprite3D;
import away3d.materials.ColorMaterial;
import away3d.materials.TextureMaterial;
import away3d.primitives.TorusGeometry;
import away3d.textures.BitmapTexture;
import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.Shape;
import flash.geom.Matrix;

class BowShieldEffect extends ObjectContainer3D
{
   
   private const BOW_SEGMENT_COUNT_MIN:uint = 1;
   
   private const BOW_SEGMENT_COUNT_MAX:uint = 6;
   
   private var _bowGeometry:BowGeometry;
   
   private var _material:ColorMaterial;
   
   private var _alpha:Number;
   
   private var _color:Number;
   
   private var _bowSegmentCount:uint = 2;
   
   private var _angle:Number;
   
   private var _angleDegree:Number;
   
   private var _rotationContainerAngleInDegree:Number;
   
   private var _bowLengthPercentage:Number = 0;
   
   private var _linestroke:uint = 3;
   
   private var _radius:uint = 200;
   
   public function BowShieldEffect()
   {
      super();
   }
   
   public function initialize() : void
   {
      var _loc1_:Mesh = null;
      this._angle = Math.PI * 2 / this._bowSegmentCount;
      this._angleDegree = this._angle * (360 / (Math.PI * 2));
      this._rotationContainerAngleInDegree = 0;
      this._bowGeometry = new BowGeometry(this._angle,this._radius,this._linestroke);
      this._material = new ColorMaterial(this._color,this._alpha);
      var _loc2_:Number = 0;
      var _loc3_:uint = 0;
      while(_loc3_ < this._bowSegmentCount)
      {
         _loc1_ = new Mesh(this._bowGeometry,this._material);
         this.addChild(_loc1_);
         _loc1_.rotateTo(0,0,_loc2_);
         _loc2_ += this._angleDegree;
         _loc3_++;
      }
   }
   
   public function destroy() : void
   {
   }
   
   public function updateRotation(param1:Number) : void
   {
      this._rotationContainerAngleInDegree = param1;
      this.rotationY = this._rotationContainerAngleInDegree + this._angleDegree / 2 * this._bowLengthPercentage;
   }
   
   public function updatePercentageValue(param1:Number) : void
   {
      this._bowLengthPercentage = param1;
      this._bowGeometry.bowLengthPercentage = this._bowLengthPercentage;
      this.updateRotation(this._rotationContainerAngleInDegree);
   }
   
   public function set color(param1:int) : void
   {
      this._color = param1;
   }
   
   public function set alpha(param1:Number) : void
   {
      this._alpha = param1;
   }
   
   public function set linestroke(param1:uint) : void
   {
      this._linestroke = param1;
   }
   
   public function set radius(param1:uint) : void
   {
      this._radius = param1;
   }
   
   public function set bowSegmentCount(param1:int) : void
   {
      param1 = param1 < this.BOW_SEGMENT_COUNT_MIN ? int(this.BOW_SEGMENT_COUNT_MIN) : param1;
      param1 = param1 > this.BOW_SEGMENT_COUNT_MAX ? int(this.BOW_SEGMENT_COUNT_MAX) : param1;
      this._bowSegmentCount = param1;
   }
}

class BowGeometry extends TorusGeometry
{
   
   private static const BOW_LENGTH_MAX:Number = Math.PI * 2;
   
   private var _boxMaxLength:Number = 1.5707963267948966;
   
   private var _bowLength:Number = 0;
   
   public function BowGeometry(param1:Number, param2:Number = 100, param3:uint = 3)
   {
      this._boxMaxLength = param1;
      super(param2,param3,16,2);
   }
   
   public function set bowLength(param1:Number) : void
   {
      if(param1 > 0 && param1 <= BOW_LENGTH_MAX)
      {
         this._bowLength = param1;
         invalidateGeometry();
      }
   }
   
   public function set bowLengthPercentage(param1:Number) : void
   {
      if(param1 >= 0 && param1 <= 1)
      {
         this._bowLength = param1 * this._boxMaxLength;
         invalidateGeometry();
      }
   }
   
   public function set bowMaxLengthInRad(param1:Number) : void
   {
      if(param1 >= 0 && param1 <= Math.PI * 2)
      {
         this._boxMaxLength = param1;
      }
   }
   
   override protected function buildGeometry(param1:CompactSubGeometry) : void
   {
      var _loc2_:uint = 0;
      var _loc3_:uint = 0;
      var _loc4_:Number = NaN;
      var _loc5_:Number = NaN;
      var _loc6_:Number = NaN;
      var _loc7_:Number = NaN;
      var _loc8_:Number = NaN;
      var _loc9_:Number = NaN;
      var _loc10_:Number = NaN;
      var _loc11_:Number = NaN;
      var _loc12_:uint = 0;
      var _loc15_:Number = NaN;
      var _loc16_:Number = NaN;
      var _loc17_:Number = NaN;
      var _loc18_:Number = NaN;
      var _loc19_:Number = NaN;
      var _loc20_:Number = NaN;
      var _loc21_:uint = 0;
      var _loc22_:uint = 0;
      var _loc23_:uint = 0;
      var _loc24_:uint = 0;
      var _loc25_:uint = 0;
      var _loc26_:Number = NaN;
      var _loc27_:uint = 0;
      _numVertices = 0;
      _nextVertexIndex = 0;
      _currentIndex = 0;
      _currentTriangleIndex = 0;
      _vertexStride = param1.vertexStride;
      _vertexOffset = param1.vertexOffset;
      _numVertices = (_segmentsT + 1) * (_segmentsR + 1);
      _loc12_ = _segmentsT * _segmentsR * 2;
      if(_numVertices == param1.numVertices)
      {
         _rawVertexData = param1.vertexData;
         _rawIndices = param1.indexData || new Vector.<uint>(_loc12_ * 3,true);
      }
      else
      {
         _loc27_ = _numVertices * _vertexStride;
         _rawVertexData = new Vector.<Number>(_loc27_,true);
         _rawIndices = new Vector.<uint>(_loc12_ * 3,true);
         invalidateUVs();
      }
      var _loc13_:Number = this._bowLength / _segmentsR;
      var _loc14_:Number = 2 * Math.PI / _segmentsT;
      _loc3_ = 0;
      while(_loc3_ <= _segmentsT)
      {
         _loc21_ = _vertexOffset + _nextVertexIndex * _vertexStride;
         _loc2_ = 0;
         while(_loc2_ <= _segmentsR)
         {
            _loc10_ = _loc2_ * _loc13_;
            _loc11_ = _loc3_ * _loc14_;
            _loc26_ = Math.cos(_loc11_);
            _loc7_ = _loc26_ * Math.cos(_loc10_);
            _loc8_ = _loc26_ * Math.sin(_loc10_);
            _loc9_ = Math.sin(_loc11_);
            _loc4_ = _radius * Math.cos(_loc10_) + _tubeRadius * _loc7_;
            _loc5_ = _radius * Math.sin(_loc10_) + _tubeRadius * _loc8_;
            _loc6_ = _loc3_ == _segmentsT ? 0 : _tubeRadius / 2 * _loc9_;
            _loc19_ = _loc8_;
            _loc20_ = _loc9_;
            _loc17_ = _loc26_ ? _loc7_ / _loc26_ : _loc4_ / _radius;
            _loc18_ = 0;
            _loc15_ = _loc5_;
            _loc16_ = _loc6_;
            addVertex(_loc4_,_loc15_,_loc16_,_loc7_,_loc19_,_loc20_,-(_loc26_ ? _loc8_ / _loc26_ : _loc5_ / _radius),_loc17_,_loc18_);
            if(_loc2_ > 0 && _loc3_ > 0)
            {
               _loc22_ = _nextVertexIndex - 1;
               _loc23_ = _nextVertexIndex - 2;
               _loc24_ = _loc23_ - _segmentsR - 1;
               _loc25_ = _loc22_ - _segmentsR - 1;
               addTriangleClockWise(_loc22_,_loc23_,_loc24_);
               addTriangleClockWise(_loc22_,_loc24_,_loc25_);
            }
            _loc2_++;
         }
         _loc3_++;
      }
      param1.updateData(_rawVertexData);
      param1.updateIndexData(_rawIndices);
   }
}

interface IFx
{
   
   function initialize() : void;
   
   function updatePercentageValue(param1:Number) : void;
}

class ParticleFX implements IFx
{
   
   private var _container:ObjectContainer3D;
   
   private var _pool:Vector.<Entity>;
   
   private var _material:TextureMaterial;
   
   private var _activeParticlesCount:uint = 0;
   
   private var _speed:Number = 0.003;
   
   private var _color:Number = 65280;
   
   private var _percentage:Number = 0;
   
   public var maxParticleCount:Number = 50;
   
   public var innerRadius:Number = 90;
   
   public var outerRadius:Number = 680;
   
   public var K:Number = 3.141592653589793;
   
   public function ParticleFX(param1:ObjectContainer3D)
   {
      super();
      this._container = param1;
   }
   
   public function initialize() : void
   {
      this._pool = new Vector.<Entity>();
      var _loc1_:uint = 128;
      var _loc2_:uint = 128;
      var _loc3_:Number = 128;
      var _loc4_:Shape = new Shape();
      var _loc5_:Matrix = new Matrix();
      _loc5_.createGradientBox(_loc3_ * 2,_loc3_ * 2,0,0,0);
      _loc4_.graphics.beginGradientFill(GradientType.RADIAL,[this._color,0],[0.5,0],[0,128],_loc5_);
      _loc4_.graphics.drawCircle(_loc3_,_loc3_,_loc3_);
      var _loc6_:BitmapData = new BitmapData(_loc1_ * 2,_loc2_ * 2,true,526344);
      _loc6_.draw(_loc4_);
      this._material = new TextureMaterial(new BitmapTexture(_loc6_));
      this._material.alphaBlending = true;
   }
   
   public function updatePercentageValue(param1:Number) : void
   {
      var _loc2_:int = 0;
      var _loc3_:uint = 0;
      var _loc4_:Entity = null;
      var _loc5_:uint = 0;
      var _loc6_:uint = 0;
      if(param1 >= 0 && param1 <= 1)
      {
         this._percentage = param1;
         this._activeParticlesCount = Math.ceil(param1 * this.maxParticleCount);
         _loc2_ = this._activeParticlesCount - this._pool.length;
         if(_loc2_ > 0)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc2_)
            {
               this.createAndAddParticle();
               _loc6_++;
            }
         }
         _loc3_ = 0;
         _loc3_ = 0;
         while(_loc3_ < this._activeParticlesCount)
         {
            _loc4_ = this._pool[_loc3_];
            _loc4_.visible = true;
            this.animate(_loc4_,_loc3_);
            _loc3_++;
         }
         _loc5_ = uint(this._pool.length);
         _loc3_ = uint(this._activeParticlesCount);
         while(_loc3_ < _loc5_)
         {
            _loc4_ = this._pool[_loc3_];
            _loc4_.visible = false;
            _loc3_++;
         }
      }
   }
   
   private function createAnimationStartIndex(param1:Entity) : void
   {
      param1.id = String(Math.random() * Math.PI);
   }
   
   private function animate(param1:Entity, param2:Number) : void
   {
      var _loc4_:Number = NaN;
      var _loc5_:Number = NaN;
      var _loc3_:Number = Number(param1.id);
      if(_loc3_ > 0)
      {
         if(_loc3_ + this._speed >= 1)
         {
            _loc3_ = _loc3_ + this._speed - 1;
         }
         _loc3_ += this._speed;
         param1.id = String(_loc3_);
         _loc4_ = param2 / this.maxParticleCount * (Math.PI / 2);
         _loc5_ = this.outerRadius - (this.outerRadius - this.innerRadius) * (1 - _loc3_);
         _loc5_ = this.outerRadius * Math.sin(Math.PI / 2 * (_loc5_ / this.outerRadius));
         param1.x = _loc5_ * Math.sin(this.K + _loc4_);
         param1.z = _loc5_ * Math.cos(this.K + _loc4_);
         param1.scaleX = param1.scaleY = 0.5 + 2 * (1 - _loc3_);
      }
   }
   
   private function createAndAddParticle() : void
   {
      var _loc1_:Entity = null;
      _loc1_ = new Sprite3D(this._material,12,12) as Entity;
      this.createAnimationStartIndex(_loc1_);
      this._pool.push(_loc1_);
      this._container.addChild(_loc1_);
   }
   
   public function destroy() : void
   {
      var _loc1_:Entity = null;
      var _loc2_:uint = 0;
      if(this._pool)
      {
         _loc2_ = 0;
         while(_loc2_ < this._pool.length)
         {
            _loc1_ = this._pool[_loc2_];
            _loc1_.dispose();
            _loc2_++;
         }
         this._pool = null;
      }
   }
   
   public function set color(param1:Number) : void
   {
      this._color = param1;
   }
   
   public function set speed(param1:Number) : void
   {
      this._speed = param1;
   }
}
