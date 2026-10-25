package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.EMPEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class EmpEffect3D extends StandaloneParticle3D
   {
      
      private static const RANGE:Number = 0.0025;
      
      private static const TYPE_2_PARTICELFILE:* = {};
      
      TYPE_2_PARTICELFILE[EMPEffect.TYPE_ULTIMATE] = "emp_ultimate.zip";
      TYPE_2_PARTICELFILE[EMPEffect.TYPE_EMPEROR] = "emp_emperor.zip";
      TYPE_2_PARTICELFILE[EMPEffect.TYPE_ULTIMATE_EPEROR] = "emp_emperor_ultimate.zip";
      TYPE_2_PARTICELFILE[EMPEffect.TYPE_NUKE] = "npc_nuke.zip";
      TYPE_2_PARTICELFILE[EMPEffect.TYPE_BURNING_TRAIL] = "fx_burning_trail_tech-shockwave.zip";
      
      private var _effect:EMPEffect;
      
      public function EmpEffect3D(param1:MapView3D, param2:EMPEffect)
      {
         this._effect = param2;
         var _loc3_:String = TYPE_2_PARTICELFILE[this._effect.empType] || "emp.zip";
         super(param2,_loc3_,param2.source.position,null,true);
      }
      
      override protected function initAndPlay() : void
      {
         super.initAndPlay();
         view.scaleX = view.scaleZ = view.scaleY = view.scaleY * RANGE;
         AudioManager.playSoundEffect(this._effect.soundID,false,false,this._effect.source.position.x,this._effect.source.position.y);
      }
   }
}

