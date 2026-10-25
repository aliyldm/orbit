package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.common.IDisposable;
   
   public class CompactCannonLease3D implements IDisposable
   {
      
      private var link:CompactCannonLink3D;
      
      private var generation:uint;
      
      public function CompactCannonLease3D(param1:CompactCannonLink3D, param2:uint)
      {
         super();
         this.link = param1;
         this.generation = param2;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(Boolean(this.link) && this.link.generation == this.generation)
         {
            this.link.disposeView(param1);
         }
         this.link = null;
      }
   }
}

