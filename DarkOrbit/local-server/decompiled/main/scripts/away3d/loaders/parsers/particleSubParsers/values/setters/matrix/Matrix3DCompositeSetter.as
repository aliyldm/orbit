package away3d.loaders.parsers.particleSubParsers.values.setters.matrix
{
   import away3d.animators.data.ParticleProperties;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   public class Matrix3DCompositeSetter extends SetterBase
   {
      
      public static const SCALE:int = 2;
      
      public static const ROTATION:int = 1;
      
      public static const TANSLATION:int = 0;
      
      private static var _scaleHelpMatrix:Matrix3D = new Matrix3D();
      
      private var _transforms:Vector.<SetterBase>;
      
      public function Matrix3DCompositeSetter(param1:String, param2:Vector.<SetterBase>)
      {
         super(param1);
         this._transforms = param2;
      }
      
      override public function setProps(param1:ParticleProperties) : void
      {
         param1[_propName] = this.generateOneValue(param1.index,param1.total);
      }
      
      override public function generateOneValue(param1:int = 0, param2:int = 1) : *
      {
         var _loc4_:Vector3D = null;
         var _loc5_:SetterBase = null;
         var _loc6_:Vector.<Number> = null;
         var _loc3_:Matrix3D = new Matrix3D();
         for each(_loc5_ in this._transforms)
         {
            _loc4_ = _loc5_.generateOneValue(param1,param2);
            switch(int(_loc5_.propName))
            {
               case SCALE:
                  _loc6_ = _scaleHelpMatrix.rawData;
                  _loc6_[0] = _loc4_.x;
                  _loc6_[5] = _loc4_.y;
                  _loc6_[10] = _loc4_.z;
                  _scaleHelpMatrix.copyRawDataFrom(_loc6_);
                  _loc3_.append(_scaleHelpMatrix);
                  break;
               case ROTATION:
                  _loc3_.appendRotation(_loc4_.x,Vector3D.X_AXIS);
                  _loc3_.appendRotation(_loc4_.y,Vector3D.Y_AXIS);
                  _loc3_.appendRotation(_loc4_.z,Vector3D.Z_AXIS);
                  break;
               default:
                  _loc3_.appendTranslation(_loc4_.x,_loc4_.y,_loc4_.z);
            }
         }
         return _loc3_;
      }
      
      override public function startPropsGenerating(param1:ParticleProperties) : void
      {
         var _loc2_:SetterBase = null;
         for each(_loc2_ in this._transforms)
         {
            _loc2_.startPropsGenerating(param1);
         }
      }
      
      override public function finishPropsGenerating(param1:ParticleProperties) : void
      {
         var _loc2_:SetterBase = null;
         for each(_loc2_ in this._transforms)
         {
            _loc2_.finishPropsGenerating(param1);
         }
      }
   }
}

