package away3d.loaders.parsers.particleSubParsers.values.setters.threeD
{
   import away3d.animators.data.ParticleProperties;
   import away3d.core.math.MathConsts;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   public class ThreeDCylinderSetter extends SetterBase
   {
      
      private var _innerRadius:Number;
      
      private var _outerRadius:Number;
      
      private var _height:Number;
      
      private var _centerX:Number;
      
      private var _centerY:Number;
      
      private var _centerZ:Number;
      
      private var _matrix:Matrix3D;
      
      public function ThreeDCylinderSetter(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number)
      {
         var _loc12_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:Vector3D = null;
         super(param1);
         this._innerRadius = param2;
         this._outerRadius = param3;
         this._height = param4;
         this._centerX = param5;
         this._centerY = param6;
         this._centerZ = param7;
         var _loc11_:Vector3D = new Vector3D(param8,param9,param10);
         if(_loc11_.length > 0)
         {
            _loc11_.normalize();
            _loc12_ = _loc11_.dotProduct(Vector3D.Y_AXIS) > 0 ? 1 : -1;
            _loc13_ = _loc12_ * Vector3D.angleBetween(Vector3D.Y_AXIS,_loc11_) * MathConsts.RADIANS_TO_DEGREES;
            if(_loc13_ != 0)
            {
               _loc14_ = Vector3D.Y_AXIS.crossProduct(_loc11_);
               this._matrix = new Matrix3D();
               this._matrix.appendRotation(_loc13_,_loc14_);
            }
         }
      }
      
      override public function setProps(param1:ParticleProperties) : void
      {
         param1[_propName] = this.generateOneValue(param1.index,param1.total);
      }
      
      override public function generateOneValue(param1:int = 0, param2:int = 1) : *
      {
         var _loc3_:Number = Math.random() * this._height;
         var _loc4_:Number = this._outerRadius * Math.pow(Math.random() * (1 - this._innerRadius / this._outerRadius) + this._innerRadius / this._outerRadius,1 / 2);
         var _loc5_:Number = Math.random() * Math.PI * 2;
         var _loc6_:Vector3D = new Vector3D(_loc4_ * Math.cos(_loc5_),_loc3_,_loc4_ * Math.sin(_loc5_));
         if(this._matrix)
         {
            _loc6_ = this._matrix.deltaTransformVector(_loc6_);
         }
         _loc6_.x += this._centerX;
         _loc6_.y += this._centerY;
         _loc6_.z += this._centerZ;
         return _loc6_;
      }
   }
}

