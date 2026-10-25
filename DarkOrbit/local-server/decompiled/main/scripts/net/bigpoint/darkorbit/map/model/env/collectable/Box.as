package net.bigpoint.darkorbit.map.model.env.collectable
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class Box extends Collectable
   {
      
      private static const _type2settings:Object = {};
      
      _type2settings["BONUS_BOX"] = Settings.displayBonusBoxes;
      _type2settings["FROM_SHIP"] = Settings.displayFreeCargoBoxes;
      _type2settings["FROM_SHIP_BLOCKED"] = Settings.displayNotFreeCargoBoxes;
      
      public function Box(param1:String, param2:String, param3:int, param4:int, param5:Boolean)
      {
         super("box_" + param1,param2,param3,param4,param5,_type2settings[param1] as BindableBoolean);
      }
   }
}

