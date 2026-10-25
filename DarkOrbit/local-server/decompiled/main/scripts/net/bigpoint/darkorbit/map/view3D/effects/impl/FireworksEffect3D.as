package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.FireworksEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class FireworksEffect3D
   {
      
      private var _resKeys:Vector.<String>;
      
      private var _position:BindablePointLite;
      
      private var _effect:FireworksEffect;
      
      public function FireworksEffect3D(param1:MapView3D, param2:FireworksEffect)
      {
         super();
         this._effect = param2;
         var _loc3_:FireworksEffect = param2 as FireworksEffect;
         this._resKeys = _loc3_.patterns.concat();
         this._position = new BindablePointLite(param2.x,param2.y);
         this.spawnNext();
      }
      
      private function spawnNext() : void
      {
         var _loc1_:StandaloneParticle3D = null;
         if(this._resKeys.length > 0)
         {
            _loc1_ = new StandaloneParticle3D(this._effect,this._resKeys.pop() + ".zip",this._position);
            _loc1_.completed.addOnce(this.spawnNext);
            _loc1_.scale = 2;
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_FIREWORK);
         }
      }
   }
}

