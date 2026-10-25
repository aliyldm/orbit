package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.materials.MaterialBase;
   import flash.display.BlendMode;
   
   public class CompactLightningMaterial3D extends MaterialBase
   {
      
      public function CompactLightningMaterial3D()
      {
         super();
         bothSides = true;
         blendMode = BlendMode.ADD;
         addPass(new CompactLightningPass3D());
      }
   }
}

