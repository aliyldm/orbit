package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpawnChildrenEffect;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class SpawnChildrenEffect3D implements IDisposable
   {
      
      private var _displayTrait:UberDisplayTrait;
      
      private var _effect:SpawnChildrenEffect;
      
      public function SpawnChildrenEffect3D(param1:MapView3D, param2:SpawnChildrenEffect)
      {
         super();
         this._effect = param2;
         this._displayTrait = this._effect.source.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
         if(this._displayTrait)
         {
            this._displayTrait.playAnimation("open");
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._displayTrait)
         {
            this._displayTrait.playAnimation("close");
         }
      }
   }
}

