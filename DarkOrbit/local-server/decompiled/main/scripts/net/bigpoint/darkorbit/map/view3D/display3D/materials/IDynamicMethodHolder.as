package net.bigpoint.darkorbit.map.view3D.display3D.materials
{
   import away3d.materials.methods.EffectMethodBase;
   
   public interface IDynamicMethodHolder
   {
      
      function addDynamicMethod(param1:EffectMethodBase) : void;
      
      function removeDynamicMethod(param1:EffectMethodBase) : void;
      
      function removeDynamicMethods() : void;
   }
}

