package away3d.loaders.parsers.particleSubParsers.values.setters.property
{
   import away3d.animators.data.ParticleInstanceProperty;
   import away3d.animators.data.ParticleProperties;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import flash.geom.Vector3D;
   
   public class InstancePropertySubSetter extends SetterBase
   {
      
      private var _positionSetter:SetterBase;
      
      private var _rotationSetter:SetterBase;
      
      private var _scaleSetter:SetterBase;
      
      private var _timeOffsetSetter:SetterBase;
      
      private var _playSpeedSetter:SetterBase;
      
      public function InstancePropertySubSetter(param1:String, param2:SetterBase, param3:SetterBase, param4:SetterBase, param5:SetterBase, param6:SetterBase)
      {
         super(param1);
         this._positionSetter = param2;
         this._rotationSetter = param3;
         this._scaleSetter = param4;
         this._timeOffsetSetter = param5;
         this._playSpeedSetter = param6;
      }
      
      override public function setProps(param1:ParticleProperties) : void
      {
         param1[_propName] = this.generateOneValue(param1.index,param1.total);
      }
      
      override public function generateOneValue(param1:int = 0, param2:int = 1) : *
      {
         var _loc3_:Vector3D = this._positionSetter ? this._positionSetter.generateOneValue(param1,param2) : null;
         var _loc4_:Vector3D = this._rotationSetter ? this._rotationSetter.generateOneValue(param1,param2) : null;
         var _loc5_:Vector3D = this._scaleSetter ? this._scaleSetter.generateOneValue(param1,param2) : null;
         var _loc6_:Number = this._timeOffsetSetter ? Number(this._timeOffsetSetter.generateOneValue(param1,param2)) : 0;
         var _loc7_:Number = this._playSpeedSetter ? Number(this._playSpeedSetter.generateOneValue(param1,param2)) : 1;
         return new ParticleInstanceProperty(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
      }
      
      override public function startPropsGenerating(param1:ParticleProperties) : void
      {
         if(this._positionSetter)
         {
            this._positionSetter.startPropsGenerating(param1);
         }
         if(this._rotationSetter)
         {
            this._rotationSetter.startPropsGenerating(param1);
         }
         if(this._scaleSetter)
         {
            this._scaleSetter.startPropsGenerating(param1);
         }
         if(this._timeOffsetSetter)
         {
            this._timeOffsetSetter.startPropsGenerating(param1);
         }
         if(this._playSpeedSetter)
         {
            this._playSpeedSetter.startPropsGenerating(param1);
         }
      }
      
      override public function finishPropsGenerating(param1:ParticleProperties) : void
      {
         if(this._positionSetter)
         {
            this._positionSetter.finishPropsGenerating(param1);
         }
         if(this._rotationSetter)
         {
            this._rotationSetter.finishPropsGenerating(param1);
         }
         if(this._scaleSetter)
         {
            this._scaleSetter.finishPropsGenerating(param1);
         }
         if(this._timeOffsetSetter)
         {
            this._timeOffsetSetter.finishPropsGenerating(param1);
         }
         if(this._playSpeedSetter)
         {
            this._playSpeedSetter.finishPropsGenerating(param1);
         }
      }
   }
}

