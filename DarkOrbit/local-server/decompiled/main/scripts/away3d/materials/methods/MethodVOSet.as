package away3d.materials.methods
{
   import away3d.arcane;
   
   use namespace arcane;
   
   public class MethodVOSet
   {
      
      public var method:EffectMethodBase;
      
      public var data:MethodVO;
      
      public function MethodVOSet(param1:EffectMethodBase)
      {
         super();
         this.method = param1;
         this.data = param1.createMethodVO();
      }
   }
}

