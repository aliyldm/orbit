package net.bigpoint.darkorbit.map.model.traits.hud
{
   import com.bigpoint.utils.bindables.BindableInt;
   import com.bigpoint.utils.bindables.BindableString;
   
   public class DamageIconTrait extends IconTrait
   {
      
      public static const BUFF:String = "BUFF";
      
      public static const DEBUFF:String = "DEBUFF";
      
      public const level:BindableInt = new BindableInt(1);
      
      public const type:BindableString = new BindableString();
      
      public function DamageIconTrait(param1:String = "BUFF")
      {
         super();
         this.type.value = param1;
      }
   }
}

