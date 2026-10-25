package net.bigpoint.darkorbit.map.model.traits.hud
{
   import com.bigpoint.utils.bindables.BindableInt;
   import com.bigpoint.utils.bindables.BindableString;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   
   public class MapObjectInfoTrait extends EntityTraitBase
   {
      
      public const clanID:BindableInt = new BindableInt(0);
      
      public const clanDiplomacy:BindableInt = new BindableInt(0);
      
      public const clanTag:BindableString = new BindableString("");
      
      public const username:BindableString = new BindableString("");
      
      public const factionID:BindableInt = new BindableInt();
      
      public const dailyRank:BindableInt = new BindableInt();
      
      public const galaxyGatesFinished:BindableInt = new BindableInt();
      
      public const titleID:BindableString = new BindableString();
      
      public const pvpReputation:BindableInt = new BindableInt(-999);
      
      public const saeScore:BindableInt = new BindableInt(-999);
      
      public const specialType:BindableString = new BindableString();
      
      public function MapObjectInfoTrait()
      {
         super();
      }
   }
}

