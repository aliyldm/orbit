package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.TechShieldBackupEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class ShieldBackupTech3D extends StandaloneParticle3D
   {
      
      private static const URL:String = "shield_backup_tech.zip";
      
      private static const DATA:* = {};
      
      DATA[EffectIDList.TECH_SHIELD_BACKUP_EFFECT] = "shield_backup_tech.zip";
      DATA[EffectIDList.TECH_SHIELD_BACKUP_EFFECT_2] = "shield_backup_tech_purple.zip";
      
      public function ShieldBackupTech3D(param1:MapView3D, param2:TechShieldBackupEffect)
      {
         super(param2,DATA[param2.id],param2.source.position);
      }
   }
}

