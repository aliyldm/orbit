package away3d.loaders.parsers.particleSubParsers.values.setters.color
{
   import away3d.animators.data.ParticleProperties;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import flash.geom.ColorTransform;
   
   public class CompositeColorSetter extends SetterBase
   {
      
      private var _redMultiplierSetter:SetterBase;
      
      private var _greenMultiplierSetter:SetterBase;
      
      private var _blueMultiplierSetter:SetterBase;
      
      private var _alphaMultiplierSetter:SetterBase;
      
      private var _redOffsetSetter:SetterBase;
      
      private var _greenOffsetSetter:SetterBase;
      
      private var _blueOffsetSetter:SetterBase;
      
      private var _alphaOffsetSetter:SetterBase;
      
      public function CompositeColorSetter(param1:String, param2:SetterBase, param3:SetterBase, param4:SetterBase, param5:SetterBase, param6:SetterBase, param7:SetterBase, param8:SetterBase, param9:SetterBase)
      {
         super(param1);
         this._redMultiplierSetter = param2;
         this._greenMultiplierSetter = param3;
         this._blueMultiplierSetter = param4;
         this._alphaMultiplierSetter = param5;
         this._redOffsetSetter = param6;
         this._greenOffsetSetter = param7;
         this._blueOffsetSetter = param8;
         this._alphaOffsetSetter = param9;
      }
      
      override public function setProps(param1:ParticleProperties) : void
      {
         param1[_propName] = this.generateOneValue(param1.index,param1.total);
      }
      
      override public function generateOneValue(param1:int = 0, param2:int = 1) : *
      {
         var _loc3_:Number = this._redMultiplierSetter ? Number(this._redMultiplierSetter.generateOneValue(param1,param2)) : 0;
         var _loc4_:Number = this._greenMultiplierSetter ? Number(this._greenMultiplierSetter.generateOneValue(param1,param2)) : 0;
         var _loc5_:Number = this._blueMultiplierSetter ? Number(this._blueMultiplierSetter.generateOneValue(param1,param2)) : 0;
         var _loc6_:Number = this._alphaMultiplierSetter ? Number(this._alphaMultiplierSetter.generateOneValue(param1,param2)) : 0;
         var _loc7_:Number = this._redOffsetSetter ? Number(this._redOffsetSetter.generateOneValue(param1,param2)) : 0;
         var _loc8_:Number = this._greenOffsetSetter ? Number(this._greenOffsetSetter.generateOneValue(param1,param2)) : 0;
         var _loc9_:Number = this._blueOffsetSetter ? Number(this._blueOffsetSetter.generateOneValue(param1,param2)) : 0;
         var _loc10_:Number = this._alphaOffsetSetter ? Number(this._alphaOffsetSetter.generateOneValue(param1,param2)) : 0;
         return new ColorTransform(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_);
      }
      
      override public function startPropsGenerating(param1:ParticleProperties) : void
      {
         if(this._redMultiplierSetter)
         {
            this._redMultiplierSetter.startPropsGenerating(param1);
         }
         if(this._greenMultiplierSetter)
         {
            this._greenMultiplierSetter.startPropsGenerating(param1);
         }
         if(this._blueMultiplierSetter)
         {
            this._blueMultiplierSetter.startPropsGenerating(param1);
         }
         if(this._alphaMultiplierSetter)
         {
            this._alphaMultiplierSetter.startPropsGenerating(param1);
         }
         if(this._redOffsetSetter)
         {
            this._redOffsetSetter.startPropsGenerating(param1);
         }
         if(this._greenOffsetSetter)
         {
            this._greenOffsetSetter.startPropsGenerating(param1);
         }
         if(this._blueOffsetSetter)
         {
            this._blueOffsetSetter.startPropsGenerating(param1);
         }
         if(this._alphaOffsetSetter)
         {
            this._alphaOffsetSetter.startPropsGenerating(param1);
         }
      }
      
      override public function finishPropsGenerating(param1:ParticleProperties) : void
      {
         if(this._redMultiplierSetter)
         {
            this._redMultiplierSetter.finishPropsGenerating(param1);
         }
         if(this._greenMultiplierSetter)
         {
            this._greenMultiplierSetter.finishPropsGenerating(param1);
         }
         if(this._blueMultiplierSetter)
         {
            this._blueMultiplierSetter.finishPropsGenerating(param1);
         }
         if(this._alphaMultiplierSetter)
         {
            this._alphaMultiplierSetter.finishPropsGenerating(param1);
         }
         if(this._redOffsetSetter)
         {
            this._redOffsetSetter.finishPropsGenerating(param1);
         }
         if(this._greenOffsetSetter)
         {
            this._greenOffsetSetter.finishPropsGenerating(param1);
         }
         if(this._blueOffsetSetter)
         {
            this._blueOffsetSetter.finishPropsGenerating(param1);
         }
         if(this._alphaOffsetSetter)
         {
            this._alphaOffsetSetter.finishPropsGenerating(param1);
         }
      }
   }
}

