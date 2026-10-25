package net.bigpoint.darkorbit.ctb
{
   import com.bigpoint.utils.bindables.BindableInt;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   
   public class BeaconTrait extends EntityTraitBase
   {
      
      public const beaconID:BindableInt = new BindableInt(-1);
      
      public function BeaconTrait(param1:int)
      {
         super();
         this.beaconID.value = param1;
      }
   }
}

