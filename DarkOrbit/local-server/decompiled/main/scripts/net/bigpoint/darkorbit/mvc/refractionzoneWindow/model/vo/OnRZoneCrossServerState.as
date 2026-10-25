package net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import net.bigpoint.darkorbit.com.module.RzoneOnRZoneStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneStatusModule;
   
   public class OnRZoneCrossServerState extends BaseCrossServerState
   {
      
      public const enabled:BindableBoolean = new BindableBoolean(true);
      
      public function OnRZoneCrossServerState()
      {
         super();
      }
      
      override public function set state(param1:RzoneStatusModule) : void
      {
         super.state = param1;
         var _loc2_:RzoneOnRZoneStatusModule = param1 as RzoneOnRZoneStatusModule;
         this.enabled.value = _loc2_.abelToLeave;
      }
   }
}

