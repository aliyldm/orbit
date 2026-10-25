package away3d.loaders.parsers.particleSubParsers.values.setters.fourD
{
   import away3d.animators.data.ParticleProperties;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import flash.geom.Vector3D;
   
   public class FourDCompositeWithThreeDSetter extends SetterBase
   {
      
      private var _setter3D:SetterBase;
      
      private var _setterW:SetterBase;
      
      public function FourDCompositeWithThreeDSetter(param1:String, param2:SetterBase, param3:SetterBase)
      {
         super(param1);
         this._setter3D = param2;
         this._setterW = param3;
      }
      
      override public function startPropsGenerating(param1:ParticleProperties) : void
      {
         this._setter3D.startPropsGenerating(param1);
         this._setterW.startPropsGenerating(param1);
      }
      
      override public function finishPropsGenerating(param1:ParticleProperties) : void
      {
         this._setter3D.finishPropsGenerating(param1);
         this._setterW.finishPropsGenerating(param1);
      }
      
      override public function setProps(param1:ParticleProperties) : void
      {
         param1[_propName] = this.generateOneValue(param1.index,param1.total);
      }
      
      override public function generateOneValue(param1:int = 0, param2:int = 1) : *
      {
         var _loc3_:Vector3D = this._setter3D.generateOneValue(param1,param2);
         _loc3_.w = this._setterW.generateOneValue(param1,param2);
         return _loc3_;
      }
   }
}

