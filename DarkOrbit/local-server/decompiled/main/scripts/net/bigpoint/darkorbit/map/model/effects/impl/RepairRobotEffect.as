package net.bigpoint.darkorbit.map.model.effects.impl
{
   import com.bigpoint.utils.bindables.BindableInt;
   import com.bigpoint.utils.bindables.BindableString;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class RepairRobotEffect extends MapObjectEffect
   {
      
      public const repairBotId:BindableString = new BindableString();
      
      public const repairSkillLevel:BindableInt = new BindableInt();
      
      public function RepairRobotEffect(param1:int, param2:Ship, param3:String, param4:int)
      {
         super(param1,param2,PERSISTANT,new EffectPattern(param1,""));
         this.repairBotId.value = param3;
         this.repairSkillLevel.value = param4;
      }
      
      override public function reactivate(param1:Effect) : void
      {
         super.reactivate(param1);
         this.repairBotId.value = RepairRobotEffect(param1).repairBotId.value;
         this.repairSkillLevel.value = RepairRobotEffect(param1).repairSkillLevel.value;
      }
   }
}

