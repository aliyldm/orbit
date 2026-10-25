package net.bigpoint.darkorbit.map.view3D.display3D.materials
{
   import away3d.materials.methods.OutlineMethod;
   import away3d.materials.methods.RimLightMethod;
   
   public class FrostMaterial extends EntityXRayMaterial
   {
      
      private var _rim:RimLightMethod;
      
      private var _outline:OutlineMethod;
      
      public function FrostMaterial()
      {
         super();
         addMethod(this._rim = new RimLightMethod(3394815,2,2));
         addMethod(this._outline = new OutlineMethod(3394815,1.5));
      }
      
      override public function setShaderParams(param1:XML) : void
      {
         if(String(param1.@shaderColor).length)
         {
            this._rim.color = uint(param1.@shaderColor);
         }
         if(String(param1.@shaderStrength).length)
         {
            this._rim.strength = Number(param1.@shaderStrength);
         }
         if(String(param1.@shaderPower).length)
         {
            this._rim.power = Number(param1.@shaderPower);
         }
         if(String(param1.@shaderOutlineColor).length)
         {
            this._outline.outlineColor = uint(param1.@shaderOutlineColor);
         }
         else if(String(param1.@shaderColor).length)
         {
            this._outline.outlineColor = uint(param1.@shaderColor);
         }
         if(String(param1.@shaderOutlineSize).length)
         {
            this._outline.outlineSize = Number(param1.@shaderOutlineSize);
         }
      }
   }
}

