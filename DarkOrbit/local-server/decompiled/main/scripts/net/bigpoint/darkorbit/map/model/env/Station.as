package net.bigpoint.darkorbit.map.model.env
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class Station extends MapEntity
   {
      
      public static const STATE_DISABLED:String = "disabled";
      
      public static const STATE_ENABLED:String = "enabled";
      
      private var _displayTrait:UberDisplayTrait;
      
      public function Station(param1:int, param2:PointLite, param3:int)
      {
         super(param1,param2);
         UberAssetsLib.instance.fillTraits(this,"station_" + param3,UberAssetsLib.LIB_DEFAULT);
         this._displayTrait = getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
         this.isEnabled = false;
      }
      
      public function set isEnabled(param1:Boolean) : void
      {
         if(this._displayTrait)
         {
            this._displayTrait.state.value = param1 ? STATE_DISABLED : STATE_ENABLED;
         }
      }
   }
}

