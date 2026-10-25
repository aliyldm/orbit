package net.bigpoint.darkorbit.map.model.traits
{
   import com.bigpoint.utils.bindables.BindableInt;
   import net.bigpoint.darkorbit.com.module.ClanRelationModule;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   
   public class AttackTargetTrait extends EntityTraitBase
   {
      
      public static const ENEMY:int = 1;
      
      public static const NEUTRAL:int = 2;
      
      public static const DRAW_FIRE:int = 3;
      
      public static const FRIEND:int = 4;
      
      public const lockType:BindableInt = new BindableInt(ENEMY);
      
      public var explosionTypeID:int = -1;
      
      public var shieldType:int;
      
      public function AttackTargetTrait(param1:int = 1, param2:int = -1)
      {
         super();
         this.lockType.value = param1;
         this.explosionTypeID = param2;
      }
      
      public static function getTypeOnClanRelationModule(param1:int) : int
      {
         switch(param1)
         {
            case ClanRelationModule.TYPE_AT_WAR:
            case ClanRelationModule.TYPE_NONE:
               return ENEMY;
            case ClanRelationModule.TYPE_ALLIED:
               return FRIEND;
            case ClanRelationModule.TYPE_NON_AGGRESSION_PACT:
               return NEUTRAL;
            default:
               return ENEMY;
         }
      }
   }
}

