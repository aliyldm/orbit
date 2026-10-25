package net.bigpoint.darkorbit.map.view3D.effects.impl.drive
{
   import net.bigpoint.darkorbit.map.model.effects.impl.drive.DriveAreaEffect;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class RangeDriveParticle3D extends StandaloneParticle3D
   {
      
      private var area:DriveAreaEffect;
      
      public function RangeDriveParticle3D(param1:DriveAreaEffect)
      {
         this.area = param1;
         super(param1,param1.pattern.resKey + ".zip",param1.source.position,null,true);
      }
      
      override protected function updateScale() : void
      {
         scale = this.area.pattern.scale * (this.area.scale == -1 ? 1 : this.area.scale);
      }
   }
}

