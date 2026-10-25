package net.bigpoint.darkorbit.map.model.ship.pet
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableInt;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   
   public class PetTrait extends EntityTraitBase
   {
      
      public static const MAX_LVL:int = 20;
      
      public const level:BindableInt = new BindableInt();
      
      public const ownerID:BindableInt = new BindableInt();
      
      public const evasionProtocolEquiped:BindableBoolean = new BindableBoolean();
      
      public function PetTrait()
      {
         super();
      }
   }
}

