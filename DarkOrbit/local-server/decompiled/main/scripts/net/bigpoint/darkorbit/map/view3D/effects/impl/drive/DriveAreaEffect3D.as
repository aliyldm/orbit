package net.bigpoint.darkorbit.map.view3D.effects.impl.drive
{
   import net.bigpoint.darkorbit.map.common.EffectRangeTicker;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.impl.drive.DriveAreaEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.EffectRange3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class DriveAreaEffect3D implements IDisposable
   {
      
      private var rangeToken:Object;
      
      private var effect:DriveAreaEffect;
      
      private var particle:StandaloneParticle3D;
      
      private var disposed:Boolean = false;
      
      public function DriveAreaEffect3D(param1:MapView3D, param2:DriveAreaEffect)
      {
         super();
         this.effect = param2;
         this.poll();
         this.rangeToken = EffectRangeTicker.add(this.poll,250);
      }
      
      private function poll() : void
      {
         if(this.disposed)
         {
            return;
         }
         if(EffectRange3D.near(this.effect.source.position,800))
         {
            if(!this.particle)
            {
               this.particle = new RangeDriveParticle3D(this.effect);
            }
         }
         else if(this.particle)
         {
            this.particle.disposeView(true);
            this.particle = null;
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this.disposed)
         {
            return;
         }
         this.disposed = true;
         EffectRangeTicker.remove(this.rangeToken);
         this.rangeToken = null;
         if(this.particle)
         {
            this.particle.disposeView(true);
         }
         this.particle = null;
         this.effect = null;
      }
   }
}

