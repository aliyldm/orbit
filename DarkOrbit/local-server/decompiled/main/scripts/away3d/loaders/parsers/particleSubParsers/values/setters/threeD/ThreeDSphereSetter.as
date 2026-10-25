package away3d.loaders.parsers.particleSubParsers.values.setters.threeD
{
   import away3d.animators.data.ParticleProperties;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import flash.geom.Vector3D;
   
   public class ThreeDSphereSetter extends SetterBase
   {
      
      private var _innerRadius3:Number;
      
      private var _outerRadius3:Number;
      
      private var _centerX:Number;
      
      private var _centerY:Number;
      
      private var _centerZ:Number;
      
      public function ThreeDSphereSetter(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number)
      {
         super(param1);
         this._innerRadius3 = Math.pow(param2,3);
         this._outerRadius3 = Math.pow(param3,3);
         this._centerX = param4;
         this._centerY = param5;
         this._centerZ = param6;
      }
      
      override public function setProps(param1:ParticleProperties) : void
      {
         param1[_propName] = this.generateOneValue(param1.index,param1.total);
      }
      
      override public function generateOneValue(param1:int = 0, param2:int = 1) : *
      {
         var _loc3_:Number = Math.random() * Math.PI * 2;
         var _loc4_:Number = Math.pow(Math.random() * (this._outerRadius3 - this._innerRadius3) + this._innerRadius3,1 / 3);
         var _loc5_:Vector3D = new Vector3D(Math.random() - 0.5,Math.random() - 0.5,Math.random() - 0.5);
         if(_loc5_.length == 0)
         {
            _loc5_.x = 1;
         }
         _loc5_.normalize();
         _loc5_.scaleBy(_loc4_);
         _loc5_.x += this._centerX;
         _loc5_.y += this._centerY;
         _loc5_.z += this._centerZ;
         return _loc5_;
      }
   }
}

