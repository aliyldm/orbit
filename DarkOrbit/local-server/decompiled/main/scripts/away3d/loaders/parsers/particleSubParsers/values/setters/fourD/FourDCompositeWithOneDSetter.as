package away3d.loaders.parsers.particleSubParsers.values.setters.fourD
{
   import away3d.animators.data.ParticleProperties;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import flash.geom.Vector3D;
   
   public class FourDCompositeWithOneDSetter extends SetterBase
   {
      
      private var _setterX:SetterBase;
      
      private var _setterY:SetterBase;
      
      private var _setterZ:SetterBase;
      
      private var _setterW:SetterBase;
      
      public function FourDCompositeWithOneDSetter(param1:String, param2:SetterBase = null, param3:SetterBase = null, param4:SetterBase = null, param5:SetterBase = null)
      {
         super(param1);
         this._setterX = param2;
         this._setterY = param3;
         this._setterZ = param4;
         this._setterW = param5;
      }
      
      override public function setProps(param1:ParticleProperties) : void
      {
         param1[_propName] = this.generateOneValue(param1.index,param1.total);
      }
      
      override public function generateOneValue(param1:int = 0, param2:int = 1) : *
      {
         var _loc3_:Number = this._setterX ? Number(this._setterX.generateOneValue(param1,param2)) : 0;
         var _loc4_:Number = this._setterY ? Number(this._setterY.generateOneValue(param1,param2)) : 0;
         var _loc5_:Number = this._setterZ ? Number(this._setterZ.generateOneValue(param1,param2)) : 0;
         var _loc6_:Number = this._setterW ? Number(this._setterW.generateOneValue(param1,param2)) : 0;
         return new Vector3D(_loc3_,_loc4_,_loc5_,_loc6_);
      }
      
      override public function startPropsGenerating(param1:ParticleProperties) : void
      {
         if(this._setterX)
         {
            this._setterX.startPropsGenerating(param1);
         }
         if(this._setterY)
         {
            this._setterY.startPropsGenerating(param1);
         }
         if(this._setterZ)
         {
            this._setterZ.startPropsGenerating(param1);
         }
         if(this._setterW)
         {
            this._setterW.startPropsGenerating(param1);
         }
      }
      
      override public function finishPropsGenerating(param1:ParticleProperties) : void
      {
         if(this._setterX)
         {
            this._setterX.finishPropsGenerating(param1);
         }
         if(this._setterY)
         {
            this._setterY.finishPropsGenerating(param1);
         }
         if(this._setterZ)
         {
            this._setterZ.finishPropsGenerating(param1);
         }
         if(this._setterW)
         {
            this._setterW.finishPropsGenerating(param1);
         }
      }
   }
}

